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


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Выполняется код на уровне приложения после запуска последнего.


    // UIApplicationBackgroundFetchIntervalMinimum - чтобы наше приложение запустилось в бэкграунде при любом возможном случае
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
	    NSRange group1 = [match rangeAtIndex:1];
    }

    NSTextCheckingResult *match = [regex firstMatchInString:searchedString options:0 range: searchedRange];

    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]) {
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeSound|UIUserNotificationTypeBadge categories:nil]];
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
            NSLog(@"golog2: Running in the background\n");
            dcoinStart();
            while(TRUE)
            {
                int tRem = [[UIApplication sharedApplication] backgroundTimeRemaining];
                NSLog(@"golog2: Background time Remaining: %d",tRem);
                if (tRem < 10 && tRem > 0) {
                    NSLog(@"golog2: DCOIN STOP");
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
    UIGraphicsBeginImageContext(self.window.frame.size);
    [[UIImage imageNamed:@"assets/LaunchImage.png"] drawInRect:self.window.bounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.window.backgroundColor = [UIColor colorWithPatternImage:image];

    [self.window makeKeyAndVisible];

    return YES;
}

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
  }
}  

							
- (void)applicationWillResignActive:(UIApplication *)application
{
    NSLog(@"golog2 applicationWillResignActive");

   // Переход из неактивного состояния в активное.

   // Метод выполняется, когда приложение собирается перейти из активного в неактивное состояние. Это может произойти при разных видах прерывания (например, входящий звонок или SMS сообщение) или когда пользователь выходит из приложения (жмет HOME), и оно начинает переход на фоновое состояние.

   // Используйте этот метод для приостановки текущих задач, отключения таймеров и графики OpenGL ES. Игры должны использовать этот метод, чтобы приостановить игру.
}

- (void) sleep1:(NSTimer*)t {
   NSLog(@"SLEEP ok");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Переход из неактивного состояния в фоновое.

    // Метод используется, чтобы освободить все ресурсы, которые могут быть восстановлены в дальнейшем, сохранить пользовательскихе данные, недействительные таймеры, и чтобы хранить достаточно информации о состоянии приложения для восстановления приложения до его текущего состояния в случае, если оно не будет прекращено позже.

    // Если приложение поддерживает фоновое выполнение, этот метод вызывается вместо applicationWillTerminate: когда пользователь завершает работу.

    // В этом методе можно сделать запрос дополнительного времени на выполнение в фоновом режиме

    NSLog(@"golog2 applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    NSLog(@"golog2 applicationWillEnterForeground");

    // Переход из фонового состояния в неактивное.

    // Метод вызывается как часть перехода из фона в неактивное состояние, здесь вы можете отменить многие из изменений, внесенных при входе в фоновом режиме.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
   NSLog(@"golog2 applicationDidBecomeActive");
   [UIApplication sharedApplication].applicationIconBadgeNumber=0;

   // Переход из неактивного состояния в активное.

   // Метод используется, чтобы перезапустить любые задачи, которые были приостановлены (или еще не начались), когда приложение было неактивно. Также в этом методе обновляется пользовательский интерфейс, если приложение было ранее в фоновом режиме.

   // ВАЖНО! Метод вызывается также при первом запуске приложения на выполнение!
}


- (void) terminate1:(NSTimer*)t {
   NSLog(@"TERM ok");
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    NSLog(@"golog2 dcoinStopHTTPServer");
    dcoinStopHTTPServer();
    NSLog(@"golog2 dcoinStop");
    dcoinStop();
    // Вызывается только, когда приложение находится в фоновом состоянии и убивается системой или самостоятельно пользователем.
}


@end


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
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
    NSLog(@"shouldAutorotateToInterfaceOrientation");
    return (UIInterfaceOrientationIsPortrait(interfaceOrientation) || UIInterfaceOrientationIsLandscape(interfaceOrientation));
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSLog(@"willRotateToInterfaceOrientation");

}


- (void) changeTheViewToPortrait:(BOOL)portrait andDuration:(NSTimeInterval)duration{

}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"golog2 Failed to load with error :%@",[error debugDescription]);
}    

-(BOOL) webView:(UIWebView *)inWeb shouldStartLoadWithRequest:(NSURLRequest *)inRequest navigationType:(UIWebViewNavigationType)inType {

     NSError  *error = nil;
     NSString* string = [[inRequest URL] absoluteString];
 
     NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"^((?!127\.0\.0\.1).)*$" options:NSRegularExpressionCaseInsensitive error:&error];
     NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];     
     NSLog(@"external: %@", match);
     BOOL isExternal = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"dcoinKey&password=(.*)$" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     BOOL isKey = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"upgrade3" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     BOOL isUpgrade3 = match != nil;

     regex = [NSRegularExpression regularExpressionWithPattern:@"upgrade4" options:NSRegularExpressionCaseInsensitive error:&error];
     match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
     BOOL isUpgrade4 = match != nil;

     if (isUpgrade3) {
    	self.webView.scalesPageToFit = YES;
	return YES;
     } else if (isUpgrade4) {
        self.webView.scalesPageToFit = NO;
        return YES;
     } else if (isExternal) {
        [[UIApplication sharedApplication] openURL:[inRequest URL]];
        return NO;
     } else if (isKey) {
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
    // save image from the web
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://127.0.0.1:8089/ajax?controllerName=dcoinKey&ios=1&first=1"]]];
    NSLog(@"img ok");
    if (error) {
         NSLog(@"ERRR IMG%@", [error localizedDescription]);
                [error release];
    } else {
         NSLog(@"Data has loaded successfully.");
    }
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
  
    [self performSelectorOnMainThread:@selector(imageDownloaded) withObject:nil waitUntilDone:NO ];  
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
    // network animation off
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    // do whatever you need to do after 
}

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
