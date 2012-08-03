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
#import "A4GMapViewController.h"
#import "A4GDetailsViewController.h"
#import "A4GSettingsViewController.h"

@interface A4GAppDelegate ()

@property (strong, nonatomic) UISplitViewController *splitViewController;

@end

@implementation A4GAppDelegate

@synthesize window = _window;
@synthesize splitViewController = _splitViewController;
@synthesize navigationController = _navigationController;
@synthesize mapViewController = _mapViewController;
@synthesize detailsViewController = _detailsViewController;
@synthesize settingsViewController = _settingsViewController;

- (void)dealloc {
    [_window release];
    [_splitViewController release];
    [_navigationController release];
    [_mapViewController release];
    [_detailsViewController release];
    [_settingsViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    DLog(@"%@", launchOptions);
    if (self.window == nil) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        //Do iPhone specific stuff here
    } 
    else {
        //Do iPad specific stuff here
    }
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
