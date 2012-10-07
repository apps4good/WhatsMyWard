// ##########################################################################################
// 
// Copyright (c) 2012, Apps4Good. All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without modification, are 
// permitted provided that the following conditions are met:
// 
// 1) Redistributions of source code must retain the above copyright notice, this list of 
//    conditions and the following disclaimer.
// 2) Redistributions in binary form must reproduce the above copyright notice, this list
//    of conditions and the following disclaimer in the documentation 
//    and/or other materials provided with the distribution.
// 3) Neither the name of the Apps4Good nor the names of its contributors may be used to 
//    endorse or promote products derived from this software without specific prior written 
//    permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY 
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES 
// OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT 
// SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT 
// OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) 
// HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR 
// TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, 
// EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
// 
// ##########################################################################################

#import "A4GAppDelegate.h"
#import "A4GTabBarController.h"
#import "A4GMapViewController.h"
#import "A4GDetailsViewController.h"
#import "A4GSettingsViewController.h"
#import "A4GLayersViewController.h"
#import "A4GDevice.h"
#import "A4GSettings.h"

@interface A4GAppDelegate ()

@property (strong, nonatomic) UISplitViewController *splitViewController;
@property (strong, nonatomic) UINavigationController *masterNavigationController;
@property (strong, nonatomic) UINavigationController *detailNavigationController;

@end

@implementation A4GAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;
@synthesize splitViewController = _splitViewController;
@synthesize mapViewController = _mapViewController;
@synthesize detailsViewController = _detailsViewController;
@synthesize settingsViewController = _settingsViewController;
@synthesize layersViewController = _layersViewController;
@synthesize masterNavigationController = _masterNavigationController;
@synthesize detailNavigationController = _detailNavigationController;

#pragma mark - Public

- (void)sidebar:(id)sender event:(UIEvent*)event {
    UIBarButtonItem *barButtonItem = (UIBarButtonItem*)sender;
    CGRect master = self.tabBarController.view.frame;
    CGRect split = self.splitViewController.view.frame;    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];  
    DLog(@"Before:%@", NSStringFromCGRect(split));
    BOOL restoreSplitFrame = NO;
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        DLog(@"UIInterfaceOrientationLandscapeLeft");
        if (split.size.height > self.window.frame.size.height) {
            split.size.height = self.window.frame.size.height;   
            barButtonItem.image = [UIImage imageNamed:@"hide.png"];
        }
        else {
            split.size.height += master.size.width;   
            barButtonItem.image = [UIImage imageNamed:@"show.png"];
        }
    }
    else if (orientation == UIInterfaceOrientationLandscapeRight) {
        DLog(@"UIInterfaceOrientationLandscapeRight");
        if (split.origin.y < 0) {
            split.origin.y = 0;
            restoreSplitFrame = YES;
            barButtonItem.image = [UIImage imageNamed:@"hide.png"];
        }
        else {
            split.origin.y -= master.size.width;
            split.size.height += master.size.width;   
            barButtonItem.image = [UIImage imageNamed:@"show.png"];
        }
    }
    else {
        DLog(@"Orientation:%d", orientation);
    }
    DLog(@"After:%@", NSStringFromCGRect(split));
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.splitViewController.view.frame = split;
                     }
                     completion:^(BOOL finished){
                         if (restoreSplitFrame) {
                             DLog(@"restoreSplitFrame");
                             CGRect split = self.splitViewController.view.frame; 
                             split.size.height = self.window.frame.size.height;
                             self.splitViewController.view.frame = split;
                         }
                     }];
}

#pragma mark - UIApplication

- (void)dealloc {
    [_window release];
    [_tabBarController release];
    [_splitViewController release];
    [_mapViewController release];
    [_detailsViewController release];
    [_settingsViewController release];
    [_detailNavigationController release];
    [_masterNavigationController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DLog(@"Options:%@", launchOptions);
    if (self.window == nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    if ([A4GDevice isIPad]) {
        self.detailNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
        self.detailNavigationController.navigationBar.tintColor = [A4GSettings navBarColor];
        
        self.splitViewController = [[UISplitViewController alloc] init];
        self.splitViewController.viewControllers = [NSArray arrayWithObjects:self.tabBarController, self.detailNavigationController, nil];
        self.splitViewController.delegate = self.mapViewController;
        
        self.window.rootViewController = self.splitViewController;
    } 
    else {
        self.masterNavigationController = [[UINavigationController alloc] initWithRootViewController:self.mapViewController];
        self.masterNavigationController.navigationBar.tintColor = [A4GSettings navBarColor];
        self.window.rootViewController = self.masterNavigationController;
    }
    [self.window setFrame:[[UIScreen mainScreen] bounds]];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    DLog(@"");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    DLog(@"");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DLog(@"");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    DLog(@"");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    DLog(@"");
}

@end
