//
//  CustomView.m
//  ios_Auto-Layout
//
//  Created by alvin on 16/7/3.
//  Copyright © 2016年 alvin.3G. All rights reserved.
//
#define ORANGE_COLOR    [NSColor colorWithDeviceRed:1 green:0.6 blue:0 alpha:1]
#define AQUA_COLOR    [NSColor colorWithDeviceRed:0 green:0.6745 blue:0.8039 alpha:1]

#import "CustomView.h"

@implementation CustomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSBezierPath *path;
    
    // Calculate offset from frame for 170x170 art
    CGFloat dx = (self.frame.size.width - 170) / 2.0f;
    CGFloat dy = (self.frame.size.height - 170);
    
    // Draw a shadow
    NSRect rect = NSMakeRect(8 + dx, -8 + dy, 160, 160);
    path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:32 yRadius:32];
    [[[NSColor blackColor] colorWithAlphaComponent:0.3f] set];
    [path fill];
    
    // Draw shape with outline
    rect.origin = CGPointMake(dx, dy);
    path = [NSBezierPath bezierPathWithRoundedRect:rect xRadius:32 yRadius:32];
    [[NSColor blackColor] set];
    path.lineWidth = 6;
    [path stroke];
    
    [ORANGE_COLOR set];
    [path fill];
}

- (NSSize)intrinsicContentSize
{
    // Fixed content size - base + frame
    return NSMakeSize(170, 170);
}

#define USE_ALIGNMENT_RECTS 1
#if USE_ALIGNMENT_RECTS
- (NSRect)frameForAlignmentRect:(NSRect)alignmentRect
{
    // 10 / 160 = 1.0625
    NSRect rect = (NSRect){.origin = alignmentRect.origin};
    rect.size.width = alignmentRect.size.width * 1.06250;
    rect.size.height = alignmentRect.size.height * 1.06250;
    return rect;
}

- (NSRect)alignmentRectForFrame:(NSRect)frame
{
    // 160 / 170 = 0.94117
    NSRect rect;
    CGFloat dy = (frame.size.height - 170) / 2.0; // account for vertical flippage
    rect.origin = CGPointMake(frame.origin.x, frame.origin.y + dy);
    rect.size.width = frame.size.width * 0.94117;
    rect.size.height = frame.size.height * 0.94117;
    return rect;
}
#endif

@end
