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
@property(nonatomic,retain)UIWindow *window;
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

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
        NSLog(@"Loading KEY ERROR:%@", error);
    }
    else
    {
        NSLog(@"OK DCOIN KEY");
    }
}




/*
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
*/


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    NSLog(@"golog2 didFinishLaunchingWithOptions");




NSString *searchedString = @"http://127.0.0.1:8089/ajax?controllerName=dcoinKey&password=2fh4h3Fdd";
NSRange   searchedRange = NSMakeRange(0, [searchedString length]);
NSString *pattern = @"dcoinKey&password=(.*)$";
NSError  *error = nil;
NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern: pattern options:0 error:&error];
NSArray* matches = [regex matchesInString:searchedString options:0 range: searchedRange];
for (NSTextCheckingResult* match in matches) {
    NSString* matchText = [searchedString substringWithRange:[match range]];
    NSLog(@"*********************match: %@", matchText);
    NSRange group1 = [match rangeAtIndex:1];
    //NSRange group2 = [match rangeAtIndex:2];
    NSLog(@"group1: %@", [searchedString substringWithRange:group1]);
    //NSLog(@"group2: %@", [searchedString substringWithRange:group2]);
}

NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];
NSLog(@">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>.group1: %@", [searchedString substringWithRange:[match rangeAtIndex:1]]);
//NSLog(@">>>>group2: %@", [searchedString substringWithRange:[match rangeAtIndex:2]]);


//    NSError* error = nil;
// UIImage *imageWithData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.fnordware.com/superpng/pngtest8rgba.png"] options:NSDataReadingUncached error:&error];
/*   UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://www.fnordware.com/superpng/pngtest8rgba.png"]]]; 
   NSLog(@"img ok");
    if (error) {
       NSLog(@"ERRR IMG%@", [error localizedDescription]);
       [error release];
    } else {
        NSLog(@">>>>>>>>Data has loaded successfully.");
    }
        // Create path.
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Image.png"];
        NSLog(@">>>>>>>PATH%@", filePath);
*/
/*        // Save image.
        [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
*/

//    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);



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
//    self.window.backgroundColor = [UIColor [colorFromHexString: @"#0E70AD"]]
//    self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"assets/LaunchImage.png"]];
    UIGraphicsBeginImageContext(self.window.frame.size);
    [[UIImage imageNamed:@"assets/LaunchImage.png"] drawInRect:self.window.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.window.backgroundColor = [UIColor colorWithPatternImage:image];


    [self.window makeKeyAndVisible];


    return YES;
}
/*
// Assumes input like "#00FF00" (#RRGGBB).
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}
*/
-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{

  UIApplicationState state = [[UIApplication sharedApplication] applicationState];
 // checking the state of the application
  if (state == UIApplicationStateActive) 
   {
      // Application is running in the foreground
	UIAlertView* alert = [[UIAlertView alloc] initWithTitle:notification.alertTitle message:notification.alertBody delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];

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
//    dcoinStopHTTPServer();
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
//    dcoinStartHTTPServer();
    NSLog(@"golog2 applicationWillEnterForeground");

    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSLog(@"golog2 applicationDidBecomeActive");
    //dcoinStartHTTPServer();
   [UIApplication sharedApplication].applicationIconBadgeNumber=0;

    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void) terminate1:(NSTimer*)t {
   NSLog(@"TERM ok");
}



- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"golog2 applicationWillTerminate!!!");
    dcoinStopHTTPServer();
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
/*
- (void) openWV:(NSTimer*)t {

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8089"]];
    self.view = self.webView;
    [self.webView loadRequest:request];
}
*/
- (void)viewDidLoad
{
///    [super viewDidLoad];




/*   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [NSThread sleepForTimeInterval:5.0f];
        dispatch_async(dispatch_get_main_queue(), ^{

    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSString * string = @"<html><body><h1>Hayageek</h1>How to <a href=\"http://vk.com/\" target=\"_blank\">111</a> <br><br><br><br><br><a href=\"?jjj=1\">222222222222222</a>";
    self.view = self.webView;
    self.webView.delegate = self;
    [self.webView loadHTMLString:string baseURL:nil];
        });
    });
*/


//    [NSTimer scheduledTimerWithTimeInterval:5.0
  //                             target:self
    //                           selector:@selector(openWV:)
      //                         userInfo:nil
        //                       repeats:NO];


  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //Here your non-main thread.
        [NSThread sleepForTimeInterval:3.0f];   
        dispatch_async(dispatch_get_main_queue(), ^{
            
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSMutableURLRequest * request =[NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://127.0.0.1:8089"]];    
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.webView.scrollView.bounces = NO;
    self.webView.scalesPageToFit = NO;
    self.view = self.webView;
    self.webView.delegate = self;
    [self.webView loadRequest:request];
        });
    });

    NSLog(@"golog2 viewDidLoad ok");
    [super viewDidLoad];

}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    NSLog(@"golog2 111111111111111111111111111");
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation) || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"golog2 111111111111111111111111111222");

}

