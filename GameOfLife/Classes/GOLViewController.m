//
//  GOLViewController.m
//  Game Of Life
//
//  Created by Gary Newby on 03/10/2014.
//  Copyright (c) 2014 Gary Newby. All rights reserved.
//

#import "GOLViewController.h"
#import "GOLGameController.h"

@interface GOLViewController () <GOLGameControllerDelegate>

@property (nonatomic, weak) IBOutlet UILabel *iterationLabel;
@property (nonatomic, strong) GOLGameController *gameController;

@end


@implementation GOLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.gameController = [[GOLGameController alloc] initWithView:self.view];
    self.gameController.delegate = self;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma  mark - Controls

- (IBAction)newTapped:(id)sender
{
    [self.gameController newGame:YES];
}

- (IBAction)continueTapped:(id)sender
{
    [self.gameController continue];
}

- (IBAction)stopTapped:(id)sender
{
   [self.gameController stop];
}

#pragma mark - GOLGameControllerDelegate

- (void)updateIterationsLabel:(NSString *)text
{
    self.iterationLabel.text = text;
}



@end



