//
//  VDImageBrowserCollectionViewCell.h
//  VDImageBrowserDemo
//
//  Created by Harwyn T'an on 2017/7/21.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VDImageBrowserCollectionViewCellDelegate <NSObject>

- (void)shouldHiddenOrShowMaskView;
- (void)shouldShowCommentView;

@end

@class VDImageModel;
@interface VDImageBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic, weak) id <VDImageBrowserCollectionViewCellDelegate> delegate;
@property (nonatomic, strong) VDImageModel *imageModel;

@property (nonatomic, assign) BOOL hiddenMaskView;

@end
