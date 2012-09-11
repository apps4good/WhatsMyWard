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

#import "A4GWebViewController.h"
#import "UIViewController+A4G.h"
#import "UIAlertView+A4G.h"
#import "UIBarButtonItem+A4G.h"
#import "A4GLoadingButton.h"
#import "A4GDevice.h"

@interface A4GWebViewController ()

@property (strong, nonatomic) A4GInternet *internet;
@property (strong, nonatomic) UIBarButtonItem *backButton;
@property (strong, nonatomic) UIBarButtonItem *forwardButton;
@property (strong, nonatomic) A4GLoadingButton *refreshButton;

- (void) loadAddress:(NSString *)address;

@end

@implementation A4GWebViewController

@synthesize url = _url;
@synthesize internet = _internet;
@synthesize webView = _webView;
@synthesize infoButton = _infoButton;
@synthesize flipView = _flipView;
@synthesize scaleType = _scaleType;
@synthesize backButton = _backButton;
@synthesize forwardButton = _forwardButton;
@synthesize refreshButton = _refreshButton;

typedef enum {
    WebScaleNormal,
    WebScaleZoomed
} WebScale;

#pragma mark - IBActions

- (void) loadAddress:(NSString *)address {
    if (address != nil && address.length > 0) {
        NSString *website = [address hasPrefix:@"http://"] || [address hasPrefix:@"https://"]
        ? address : [NSString stringWithFormat:@"http://www.google.com/search?q=%@", [address stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
        NSURL *url = [NSURL URLWithString:website];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webView loadRequest:request];
    } 
}

- (IBAction) scaleTypeChanged:(id)sender event:(UIEvent*)event {
    DLog(@"");
    if (self.scaleType.selectedSegmentIndex == WebScaleNormal) {
        self.webView.scalesPageToFit = NO;
    }
    else if (self.scaleType.selectedSegmentIndex == WebScaleZoomed) {
        self.webView.scalesPageToFit = YES;
    }
    [self animatePageCurlDown:0.5];
    [self loadAddress:self.url];
}

- (void)scaleTypeCancelled:(id)sender event:(UIEvent*)event {
    DLog(@"");
    [self animatePageCurlDown:0.5];
}

- (IBAction) showScaleType:(id)sender event:(UIEvent*)event {
    DLog(@"");
    if (self.webView.scalesPageToFit) {
        [self.scaleType setSelectedSegmentIndex:WebScaleZoomed];
    }
    else {
        [self.scaleType setSelectedSegmentIndex:WebScaleNormal];
    }
    [self animatePageCurlUp:0.5];
}

#pragma mark - UIViewController

- (void)dealloc {
    [_url release];
    [_internet release];
    [_webView release];
    [_scaleType release];
    [_infoButton release];
    [_flipView release];
    [_backButton release];
    [_forwardButton release];
    [_refreshButton release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.internet = [[A4GInternet alloc] initWithDelegate:self];
    [self.flipView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]]];
    self.backButton = [UIBarButtonItem borderedItemWithImage:[UIImage imageNamed:@"back.png"] target:self.webView action:@selector(goBack)];
    self.forwardButton = [UIBarButtonItem borderedItemWithImage:[UIImage imageNamed:@"forward.png"] target:self.webView action:@selector(goForward)];
    self.refreshButton = [[A4GLoadingButton alloc] initWithImage:[UIImage imageNamed:@"refresh.png"] style:UIBarButtonItemStyleBordered target:self.webView action:@selector(reload)];
    self.navigationItem.rightBarButtonItem = [self barButtonWithItems:self.refreshButton, self.backButton, self.forwardButton, nil];                                
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.internet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadAddress:self.url];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"");
    if ([self.internet hasWiFi] || [self.internet hasNetwork]) {
        self.navigationItem.title = NSLocalizedString(@"Loading...", nil);
        self.refreshButton.loading = YES;
    }
    else {
        self.navigationItem.title = NSLocalizedString(@"No Internet", nil);
        [self showLoadingWithMessage:NSLocalizedString(@"No Internet", nil)];
        [self hideLoadingAfterDelay:2.0];
    }
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"");
    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.refreshButton.loading = NO;
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"%@", [error localizedDescription]);
    self.navigationItem.title = [error localizedDescription];
    self.refreshButton.loading = NO;
    self.backButton.enabled = webView.canGoBack;
    self.forwardButton.enabled = webView.canGoForward;
}

#pragma mark - A4GInternetDelegate

- (void) networkChanged:(A4GInternet *)internet connected:(BOOL)connected {
    DLog(@"Network: %@", connected ? @"Connected" : @"Not Connected");
}

- (void) wifiChanged:(A4GInternet *)internet connected:(BOOL)connected {
    DLog(@"WiFi: %@", connected ? @"Connected" : @"Not Connected");
}

@end
