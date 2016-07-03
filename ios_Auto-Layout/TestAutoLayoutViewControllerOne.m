//
//  ViewController.m
//  ios_Auto-Layout
//
//  Created by alvin on 16/7/3.
//  Copyright © 2016年 alvin.3G. All rights reserved.
//

#import "TestAutoLayoutViewControllerOne.h"
#import "ConstraintUtilities-Install.h"

#define ORANGE_COLOR    [UIColor colorWithRed:1.0f green:0.6f blue:0.0f alpha:1.0f]
#define IS_HORIZONTAL_ALIGNMENT(ALIGNMENT) [@[@(NSLayoutFormatAlignAllLeft), @(NSLayoutFormatAlignAllRight), @(NSLayoutFormatAlignAllLeading), @(NSLayoutFormatAlignAllTrailing), @(NSLayoutFormatAlignAllCenterX), ] containsObject:@(ALIGNMENT)]

#define HYBRID 0
#define CONSTRAININGTOSUPERVIEW  0
#define STRETCH 0
#define CONSTRAINEDSIZE 0
#define BUILDROW 1
#define MATCHING 0

@interface TestAutoLayoutViewControllerOne (){
    NSMutableArray *views;
    
    /**Constraining to Superview*/
#if CONSTRAININGTOSUPERVIEW
    //NSMutableArray *views;
    NSArray *constraints;
    NSLayoutConstraint *constraint;
#endif
#if STRETCH
    //NSMutableArray *views;
#endif
}

@end

@implementation TestAutoLayoutViewControllerOne

#pragma mark - Constrain Views
// Constrain to superview
void constrainWithinSuperview(UIView *view, float minimumSize, NSUInteger priority)
{
    if (!view || !view.superview)
        return;
    
    for (NSString *format in @[
                               @"H:|->=0@priority-[view(==minimumSize@priority)]",
                               @"H:[view]->=0@priority-|",
                               @"V:|->=0@priority-[view(==minimumSize@priority)]",
                               @"V:[view]->=0@priority-|"])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"priority":@(priority), @"minimumSize":@(minimumSize)} views:@{@"view": view}];
        [view.superview addConstraints:constraints];
    }
}

#pragma mark - Constrain Size
void constrainViewSize(UIView *view, CGSize size, NSUInteger priority)
{
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"width":@(size.width), @"height":@(size.height), @"priority":@(priority)};
    
    for (NSString *formatString in @[
                                     @"H:[view(==width@priority)]",
                                     @"V:[view(==height@priority)]",
                                     ])
    {
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:formatString
                                options:0 metrics:metrics views:bindings];
        //[view addConstraints:constraints];
        //Equal Only When constraints
        for (NSLayoutConstraint *constraint in constraints)
            [constraint install];
    }
}

void constrainMinimumViewSize(UIView *view, CGSize size, NSUInteger priority)
{
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"width":@(size.width), @"height":@(size.height), @"priority":@(priority)};
    
    for (NSString *formatString in @[
                                     @"H:[view(>=width@priority)]",
                                     @"V:[view(>=height@priority)]",
                                     ])
    {
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:formatString
                                options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
}

void constrainMaximumViewSize(UIView *view, CGSize size, NSUInteger priority)
{
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSDictionary *metrics = @{@"width":@(size.width), @"height":@(size.height), @"priority":@(priority)};
    
    for (NSString *formatString in @[
                                     @"H:[view(<=width@priority)]",
                                     @"V:[view(<=height@priority)]",
                                     ])
    {
        NSArray *constraints = [NSLayoutConstraint
                                constraintsWithVisualFormat:formatString
                                options:0 metrics:metrics views:bindings];
        [view addConstraints:constraints];
    }
}

#pragma mark - Stretch Views
void stretchToSuperview(UIView *view, CGFloat indent, NSUInteger priority)
{
    for (NSString *format in @[
                               @"H:|-indent-[view(>=0)]-indent-|",
                               @"V:|-indent-[view(>=0)]-indent-|"
                               ])
    {
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"indent":@(indent)} views:@{@"view": view}];
        [view.superview addConstraints:constraints];
    }
}

#pragma mark - Create Views
UIColor *randomColor()
{
    UIColor *theColor = [UIColor colorWithRed:((random() % 255) / 255.0f)
                                        green:((random() % 255) / 255.0f)
                                         blue:((random() % 255) / 255.0f)
                                        alpha:1.0f];
    return theColor;
}

