//
//  FollowerViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/22/21.
//

#import "FollowerViewController.h"
#import "FriendTableViewCell.h"
@import Parse;

@interface FollowerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *myFriends;
@end

@implementation FollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Do any additional setup after loading the view.
    self.myFriends = self.currentUser[@"friends"];
    NSLog(@"%@", self.myFriends);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell" ];
    PFUser *friend = self.myFriends[1];
    NSLog(@"%@", self.myFriends[1]);
    cell.nameLabel.text = friend[@"username"];
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myFriends.count;
    
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
