//
//  VDImageBrowserCollectionViewCell.m
//  VDImageBrowserDemo
//
//  Created by Harwyn T'an on 2017/7/21.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "VDImageBrowserCollectionViewCell.h"
#import "VDImageModel.h"
#import <YYKit/YYKit.h>
#import <Masonry.h>

@interface VDImageBrowserCollectionViewCell () <UIScrollViewDelegate>

@property (nonatomic, weak) UIScrollView *imageContainerScrollView;
@property (nonatomic, weak) UIImageView *contentImageView;
@property (nonatomic, assign) CGFloat imageRealHeight;
@property (nonatomic, assign) CGFloat imageRealWidth;
//@property (nonatomic, weak) UIView *maskView;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *bottomView;
@property (nonatomic, weak) YYLabel *pageControlLbl;
@property (nonatomic, weak) YYLabel *titleLbl;
@property (nonatomic, weak) YYTextView *descriptionView;

@end

@implementation VDImageBrowserCollectionViewCell

- (void)setImageModel:(VDImageModel *)imageModel {
    _imageModel = imageModel;
    
    if (imageModel.hiddenMaskView) {
        [self hiddenMaskViewWithAnimate:NO];
    }
    else {
        [self showMaskViewWithAnimate:NO];
    }
    
    @weakify(self)
    [self.contentImageView setImageWithURL:[NSURL URLWithString:imageModel.imageSrcUrl] placeholder:nil options:YYWebImageOptionSetImageWithFadeAnimation completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        CGFloat imageRealHeight = CGImageGetHeight(image.CGImage);
        CGFloat imageRealWidth = CGImageGetWidth(image.CGImage);
        weak_self.imageRealHeight = imageRealHeight;
        weak_self.imageRealWidth = imageRealWidth;
        weak_self.contentImageView.frame = CGRectMake(0, 0, self.contentView.size.width, self.contentView.size.width * (imageRealHeight / imageRealWidth));
        weak_self.contentImageView.center = self.contentView.center;
    }];
    
    NSMutableAttributedString *mattStr = [[NSMutableAttributedString alloc] initWithString:imageModel.imageDescription];
    mattStr.font = [UIFont systemFontOfSize:17];
    mattStr.lineSpacing = 10;
    mattStr.color = [UIColor whiteColor];
    
    YYTextContainer *textContainer = [YYTextContainer containerWithSize:CGSizeMake(self.contentView.size.width - 2 * 17, CGFLOAT_MAX)];
    YYTextLayout *textLayout = [YYTextLayout layoutWithContainer:textContainer text:mattStr];
    self.descriptionView.attributedText = mattStr.copy;
    CGFloat fixedHeight = textLayout.textBoundingSize.height;
    if (fixedHeight > 300) {
        fixedHeight = 300;
    }
    [self.descriptionView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.right.offset(-17);
        make.top.equalTo(self.pageControlLbl.mas_bottom).offset(15);
        make.bottom.offset(-44);
        make.height.offset(fixedHeight);
    }];
    
    NSMutableAttributedString *pageStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%ld", (long)imageModel.imageIndex]];
    pageStr.font = [UIFont systemFontOfSize:14];
    pageStr.color = [UIColor whiteColor];
    
    [pageStr appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"/%ld", (long)imageModel.imagesCount] attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:9], NSForegroundColorAttributeName:[UIColor whiteColor]}]];
    
    self.pageControlLbl.attributedText = pageStr.copy;
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:@"标题标题标题标题标题标题"];
    titleStr.font = [UIFont systemFontOfSize:20];
    titleStr.color = [UIColor whiteColor];
    
    self.titleLbl.attributedText = titleStr.copy;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageContainerScrollView.frame = self.contentView.bounds;
    self.imageContainerScrollView.contentSize = self.contentView.bounds.size;
    if (self.imageRealWidth != 0 && self.imageRealHeight != 0) {
        self.contentImageView.frame = CGRectMake(0, 0, self.contentView.size.width, self.contentView.size.width * (self.imageRealHeight / self.imageRealWidth));
        self.contentImageView.center = self.contentView.center;
    }
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIScrollView *imageContainerScrollView = [[UIScrollView alloc] init];
        self.imageContainerScrollView = imageContainerScrollView;
        [self.contentView addSubview:imageContainerScrollView];
        imageContainerScrollView.frame = self.contentView.bounds;
        imageContainerScrollView.contentSize = self.contentView.bounds.size;
        imageContainerScrollView.delegate = self;
        imageContainerScrollView.minimumZoomScale = 1.0;
        imageContainerScrollView.maximumZoomScale = 1.8;
        imageContainerScrollView.bouncesZoom = YES;
        imageContainerScrollView.backgroundColor = [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1];
        [self.contentView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapScrollView:)]];
        
        UIImageView *contentImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        self.contentImageView = contentImageView;
        [imageContainerScrollView addSubview:contentImageView];
        
        /*
         UIView *maskView = [[UIView alloc] init];
         self.maskView = maskView;
         [self.contentView addSubview:maskView];
         [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.top.bottom.offset(0);
         }];
         */
        
        UIView *bottomView = [[UIView alloc] init];
        self.bottomView = bottomView;
        [self.contentView addSubview:bottomView];
        bottomView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.offset(0);
        }];
        
        YYLabel *pageControlLbl = [[YYLabel alloc] init];
        self.pageControlLbl = pageControlLbl;
        [bottomView addSubview:pageControlLbl];
        [pageControlLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.offset(17);
            make.height.offset(20);
        }];
        
        YYLabel *titleLbl = [[YYLabel alloc] init];
        self.titleLbl = titleLbl;
        [bottomView addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.offset(15);
            make.left.equalTo(pageControlLbl.mas_right).offset(5);
            make.height.offset(20);
        }];
        
        YYTextView *descriptionView = [[YYTextView alloc] init];
        self.descriptionView = descriptionView;
        [bottomView addSubview:descriptionView];
        descriptionView.showsVerticalScrollIndicator = NO;
        descriptionView.showsHorizontalScrollIndicator = NO;
        descriptionView.bounces = NO;
        descriptionView.editable = NO;
        descriptionView.selectable = NO;
        descriptionView.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
        [descriptionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(17);
            make.right.offset(-17);
            make.top.equalTo(pageControlLbl.mas_bottom).offset(15);
            make.bottom.offset(-44);
            make.height.offset(110);
        }];
        
        UIButton *commentBtn = [[UIButton alloc] init];
        [bottomView addSubview:commentBtn];
        [commentBtn setTitle:@"写评论..." forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        commentBtn.backgroundColor = [UIColor colorWithWhite:1 alpha:0.3];
        commentBtn.layer.cornerRadius = 16;
        commentBtn.layer.masksToBounds = YES;
        [commentBtn addTarget:self action:@selector(didClickCommentBtn:) forControlEvents:UIControlEventTouchUpInside];
        [commentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(17);
            make.height.offset(32);
            make.bottom.offset(-6);
        }];
        
        UIButton *likeBtn = [[UIButton alloc] init];
        UIButton *collectBtn = [[UIButton alloc] init];
        UIButton *allCommentBtn = [[UIButton alloc] init];
        [bottomView addSubview:likeBtn];
        [bottomView addSubview:collectBtn];
        [bottomView addSubview:allCommentBtn];
        
        [likeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.offset(44);
            make.left.equalTo(commentBtn.mas_right).offset(5);
            make.centerY.equalTo(commentBtn.mas_centerY);
        }];
        
        [collectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerY.equalTo(likeBtn);
            make.left.equalTo(likeBtn.mas_right).offset(5);
        }];
        
        [allCommentBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.centerY.equalTo(likeBtn);
            make.left.equalTo(collectBtn.mas_right).offset(5);
            make.right.offset(-5);
        }];
    }
    return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    NSArray *arr = scrollView.subviews;
    for (UIView *obj in arr) {
        if ([obj isKindOfClass:[UIImageView class]]){
            return obj;
        }
    }
    return nil;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    CGRect kBounds = scrollView.bounds;
    self.contentImageView.center = CGPointMake(kBounds.origin.x + kBounds.size.width/2, (kBounds.origin.y +kBounds.size.height)/2);
}

