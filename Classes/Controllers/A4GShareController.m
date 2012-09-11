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

#import "A4GShareController.h"
#import "A4GSettings.h"
#import "UIAlertView+A4G.h"
#import "A4GLoadingView.h"
#import "UIViewController+A4G.h"
#import "A4GLoadingView.h"

@interface A4GShareController ()

@property (strong, nonatomic) UIViewController<A4GShareControllerDelegate> *controller;
@property (strong, nonatomic) NSString *textShareSMS;
@property (strong, nonatomic) NSString *textShareEmail;
@property (strong, nonatomic) NSString *textCopyClipboard;
@property (strong, nonatomic) NSString *textShareTwitter;
@property (strong, nonatomic) NSString *textPrintDetails;
@property (strong, nonatomic) NSString *textCancelAction;
@property (strong, nonatomic) A4GLoadingView *loadingView;

@end

@implementation A4GShareController

@synthesize controller = _controller;
@synthesize textShareSMS = _textShareSMS;
@synthesize textShareEmail = _textShareEmail;
@synthesize textCopyClipboard = _textCopyClipboard;
@synthesize textShareTwitter = _textShareTwitter;
@synthesize textPrintDetails = _textPrintDetails;
@synthesize textCancelAction = _textCancelAction;
@synthesize loadingView = _loadingView;

typedef enum {
    AlertViewError,
    AlertViewWebsite
} AlertView;

- (id) initWithController:(UIViewController<A4GShareControllerDelegate>*)controller {
    if (self = [super init]) {
        self.controller = controller;
        self.loadingView = [A4GLoadingView initWithController:controller];
        self.textShareEmail = NSLocalizedString(@"Share via Email", nil);
        self.textShareSMS = NSLocalizedString(@"Share via SMS", nil);
        self.textShareTwitter = NSLocalizedString(@"Share via Twitter", nil);
        self.textPrintDetails = NSLocalizedString(@"Print Information", nil);
        self.textCopyClipboard = NSLocalizedString(@"Copy to Clipboard", nil);
        self.textCancelAction = NSLocalizedString(@"Cancel", nil);
    }
    return self;
}

- (void)dealloc {
    [_controller release];
    [_loadingView release];
    [_textShareTwitter release];
    [_textShareSMS release];
    [_textPrintDetails release];
    [_textCancelAction release];
    [_textCopyClipboard release];
    [super dealloc];
}

- (void)showActionsForEvent:(UIEvent*)event {
    DLog(@"");
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:nil 
                                                              delegate:self
                                                     cancelButtonTitle:nil
                                                destructiveButtonTitle:nil
                                                     otherButtonTitles:nil] autorelease];
    if ([self canPrintText]) {
        DLog(@"canPrintText");
        [actionSheet addButtonWithTitle:self.textPrintDetails];
    }
    if ([self canCopyText]) {
        DLog(@"canCopyText");
        [actionSheet addButtonWithTitle:self.textCopyClipboard];
    }
    if ([self canSendEmail]) {
        DLog(@"canSendMail");
        [actionSheet addButtonWithTitle:self.textShareEmail];
    }
    if ([self canSendSMS]) {
        DLog(@"canSendSMS");
        [actionSheet addButtonWithTitle:self.textShareSMS];
    }
    if ([self canSendTweet]) {
        DLog(@"canSendTweet");
        [actionSheet addButtonWithTitle:self.textShareTwitter];
    }
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:self.textCancelAction];
    [actionSheet showFromRect:[self.controller touchOfEvent:event] inView:self.controller.view animated:YES];  
}

- (BOOL) canPrintText {
    return [UIPrintInteractionController isPrintingAvailable];
}

- (BOOL) canCopyText {
    return NSClassFromString(@"UIPasteboard") != nil;
}

- (BOOL) canSendSMS {
    return [MFMessageComposeViewController canSendText];
}

- (BOOL) canSendEmail {
    return [MFMailComposeViewController canSendMail];
}

- (BOOL) canSendTweet {
    return [TWTweetComposeViewController class] != nil &&
        [TWTweetComposeViewController canSendTweet];
    //return NSClassFromString(@"TWTweetComposeViewController") != nil;
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
    if ([self canCallNumber:number]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", number]];
        [[UIApplication sharedApplication] openURL:url];    
    }
}

- (void) sendTweet:(NSString*)tweet withURL:(NSString*)url {
    DLog(@"Tweet:%@ URL:%@", tweet, url);
    if ([self canSendTweet]) {
        //Class TWTweetComposeViewControllerClass = NSClassFromString(@"TWTweetComposeViewController");
        //UIViewController *twitterViewController = [[TWTweetComposeViewControllerClass alloc] init];
        TWTweetComposeViewController *twitterViewController = [[TWTweetComposeViewController alloc] init];
        if (tweet != nil) {
            [twitterViewController performSelector:@selector(setInitialText:) withObject:tweet];
        }
        if (url != nil) {
            [twitterViewController performSelector:@selector(addURL:) withObject:[NSURL URLWithString:url]];    
        }
        [self.controller presentModalViewController:twitterViewController animated:YES];
        [twitterViewController release];
    }
}

- (void) printText:(NSString*)text withTitle:(NSString*)title {
    DLog(@"Text:%@ Title:%@", text, title);
    if ([self canPrintText]) {
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
                    if (completed && !error) {
                        [self.loadingView showWithMessage:NSLocalizedString(@"Printed!", nil)];
                        [self.loadingView hideAfterDelay:2.0];
                    }
                    else if (!completed && error) {
                        DLog(@"Error:%@ Domain:%@ Code:%u", error, error.domain, error.code);
                        [UIAlertView showWithTitle:NSLocalizedString(@"Print Error", nil) 
                                           message:[error localizedDescription]
                                          delegate:self 
                                               tag:AlertViewError 
                                 cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                                 otherButtonTitles:nil];
                    }
                };
            [printController presentAnimated:YES completionHandler:completionHandler];
        }
    }
}