//--------------------------------------------------------------------------------------------------------------------------------------------------------------------

- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration{

    NSLog(@"golog2 11111111111111111111111111122233333");

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"golog2 Failed to load with error :%@",[error debugDescription]);
}    

//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    	NSLog(@"golog2 +++++++++++++++++++++++++++++++++111111+");
//	return YES;
//}

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {
    NSLog(@"golog2 ++++++++++++SAFARI++++++++++++++++++++++");
//    NSLog(@"%@", inRequest);
    NSLog(@"%@", [inRequest URL]);
//    NSLog(@"%@", inWeb);
//    NSLog(@"%@", inType);

//   self.webView.scalesPageToFit = NO;
	
     NSError  *error = nil;
     NSString* string = [[inRequest URL] absoluteString];
 
//     NSString* string = @"http://127.0.0.1/dcoin1Key/";
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((?!127\.0\.0\.1).)*$" options:NSRegularExpressionCaseInsensitive error:&error];
     NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];     
     NSLog(@"external: %@", match);
     BOOL isExternal = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"FormExPs=mobile" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     NSLog(@"isMobileGate: %@", match);
     BOOL isMobileGate = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"dcoinKey&password=(.*)$" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     NSLog(@"isKey: %@", match);
     BOOL isKey = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"upgrade3" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     NSLog(@"isUpgrade3: %@", match);
     BOOL isUpgrade3 = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"upgrade4" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     NSLog(@"isUpgrade4: %@", match);
     BOOL isUpgrade4 = match != nil;


     if (isUpgrade3) {
        NSLog(@"isUpgrade3 ok");
    	self.webView.scalesPageToFit = YES;
	return YES;
     } else if (isUpgrade4) {
        NSLog(@"isUpgrade4 ok");
        self.webView.scalesPageToFit = NO;
        return YES;
     } else if (isMobileGate) {
        NSLog(@"isMobileGate ok");
       // [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return YES;
     } else if (isExternal) {
        NSLog(@"isExternal %@", [inRequest URL]);
        NSString* URL = @"http://tmp-e.dcoin.club/go.php?FormExPs=mobile&FormExAmount=1&FormDC=72&FormToken=ZyCIpKnpEoUXrl6nNzDo3r5XJaDLsC";
        [[UIApplication sharedApplication] openURL:URL];
        return NO;
     } else if (isKey) {
         NSLog(@"group1: %@", [string substringWithRange:[match rangeAtIndex:1]]);
         NSLog(@"SAFARI");
        //[[UIApplication sharedApplication] openURL:[inRequest URL]];
        //return NO;
/*	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1:8089/ajax?controllerName=dcoinKey&ios=1&password="+[string substringWithRange:[match rangeAtIndex:1]]]]];
   	NSLog(@"img ok");
    	if (error) {
       		NSLog(@"ERRR IMG%@", [error localizedDescription]);
       		[error release];
        } else {
        	NSLog(@">>>>>>>>Data has loaded successfully.");
        }
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
*/

	[NSThread detachNewThreadSelector:@selector(downloadImage) toTarget:self withObject:nil];
	return NO;
     }
     return YES;
}

- (void)downloadImage
{

    // network animation on
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

    // create autorelease pool
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; 

    NSError  *error = nil;
    NSLog(@"001");
    // save image from the web
  	UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1:8089/ajax?controllerName=dcoinKey&ios=1&first=1"]]];
        NSLog(@"img ok");
        if (error) {
                NSLog(@"ERRR IMG%@", [error localizedDescription]);
                [error release];
        } else {
                NSLog(@">>>>>>>>Data has loaded successfully.");
        }
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  
  //UIImageWriteToSavedPhotosAlbum([UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1:8089/ajax?controllerName=dcoinKey"]]], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    NSLog(@"002");
    [self performSelectorOnMainThread:@selector(imageDownloaded) withObject:nil waitUntilDone:NO ];  
    NSLog(@"003");
    [pool drain];       

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL)
    {
	NSLog(@"Loading KEY ERROR:%@", error);        
    }
    else 
    {
       	NSLog(@"OK DCOIN KEY");
    }
}

- (void)imageDownloaded
{
    NSLog(@"004");
    // network animation off
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    NSLog(@"005");
    // do whatever you need to do after 
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

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIInterfaceOrientationPortrait;
}
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
