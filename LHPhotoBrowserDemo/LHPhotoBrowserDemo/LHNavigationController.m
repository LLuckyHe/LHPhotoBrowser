//
//  LHNavigationController.m
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import "LHNavigationController.h"

@interface LHNavigationController ()

@end

@implementation LHNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return self.topViewController.supportedInterfaceOrientations;
}

@end