- (void) copyText:(NSString *)string {
    DLog(@"Text:%@", string);
    if ([self canCopyText]) {
        UIPasteboard *pasteBoard = [UIPasteboard generalPasteboard];
        pasteBoard.persistent = YES;
        pasteBoard.string = string;
    }
}

- (void) openURL:(NSString *)url {
    DLog(@"URL:%@", url);
    if ([self canOpenURL:url]) {
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
    if ([self canSendSMS]) {
        MFMessageComposeViewController *smsController = [[[MFMessageComposeViewController alloc] init] autorelease];
        smsController.navigationBar.tintColor = [A4GSettings navBarColor];
        smsController.messageComposeDelegate = self;
        if (message != nil) {
            smsController.body = message;    
        }
        smsController.modalPresentationStyle = UIModalPresentationFormSheet;
        smsController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.controller presentModalViewController:smsController animated:YES];
    }
}

- (void) sendEmail:(NSString*)message withSubject:(NSString *)subject toRecipient:(NSString*)recipient {
    NSArray *recipients = recipient != nil ? [NSArray arrayWithObject:recipient] : nil;
    [self sendEmail:message withSubject:subject toRecipients:recipients];   
}

- (void) sendEmail:(NSString*)message withSubject:(NSString *)subject toRecipients:(NSArray*)recipients {
    DLog(@"Message:%@ Subject:%@", message, subject);
    if ([self canSendEmail]) {
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
        mailController.modalPresentationStyle = UIModalPresentationFormSheet;
        mailController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self.controller presentModalViewController:mailController animated:YES]; 
    }
}

#pragma mark - MFMailComposeViewController

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
    if (result == MFMailComposeResultSent) {
        DLog(@"MFMailComposeResultSent");
        [self.controller dismissModalViewControllerAnimated:YES];
        [self.loadingView showWithMessage:NSLocalizedString(@"Sent!", nil)];
        [self.loadingView hideAfterDelay:2.0];
    }
    else if (result == MFMailComposeResultFailed) {
        DLog(@"MFMailComposeResultFailed");
        [self.controller dismissModalViewControllerAnimated:YES];
        [UIAlertView showWithTitle:NSLocalizedString(@"Email Error", nil) 
                           message:[error localizedDescription] 
                          delegate:self 
                               tag:AlertViewError 
                 cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                 otherButtonTitles:nil];
    }
    else if (result == MFMailComposeResultCancelled) {
        DLog(@"MFMailComposeResultCancelled");
        [self.controller dismissModalViewControllerAnimated:YES];
    } 
    else {
        [self.controller dismissModalViewControllerAnimated:YES];
    }
}

#pragma mark - MFMessageComposeViewController

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    if (result == MessageComposeResultSent) {
        DLog(@"MessageComposeResultSent");
        [self.controller dismissModalViewControllerAnimated:YES];
        [self.loadingView showWithMessage:NSLocalizedString(@"Sent!", nil)];
        [self.loadingView hideAfterDelay:2.0];
    }
    else if (result == MessageComposeResultFailed) {
        DLog(@"MessageComposeResultFailed");
        [self.controller dismissModalViewControllerAnimated:YES];
        [UIAlertView showWithTitle:NSLocalizedString(@"SMS Error", nil) 
                           message:NSLocalizedString(@"There was a problem sending SMS message.", nil) 
                          delegate:self 
                               tag:AlertViewError 
                 cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                 otherButtonTitles:nil];
    }
    else if (result == MessageComposeResultCancelled) {
        DLog(@"MessageComposeResultCancelled");
        [self.controller dismissModalViewControllerAnimated:YES];
    }
    else {
        [self.controller dismissModalViewControllerAnimated:YES];
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

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textShareSMS]) {
        if ([self.controller respondsToSelector:@selector(share:willSendSMS:)]) {
            NSString *sms = nil;
            [self.controller share:self willSendSMS:&sms];
            [self sendSMS:sms];
        }
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textShareEmail]) {
        if ([self.controller respondsToSelector:@selector(share:willSendEmail:withSubject:toRecipients:)]) {
            NSString *email = nil;
            NSString *subject = nil;
            NSArray *recipients = nil;
            [self.controller share:self willSendEmail:&email withSubject:&subject toRecipients:&recipients];
            [self sendEmail:email withSubject:subject toRecipients:recipients];
        }
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textShareTwitter]) {
        if ([self.controller respondsToSelector:@selector(share:willSendTweet:withURL:)]) {
            NSString *tweet = nil;
            NSString *url = nil;
            [self.controller share:self willSendTweet:&tweet withURL:&url];
            [self sendTweet:tweet withURL:url];
        }
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textPrintDetails]) {
        if ([self.controller respondsToSelector:@selector(share:willPrintText:withTitle:)]) {
            NSString *print = nil;
            NSString *title = nil;
            [self.controller share:self willPrintText:&print withTitle:&title];
            [self printText:print withTitle:title];
        }
    } 
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textCopyClipboard]) {
        if ([self.controller respondsToSelector:@selector(share:willCopyText:)]) {
            NSString *text = nil;
            [self.controller share:self willCopyText:&text];
            [self copyText:text];
            [self.loadingView showWithMessage:NSLocalizedString(@"Copied!", nil)];
            [self.loadingView hideAfterDelay:1.5];
        }
    }
}

@end
