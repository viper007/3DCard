//
//  CollectionViewCell.m
//  CycleScrollView
//
//  Created by 满艺网 on 2017/12/6.
//  Copyright © 2017年 lvzhenhua. All rights reserved.
//

#import "CollectionViewCell.h"
#import <UIImageView+WebCache.h>
@interface CollectionViewCell()

@property (nonatomic ,strong) UIImageView *imageView;

@end

@implementation CollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageView = imageView;
        imageView.backgroundColor = [UIColor yellowColor];
        [self.contentView addSubview:imageView];
    }
    return self;
}

- (void)setUrlStr:(NSString *)urlStr {
    _urlStr = urlStr;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlStr]];
}

@end
