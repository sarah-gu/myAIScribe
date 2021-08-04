//
//  FindFriendsViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/30/21.
//

#import "FindFriendsViewController.h"
#import "FindFriendTableViewCell.h"
@import Parse;

@interface FindFriendsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *allUsers;
@property (strong, nonatomic) NSArray *filteredUsers;
@end

@implementation FindFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    [self queryMyFriends];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.filteredUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FindFriendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FindFriendTableViewCell" ];
    cell.clickedUser = self.filteredUsers[indexPath.row];
    cell.nameLabel.text = self.filteredUsers[indexPath.row][@"username"];
    if(self.filteredUsers[indexPath.row][@"profilePicture"] == nil){
        [cell.profilePicture setImage:[UIImage systemImageNamed:@"suit.heart.fill"]];
    }
    else {
        cell.profilePicture.file = self.filteredUsers[indexPath.row][@"profilePicture"];
        [cell.profilePicture loadInBackground];
    }
    
    PFUser *currentUser = [PFUser currentUser];
    NSArray *keys = [currentUser[@"friends"] valueForKeyPath:@"objectId"];
    if([keys containsObject:[self.filteredUsers[indexPath.row] objectId]]) {
         NSLog(@"nice");
        [cell.followBtn setTitle:@"Following" forState:UIControlStateNormal];
        cell.followBtn.enabled = NO;
    }
    return cell;
}

- (void) queryMyFriends {
    PFQuery *query = [PFUser query];
    [query whereKey:@"username" notEqualTo:[PFUser currentUser][@"username"]];
    [query includeKey:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects) {
            // do something with the data fetched
            self.allUsers = objects;
            self.filteredUsers = objects;
            NSLog(@"%@", self.allUsers); 
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
    }];
}

- (void)searchBar:searchBar textDidChange:(nonnull NSString *)searchText {
    if(searchText.length != 0){
       NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(PFUser *evaluatedObject, NSDictionary *bindings){
            return [[evaluatedObject[@"username"] lowercaseString] containsString:[searchText lowercaseString]]; //check containsString for toLower parameter
       }];
        self.filteredUsers= [[self.allUsers filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else{
        self.filteredUsers = [self.allUsers mutableCopy];
    }
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.showsCancelButton = NO;
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
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
