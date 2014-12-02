//
//  GOLCellView.h
//  Game Of Life
//
//  Created by Gary Newby on 03/10/2014.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define kAliveColour [UIColor colorWithWhite:0.9 alpha:1.0]
#define kDeadColour [UIColor colorWithWhite:0.1 alpha:1.0]

static const NSUInteger columns = 50;
static const NSUInteger rows    = 63;
static const CGFloat cellSpace  = 2.0;


@interface GOLCellView : UIView

@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter=isAlive) BOOL alive;
@property (nonatomic, assign, getter=isAlivePrePass) BOOL alivePrePass;

- (id)initWithFrameAndIndex:(CGRect)frame index:(NSUInteger)index cellArray:(NSArray *)cellArray;
- (void)checkLifeState;
- (void)updateLifeState;

@end
