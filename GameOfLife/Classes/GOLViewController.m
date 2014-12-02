//
//  GOLViewController.m
//  Game Of Life
//
//  Created by Gary Newby on 03/10/2014.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import "GOLViewController.h"
#import "GOLCellView.h"


@interface GOLViewController ()

@property (nonatomic, weak) IBOutlet UIButton *resetButton;
@property (nonatomic, weak) IBOutlet UIButton *clearButton;
@property (nonatomic, weak) IBOutlet UIButton *startButton;
@property (nonatomic, weak) IBOutlet UIButton *stopButton;
@property (nonatomic, weak) IBOutlet UILabel *iterationLabel;
@property (nonatomic, strong) NSMutableArray *cellViewArray;
@property (nonatomic, strong) NSMutableArray *cellViewInnerArray;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) NSUInteger generation;

@end


@implementation GOLViewController

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addContraints];
    [self addCells];
}

- (void)addContraints
{
    [self.view removeConstraints:self.view.constraints];
    self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.clearButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.startButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.stopButton.translatesAutoresizingMaskIntoConstraints = NO;
    self.iterationLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSDictionary *viewsDictionary = @{@"resetButton":self.resetButton, @"clearButton":self.clearButton, @"startButton":self.startButton, @"stopButton":self.stopButton, @"iterationLabel":self.iterationLabel};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[resetButton(95)]-10-[clearButton(65)]-10-[startButton(65)]-10-[stopButton(65)]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-25-[iterationLabel]" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[resetButton(44)]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[clearButton(44)]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[startButton(44)]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[stopButton(44)]-20-|" options:0 metrics:nil views:viewsDictionary]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[iterationLabel(44)]-20-|" options:0 metrics:nil views:viewsDictionary]];

}

#pragma  mark -

- (void)addCells
{
    self.cellViewArray = [NSMutableArray array];
    self.cellViewInnerArray = [NSMutableArray array];
    CGFloat cellSize = (CGRectGetWidth(self.view.bounds) - ((columns - 1) * cellSpace) - 20.0) / columns;
    int cellCount = 0;
    int cellCountInner = 0;
    for (int r = 0; r < rows; r++) {
        for (int c = 0; c < columns; c++) {
            GOLCellView *cellView = [[GOLCellView alloc] initWithFrameAndIndex:CGRectMake(10 + (c * (cellSize+cellSpace)), 20 + (r * (cellSize+cellSpace)), cellSize, cellSize) index:cellCount cellArray:self.cellViewArray];
            self.cellViewArray[cellCount] = cellView;
            cellView.backgroundColor = self.view.backgroundColor; // border cells
            if ([self insideBorder:r c:c]) {
                self.cellViewInnerArray[cellCountInner] = cellView;
                cellCountInner++;
                cellView.backgroundColor = kDeadColour;
            }
            [self.view addSubview:cellView];
            cellCount++;
        }
    }
}

- (void)gameLoop
{
    for (GOLCellView *cellView in self.cellViewInnerArray) {
        [cellView checkLifeState];
    }
    for (GOLCellView *cellView in self.cellViewInnerArray) {
        [cellView updateLifeState];
    }
    self.iterationLabel.text = [NSString stringWithFormat:@"Game Of Life / %06lu", (unsigned long)self.generation];
    self.generation++;
}

- (void)reset:(BOOL)randomise
{
    for (GOLCellView *cellView in self.cellViewInnerArray) {
        cellView.backgroundColor = kDeadColour;
        cellView.alive = NO;
        cellView.alivePrePass = NO;
        if (randomise && arc4random_uniform(16) == 0) {
            cellView.alive = YES;
            cellView.backgroundColor = kAliveColour;
        }
    }
    self.generation = 0;
    self.iterationLabel.text = [NSString stringWithFormat:@"Game Of Life / %06lu", (unsigned long)self.generation];
}

- (BOOL)insideBorder:(NSUInteger)r c:(NSUInteger)c
{
    return (r > 0 && r < (rows-1) && c >= 1 && c < (columns-1));
}

#pragma  mark -

- (IBAction)startTapped:(id)sender
{
    if (self.displayLink) {
        return;
    }
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(gameLoop)];
    self.displayLink.frameInterval = 12.0;
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
}

- (IBAction)stopTapped:(id)sender
{
    [self.displayLink invalidate];
    self.displayLink = nil;
}

- (IBAction)resetTapped:(id)sender
{
    [self reset:YES];
}

- (IBAction)clearTapped:(id)sender
{
    [self reset:NO];
}




@end



