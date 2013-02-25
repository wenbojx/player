//
//  ImageCropper.m

//

#import "ImageCropper.h"

@implementation ImageCropper

@synthesize scrollView, imageView;
@synthesize delegate;

- (id)initWithImage:(UIImage *)image {
	self = [super init];
	
	if (self) {
		[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:YES];
		
		scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0.0, -20.0, 320.0, 480.0)];
		//[scrollView setBackgroundColor:[UIColor blackColor]];
		[scrollView setDelegate:self];
		[scrollView setShowsHorizontalScrollIndicator:NO];
		[scrollView setShowsVerticalScrollIndicator:NO];
		[scrollView setMaximumZoomScale:2.0];
		
		imageView = [[UIImageView alloc] initWithImage:image];
		
		CGRect rect;
		rect.size.width = image.size.width;
		rect.size.height = image.size.height;
		
		[imageView setFrame:rect];
		
		[scrollView setContentSize:[imageView frame].size];
		[scrollView setMinimumZoomScale:[scrollView frame].size.width / [imageView frame].size.width];
		[scrollView setZoomScale:[scrollView minimumZoomScale]];
		[scrollView addSubview:imageView];
		
		[[self view] addSubview:scrollView];
		
    }
	
	return self;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
	return imageView;
}

- (void)dealloc {
	[imageView release];
	[scrollView release];
	
    [super dealloc];
}

@end