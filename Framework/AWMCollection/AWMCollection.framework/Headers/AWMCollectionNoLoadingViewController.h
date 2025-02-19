//
//  AWMCollectionNoLoadingViewController.h
//  ZContainer
//
//  Created by three stone 王 on 2019/8/22.
//  Copyright © 2019 three stone 王. All rights reserved.
//

@import AWMTransition;
#import "AWMCollectionHeaderView.h"
#import "AWMCollectionFooterView.h"
NS_ASSUME_NONNULL_BEGIN

@interface AWMCollectionNoLoadingViewController : AWMTViewController

@property (nonatomic ,strong ,readonly) UICollectionView *collectionView;

- (UICollectionView *)createCollectionWithLayout:(UICollectionViewFlowLayout *)layout;

- (UICollectionViewCell *)configCollectionViewCell:(id)data forIndexPath:(NSIndexPath *)ip ;

- (void)collectionViewSelectData:(id)data forIndexPath:(NSIndexPath *)ip ;

- (CGSize )configCollectionViewCellItemSize:(id)data forIndexPath:(NSIndexPath *)ip ;

- ( UIEdgeInsets)configCollectionViewCellSectionInset:(id)data forSection:(NSInteger )section;

- (CGFloat )configCollectionViewCellMinimumLineSpacing:(id)data forSection:(NSInteger )section ;

- (CGFloat )configCollectionViewCellMinimumInteritemSpacing:(id)data forSection:(NSInteger )section  ;
- (CGSize )configCollectionViewHeaderItemSize:(id)data forSection:(NSInteger )section ;

- (CGSize )configCollectionViewFooterItemSize:(id)data forSection:(NSInteger )section ;

- (AWMCollectionHeaderView *)configCollectionViewHeader:(id)data forIndexPath:(NSIndexPath *)ip;

- (AWMCollectionFooterView *)configCollectionViewFooter:(id)data forIndexPath:(NSIndexPath *)ip;
@end

NS_ASSUME_NONNULL_END
