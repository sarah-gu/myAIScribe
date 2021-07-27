//
//  ClassGroupingTableViewCell.h
//  myAIScribe
//
//  Created by Sarah Wen Gu on 7/27/21.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassGroupingTableViewCell : UITableViewCell <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *className;
@property (strong, nonatomic) NSArray* myNotes;
@end

NS_ASSUME_NONNULL_END
