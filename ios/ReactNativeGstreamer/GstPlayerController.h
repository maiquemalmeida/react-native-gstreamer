//
//  RCTGSTPlayerController.h
//  GStreamerIOS
//
//  Created by Alann Sapone on 26/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GStreamerBackendDelegate.h"
#import "GStreamerBackend.h"
#import <React/RCTBridgeModule.h>
#import "EaglUIView.h"

@interface GstPlayerController : UIViewController <GStreamerBackendDelegate> {
    EaglUIView *_view;
}

@property (nonatomic, retain) IBOutlet EaglUIView *view;
@property (retain, nonatomic) NSString *uri;
@property (retain, nonatomic) GStreamerBackend *gst_backend;

-(void) refreshScreen;

/* From GStreamerBackendDelegate */
-(void) gstreamerInitialized;
-(void) gstreamerSetUIMessage:(NSString *)message;
-(void) setUri:(NSString *)_uri;
-(void) setState:(GstState)state;
-(void) setLaunchCmd:(NSString*)_launchCmd;

@end
