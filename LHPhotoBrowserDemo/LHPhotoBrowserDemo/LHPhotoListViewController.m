//
//  LHPhotoListViewController.m
//  LHPhotoBrowserDemo
//
//  Created by slihe on 16/5/17.
//  Copyright © 2016年 slihe. All rights reserved.
//

#import "LHPhotoListViewController.h"
#import "LHPhotoListCell.h"

@interface LHPhotoListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
}

@property(nonatomic, strong)NSArray *imgsArray;

@property(nonatomic, strong)NSArray *imgUrlsArray;

@end

@implementation LHPhotoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    _imgsArray = @[@"11.jpg", @"22.jpg", @"33.jpg", @"44.jpeg", @"55.jpg", @"66.jpg", @"77.jpg", @"88.jpeg", @"99.jpeg"];
    
    _imgUrlsArray = @[@"http://img.taopic.com/uploads/allimg/120928/219049-12092Q3125571.jpg", @"http://3ds.tgbus.com/UploadFiles/201308/20130826163332457.jpg", @"http://img5.pcpop.com/ProductImages/0x0/0/972/000972723.jpg", @"http://img.xgo-img.com.cn/pics/998/997219.jpg", @"http://img2.duitang.com/uploads/item/201211/10/20121110134323_X8GQK.jpeg", @"http://img4q.duitang.com/uploads/item/201403/22/20140322130003_r5HKG.jpeg", @"http://oss.pgive.com/forum/201503/28/140929ummqewcdsqssss3s.jpg", @"http://cdnq.duitang.com/uploads/item/201207/13/20120713191526_sQW8N.jpeg", @"http://s9.sinaimg.cn/orignal/5244a93cg9914e513e468&690"];
    
    _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [_tableView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LHPhotoListCell *cell = [LHPhotoListCell LHPhotoListCellWithTableView:tableView];
    
    cell.imgs = _imgsArray;
    cell.imgUrls = _imgUrlsArray;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [LHPhotoListCell cellHeight:_imgsArray.count];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

@end
