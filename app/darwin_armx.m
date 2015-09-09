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

@interface ViewController : UIViewController<UIWebViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>
{
    IBOutlet UIWebView *webView;
    IBOutlet UISlider *slider;
    IBOutlet UILabel *lbl;
    IBOutlet UITextField *txtField;
    IBOutlet UIButton *btn;
    IBOutlet UISwitch *swich;
    IBOutlet UIScrollView *scView;


}
//property (strong, nonatomic) IBOutlet UIWebView *viewWeb;
//property (nonatomic, retain) UIWebView *page;
@property(nonatomic,retain)UIWebView *webView;
@property(nonatomic,retain)UISlider *slider;
@property(nonatomic,retain)UILabel *lbl;
@property(nonatomic,retain)UITextField *txtField;
@property(nonatomic,retain)UIButton *btn;
@property(nonatomic,retain)UIScrollView *scView;
@property(nonatomic,retain)UISwitch *swich;

-(IBAction)sliderChanged:(UISlider *)slider;

@end


@interface GoAppAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic, strong) ViewController *vc;
@property (strong, nonatomic) UIWindow *window;
@end

@implementation GoAppAppDelegate

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
        NSLog(@"golog2 performFetchWithCompletionHandler");
	for (int i=0;i<15;i++)
        {
            int tRem = [[UIApplication sharedApplication] backgroundTimeRemaining];
            NSLog(@"golog2 b20.3>: Background +++++++++++ time Remaining: %d",tRem);
            if (i == 15) {
                NSLog(@"golog2 b20.3>: DCOIN STOP");
                dcoinStopHTTPServer();
                dcoinStop();
            }
            [NSThread sleepForTimeInterval:1]; //wait for 1 sec
        }
        completionHandler(UIBackgroundFetchResultNewData); 
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    NSLog(@"golog2 didFinishLaunchingWithOptions");


    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge
                                                                                                              categories:nil]];
    }
    //-- Set Notification
    if ([application respondsToSelector:@selector(isRegisteredForRemoteNotifications)])
    {
        // iOS 8 Notifications
        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
        
        [application registerForRemoteNotifications];
    }
    else
    {
        // iOS < 8 Notifications
        [application registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound)];
    }




//    dcoinStart();
//   self.vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = self.vc;
//    self.window.backgroundColor = [UIColor greenColor];
//    [self.window makeKeyAndVisible];


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
	//goserv();
	dcoinStart();
        while(TRUE)
        {
 	    int tRem = [[UIApplication sharedApplication] backgroundTimeRemaining];
            NSLog(@"golog2 b20.3>: Background time Remaining: %d",tRem);
	    if (tRem < 10 && tRem > 0) {
  	        NSLog(@"golog2 b20.3>: DCOIN STOP");
		dcoinStopHTTPServer();
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


    self.vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = self.vc;
    self.window.backgroundColor = [UIColor greenColor];
    [self.window makeKeyAndVisible];


//    self.vc = [[ViewController alloc] initWithNibName:nil bundle:nil];
//    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//    self.window.rootViewController = self.vc;
//    self.window.backgroundColor = [UIColor blueColor];
//    [self.window makeKeyAndVisible];
//    NSLog(@"golog2 didFinishLaunchingWithOptions ok");
    // Override point for customization after application launch.

//  NSURL *url = [NSURL URLWithString:@"http://www.google.com"];
//  NSURLRequest *request = [NSURLRequest requestWithURL:url];
//  [webView setScalesPageToFit:YES];
//  [webView loadRequest:request];


    return YES;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

  UIApplicationState state = [[UIApplication sharedApplication] applicationState];
 // checking the state of the application
  if (state == UIApplicationStateActive) 
   {
      // Application is running in the foreground
      // Showing alert
//      UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"3333" message:@"rr" delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:otherButtonTitle, nil];
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Простой alert" message:@"Это простой UIAlertView, он просто показывает сообщение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];

      [alert show];
      [alert release];

    //Playing sound
   // NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath],notification.soundName]];

    //AVAudioPlayer *newAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:NULL];
   // self.audioPlayer = newAudioPlayer;
   // self.audioPlayer.numberOfLoops = -1;
   // [self.audioPlayer play];
   // [newAudioPlayer release];
  }
}  

/*
 - (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
  {
    [self.audioPlayer stop];
  }
*/
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"golog2 applicationWillResignActive");

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void) sleep1:(NSTimer*)t {
   NSLog(@"SLEEP ok");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"golog2 applicationDidEnterBackground");
    dcoinStopHTTPServer();
//    dcoinTestSleep();
    NSLog(@"golog2 toback ok");
//    [NSTimer scheduledTimerWithTimeInterval:3.0
//                               target:self
//                               selector:@selector(sleep1:)
//                               userInfo:nil
//                               repeats:NO];
//    NSLog(@"golog2 toback 2");

}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    dcoinStartHTTPServer();
    NSLog(@"golog2 applicationWillEnterForeground");

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"golog2 applicationDidBecomeActive");
    //dcoinStartHTTPServer();


    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void) terminate1:(NSTimer*)t {
   NSLog(@"TERM ok");
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"golog2 applicationWillTerminate!!!");
    //dcoinStopHTTPServer();
    NSLog(@"golog2 dcoinStop ++++++++++++++++++++++++++++++++++");
    dcoinStop();
    //dcoinTestSleep();
    NSLog(@"golog2 applicationWillTerminate ok");
    //[NSTimer scheduledTimerWithTimeInterval:5.0
   //                            target:self
   //                            selector:@selector(terminate1:)
   //                            userInfo:nil
   //                            repeats:NO];
  //  NSLog(@"golog2 applicationWillTerminate 2");

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end


@interface ViewController ()

@end

@implementation ViewController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
//{
//    NSLog(@"golog2 initWithNibName");
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    return self;
//}

//- (void)viewDidLayoutSubviews {
//    webView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//    NSLog(@"golog2 viewDidLayoutSubviews");

//}

- (void) openWV:(NSTimer*)t {

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8089"]];
    self.view = self.webView;
    [self.webView loadRequest:request];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [NSTimer scheduledTimerWithTimeInterval:5.0
                               target:self
                               selector:@selector(openWV:)
                               userInfo:nil
                               repeats:NO];

    [super viewDidLoad];

    NSLog(@"golog2 viewDidLoad ok");

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"golog2 Failed to load with error :%@",[error debugDescription]);
}    

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    if ( inType == UIWebViewNavigationTypeLinkClicked ) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
    }

    return YES;
}

/*
#pragma - mark UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSLog(@"Loading URL :%@",request.URL.absoluteString);
    
    //return FALSE; //to stop loading
    return YES;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"golog2 didReceiveMemoryWarning");

    // Dispose of any resources that can be recreated.
}
*/
@end




void runApp(void) {
//	back2();
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
        NSArray *paths = NSSearchPathForDirectoriesInDomains
                   (NSDocumentDirectory, NSUserDomainMask, YES);
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

//void logNS(char* text) {
//    NSLog(@"golog: %s", text);
//}


void ShowMess1() {
    NSLog(@"golog2 UIAlertView ++++++++############");
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Простой alert" message:@"Это простой UIAlertView, он просто показывает сообщение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
	[alert show];
	[alert release];
}