- (void)tapScrollView:(UITapGestureRecognizer *)tap {
    self.hiddenMaskView = !self.hiddenMaskView;
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldHiddenOrShowMaskView)]) {
        [self.delegate shouldHiddenOrShowMaskView];
    }
}

- (void)didClickCommentBtn:(UIButton *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(shouldShowCommentView)]) {
        [self.delegate shouldShowCommentView];
    }
}

- (void)setHiddenMaskView:(BOOL)hiddenMaskView {
    _hiddenMaskView = hiddenMaskView;
    if (hiddenMaskView) {
        [self hiddenMaskViewWithAnimate:YES];
    }
    else {
        [self showMaskViewWithAnimate:YES];
    }
}

- (void)hiddenMaskViewWithAnimate:(BOOL)animate {
    if (animate) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.alpha = 0;
            self.topView.alpha = 0;
        }];
    }
    else {
        self.bottomView.alpha = 0;
        self.topView.alpha = 0;
    }
}

- (void)showMaskViewWithAnimate:(BOOL)animate {
    if (animate) {
        [UIView animateWithDuration:0.5 animations:^{
            self.bottomView.alpha = 1;
            self.topView.alpha = 1;
        }];
    }
    else {
        self.bottomView.alpha = 1;
        self.topView.alpha = 1;
    }
}

@end
