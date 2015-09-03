// Copyright 2015 The Go Authors. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// +build darwin
// +build arm arm64

#include "_cgo_export.h"
#include <pthread.h>
#include <stdio.h>
#include <sys/utsname.h>

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

struct utsname sysInfo;


@interface GoAppAppController : GLKViewController<UIContentContainer>
@end

@interface GoAppAppDelegate : UIResponder<UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) GoAppAppController *controller;
@end

@implementation GoAppAppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSLog(@"golog2 didFinishLaunchingWithOptions");
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	self.controller = [[GoAppAppController alloc] initWithNibName:nil bundle:nil];
	self.window.rootViewController = self.controller;
	[self.window makeKeyAndVisible];
	return YES;
}
@end

@interface GoAppAppController ()
@property (strong, nonatomic) EAGLContext *context;
@end

@implementation GoAppAppController
- (void)viewDidLoad {
	[super viewDidLoad];

    NSLog(@"golog2 viewDidLoad");

	UIApplication * application = [UIApplication sharedApplication];

	if([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)])
	{
		NSLog(@"golog2: Multitasking Supported");

		__block UIBackgroundTaskIdentifier background_task;
		background_task = [application beginBackgroundTaskWithExpirationHandler:^ {

			//Clean up code. Tell the system that we are done.
			[application endBackgroundTask: background_task];
			background_task = UIBackgroundTaskInvalid;
		}];

		//To make the code block asynchronous
		dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

			//### background task starts
			NSLog(@"golog2>: Running in the background\n");
			dcoinStart();
			while(TRUE)
			{
			int tRem = [[UIApplication sharedApplication] backgroundTimeRemaining];
				NSLog(@"golog2 b20.3>: Background time Remaining: %f",tRem);
			if (tRem < 10 && tRem > 0) {
				dcoinStop();
			}
				[NSThread sleepForTimeInterval:1]; //wait for 1 sec
			}
			//#### background task ends

			//Clean up code. Tell the system that we are done.
			[application endBackgroundTask: background_task];
			background_task = UIBackgroundTaskInvalid;
		});
	}
	else
	{
		NSLog(@"golog2: Multitasking Not Supported");
	}

	NSLog(@"golog2: UIWebView 0");

	[NSThread sleepForTimeInterval:3];

    @try {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
        [webView setDelegate:self];

        NSString *urlAddress = @"http://127.0.0.1:8089/";
        NSURL *url = [NSURL URLWithString:urlAddress];
        NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
        [webView loadRequest:requestObj];

        [self.view addSubview:webView];
	}@catch (NSException *exception) {
       NSLog(@"golog2 ERR: %@", exception.reason);
    }

	self.preferredFramesPerSecond = 60;
	self.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
	GLKView *view = (GLKView *)self.view;
	view.context = self.context;
	view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
	view.multipleTouchEnabled = true; // TODO expose setting to user.

	int scale = 1;
	if ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)]) {
		scale = (int)[UIScreen mainScreen].scale; // either 1.0, 2.0, or 3.0.
	}
	setScreen(scale);

	CGSize size = [UIScreen mainScreen].bounds.size;
	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
	updateConfig((int)size.width, (int)size.height, orientation);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
	[coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		// TODO(crawshaw): come up with a plan to handle animations.
	} completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
		UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
		updateConfig((int)size.width, (int)size.height, orientation);
	}];
}

- (void)update {
	//NSLog(@"golog2 update");
	drawgl((GoUintptr)self.context);
}

#define TOUCH_TYPE_BEGIN 0 // touch.TypeBegin
#define TOUCH_TYPE_MOVE  1 // touch.TypeMove
#define TOUCH_TYPE_END   2 // touch.TypeEnd

static void sendTouches(int change, NSSet* touches) {
    NSLog(@"golog2 sendTouches");
	CGFloat scale = [UIScreen mainScreen].scale;
	for (UITouch* touch in touches) {
		CGPoint p = [touch locationInView:touch.view];
		sendTouch((GoUintptr)touch, (GoUintptr)change, p.x*scale, p.y*scale);
	}
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
	sendTouches(TOUCH_TYPE_BEGIN, touches);
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
	sendTouches(TOUCH_TYPE_MOVE, touches);
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
	sendTouches(TOUCH_TYPE_END, touches);
}
@end

void runApp(void) {
    NSLog(@"golog2 runApp");
	@autoreleasepool {
		UIApplicationMain(0, nil, nil, NSStringFromClass([GoAppAppDelegate class]));
	}
}

void setContext(void* context) {
	EAGLContext* ctx = (EAGLContext*)context;
	if (![EAGLContext setCurrentContext:ctx]) {
		// TODO(crawshaw): determine how terrible this is. Exit?
		NSLog(@"failed to set current context");
	}
}

char* GetFilesDir(void) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        return (char*)[documentsDirectory UTF8String];
}

uint64_t threadID() {
	uint64_t id;
	if (pthread_threadid_np(pthread_self(), &id)) {
		abort();
	}
	return id;
}

