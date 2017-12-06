//
//  ViewController.m
//  CycleScrollView
//
//  Created by 满艺网 on 2017/12/6.
//  Copyright © 2017年 lvzhenhua. All rights reserved.
//

#import "ViewController.h"
#import "MY3DFlowLayoutHorizon.h"
#import "CollectionViewCell.h"
@interface ViewController () <UICollectionViewDataSource,UICollectionViewDelegate>
@property (nonatomic ,strong) NSMutableArray *dataSources;
@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) MY3DFlowLayoutHorizon *flowLayout;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) NSUInteger currentSection;
@property (nonatomic ,assign) NSUInteger currentIndex;

@end

@implementation ViewController
- (NSMutableArray *)dataSources {
    if (!_dataSources) {
        _dataSources = [NSMutableArray arrayWithObjects:@"http://manyiaby.oss-cn-beijing.aliyuncs.com/banner/home/2017/11/24/fe1e26b6-c6d4-4450-a471-35cc3db37b7b.jpg/default",@"http://manyiaby.oss-cn-beijing.aliyuncs.com/banner/home/2017/11/24/41677239-2e48-4db9-a16f-c46173d7dd6e.jpg/default",@"http://manyiaby.oss-cn-beijing.aliyuncs.com/banner/home/2017/11/24/cd3bb79f-f057-467f-b4da-a577d6065d49.jpg/default", nil];
    }
    return _dataSources;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
    [self setupTimer];
    self.currentIndex = 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 200;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:(indexPath.row * 30 + 50)/255.0 green:(indexPath.row * 30 + 50)/255.0 blue:(indexPath.row * 30 + 50)/255.0 alpha:1];
    cell.urlStr = self.dataSources[indexPath.row];
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)autoScroll {
    if (self.currentSection > [self.collectionView numberOfSections]){
        self.currentSection = 0;
    }
    if (self.currentIndex > self.dataSources.count - 1) {
        self.currentIndex = 0;
        self.currentSection++;
        if (self.currentSection >= 200) {
            self.currentSection = 0;
        }
    }
    CGFloat kSpace = 10;
    CGFloat margin = (self.flowLayout.itemSize.width + kSpace);
    CGFloat sectionWidth = self.dataSources.count * margin;
    [self.collectionView setContentOffset:CGPointMake(self.currentSection * sectionWidth + self.currentIndex * margin - kSpace, 0) animated:YES];
    self.currentIndex++;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self invalidateTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self setupTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
     CGPoint offsetPoint = scrollView.contentOffset;
     [self.flowLayout targetContentOffsetForProposedContentOffset:offsetPoint];
     CGFloat margin = (self.flowLayout.itemSize.width + 10);
     CGFloat sectionWidth = self.dataSources.count * margin;
     self.currentSection = (int)(offsetPoint.x / sectionWidth);
     CGFloat offsetMargin = offsetPoint.x - self.currentSection * sectionWidth;
     self.currentIndex = (int)(offsetMargin/margin) + 1;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
   
}
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        MY3DFlowLayoutHorizon *flowlayout = [[MY3DFlowLayoutHorizon alloc] init];
        self.flowLayout = flowlayout;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 150) collectionViewLayout:flowlayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor purpleColor];
        _collectionView.alwaysBounceHorizontal = true;
        _collectionView.pagingEnabled = false;
        _collectionView.clipsToBounds = false;
        [_collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return _collectionView;
}

- (void)setupTimer {
    self.timer = [NSTimer timerWithTimeInterval:3 target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
}
@end
