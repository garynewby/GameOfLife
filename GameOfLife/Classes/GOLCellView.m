//
//  GOLCellView.m
//  Game Of Life
//
//  Created by Gary Newby on 03/10/2014.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import "GOLCellView.h"

@interface GOLCellView ()

@property (nonatomic, strong) NSArray *cellArray;
@property (nonatomic, strong) NSArray *matrixArray;
@property (nonatomic, assign) NSUInteger age;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;

@end


@implementation GOLCellView

- (id)initWithFrameAndIndex:(CGRect)frame index:(NSUInteger)index cellArray:(NSArray *)cellArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        NSUInteger i = index;
        
        _index = index;
        _cellArray = cellArray;
        _alive = NO;
        _matrixArray = @[@(i - (columns+1)), @(i - columns), @(i - (columns-1)), @(i + 1), @(i + (columns+1)), @(i + columns), @(i + (columns-1)), @(i - 1)];
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLive)];
        [self addGestureRecognizer:_tapRecognizer];
        
        self.userInteractionEnabled = YES;
        self.backgroundColor = kDeadColour;
        self.layer.cornerRadius = CGRectGetWidth(frame)/3.0;
    }
    return self;
}

- (void)dealloc
{
    [self removeGestureRecognizer:self.tapRecognizer];
}

- (void)toggleLive
{
    self.alive = !self.isAlive;
    self.backgroundColor = self.alive ? kAliveColour : kDeadColour;
}

- (void)checkLifeState
{
    NSUInteger liveNeighbouringCellCount = 0;
    for (NSNumber *index in self.matrixArray) {
         liveNeighbouringCellCount += [self checkCellAtIndex:[index intValue]];
    }
    // Any live cell with fewer than two live neighbours dies, as if caused by under-population
    if (self.isAlive && liveNeighbouringCellCount < 2) {
        self.alivePrePass = NO;
        self.age = 0;
    }
    // Any live cell with two or three live neighbours lives on to the next generation
    if (self.isAlive && (liveNeighbouringCellCount == 2 || liveNeighbouringCellCount == 3)) {
        self.alivePrePass = YES;
        self.age++;
    }
    // Any live cell with more than three live neighbours dies, as if by overcrowding
    if (self.isAlive && liveNeighbouringCellCount > 3) {
        self.alivePrePass = NO;
        self.age = 0;
    }
    // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
    if (!self.isAlive && liveNeighbouringCellCount == 3) {
        self.alivePrePass = YES;
        self.age = 0;
    }
}

- (void)updateLifeState
{
    self.alive = self.alivePrePass;
    self.backgroundColor = self.alive ? [UIColor colorWithHue:(self.age * 0.01) saturation:0.7 brightness:0.8 alpha:1.0] : kDeadColour;
}

- (NSUInteger)checkCellAtIndex:(NSUInteger)index
{
    if (index >= [self.cellArray count]) {
        return 0;
    }
    return (((GOLCellView *)self.cellArray[index]).isAlive ? 1 : 0);
}

@end



