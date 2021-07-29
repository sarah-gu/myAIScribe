//
//  FollowerViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/22/21.
//

#import "FollowerViewController.h"
#import "FriendTableViewCell.h"
#import "Friends.h"
#import "Note.h"
@import Parse;

@interface FollowerViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray *myFriends;
@end

@implementation FollowerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if(!self.isFollowing){
        self.titleLabel.text = @"Following";
    }
    else{
        self.titleLabel.text = @"Followers";
    }
    
    [self queryMyFollowing];
    [self.tableView reloadData];
}

- (void) queryMyFollowing {
    PFQuery *friendQuery = [PFQuery queryWithClassName:@"Friends"];
    NSLog(@"%@", self.currentUser);
    if(!self.isFollowing){
        [friendQuery whereKey:@"following" equalTo:self.currentUser];
    }
    else{
        [friendQuery whereKey:@"follower" equalTo:self.currentUser];
    }
    [friendQuery includeKey:@"following"];
    [friendQuery includeKey:@"follower"];
    friendQuery.limit = 20;
    [friendQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable users, NSError * _Nullable error) {
        if(users){
            NSLog(@"objects: %@", users);
            self.myFriends = users;
            [self.tableView reloadData];
        }
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendTableViewCell" ];
    
    Friends *friend = self.myFriends[indexPath.row];
    NSLog(@"%@", friend);
    if(self.isFollowing){
        cell.nameLabel.text = friend[@"following"][@"username"];
    }
    else{
        cell.nameLabel.text = friend[@"follower"][@"username"];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
