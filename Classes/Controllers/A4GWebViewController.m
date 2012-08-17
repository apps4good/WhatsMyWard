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

@interface A4GWebViewController ()

- (void) loadAddress:(NSString *)address;

@end

@implementation A4GWebViewController

@synthesize url = _url;
@synthesize webView = _webView;
@synthesize textField = _textField;
@synthesize infoButton = _infoButton;
@synthesize flipView = _flipView;
@synthesize scaleType = _scaleType;
@synthesize segmentControl = _segmentControl;

typedef enum {
    NavigateBack,
    NavigateForward
} Navigate;

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

- (IBAction)navigate:(id)sender event:(UIEvent*)event {
    if (self.segmentControl.selectedSegmentIndex == NavigateBack) {
        [self.webView goBack];
    }
    else if (self.segmentControl.selectedSegmentIndex == NavigateForward) {
        [self.webView goForward];
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
    [self loadAddress:self.textField.text];
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
    [_webView release];
    [_textField release];
    [_scaleType release];
    [_infoButton release];
    [_flipView release];
    [_segmentControl release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.flipView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.textField.text = self.url;
    [self loadAddress:self.url];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self loadAddress:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"");
    [self showLoadingWithMessage:NSLocalizedString(@"Loading...", nil)];
    NSURL *url = [[webView request] URL];
    if (url != nil) {
        self.textField.text = [url absoluteString];   
    }
    [self.segmentControl setEnabled:webView.canGoBack forSegmentAtIndex:NavigateBack];
    [self.segmentControl setEnabled:webView.canGoForward forSegmentAtIndex:NavigateForward];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"");
    NSURL *url = [[webView request] URL];
    if (url != nil) {
        self.textField.text = [url absoluteString];   
    }
    [self.segmentControl setEnabled:webView.canGoBack forSegmentAtIndex:NavigateBack];
    [self.segmentControl setEnabled:webView.canGoForward forSegmentAtIndex:NavigateForward];
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"%@", [error localizedDescription]);
}

@end
