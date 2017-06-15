//
//  GravityViewController.m
//  DynamicAction
//
//  Created by 董知樾 on 2017/6/14.
//  Copyright © 2017年 董知樾. All rights reserved.
//

#import "GravityViewController.h"
#import "YYView.h"
#import <CoreMotion/CoreMotion.h>

@interface GravityViewController ()
@property (weak, nonatomic) IBOutlet UIView *funcView;

@property (strong, nonatomic) UIDynamicAnimator *animator;

@property (strong, nonatomic) UIGravityBehavior *gravity;

@property (strong, nonatomic) UICollisionBehavior *collision;

@property (strong, nonatomic) UIDynamicItemBehavior *itemBehavior;

@property (strong, nonatomic) CMMotionManager *motionManager;

@end

@implementation GravityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    NSInteger count = 5;
    CGFloat itemW = 30;
    NSMutableArray <UIView *>* items = [NSMutableArray array];
    for (NSInteger i = 0; i < count; i ++) {
        CGFloat X = i % 10 * itemW;
        CGFloat Y = (35 + i / 10);
        
        YYView *view = [[YYView alloc] initWithFrame:CGRectMake(X, Y, itemW, itemW)];
        view.layer.cornerRadius = itemW / 2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.lightGrayColor.CGColor;
        view.layer.masksToBounds = YES;
        [self.view insertSubview:view belowSubview:_funcView];
        
        [items addObject:view];
    }
    _gravity = [[UIGravityBehavior alloc] initWithItems:items];
    [_animator addBehavior:_gravity];
    
    _collision = [[UICollisionBehavior alloc] initWithItems:items];
    [_collision addBoundaryWithIdentifier:@"view" forPath:[UIBezierPath bezierPathWithRect:[UIScreen mainScreen].bounds]];
    [_animator addBehavior:_collision];
    
    _itemBehavior = [[UIDynamicItemBehavior alloc] initWithItems:items];
    _itemBehavior.elasticity = 0.5;
    _itemBehavior.allowsRotation = YES;
    [_animator addBehavior:_itemBehavior];
    
    _motionManager = [[CMMotionManager alloc] init];
    
    if (_motionManager.deviceMotionAvailable) {
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        
        [_motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
            if (!error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    _gravity.gravityDirection = CGVectorMake(motion.gravity.x, -motion.gravity.y);
                });
            }
        }];
    }else{
        NSLog(@"deviceMotion不可用");
    }
    
    
}

#if TARGET_IPHONE_SIMULATOR

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGVector ve0 = CGVectorMake(0, 1);
    CGVector ve1 = CGVectorMake(1, 0);
    CGVector ve2 = CGVectorMake(0, -1);
    CGVector ve3 = CGVectorMake(-1, 0);
    if (CGVectorEqualToVector(_gravity.gravityDirection, ve0)) {
        _gravity.gravityDirection = ve1;
    } else if (CGVectorEqualToVector(_gravity.gravityDirection, ve1)) {
        _gravity.gravityDirection = ve2;
    } else if (CGVectorEqualToVector(_gravity.gravityDirection, ve2)) {
        _gravity.gravityDirection = ve3;
    } else if (CGVectorEqualToVector(_gravity.gravityDirection, ve3)) {
        _gravity.gravityDirection = ve0;
    }
}

NS_INLINE BOOL CGVectorEqualToVector(CGVector vector0, CGVector vector1) {
    return (vector0.dx == vector1.dx) && (vector0.dy == vector1.dy);
}

#endif

- (IBAction)dismissClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)addButtonClick:(UIButton *)sender {
    NSInteger count = 10;
    CGFloat itemW = 30;
    
    for (NSInteger i = 0; i < count; i ++) {
        CGFloat X = i % 10 * itemW;
        CGFloat Y = (35 + i / 10);
        
        YYView *view = [[YYView alloc] initWithFrame:CGRectMake(X, Y, itemW, itemW)];
        view.layer.cornerRadius = itemW / 2;
        view.layer.borderWidth = 1;
        view.layer.borderColor = UIColor.lightGrayColor.CGColor;
        view.layer.masksToBounds = YES;
        [self.view insertSubview:view belowSubview:_funcView];
        
        [_collision addItem:view];
        [_gravity addItem:view];
        [_itemBehavior addItem:view];
    }
    
}

@end
