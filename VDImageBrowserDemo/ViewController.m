//
//  ViewController.m
//  VDImageBrowserDemo
//
//  Created by Harwyn T'an on 2017/7/21.
//  Copyright © 2017年 vvard3n. All rights reserved.
//

#import "ViewController.h"
#import "VDImageBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *btn = [[UIButton alloc] init];
    [self.view addSubview:btn];
    btn.frame = CGRectMake(0, 100, 500, 100);
    [btn setTitle:@"Show Image Browser" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showImageBrowser) forControlEvents:UIControlEventTouchUpInside];
}

- (void)showImageBrowser {
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[VDImageBrowserViewController alloc] init]];
    [self presentViewController:navVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
