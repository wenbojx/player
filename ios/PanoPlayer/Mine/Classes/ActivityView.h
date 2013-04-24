//
//  ActivityView.h
//  Wxl
//
//  Created by wxl on 11-10-9.
//  Copyright 2011 hna. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>

/*
 这里可以自定义的各种配置 
 */

//大小
#define mySize         CGSizeMake(37, 37)
//内半径
#define INRADIUS       8.0
//外半径
#define OUTRADIUS      17.0
//线宽
#define LINEWIDTH      2.5

//转动动画颜色
#define  BeginR		0.0
#define  BeginG		0.5
#define  BeginB		1.0 

//背景动画颜色
#define  EndR       1.0
#define  EndG       1.0
#define  EndB       1.0

/*------------------------------------------------*/


@interface ActivityView : UIView
{
@private
	// The pixel dimensions of the backbuffer
	GLint backingWidth;
	GLint backingHeight;
	
	EAGLContext *context;
	
	// OpenGL names for the renderbuffer and framebuffers used to render to this view
	GLuint viewRenderbuffer, viewFramebuffer;
	
	// OpenGL name for the depth buffer that is attached to viewFramebuffer, if it exists (0 if it does not exist)
	GLuint depthRenderbuffer;
	
	CADisplayLink  * displayLink;
	NSInteger animationFrameInterval;
	
	GLfloat        * allLineVertexs;
	GLfloat        * allLineColors;
	
	BOOL             isAnimationRunning;
	BOOL		     hidesWhenStopped;

}

@property BOOL hidesWhenStopped;

-(void)startAnimating;
-(void)stopAnimating;
-(BOOL)isAnimating;

@end
