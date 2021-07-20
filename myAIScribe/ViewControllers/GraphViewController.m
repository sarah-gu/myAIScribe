//
//  GraphViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/16/21.
//

@import Charts;
#import "GraphViewController.h"
#import "Note.h"
@import Parse;

@interface GraphViewController () <ChartViewDelegate>
@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (weak, nonatomic) IBOutlet UISlider *mySlider;
@property (strong, nonatomic) NSArray *notes;
@property (strong, nonatomic) NSMutableDictionary *dict;
@property (weak, nonatomic) IBOutlet UILabel *daysToShow;
@end

@implementation GraphViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _chartView.delegate = self;
    _chartView.chartDescription.enabled = NO;
    
    _chartView.dragEnabled = YES;
    [_chartView setScaleEnabled:YES];
    _chartView.pinchZoomEnabled = YES;
    _chartView.drawGridBackgroundEnabled = NO;

    // x-axis limit line
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
    llXAxis.lineWidth = 4.0;
    llXAxis.lineDashLengths = @[@(10.f), @(10.f), @(0.f)];
    llXAxis.labelPosition = ChartLimitLabelPositionBottomRight;
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    
    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    _chartView.xAxis.gridLineDashPhase = 0.f;

    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:0 label:@"Lower Limit"];
    ll2.lineWidth = 4.0;
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionBottomRight;
    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    [leftAxis addLimitLine:ll2];
    leftAxis.axisMaximum = 10.0;
    leftAxis.axisMinimum = 0.0;
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    
    _chartView.rightAxis.enabled = NO;
    
    _chartView.legend.form = ChartLegendFormLine;
    
    [_chartView animateWithXAxisDuration:2.5];
    [self setDataCount:self.mySlider.value range:10];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sliderAction:(id)sender {
    self.daysToShow.text = [NSString stringWithFormat:@"%f days ago", self.mySlider.value];
    [self setDataCount:self.mySlider.value range:10];
}

- (void)updateChartData
{
    [self setDataCount:self.mySlider.value range:10];
}

- (void)setDataCount:(int)count range:(double)range
{
    self.dict = [[NSMutableDictionary alloc] init];
    NSDictionary *monthEndings = @{ @1: @31, @2 : @28, @6: @30};
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSInteger day = [components day];
    NSInteger month = [components month];
    NSInteger year = [components year];
    NSString *dateString = [NSString stringWithFormat:@"%li-%li-%li", (long)month, (long)day, (long)year];
    NSLog(@"%@", dateString);
    
    [self.dict setObject:[NSNumber numberWithInt:0] forKey:dateString];
    
    for(int x = 0; x < count; x++){
        day = day - 1;
        if(day == 0){
            month = month - 1;
            day = [[monthEndings objectForKey:@(month)] intValue];
        }
        dateString = [NSString stringWithFormat:@"%li-%li-%li", (long)month, (long)day, (long)year];
        NSLog(@"%@", dateString);
        [self.dict setObject:[NSNumber numberWithInt:0] forKey:dateString];
    }
    NSLog(@"%@", self.dict);
    [self queryPosts];
}

- (void) queryPosts{

    PFQuery *postQuery = [Note query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Note *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.notes = posts;
            [self setDataForGraph];
        }
    }];
}

-(void) setDataForGraph {
    
    for (int i = 0; i < self.notes.count; i++)
    {
        
        Note *myNote = [self.notes objectAtIndex:i];
        NSDate *noteDate = myNote.createdAt;

        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:noteDate];
        NSString *dateString = [NSString stringWithFormat:@"%li-%li-%li", (long)[components month], (long)[components day], (long)[components year]];
        NSLog(@"%@", dateString);
        
        if(self.dict[dateString]){
            self.dict[dateString] = @([self.dict[dateString] intValue] + 1);
            NSLog(@"%@", self.dict[dateString]);
        }
    }
    
    NSMutableArray *values = [[NSMutableArray alloc] init];
    int counter = 1;
    for(id key in self.dict) {
        [values addObject:[[ChartDataEntry alloc] initWithX:counter y:(double)[[self.dict objectForKey:key] intValue] icon: [UIImage imageNamed:@"icon"]]];
        counter += 1;
    }
    
    NSLog(@"%@", values);
    NSLog(@"hello");
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        [set1 replaceEntries: values];
        [_chartView.data notifyDataChanged];
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithEntries:values label:@"DataSet 1"];
        
        set1.drawIconsEnabled = NO;
        
        set1.lineDashLengths = @[@5.f, @2.5f];
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        [set1 setColor:UIColor.blackColor];
        [set1 setCircleColor:UIColor.blackColor];
        set1.lineWidth = 1.0;
        set1.circleRadius = 3.0;
        set1.drawCircleHoleEnabled = NO;
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        set1.formLineDashLengths = @[@5.f, @2.5f];
        set1.formLineWidth = 1.0;
        set1.formSize = 15.0;
        
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        
        set1.fillAlpha = 1.f;
       // set1.fill = [[ChartFillTypeLinearGradient alloc] initWithGradient:gradient angle:90.0f];
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
