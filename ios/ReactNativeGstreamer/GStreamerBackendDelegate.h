#import <Foundation/Foundation.h>
#include <gst/gst.h>

@protocol GStreamerBackendDelegate <NSObject>

@optional
/* Called when the GStreamer backend has finished initializing
 * and is ready to accept orders. */
-(void) gstreamerInitialized;

/* Called when the GStreamer backend wants to output some message
 * to the screen. */
-(void) gstreamerSetUIMessage:(NSString *)message;

/* Called when the media size is first discovered or it changes */
-(void) mediaSizeChanged:(NSInteger)width height:(NSInteger)height;

/* Called when the media position changes. Times in milliseconds */
-(void) setCurrentPosition:(NSInteger)position duration:(NSInteger)duration;

/* Change the gstreamer state */
-(void) setState:(GstState)state;

/* Called when the audio level changes */
-(void) audioLevelChanged:(double)audioLevel;

/* Called when the state changes */
-(void) stateChanged:(NSString *)state;

/* Called when the player is ready */
-(void) ready;

@end
