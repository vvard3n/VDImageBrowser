//
//  VDImageModel.h
//  VDImageBrowserDemo
//
//  Created by Harwyn T'an on 2017/7/21.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VDImageModel : NSObject

@property (nonatomic, copy) NSString *imageSrcUrl;
@property (nonatomic, copy) NSString *imageDescription;
@property (nonatomic, assign) NSInteger imageIndex;
@property (nonatomic, assign) NSInteger imagesCount;
@property (nonatomic, assign) BOOL hiddenMaskView;

@end
