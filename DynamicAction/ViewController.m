//
//  ViewController.m
//  DynamicAction
//
//  Created by 董知樾 on 2017/5/19.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "ViewController.h"
#import "YYView.h"

@interface ViewController ()

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) NSMutableArray<CAShapeLayer *> *layers;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSInteger count = 2;
    CGFloat itemW = 30;
    CGFloat dotY = 30;
    NSMutableArray <UIView *>* dots = [NSMutableArray array];
    NSMutableArray <UIView *>* items = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        CGFloat X = self.view.center.x + (i - count / 2.0) * itemW;
        CGFloat dotX = X + itemW * 0.5;
        CGFloat Y = 200;
        
        if (i == 0) {
            if (count > 1) {
                Y = sqrt((200 - dotY) * (200 - dotY) - X * X) + dotY;
            }
            X = 0;
        }
        YYView *view = [[YYView alloc] initWithFrame:CGRectMake(X, Y, itemW, itemW)];
        [self.view addSubview:view];
        
        UIView *dot = [[UIView alloc] init];
        dot.bounds = CGRectMake(0, 0, 1, 1);
        dot.center = CGPointMake(dotX, dotY);
        dot.backgroundColor = UIColor.redColor;
        [self.view addSubview:dot];
        
        
        UIAttachmentBehavior *attachment = [[UIAttachmentBehavior alloc] initWithItem:view offsetFromCenter:UIOffsetMake(0, -view.bounds.size.height * 0.5) attachedToAnchor:dot.center];
        [_animator addBehavior:attachment];
        
        [items addObject:view];
        [dots addObject:dot];
    }
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:items];
    [_animator addBehavior:gravity];
    
    UICollisionBehavior *collision=[[UICollisionBehavior alloc] initWithItems:items];
    [_animator addBehavior:collision];
    
    
    _layers = [NSMutableArray array];
    __weak __typeof__(self)wself = self;
    gravity.action = ^{
        for (NSInteger i = 0; i < dots.count; i ++) {
            UIBezierPath *path = [UIBezierPath bezierPath];
            [path moveToPoint:dots[i].center];
            [path addLineToPoint:CGPointMake(items[i].center.x, items[i].center.y - itemW * 0.5)];
            path.lineWidth = 1;
            
            if (wself.layers.count <= i) {
                CAShapeLayer *layer = [CAShapeLayer layer];
                layer.strokeColor = UIColor.darkGrayColor.CGColor;
                
                [wself.view.layer addSublayer:layer];
                [wself.layers addObject:layer];
            }
            
            wself.layers[i].path = path.CGPath;
            [wself.animator updateItemUsingCurrentState:items[i]];
        }
    };
    
    
}


@end
