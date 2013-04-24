//
//  ActivityView.m
//  Wxl
//
//  Created by wxl on 11-10-9.
//  Copyright 2011 hna. All rights reserved.
//

#import "ActivityView.h"

#define DEGREES_TO_RADIANS(__ANGLE) ((__ANGLE) / 180.0 * M_PI)

@interface  ActivityView(PrivateMethods)
- (BOOL)createFramebuffer;
- (void)destroyFramebuffer;
- (void)drawView;
- (void)commitInit;
@end

@implementation ActivityView
@synthesize hidesWhenStopped;

#pragma mark ------
#pragma mark Draw 

//创建正视图
- (void)setupView
{
	glViewport(0,0,backingWidth,backingHeight);
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	glOrthof(0, backingWidth, 0 , backingHeight, -1, 1);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
}

- (void)updateColorWithIndex:(short)index;
{
	/*
	 看到的11和12都是由于系统的UIActivityIndicatorView共有12条线
	 */
	
	if(index<0 || index >11) return;
	
	for(short i=0;i<12;i++,index++)
	{
		index %= 12;
		
		//1color rgba
		allLineColors[index*8+0]=MIN(EndR,BeginR+(1.0/12.0)*i);
		allLineColors[index*8+1]=MIN(EndG,BeginG+(1.0/12.0)*i);
		allLineColors[index*8+2]=MIN(EndB,BeginB+(1.0/12.0)*i);
		allLineColors[index*8+3]=1.0;
		
		//2color rgba
		allLineColors[index*8+4]=MIN(EndR,BeginR+(1.0/12.0)*i);
		allLineColors[index*8+5]=MIN(EndG,BeginG+(1.0/12.0)*i);
		allLineColors[index*8+6]=MIN(EndB,BeginB+(1.0/12.0)*i);
		allLineColors[index*8+7]=1.0;
	}
}

//绘制
- (void)drawView
{	
	[EAGLContext setCurrentContext:context];
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	
	glClear(GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT);
	glLoadIdentity();
	
	glPushMatrix();
	
	glTranslatef(self.bounds.size.width/2.0,self.bounds.size.height/2.0,0.0);
	glColorPointer(4, GL_FLOAT,0,allLineColors);
	glVertexPointer(2,GL_FLOAT,0,allLineVertexs);
	glDrawArrays(GL_LINES,0,24);
	
	glPopMatrix();
	
	// Display the buffer
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	[context presentRenderbuffer:GL_RENDERBUFFER_OES];
	
	//5帧更新动画
	static short FrameCount=0;
	static short animCount=11;
	FrameCount++;
	if(FrameCount>=5)
	{
		FrameCount=0;
		
		animCount--;
		if(animCount<0)
			animCount=11;
		
		[self updateColorWithIndex:animCount];
	}
}

#pragma mark ------
#pragma mark LifeCycle

+ (Class) layerClass
{
	return [CAEAGLLayer class];
}

- (void)commitInit
{
	CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
	
	eaglLayer.opaque = NO;    //层是透明的
	// In this application, we want to retain the EAGLDrawable contents after a call to presentRenderbuffer.
	eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
									[NSNumber numberWithBool:YES], kEAGLDrawablePropertyRetainedBacking, kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
	
	context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
	
	if (!context || ![EAGLContext setCurrentContext:context]) 
	{
		[self release];
		NSAssert(0,@"CAEAGLLayer context error!");
	}
	
	animationFrameInterval=1;
	depthRenderbuffer=1;
	hidesWhenStopped=FALSE;
	isAnimationRunning=FALSE;
	
	//初始化opengles
	glClearColor(0.0,0.0,0.0,0.0);
	glShadeModel(GL_SMOOTH);
	glEnable(GL_DEPTH_TEST);
	
	glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	glEnable(GL_BLEND);
	glEnable(GL_LINE_SMOOTH);
	
	glEnableClientState(GL_VERTEX_ARRAY);
	glEnableClientState(GL_COLOR_ARRAY);
	glLineWidth(LINEWIDTH);
	
	//计算所有顶点
	allLineVertexs = new GLfloat[12*2*2];   //12条线 24个顶点
	allLineColors  = new GLfloat[12*2*4];   //24个顶点的颜色
	
	for(int i=0;i<12;i++)
	{
		GLfloat x=cosf(DEGREES_TO_RADIANS(i*30));
		GLfloat y=sinf(DEGREES_TO_RADIANS(i*30));
		
		allLineVertexs[i*4+0]=INRADIUS*x;
		allLineVertexs[i*4+1]=INRADIUS*y;
		
		allLineVertexs[i*4+2]=OUTRADIUS*x;
		allLineVertexs[i*4+3]=OUTRADIUS*y;
	}
	
	[self updateColorWithIndex:0];
}

- (id)initWithFrame:(CGRect)frame
{
	frame.size.width=mySize.width;
	frame.size.height=mySize.height;
	
	if(self = [super initWithFrame:frame])
	{
		[self commitInit];
	}
	return self;
}

- (BOOL)isAnimating
{
	return isAnimationRunning;
}

-(void)startAnimating
{
	displayLink = [NSClassFromString(@"CADisplayLink") displayLinkWithTarget:self selector:@selector(drawView)];
	[displayLink setFrameInterval:animationFrameInterval];
	[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
	
	isAnimationRunning=TRUE;
	if(hidesWhenStopped)
		self.hidden=FALSE;
}

-(void)stopAnimating
{
	[displayLink invalidate];
	displayLink=nil;
	
	isAnimationRunning=FALSE;
	if(hidesWhenStopped)
		self.hidden=TRUE;
}

-(void)layoutSubviews
{
	[EAGLContext setCurrentContext:context];
	[self destroyFramebuffer];
	[self createFramebuffer];
	[self setupView];
}

- (BOOL)createFramebuffer
{
	// Generate IDs for a framebuffer object and a color renderbuffer
	glGenFramebuffersOES(1, &viewFramebuffer);
	glGenRenderbuffersOES(1, &viewRenderbuffer);
	
	glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
	// This call associates the storage for the current render buffer with the EAGLDrawable (our CAEAGLLayer)
	// allowing us to draw into a buffer that will later be rendered to screen wherever the layer is (which corresponds with our view).
	[context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(id<EAGLDrawable>)self.layer];
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
	
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
	glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
	
	if(depthRenderbuffer)
	{
		glGenRenderbuffersOES(1, &depthRenderbuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
		glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
		glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
	}
	
	if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES)
	{
		NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
		return NO;
	}
	
	return YES;
}

// Clean up any buffers we have allocated.
- (void)destroyFramebuffer
{
	glDeleteFramebuffersOES(1, &viewFramebuffer);
	viewFramebuffer = 0;
	glDeleteRenderbuffersOES(1, &viewRenderbuffer);
	viewRenderbuffer = 0;
	
	if(depthRenderbuffer)
	{
		glDeleteRenderbuffersOES(1, &depthRenderbuffer);
		depthRenderbuffer = 0;
	}
}

// Releases resources when they are not longer needed.
- (void) dealloc
{	
	[self stopAnimation];
	
	if([EAGLContext currentContext] == context)
	{
		[EAGLContext setCurrentContext:nil];
	}
	
	delete allLineVertexs;
	delete allLineColors;
	
	[context release];
	[super dealloc];
}

@end
