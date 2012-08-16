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

#import "A4GViewController.h"
#import "A4GSettings.h"
#import "A4GLoadingView.h"

@interface A4GViewController ()

@property (strong, nonatomic) A4GLoadingView *loadingView;

- (void) changeTintColorForButton:(UIBarButtonItem*)barButtonItem;

@end

@implementation A4GViewController

@synthesize navigationBar = _navigationBar;
@synthesize loadingView = _loadingView;

typedef enum {
    AlertViewError,
    AlertViewWebsite
} AlertView;

#pragma mark - Helpers

- (void) changeTintColorForButton:(UIBarButtonItem*)barButtonItem {
    if (barButtonItem != nil && [barButtonItem respondsToSelector:@selector(tintColor)]) {
        if (barButtonItem.style == UIBarButtonItemStyleDone) {
            barButtonItem.tintColor = [A4GSettings buttonDoneColor];
        }
        else {
            //barButtonItem.tintColor = [A4GSettings buttonPlainColor];
        }
    }
}

#pragma mark - A4GLoadingView

- (void) showLoading {
    [self.loadingView show];
}

- (void) showLoadingWithMessage:(NSString *)message {
    [self.loadingView showWithMessage:message];
}

- (void) hideLoading {
    [self.loadingView hide];
}

- (void) hideLoadingAfterDelay:(NSTimeInterval)delay {
    [self.loadingView hideAfterDelay:delay];
}

#pragma mark - UIViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    DLog(@"%@", self.nibName);
}

- (void)dealloc {
    DLog(@"%@", self.nibName);
    [_loadingView release];
    [_navigationBar release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"%@", self.nibName);
    self.loadingView = [A4GLoadingView initWithController:self];
    self.navigationBar.tintColor = [A4GSettings navBarColor];
    [self changeTintColorForButton:self.navigationBar.topItem.leftBarButtonItem];
    [self changeTintColorForButton:self.navigationBar.topItem.rightBarButtonItem];
    [self changeTintColorForButton:self.navigationItem.leftBarButtonItem];
    [self changeTintColorForButton:self.navigationItem.rightBarButtonItem];
    [self changeTintColorForButton:self.navigationItem.backBarButtonItem];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    DLog(@"%@", self.nibName);
    self.loadingView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"%@", self.nibName);
    self.loadingView.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"%@", self.nibName);
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"%@", self.nibName);
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    DLog(@"%@", self.nibName);
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } 
    else {
        return YES;
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewWebsite && buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
    }
}

@end
