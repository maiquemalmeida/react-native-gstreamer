//
//  RCTGSTPlayerController.m
//  GStreamerIOS
//
//  Created by Alann Sapone on 26/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import "GstPlayerController.h"
#import <UIKit/UIKit.h>
#include <gst/gst.h>
#include "EaglUIView.h"

@implementation GstPlayerController

@synthesize uri;
@synthesize gst_backend;

/*
 * Methods from RCTGSTPlayerController
 */

@dynamic view;
- (void)loadView {
    self.view = [[EaglUIView alloc] initWithFrame:UIScreen.mainScreen.applicationFrame];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    gst_backend = [[GStreamerBackend alloc] init:self videoView:self.view];
}

/* Called when the size of the main view has changed, so we can
 * resize the sub-views in ways not allowed by storyboarding. */
- (void)viewDidLayoutSubviews
{
}

-(void)refreshScreen
{
    [gst_backend refreshScreen];
}

-(void)setUri:(NSString *)_uri
{
    [gst_backend setUri:_uri];
}

-(void)setLaunchCmd:(NSString *)_launchCmd
{
    [gst_backend setLaunchCmd:_launchCmd];
}

-(void)setState:(GstState)state
{
    [gst_backend setState:state];
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (gst_backend)
    {
        NSLog(@"DEINITING GSTREAMER");
        [gst_backend deinit];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 * Methods from GstreamerBackendDelegate
 */

-(void) gstreamerInitialized
{
    dispatch_async(dispatch_get_main_queue(), ^{

    });
    
    [self ready];
}

-(void) gstreamerSetUIMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{

    });
}

-(void) audioLevelChanged:(double)audioLevel
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        EaglUIView* view = (EaglUIView*)self.view;
        if (!view.onAudioLevelChange)
            return;
        
        view.onAudioLevelChange(@{ @"level": @(audioLevel) });
    });
}

-(void) stateChanged:(NSString *)state
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        EaglUIView* view = (EaglUIView*)self.view;
        if (!view.onStateChanged)
            return;
        
        view.onStateChanged(@{ @"state": state });
    });
}

-(void) ready
{
    dispatch_async(dispatch_get_main_queue(), ^{
        EaglUIView* view = (EaglUIView*)self.view;
        if (!view.onStateChanged)
            return;
        
        view.onReady(@{ @"ready": @YES });
    });
}
@end
