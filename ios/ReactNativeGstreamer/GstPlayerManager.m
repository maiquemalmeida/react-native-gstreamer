//
//  RNTMapManager.m
//  GStreamerIOS
//
//  Created by Alann Sapone on 21/07/2017.
//  Copyright © 2017 Facebook. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import <React/RCTLog.h>

#import "GstPlayerManager.h"

@implementation GstPlayerManager

RCT_EXPORT_MODULE();

// Events
RCT_EXPORT_VIEW_PROPERTY(onAudioLevelChange, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onStateChanged, RCTBubblingEventBlock)
RCT_EXPORT_VIEW_PROPERTY(onReady, RCTBubblingEventBlock)

// Methods
RCT_EXPORT_METHOD(setState:(nonnull NSNumber *)reactTag state:(nonnull NSString *)state) {
    NSString *_state = [RCTConvert NSString:state];
    GstState gst_state = GST_STATE_NULL;
    
    if ([_state  isEqual: @"GST_STATE_NULL"]) {
        gst_state = GST_STATE_NULL;
    } else if ([_state  isEqual: @"GST_STATE_READY"]) {
        gst_state = GST_STATE_READY;
    } else if ([_state  isEqual: @"GST_STATE_PAUSED"]) {
        gst_state = GST_STATE_PAUSED;
    } else if ([_state  isEqual: @"GST_STATE_PLAYING"]) {
        gst_state = GST_STATE_PLAYING;
    }
    
    [self->rctGstPlayer setState:gst_state];
}

RCT_EXPORT_METHOD(refreshScreen:(nonnull NSNumber *)reactTag) {
    [self->rctGstPlayer refreshScreen];
}

RCT_EXPORT_METHOD(flushBuffers:(nonnull NSNumber *)reactTag) {
    [[self->rctGstPlayer gst_backend] flushBuffers];
}

// Props
RCT_CUSTOM_VIEW_PROPERTY(uri, NSString, GstPlayerController)
{
    [self->rctGstPlayer setUri:[RCTConvert NSString:json]];
}
RCT_CUSTOM_VIEW_PROPERTY(launchCmd, NSString, GstPlayerController)
{
    [self->rctGstPlayer setLaunchCmd:[RCTConvert NSString:json]];
}

@synthesize bridge = _bridge;

- (UIView *)view
{
    self->rctGstPlayer = [[GstPlayerController alloc] init];
    return self->rctGstPlayer.view;
}
@end
