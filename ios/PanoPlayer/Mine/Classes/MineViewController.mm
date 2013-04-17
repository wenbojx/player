//
//  MineViewController.m
//  Mine
//
//  Created by wang yutao on 12-4-6.
//  Copyright 2012 zy. All rights reserved.
//

#import "MineViewController.h"
#import "ActivityView.h"

@implementation MineViewController


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	myView=[[ActivityView alloc] initWithFrame:CGRectMake(200, 200, 0, 0)];
	[self.view addSubview:myView];
	[myView release];
	
//	myView.hidesWhenStopped=YES;
	[myView startAnimating];
	
	[sysView startAnimating];
}

- (IBAction)btnAction:(id)sender
{
	static BOOL flag=TRUE;
	
	if(flag)
	{
		[sysView stopAnimating];
		[myView stopAnimating];
	}
	else 
	{
		[sysView startAnimating];
		[myView startAnimating];
	}

	NSLog(@"animation is running?--%d",[myView isAnimating]);
	
	flag=!flag;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
