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

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>

@protocol A4GShareControllerDelegate;

@interface A4GShareController : NSObject<UIAlertViewDelegate,
                                         UIActionSheetDelegate,
                                         UIPrintInteractionControllerDelegate,
                                         MFMailComposeViewControllerDelegate,
                                         MFMessageComposeViewControllerDelegate>

- (id) initWithController:(UIViewController<A4GShareControllerDelegate>*)controller;
- (void) showActionsForEvent:(UIEvent*)event;

- (BOOL) canPrintText;
- (BOOL) canCopyText;
- (BOOL) canSendSMS;
- (BOOL) canSendEmail;
- (BOOL) canSendTweet;
- (BOOL) canCallNumber:(NSString*)number;
- (BOOL) canOpenURL:(NSString*)url;

- (void) callNumber:(NSString *)number;
- (void) openURL:(NSString *)url;
- (void) copyText:(NSString *)string;
- (void) sendTweet:(NSString*)tweet withURL:(NSString*)url;
- (void) printText:(NSString*)text withTitle:(NSString*)title;
- (void) sendEmail:(NSString*)message withSubject:(NSString *)subject toRecipient:(NSString*)recipient;
- (void) sendEmail:(NSString*)message withSubject:(NSString *)subject toRecipients:(NSArray*)recipients;
- (void) sendSMS:(NSString *)message;

@end

@protocol A4GShareControllerDelegate <NSObject>

@optional

- (void) share:(A4GShareController*)share willCallNumber:(NSString**)number;
- (void) share:(A4GShareController*)share willCopyText:(NSString**)text;
- (void) share:(A4GShareController*)share willSendTweet:(NSString**)tweet withURL:(NSString**)url;
- (void) share:(A4GShareController*)share willPrintText:(NSString**)text withTitle:(NSString**)title;
- (void) share:(A4GShareController*)share willSendEmail:(NSString**)message withSubject:(NSString**)subject toRecipients:(NSArray**)recipients;
- (void) share:(A4GShareController*)share willSendSMS:(NSString**)message;

@end
