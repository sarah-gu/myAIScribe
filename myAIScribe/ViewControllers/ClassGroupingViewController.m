//
//  ClassGroupingViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//

#import "ClassGroupingViewController.h"
#import "ClassGroupingTableViewCell.h"
#import "Note.h"
@import Parse;

@interface ClassGroupingViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *myClasses;
@property (strong, nonatomic) NSMutableArray *idxToClassTracker;
@end

@implementation ClassGroupingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.myClasses = [[NSMutableArray alloc] init];
    self.idxToClassTracker = [[NSMutableArray alloc] init];
    
    [self getClassesFromNotes];
    [self.tableView reloadData]; 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassGroupingTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"ClassGroupingTableViewCell"];
    cell.myNotes= self.myClasses[indexPath.row];
    cell.className.text = self.idxToClassTracker[indexPath.row];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myClasses.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 200;
}

-(void) getClassesFromNotes {
    for(id myNote in self.allNotes){
        if(![myNote[@"subject1"] isEqual:@""]){
            [self classifyNote:myNote withSubject:@"subject1"];
        }
        if(![myNote[@"subject1"] isEqual:@""] && ![myNote[@"subject2"] isEqual:@""]){
            [self classifyNote:myNote withSubject:@"subject2"];
        }
        if(![myNote[@"subject1"] isEqual:@""] && ![myNote[@"subject2"] isEqual:@""] && ![myNote[@"subject3"] isEqual:@""] ) {
            [self classifyNote:myNote withSubject:@"subject3"];
        }
    }
}

-(void) classifyNote: (Note *)myNote withSubject: (NSString *)subject {
    NSString *currentClass = [[myNote[subject] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] lowercaseString];
    if([self.idxToClassTracker containsObject:currentClass]) {
        int classIdx = (int)[self.idxToClassTracker indexOfObject:currentClass];
        [self.myClasses[classIdx] addObject: myNote];
    }
    else{
        NSMutableArray *newClass = [@[myNote] mutableCopy];
        [self.myClasses addObject:newClass];
        [self.idxToClassTracker addObject:currentClass];
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
