//
//  ViewController.m
//  MAC_Auto-Layout
//
//  Created by alvin on 16/7/3.
//  Copyright © 2016年 alvin.3G. All rights reserved.
//

#define USE_CustomView 1

#import "ViewController.h"
#import "CustomView.h"

@interface ViewController(){
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}

#pragma mark - USE_CustomView
#if USE_CustomView
- (void) awakeFromNib
{
    CustomView *view = [[CustomView alloc] init];
    [self.view addSubview:view];
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:constraint];
}
#endif

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

@end
