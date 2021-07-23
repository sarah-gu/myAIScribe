//
//  FollowerViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/22/21.
//

#import "FollowerViewController.h"
#import "FriendTableViewCell.h"
#import "Note.h"
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
    PFQuery *query = [PFUser query];
    [query includeKey:@"friends"];
    [query whereKey:@"objectId" equalTo:self.currentUser.objectId];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            // do something with the data fetched
            self.currentUser = objects[0];
            self.myFriends = self.currentUser[@"friends"];
            NSLog(@"%@", self.myFriends);
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
    }];

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell" ];
    
    PFUser *friend = self.myFriends[indexPath.row + 1];
    NSLog(@"%@", friend);
    cell.nameLabel.text = friend[@"username"];
   
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.myFriends.count - 1;
}

-(void)getUserInfo:(NSString *) myUser{

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
