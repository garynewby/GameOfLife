//
//  GOLCellView.m
//  Game Of Life
//
//  Created by Gary Newby on 03/10/2014.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import "GOLCellView.h"
#import "GOLGameController.h"

@interface GOLCellView ()
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@end


@implementation GOLCellView

- (instancetype)initWithFrameAndIndex:(CGRect)frame index:(NSUInteger)index columns:(NSUInteger)columns
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [GOLGameController deadColour];
        self.layer.cornerRadius = CGRectGetWidth(frame)/3.0;
        
        _index = index;
        _alive = NO;
        
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleLive)];
        [self addGestureRecognizer:_tapRecognizer];
        
        _matrixArray = @[@(index - (columns+1)),
                         @(index - columns),
                         @(index - (columns-1)),
                         @(index + 1),
                         @(index + (columns+1)),
                         @(index + columns),
                         @(index + (columns-1)),
                         @(index - 1)];

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
    self.backgroundColor = self.alive ? [GOLGameController aliveColour] : [GOLGameController deadColour];
}


@end



