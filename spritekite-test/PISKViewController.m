//
//  PISKViewController.m
//  spritekite-test
//
//  Created by Maxim Berezhnoy on 16.09.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "PISKViewController.h"
#import "PISKMyScene.h"

@implementation PISKViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
#if __MY_APP_DEV_FPS==1
    skView.showsFPS = YES;
#endif
#if __MY_APP_DEV_NODES==1
    skView.showsNodeCount = YES;
#endif
    // Create and configure the scene.
    SKScene * scene = [PISKMyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
