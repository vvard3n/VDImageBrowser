//
//  VDImageBrowserViewController.m
//  VDImageBrowserDemo
//
//  Created by Harwyn T'an on 2017/7/21.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "VDImageBrowserViewController.h"
#import "VDImageBrowserCollectionViewCell.h"
#import "VDImageModel.h"
#import "VDCommentTextField.h"
#import <Masonry.h>

static NSString *const imageBrowserCollectionViewCellReuseIdentifier = @"imageBrowserCollectionViewCellReuseIdentifier";

@interface VDImageBrowserViewController () <UICollectionViewDelegate, UICollectionViewDataSource, VDImageBrowserCollectionViewCellDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, weak) UIView *topView;
@property (nonatomic, weak) UIView *commentView;
@property (nonatomic, weak) VDCommentTextField *commentTextField;
@property (nonatomic, weak) UIButton *sentbtn;
@property (nonatomic, weak) UIView *closeCommentMaskView;

@property (nonatomic, assign) BOOL hiddenMaskView;

@end

@implementation VDImageBrowserViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.collectionView.frame = self.view.bounds;
    self.flowLayout.itemSize = self.view.bounds.size;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    self.closeCommentMaskView.hidden = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.commentView.frame = CGRectMake(0, self.view.bounds.size.height - (height + 48), self.view.bounds.size.width, 48);
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification {
    self.closeCommentMaskView.hidden = YES;
    self.commentView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 48);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowLayout = flowLayout;
    flowLayout.itemSize = self.view.bounds.size;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.pagingEnabled = YES;
    collectionView.bounces = NO;
    
    [self.collectionView registerClass:[VDImageBrowserCollectionViewCell class] forCellWithReuseIdentifier:imageBrowserCollectionViewCellReuseIdentifier];
    
    UIView *topView = [[UIView alloc] init];
    self.topView = topView;
    [self.view addSubview:topView];
    topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.offset(0);
        make.height.offset(64);
    }];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    [closeBtn setTitle:@"✕" forState:UIControlStateNormal];
    [closeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setTitle:@"享" forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [topView addSubview:shareBtn];
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.offset(0);
        make.height.width.offset(44);
    }];
    
    UIView *closeCommentMaskView = [[UIView alloc] init];
    self.closeCommentMaskView = closeCommentMaskView;
    closeCommentMaskView.hidden = YES;
    [closeCommentMaskView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)]];
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeKeyboard:)];
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown | UISwipeGestureRecognizerDirectionLeft | UISwipeGestureRecognizerDirectionRight;
    [closeCommentMaskView addGestureRecognizer:swipe];
    
    [self.view addSubview:closeCommentMaskView];
    [closeCommentMaskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.offset(0);
    }];
    
    UIView *commentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, 48)];
    self.commentView = commentView;
    commentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:commentView];
    VDCommentTextField *commentTextField = [[VDCommentTextField alloc] init];
    self.commentTextField = commentTextField;
    commentTextField.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    commentTextField.layer.cornerRadius = 19;
    commentTextField.layer.masksToBounds = YES;
    commentTextField.placeholder = @"Comment Text...";
    [commentView addSubview:commentTextField];
    [commentTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.top.offset(5);
        make.bottom.offset(-5);
    }];
    UIButton *sentbtn = [[UIButton alloc] init];
    self.sentbtn = sentbtn;
    [sentbtn setTitle:@"发布" forState:UIControlStateNormal];
    [sentbtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [commentView addSubview:sentbtn];
    [sentbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-17);
        make.bottom.top.offset(0);
        make.left.equalTo(commentTextField.mas_right).offset(10);
        make.width.offset(50);
    }];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    VDImageBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imageBrowserCollectionViewCellReuseIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    VDImageModel *model = [[VDImageModel alloc] init];
    model.imageSrcUrl = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    model.imageDescription = @"https://ss0.bdstatic.com/5aV1bjqh_Q23odCf/static/superman/img/logo/bd_logo1_31bdc765.png";
    model.imageIndex = indexPath.item + 1;
    model.imagesCount = 10;
    model.hiddenMaskView = self.hiddenMaskView;
    VDImageBrowserCollectionViewCell *imageVrowserCollectionViewCell = (VDImageBrowserCollectionViewCell *)cell;
    imageVrowserCollectionViewCell.imageModel = model;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (void)shouldHiddenOrShowMaskView {
    self.hiddenMaskView = !self.hiddenMaskView;
    
    if (self.hiddenMaskView) {
        [UIView animateWithDuration:0.5 animations:^{
            self.topView.alpha = 0;
        }];
    }
    else {
        [UIView animateWithDuration:0.5 animations:^{
            self.topView.alpha = 1;
        }];
    }
}

- (void)shouldShowCommentView {
    [self.commentTextField becomeFirstResponder];
}

- (void)closeKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    [self.view endEditing:YES];
}

- (void)closeBtnClick:(UIButton *)sender {
    [self closeSelf];
}

- (void)rightBtnClick:(UIButton *)sender {
    
}

- (BOOL)isNavPush {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1) {
        if ([viewcontrollers objectAtIndex:viewcontrollers.count-1]==self) {
            //push方式
            return YES;
        }
    }
    //present方式
    return NO;
}

- (void)closeSelf {
    if (self.isNavPush) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
