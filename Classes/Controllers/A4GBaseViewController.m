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

#import "A4GBaseViewController.h"
#import "A4GSettings.h"
#import "UIAlertView+A4G.h"
#import "A4GLoadingView.h"

@interface A4GBaseViewController ()

@property (strong, nonatomic) A4GLoadingView *loadingView;

@end

@implementation A4GBaseViewController

typedef enum {
    AlertViewError,
    AlertViewWebsite
} AlertView;

@synthesize loadingView = _loadingView;

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

#pragma mark - Handlers

- (BOOL) canPrintText {
    return [UIPrintInteractionController isPrintingAvailable];
}

- (BOOL) canSendSMS {
    return [MFMessageComposeViewController canSendText];
}

- (BOOL) canSendEmail {
    return [MFMailComposeViewController canSendMail];
}

- (BOOL) canSendTweet {
    return NSClassFromString(@"TWTweetComposeViewController") != nil;
}

- (BOOL) canCallNumber:(NSString*)number {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]];
    return [[UIApplication sharedApplication] canOpenURL:url];
}

- (BOOL) canOpenURL:(NSString*)url {
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]];
}

- (void) callNumber:(NSString *)number {
    DLog(@"Number:%@", number);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]];
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];    
    }
}

- (void) sendTweet:(NSString*)tweet withURL:(NSString*)url {
    DLog(@"Tweet:%@ URL:%@", tweet, url);
    Class TWTweetComposeViewControllerClass = NSClassFromString(@"TWTweetComposeViewController");
    if (TWTweetComposeViewControllerClass != nil && [TWTweetComposeViewControllerClass respondsToSelector:@selector(canSendTweet)]) {
        UIViewController *twitterViewController = [[TWTweetComposeViewControllerClass alloc] init];
        if (tweet != nil) {
            [twitterViewController performSelector:@selector(setInitialText:) withObject:tweet];
        }
        if (url != nil) {
            [twitterViewController performSelector:@selector(addURL:) withObject:[NSURL URLWithString:url]];    
        }
        [self presentModalViewController:twitterViewController animated:YES];
        [twitterViewController release];
    }
}

- (void) printText:(NSString*)text withTitle:(NSString*)title {
    DLog(@"Text:%@ Title:%@", text, title);
    if ([UIPrintInteractionController isPrintingAvailable]) {
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
        if (printController && [UIPrintInteractionController canPrintData:data]) {
            printController.delegate = self;
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            printInfo.jobName = title;
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printController.printInfo = printInfo;
            printController.showsPageRange = YES;
            printController.printingItem = data;
            void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = 
            ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
                if (!completed && error) {
                    DLog(@"Error:%@ Domain:%@ Code:%u", error, error.domain, error.code);
                }
            };
            [printController presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (void) openURL:(NSString *)url {
    DLog(@"URL:%@", url);
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:url]]) {
        [UIAlertView showWithTitle:NSLocalizedString(@"Open in Safari?", nil) 
                           message:url 
                          delegate:self 
                               tag:AlertViewWebsite 
                 cancelButtonTitle:NSLocalizedString(@"Cancel", nil) 
                 otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    }
    
}

- (void) sendSMS:(NSString *)message {
    DLog(@"Message:%@", message);
    if ([MFMessageComposeViewController canSendText]) {
        MFMessageComposeViewController *smsController = [[[MFMessageComposeViewController alloc] init] autorelease];
        smsController.navigationBar.tintColor = [A4GSettings navBarColor];
        smsController.messageComposeDelegate = self;
        if (message != nil) {
            smsController.body = message;    
        }
        smsController.modalPresentationStyle = UIModalPresentationPageSheet;
        smsController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:smsController animated:YES];
    }
}

- (void) sendEmail:(NSString*)message withSubject:(NSString *)subject toRecipients:(NSArray*)recipients {
    DLog(@"Message:%@ Subject:%@", message, subject);
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailController = [[[MFMailComposeViewController alloc] init] autorelease];
        mailController.navigationBar.tintColor = [A4GSettings navBarColor];
        mailController.mailComposeDelegate = self;
        if (subject != nil) {
            [mailController setSubject:subject];
        }
        if (message != nil) {
            [mailController setMessageBody:message isHTML:YES]; 
        }
        if (recipients != nil) {
            [mailController setToRecipients:recipients];
        }
        mailController.modalPresentationStyle = UIModalPresentationPageSheet;
        mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentModalViewController:mailController animated:YES]; 
    }
}

#pragma mark - UIViewController

- (void)dealloc {
    [_loadingView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    DLog(@"");
    self.loadingView = [A4GLoadingView initWithController:self];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    DLog(@"");
    self.loadingView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    DLog(@"");
    self.loadingView.center = self.view.center;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    DLog(@"");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    DLog(@"");
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    DLog(@"");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } 
    else {
        return YES;
    }
}

#pragma mark - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        DLog(@"MFMailComposeResultSent");
        [self dismissModalViewControllerAnimated:YES];
    }
    else if (result == MFMailComposeResultFailed) {
        DLog(@"MFMailComposeResultFailed");
        [self dismissModalViewControllerAnimated:YES];
        [UIAlertView showWithTitle:NSLocalizedString(@"SMS Error", nil) 
                           message:NSLocalizedString(@"There was a problem sending email message.", nil) 
                          delegate:self 
                               tag:AlertViewError 
                 cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                 otherButtonTitles:nil];
    }
    else if (result == MFMailComposeResultCancelled) {
        DLog(@"MFMailComposeResultCancelled");
        [self dismissModalViewControllerAnimated:YES];
    } 
}

#pragma mark - MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultSent) {
        DLog(@"MessageComposeResultSent");
        [self dismissModalViewControllerAnimated:YES];
    }
    else if (result == MessageComposeResultFailed) {
        DLog(@"MessageComposeResultFailed");
        [self dismissModalViewControllerAnimated:YES];
        [UIAlertView showWithTitle:NSLocalizedString(@"SMS Error", nil) 
                           message:NSLocalizedString(@"There was a problem sending SMS message.", nil) 
                          delegate:self 
                               tag:AlertViewError 
                 cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                 otherButtonTitles:nil];
    }
    else if (result == MessageComposeResultCancelled) {
        DLog(@"MessageComposeResultCancelled");
        [self dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertViewWebsite) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:alertView.message]];
        }
    }
}

@end