#if (BUILDROW || MATCHING)
- (void) addViews: (NSInteger) howMany
{
    views = [NSMutableArray array];
    
    for (int i = 0; i < howMany; i++)
    {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = randomColor();
        [self.view addSubview:view];
        [views addObject:view];
        //!MATCHING
        //constrainViewSize(view, CGSizeMake(40, 40), 1);
        MATCHING ? :constrainViewSize(view, CGSizeMake(40, 40), 1);
    }
     
    NSArray *constraints;
    UIView *view = views[0];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[view]" options:0 metrics:nil views:@{@"view":view}];
    for (NSLayoutConstraint *constraint in constraints)
        [constraint install];
    
    constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[view]" options:0 metrics:nil views:@{@"view":view}];
    for (NSLayoutConstraint *constraint in constraints)
        [constraint install];
}
#else
- (void) addViews: (NSInteger) howMany
{
    views = [NSMutableArray array];
    
    for (int i = 0; i < howMany; i++)
    {
        UIView *view = [[UIView alloc] init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        view.backgroundColor = randomColor();
        [self.view addSubview:view];
        
        [views addObject:view];
        constrainWithinSuperview(view, 100, 1);
    }
}

#endif

#pragma mark [view1]-(CGFloat)space-[view2]
void buildLineWithSpacing(NSArray *views, NSLayoutFormatOptions alignment, NSString *spacing, NSUInteger priority)
{
    if (!views.count)
        return;
    
    VIEW_CLASS *view1, *view2;
    NSInteger axis = IS_HORIZONTAL_ALIGNMENT(alignment);
    NSString *axisString = (axis == 0) ? @"H:" : @"V:";
    
    NSString *format = [NSString stringWithFormat:@"%@[view1]%@[view2]", axisString, spacing];
    
    for (int i = 1; i < views.count; i++)
    {
        view1 = views[i-1];
        view2 = views[i];
        NSDictionary *bindings = NSDictionaryOfVariableBindings(view1, view2);
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:alignment metrics:nil views:bindings];
        for (NSLayoutConstraint *constraint in constraints)
            [constraint install:priority];
    }
}
#pragma mark - match the size of first item
void matchSizes(NSArray *views, NSInteger axis, NSUInteger priority)
{
    if (!views.count)
        return;
    
    NSString *format = axis ? @"V:[view2(==view1@priority)]" : @"H:[view2(==view1@priority)]";
    
    UIView *view1 = views[0];
    for (int i = 1; i < views.count; i++)
    {
        UIView *view2 = views[i];
        NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:@{@"priority":@(priority)} views:NSDictionaryOfVariableBindings(view1, view2)];
        for (NSLayoutConstraint *constraint in constraints)
            [constraint install];
    }
}

#pragma mark - HYBRID Class
#if HYBRID
- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *subview = [[[NSBundle mainBundle] loadNibNamed:@"View" owner:self options:nil] lastObject];
    [self.view addSubview:subview];
    
    subview.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *constraint;
    
    // Center it
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
    // Set its aspect
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:subview attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
    // Constrain it to the superview's size
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:-40];
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-40];
    [self.view addConstraint:constraint];
    
    // Add a weak "match size" constraint
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:-40];
    constraint.priority = 100;
    [self.view addConstraint:constraint];
    constraint = [NSLayoutConstraint constraintWithItem:subview attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeHeight multiplier:1 constant:-40];
    constraint.priority = 100;
    [self.view addConstraint:constraint];
    
}
#endif

#pragma mark - Constraining to Superview Class
#if CONSTRAININGTOSUPERVIEW
- (void) viewDidAppear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
        NSLog(@"View: %@", NSStringFromCGRect(view.frame));
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    srandom(time(0));
    [self addViews:3];
}
#endif

#pragma mark - Stretching  Class
#if STRETCH
- (void) viewDidAppear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
        NSLog(@"View: %@", NSStringFromCGRect(view.frame));
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addViews:4];
    for (int i = 0; i < 4; i++)
        stretchToSuperview(views[i], 20 * (i + 1), 500);
}
#endif

#pragma mark - Constrained Size Class
#if CONSTRAINEDSIZE
- (void) viewDidAppear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
        NSLog(@"View: %@", NSStringFromCGRect(view.frame));
}

- (void) centerView: (UIView *) view
{
    NSLayoutConstraint *constraint;
    
    constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    [self.view addConstraint:constraint];
    
    constraint = [NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    [self.view addConstraint:constraint];
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addViews:4];
    for (int i = 0; i < 4; i++)
    {
        [self centerView:views[i]];
        //constrainViewSize(views[i], CGSizeMake((8 - i) * 20, (8 - i) * 20), 500);
        constrainMinimumViewSize(views[i], CGSizeMake((8 - i) * 20, (8 - i) * 20), 500);
    }
}

#endif

#pragma mark - Build Row Class
#if BUILDROW
- (void) viewDidAppear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
        NSLog(@"View: %@", NSStringFromCGRect(view.frame));
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addViews:6];
    buildLineWithSpacing(views, NSLayoutFormatAlignAllCenterX, @"-", 500);
    //buildLineWithSpacing(views, NSLayoutFormatAlignAllCenterY, @"-", 500);
}
#endif

#pragma mark - matching class
#if MATCHING
- (void) viewDidAppear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
        NSLog(@"View: %@", NSStringFromCGRect(view.frame));
}

- (void) loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addViews:6];
    constrainViewSize(views[0], CGSizeMake(40, 40), 1);
    buildLineWithSpacing(views, NSLayoutFormatAlignAllCenterY, @"-", 500);
    matchSizes(views, 0, 500); //horizontal
    matchSizes(views, 1, 500); //vertical
}
#endif

#pragma mark -viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
}



@end
