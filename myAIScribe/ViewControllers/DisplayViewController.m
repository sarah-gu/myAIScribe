//
//  DisplayViewController.m
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/12/21.
//

#import "DisplayViewController.h"
#import "Parse/Parse.h"
#import "NoteTableViewCell.h"
#import <UIKit/UIKit.h>
#import "Note.h"
#import "LoginViewController.h"
#import "SceneDelegate.h"
#import "DetailsViewController.h"

@interface DisplayViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *notesViewControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *notes;
@property (nonatomic, strong) NSMutableArray *filteredNotes;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic) int selectedID;
@end

@implementation DisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    
    self.selectedID = (int) self.notesViewControl.selectedSegmentIndex;
    [self queryPosts];
    self.refreshControl = [[UIRefreshControl alloc] init]; //instantiate the refreshControl
    [self.refreshControl addTarget:self action:@selector( queryPosts) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NoteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteTableViewCell" ];
    cell.photoImageView.layer.cornerRadius = 20;
    cell.photoImageView.clipsToBounds = YES;
    [cell setNote:self.filteredNotes[indexPath.row]];
    
    return cell;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.filteredNotes.count;
}
- (IBAction)onViewSwitch:(id)sender {
    
    self.selectedID  = (int) self.notesViewControl.selectedSegmentIndex;
    
    NSString *titleLabels[] = {@"My Notes", @"All Notes"};
    self.titleLabel.text = titleLabels[self.notesViewControl.selectedSegmentIndex];
    [self queryPosts];
    [self.tableView reloadData];
    
}

- (void) queryPosts{

    PFQuery *postQuery = [Note query];
    [postQuery orderByDescending:@"createdAt"];
    if(self.selectedID == 0){
        [postQuery whereKey:@"author" equalTo:[PFUser currentUser]];
    }
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;

    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Note *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            // do something with the data fetched
            self.notes = posts;
            self.filteredNotes = [self.notes mutableCopy];
            [self.tableView reloadData];
        }
        else {
            // handle error
        }
    }];
    
    [self.refreshControl endRefreshing];
}

// ----- search bar functionality ---
- (void)searchBar:searchBar textDidChange:(nonnull NSString *)searchText {
    if(searchText.length != 0){
       NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(Note *evaluatedObject, NSDictionary *bindings){
            return [[evaluatedObject[@"caption"] lowercaseString] containsString:[searchText lowercaseString]]; //check containsString for toLower parameter
       }];
       // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", searchText];
        self.filteredNotes= [[self.notes filteredArrayUsingPredicate:predicate] mutableCopy];
    }
    else{
        self.filteredNotes = [self.notes mutableCopy];
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
// ---end search bar functionality --

- (IBAction)logoutBtn:(id)sender {
    
    SceneDelegate *appDelegate = (SceneDelegate *)self.view.window.windowScene.delegate;
    //AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController" ];
    appDelegate.window.rootViewController = loginViewController;
    NSLog(@"logged out");
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
    }];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([@"detailSegue"  isEqual: segue.identifier]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Note *note = self.filteredNotes[indexPath.row];
        
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.note = note;
    }
    
}


@end
