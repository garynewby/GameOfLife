//
//  NSObject+GOLGameController.h
//  GameOfLife
//
//  Created by Gary on 10/18/16.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GOLCellView.h"

@protocol GOLGameControllerDelegate <NSObject>

- (void)updateIterationsLabel:(NSString *)text;

@end

@interface GOLGameController : NSObject

@property (nonatomic, weak) id<GOLGameControllerDelegate> delegate;
@property (nonatomic, assign) NSUInteger columns;
@property (nonatomic, assign) NSUInteger rows;
@property (nonatomic, assign) CGFloat cellSpace;

+ (UIColor *)aliveColour;
+ (UIColor *)deadColour;

- (instancetype)initWithView:(UIView *)view;
- (void)newGame:(BOOL)randomise;
- (void)stop;
- (void)continue;
- (void)checkLifeState:(GOLCellView *)cellView;
- (void)updateLifeState:(GOLCellView *)cellView;

@end
