//
//  VDCommentTextField.m
//  VDImageBrowserDemo
//
//  Created by Harwyn T'an on 2017/7/22.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "VDCommentTextField.h"

@implementation VDCommentTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset( bounds , 20 , 0 );
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 20 , 0 );
}

@end
