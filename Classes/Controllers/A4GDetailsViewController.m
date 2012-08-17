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

#import "A4GDetailsViewController.h"
#import "A4GTableViewController.h"
#import "A4GWebViewController.h"
#import "A4GHeaderView.h"
#import "A4GSettings.h"
#import "A4GDevice.h"
#import "A4GData.h"
#import "NSString+A4G.h"
#import "UIAlertView+A4G.h"
#import "UIViewController+A4G.h"
#import "A4GShareController.h"
#import "A4GTableViewCellFactory.h"

@interface A4GDetailsViewController ()

@property (strong, nonatomic) A4GShareController *shareController;

@end

@implementation A4GDetailsViewController

@synthesize data = _data;
@synthesize webController = _webController;
@synthesize shareController = _shareController;

typedef enum {
    AlertViewError,
    AlertViewWebsite
} AlertView;

#pragma mark - Handlers

- (IBAction)action:(id)sender event:(UIEvent*)event {
    [self.shareController showActionsForEvent:event];
}

#pragma mark - UIViewController

- (void)dealloc {
    [_data release];
    [_webController release];
    [_shareController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareController = [[A4GShareController alloc] initWithController:self];
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.data count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data valueAtIndex:indexPath.section];
    UITableViewCell *cell = [A4GTableViewCellFactory defaultTableViewCell:tableView];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
    cell.textLabel.textColor = [A4GSettings tableGroupedTextColor];
    cell.textLabel.text = text;
    cell.textLabel.numberOfLines = 0;
    if ([NSString isEmailAddress:text] && [self.shareController canSendEmail]) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
    }
    else if ([NSString isPhoneNumber:text] && [self.shareController canCallNumber:text]) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
    }
    else if ([NSString isPhotoURL:text] && [self.shareController canOpenURL:text]) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.png"]];
    }
    else if ([NSString isTwitterURL:text] && [self.shareController canSendTweet]) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter.png"]];
    }
    else if ([NSString isWebURL:text] && [self.shareController canOpenURL:text]) {
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"web.png"]];
    }
    else {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryView = nil;
    }
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.data keyAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data valueAtIndex:indexPath.section];
    if ([NSString isEmailAddress:text]) {
        [self.shareController sendEmail:nil withSubject:self.title toRecipients:[NSArray arrayWithObject:text]];
    }
    else if ([NSString isPhotoURL:text]) {
        self.webController.url = text;
        [self.navigationController pushViewController:self.webController animated:YES];
//        [self.shareController openURL:text];
    }
    else if ([NSString isPhoneNumber:text]) {
        [self.shareController callNumber:text];
    }
    else if ([NSString isTwitterURL:text]) {
        [self.shareController sendTweet:[text removeTwitterURL] withURL:nil];
    }
    else if ([NSString isWebURL:text]) {
        self.webController.url = text;
        [self.navigationController pushViewController:self.webController animated:YES];
//        [self.shareController openURL:text];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data valueAtIndex:indexPath.section];
    return [self tableView:tableView heightForText:text withFont:[UIFont boldSystemFontOfSize:17]];
}

#pragma mark - A4GShareControllerDelegate

- (void) share:(A4GShareController*)share willCallNumber:(NSString**)number {
    //TODO implement get number for call
}

- (void) share:(A4GShareController*)share willCopyText:(NSString**)text {
    NSMutableString *message = [NSMutableString stringWithString:self.title];
    for (NSString *key in [self.data allKeys]) {
        NSString *value = [self.data valueForKey:key];
        [message appendFormat:@"\n%@: %@", key, value];
    }
    *text = message;
}

- (void) share:(A4GShareController*)share willSendTweet:(NSString**)tweet withURL:(NSString**)url {
    NSMutableString *message = [NSMutableString stringWithString:self.title];
    for (NSString *key in [self.data allKeys]) {
        NSString *value = [self.data valueForKey:key];
        if ([NSString isPhoneNumber:value]) {
            //ignore phone numbers
        }
        else if ([NSString isEmailAddress:value]) {
            //ignore email addresses
        }
        else if ([NSString isPhotoURL:value]) {
            //ignore photo urls
        }
        else if ([NSString isTwitterURL:value]) {
            if (message.length > 0) {
                [message appendString:@" "];
            }
            [message appendString:[value removeTwitterURL]];
        }
        else if ([NSString isWebURL:value]) {
            *url = value;
        }
        else if (value.length > 140) {
            //ignore long text
        }
        else {
            if (message.length > 0) {
                [message appendString:@" "];
            }
            [message appendString:value];
        }
    }
    *tweet = message;
}

- (void) share:(A4GShareController*)share willPrintText:(NSString**)print withTitle:(NSString**)text {
    NSMutableString *message = [NSMutableString stringWithString:self.title];
    for (NSString *key in [self.data allKeys]) {
        NSString *value = [self.data valueForKey:key];
        [message appendFormat:@"\n%@: %@", key, value];
    }
    *text = self.title;
    *print = message;
}

- (void) share:(A4GShareController*)share willSendEmail:(NSString**)email withSubject:(NSString**)subject toRecipients:(NSArray**)recipients {
    NSMutableString *message = [NSMutableString string];
    for (NSString *key in [self.data allKeys]) {
        NSString *value = [self.data valueForKey:key];
        if ([NSString isEmailAddress:value]) {
            [message appendFormat:@"%@: <a href='mailto:%@'>%@</a><br/>", key, value, value];
        } 
        else if ([NSString isPhotoURL:value]) {
            [message appendFormat:@"%@: <a href='%@'>%@</a><br/>", key, value, value];
        }
        else if ([NSString isWebURL:value]) {
            [message appendFormat:@"%@: <a href='%@'>%@</a><br/>", key, value, value];
        }
        else {
            [message appendFormat:@"%@: %@<br/>", key, [value stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"]];
        }
    }    
    *email = message;
    *subject = self.title;
    *recipients = nil;
}

- (void) share:(A4GShareController*)share willSendSMS:(NSString**)sms {
    NSMutableString *message = [NSMutableString stringWithString:self.title];
    for (NSString *key in [self.data allKeys]) {
        NSString *value = [self.data valueForKey:key];
        if (value.length > 140) {
            //ignore long text
        }
        else {
            if (message.length > 0) {
                [message appendString:@" "];
            }
            [message appendString:value];
        }
    }
    *sms = message;
}

- (NSString *) copyTextForShare:(A4GShareController*)share {
    NSMutableString *message = [NSMutableString stringWithString:self.title];
    for (NSString *key in [self.data allKeys]) {
        NSString *value = [self.data valueForKey:key];
        [message appendFormat:@"\n%@: %@", key, value];
    }
    return message;
}

@end
