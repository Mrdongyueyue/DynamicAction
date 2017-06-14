//
//  YYView.m
//  DynamicAction
//
//  Created by 董知樾 on 2017/5/19.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "YYView.h"

@implementation YYView

//- (void)layoutSubviews {
//    [super layoutSubviews];
//    self.layer.cornerRadius = self.frame.size.width / 2;
//    self.layer.borderWidth = 1;
//    self.layer.borderColor = UIColor.lightGrayColor.CGColor;
//    self.layer.masksToBounds = YES;
//}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"篮球"].CGImage);
    }
    return self;
}

- (UIDynamicItemCollisionBoundsType)collisionBoundsType {
    return UIDynamicItemCollisionBoundsTypeEllipse;
}

@end
