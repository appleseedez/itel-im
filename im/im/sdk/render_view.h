
#ifndef _RENDER_VIEW_H_
#define _RENDER_VIEW_H_

// iOS framework imports
#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <QuartzCore/QuartzCore.h>



@class EAGLContext;

@interface RenderView : UIView {
    EAGLContext* _context;
}

- (bool)createContext;
- (bool)makeCurrentContext;
- (bool)presentFramebuffer;

-(int32_t)setupWidth:(int32_t)width AndHeight:(int32_t)height;
-(int32_t)renderFrame:(void*)frameToRender;
-(int32_t)setCoordinatesForZOrder:(int32_t)zOrder
                             Left:(const float)left
                              Top:(const float)top
                            Right:(const float)right
                           Bottom:(const float)bottom;

@property (nonatomic, retain)EAGLContext* context;

@end




#endif // _RENDER_VIEW_H_
