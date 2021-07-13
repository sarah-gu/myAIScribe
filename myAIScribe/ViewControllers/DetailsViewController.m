//
//  DetailsViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "DetailsViewController.h"
@import Parse;

@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet PFImageView *largeImageView;
@property (weak, nonatomic) IBOutlet UITextView *generatedCaption;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _note = self.note;
    self.largeImageView.file = self.note[@"image"];
    [self.largeImageView loadInBackground];
    self.generatedCaption.text = self.note[@"caption"]; 
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
