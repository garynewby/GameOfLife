//
//  GOLCellView.h
//  Game Of Life
//
//  Created by Gary Newby on 03/10/2014.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GOLCellView : UIView

@property (nonatomic, strong) NSArray *matrixArray;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign, getter=isAlive) BOOL alive;
@property (nonatomic, assign, getter=isAlivePrePass) BOOL alivePrePass;

- (instancetype)initWithFrameAndIndex:(CGRect)frame index:(NSUInteger)index columns:(NSUInteger)columns;

@end
