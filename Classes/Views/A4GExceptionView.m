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

#import "A4GExceptionView.h"

@interface A4GExceptionView ()

@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *app;
@property (strong, nonatomic) NSString *version;
@property (strong, nonatomic) NSString *device;
@property (strong, nonatomic) NSString *model;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) UIColor *color;
@property (strong, nonatomic) UIViewController *controller;
@property (strong, nonatomic) NSException *exception;
@property (assign, nonatomic) BOOL autoErrorReport;

+ (id) singleton;

- (void) exitApplication;
- (BOOL) postException:(NSException *)exception;
- (void) showAlert:(NSString *)otherButton;

@end

void exceptionHandler(NSException *exception) {
    DLog(@"%@ : %@", [exception name], [exception reason]);
    if ([[A4GExceptionView singleton] postException:exception]) {
        [[A4GExceptionView singleton] showAlert:nil];
    }
    else {
        [[A4GExceptionView singleton] showAlert:NSLocalizedString(@"Email Support", nil)];
    }
    while (TRUE) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.1]];
    }
}

@implementation A4GExceptionView

@synthesize title = _title;
@synthesize message = _message;
@synthesize app = _app;
@synthesize version = _version;
@synthesize device = _device;
@synthesize model = _model;
@synthesize url = _url;
@synthesize email = _email;
@synthesize color = _color;
@synthesize controller = _controller;
@synthesize exception = _exception;
@synthesize autoErrorReport = _autoErrorReport;

static A4GExceptionView *singleton = nil;

+ (A4GExceptionView*) registerWithTitle:(NSString *)title
                               message:(NSString *)message 
                                   app:(NSString *)app
                               version:(NSString *)version
                                device:(NSString*)device
                                 model:(NSString*)model
                                   url:(NSString*)url
                                 email:(NSString*)email
                                 color:(UIColor*)color
                               logging:(BOOL)logging
                            controller:(UIViewController*)controller {
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    singleton.title = title;
    singleton.message = message;
    singleton.app = app;
    singleton.version = version;
    singleton.device = device;
    singleton.model = model;
    singleton.url = url;
    singleton.email = email;
    singleton.color = color;
    singleton.autoErrorReport = logging;
    NSSetUncaughtExceptionHandler(&exceptionHandler);
    return singleton;
}


+(void) setAutoErrorReport:(BOOL)autoErrorReport {
    singleton.autoErrorReport = autoErrorReport;
}

- (BOOL) postException:(NSException *)exception {
    self.exception = exception;
    if (self.autoErrorReport) {
        @try {
            if (self.url != nil && self.url.length > 0) {
                NSString *message = [NSString stringWithFormat:@"%@ : %@", [exception name], [exception reason]];
                NSString *sender = [NSString stringWithFormat:@"%@ %@ : %@ %@", self.app, self.version, self.device, self.model];
                NSString *stack = [[exception callStackSymbols] componentsJoinedByString:@"\n"];
                
                NSURL *url = [NSURL URLWithString:self.url];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
                NSMutableString *params = [NSMutableString string];
                [params appendFormat:@"entry.0.single=%@", message];
                [params appendFormat:@"&entry.1.single=%@", sender];
                [params appendFormat:@"&entry.2.single=%@", stack];
                [params appendFormat:@"&pageNumber=%@", @"0"];
                [params appendFormat:@"&backupCache=%@", @""];
                [request setHTTPMethod:@"POST"];
                [request setHTTPBody:[params dataUsingEncoding:NSUTF8StringEncoding]];
                return [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil] != nil;    
            }
        }
        @catch (NSException *error) {
            DLog(@"%@ : %@", [error name], [error reason]);
        }   
    }
    return NO;
}

- (void) showAlert:(NSString *)otherButton {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:self.title  
                                                        message:self.message 
                                                       delegate:self 
                                              cancelButtonTitle:NSLocalizedString(@"Exit Application", nil) 
                                              otherButtonTitles:otherButton, nil];
    [alertView show];
    [alertView release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    DLog(@"");
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self exitApplication];   
    }
    else {
        NSString *subject = [NSString stringWithFormat:@"%@ : %@ %@ : %@ %@", [self.exception name], self.app, self.version, self.device, self.model];
        NSString *body = [NSString stringWithFormat:@"%@\n%@\n\n%@", [self.exception name], [self.exception reason], 
                          [[self.exception callStackSymbols] componentsJoinedByString:@"\n"]];
        
        MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        mailController.navigationBar.tintColor = self.color;
        mailController.mailComposeDelegate = self;
        [mailController setToRecipients:[NSArray arrayWithObject:self.email]];
        [mailController setSubject:subject];
        [mailController setMessageBody:body isHTML:NO];
        mailController.modalPresentationStyle = UIModalPresentationPageSheet;
        mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.controller presentModalViewController:mailController animated:YES];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (error != nil) {
        DLog(@"Error:%@", [error localizedDescription]);
        [self exitApplication];
    }   
    else {
        DLog(@"Result:%d", result);   
        [self.controller dismissModalViewControllerAnimated:YES];
        [self performSelector:@selector(exitApplication) withObject:nil afterDelay:0.5];
    }
}

- (void) exitApplication {
    DLog(@"");
    exit(1);
}

+ (A4GExceptionView *)singleton {
    if (singleton == nil) {
        singleton = [[super allocWithZone:NULL] init];
    }
    return singleton;
}

- (id)init {
    self = [super init];
    if (self) {
        self.title = NSLocalizedString(@"Unhandled Exception", nil);
        self.message = NSLocalizedString(@"An unhandler exception has occured in the application.", nil);
    }
    return self;
}

-(void)dealloc {
    [_title release];
    [_message release];
    [_app release];
    [_version release];
    [_device release];
    [_model release];
    [_url release];
    [_email release];
    [_color release];
    [super dealloc];
}

+ (id)allocWithZone:(NSZone*)zone {
    return [[self singleton] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (NSUInteger)retainCount {
    return NSUIntegerMax;
}

- (oneway void)release {
    
}

- (id)autorelease {
    return self;
}

@end
