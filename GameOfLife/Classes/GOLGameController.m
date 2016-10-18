//
//  NSObject+GOLGameController.m
//  GameOfLife
//
//  Created by Gary on 10/18/16.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import "GOLGameController.h"

@interface GOLGameController()

@property (nonatomic, strong) UIView *view;
@property (nonatomic, strong) NSMutableArray *cellViewArray;
@property (nonatomic, strong) NSMutableArray *cellViewInnerArray;
@property (nonatomic, assign) NSUInteger generation;
@property (nonatomic, strong) CADisplayLink *displayLink;

@end


@implementation GOLGameController

+ (UIColor *)aliveColour
{
    return [UIColor colorWithWhite:0.9 alpha:1.0];
}

+ (UIColor *)deadColour
{
    return [UIColor colorWithWhite:0.1 alpha:1.0];
}

- (instancetype)initWithView:(UIView *)view
{
    self = [super init];
    if (self) {
        _columns     = 50;
        _rows        = 63;
        _cellSpace   = 2.0;
        _view        = view;
        [self addCells];
    }
    return self;
}

#pragma  mark - Setup

- (void)addCells
{
    self.cellViewArray = [NSMutableArray array];
    self.cellViewInnerArray = [NSMutableArray array];
    CGFloat cellSize = (CGRectGetWidth(self.view.bounds) - ((self.columns - 1) * self.cellSpace) - 20.0) / self.columns;
    int cellCount = 0;
    int cellCountInner = 0;
    for (int r = 0; r < self.rows; r++) {
        for (int c = 0; c < self.columns; c++) {
            GOLCellView *cellView = [[GOLCellView alloc] initWithFrameAndIndex:CGRectMake(10 + (c * (cellSize + self.cellSpace)), 20 + (r * (cellSize + self.cellSpace)), cellSize, cellSize) index:cellCount columns:self.columns];
            self.cellViewArray[cellCount] = cellView;
            cellView.backgroundColor = self.view.backgroundColor; // border cells
            if ([self insideBorder:r c:c]) {
                self.cellViewInnerArray[cellCountInner] = cellView;
                cellCountInner++;
                cellView.backgroundColor = [GOLGameController deadColour];
            }
            [self.view addSubview:cellView];
            cellCount++;
        }
    }
}

#pragma  mark - Loop

- (void)gameLoop
{
    for (GOLCellView *cellView in self.cellViewInnerArray) {
        [self checkLifeState: cellView];
    }
    for (GOLCellView *cellView in self.cellViewInnerArray) {
        [self updateLifeState: cellView];
    }
    [self.delegate updateIterationsLabel: [NSString stringWithFormat:@"Iteration: %06lu", (unsigned long)self.generation]];
    self.generation++;
}

#pragma  mark - Actions

- (void)newGame:(BOOL)randomise
{
    for (GOLCellView *cellView in self.cellViewInnerArray) {
        cellView.backgroundColor = [GOLGameController deadColour];
        cellView.alive = NO;
        cellView.alivePrePass = NO;
        if (randomise && arc4random_uniform(16) == 0) {
            cellView.alive = YES;
            cellView.backgroundColor = [GOLGameController aliveColour];
        }
    }
    self.generation = 0;
    [self.delegate updateIterationsLabel:[NSString stringWithFormat:@"Iteration: %06lu", (unsigned long)self.generation]];
    [self continue];
}

- (void)continue
{
    if (self.displayLink) {
        return;
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
    self.displayLink.frameInterval = 12.0;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (void)stop
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (BOOL)insideBorder:(NSUInteger)r c:(NSUInteger)c
{
    return (r > 0 && r < (self.rows-1) && c >= 1 && c < (self.columns-1));
}

- (void)checkLifeState:(GOLCellView *)cellView
{
    NSUInteger liveNeighbouringCellCount = 0;
    for (NSNumber *index in cellView.matrixArray) {
        liveNeighbouringCellCount += [self checkCellAtIndex:[index intValue]];
    }
    // Any live cell with fewer than two live neighbours dies, as if caused by under-population
    if (cellView.isAlive && liveNeighbouringCellCount < 2) {
        cellView.alivePrePass = NO;
        cellView.age = 0;
    }
    // Any live cell with two or three live neighbours lives on to the next generation
    if (cellView.isAlive && (liveNeighbouringCellCount == 2 || liveNeighbouringCellCount == 3)) {
        cellView.alivePrePass = YES;
        cellView.age++;
    }
    // Any live cell with more than three live neighbours dies, as if by overcrowding
    if (cellView.isAlive && liveNeighbouringCellCount > 3) {
        cellView.alivePrePass = NO;
        cellView.age = 0;
    }
    // Any dead cell with exactly three live neighbours becomes a live cell, as if by reproduction
    if (!cellView.isAlive && liveNeighbouringCellCount == 3) {
        cellView.alivePrePass = YES;
        cellView.age = 0;
    }
}

- (void)updateLifeState:(GOLCellView *)cellView
{
    cellView.alive = cellView.alivePrePass;
    cellView.backgroundColor = cellView.alive ? [UIColor colorWithHue:(cellView.age * 0.01) saturation:0.7 brightness:0.8 alpha:1.0] : [GOLGameController deadColour];
}

- (NSUInteger)checkCellAtIndex:(NSUInteger)index
{
    if (index >= [self.cellViewArray count]) {
        return 0;
    }
    return (((GOLCellView *)self.cellViewArray[index]).isAlive ? 1 : 0);
}


@end
