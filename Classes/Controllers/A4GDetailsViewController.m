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
#import "A4GHeaderView.h"
#import "A4GSettings.h"
#import "A4GDevice.h"
#import "A4GData.h"
#import "NSString+A4G.h"
#import "UIAlertView+A4G.h"
#import "UIViewController+A4G.h"

@interface A4GDetailsViewController ()

@property (strong, nonatomic) NSString *textShareSMS;
@property (strong, nonatomic) NSString *textShareEmail;
@property (strong, nonatomic) NSString *textShareTwitter;
@property (strong, nonatomic) NSString *textPrintDetails;
@property (strong, nonatomic) NSString *textCancelAction;

@end

@implementation A4GDetailsViewController

@synthesize data = _data;
@synthesize textShareSMS = _textShareSMS;
@synthesize textShareEmail = _textShareEmail;
@synthesize textShareTwitter = _textShareTwitter;
@synthesize textPrintDetails = _textPrintDetails;
@synthesize textCancelAction = _textCancelAction;

typedef enum {
    AlertViewError,
    AlertViewWebsite
} AlertView;

#pragma mark - Handlers

- (IBAction)done:(id)sender event:(UIEvent*)event {
    DLog(@"");
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)action:(id)sender event:(UIEvent*)event {
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
    [actionSheet showFromRect:[self touchOfEvent:event] inView:self.view animated:YES];  
}

#pragma mark - UIViewController

- (void)dealloc {
    [_data release];
    [_textShareTwitter release];
    [_textShareSMS release];
    [_textPrintDetails release];
    [_textCancelAction release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textShareEmail = NSLocalizedString(@"Share via Email", nil);
    self.textShareSMS = NSLocalizedString(@"Share via SMS", nil);
    self.textShareTwitter = NSLocalizedString(@"Share via Twitter", nil);
    self.textPrintDetails = NSLocalizedString(@"Print Information", nil);
    self.textCancelAction = NSLocalizedString(@"Cancel", nil);
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
    if ([NSString isPhotoURL:text]) {
        //TODO show photo
        static NSString *CellIdentifier = @"Cell"; 
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = text;
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.png"]];
        return cell;
    }
    else {
        static NSString *CellIdentifier = @"Cell"; 
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.textLabel.text = text;
        cell.textLabel.numberOfLines = 0;
        if ([NSString isEmailAddress:text] && [self canSendEmail]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
        }
        else if ([NSString isPhoneNumber:text] && [self canCallNumber:text]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"phone.png"]];
        }
        else if ([NSString isPhotoURL:text] && [self canOpenURL:text]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"photo.png"]];
        }
        else if ([NSString isTwitterURL:text] && [self canSendTweet]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"twitter.png"]];
        }
        else if ([NSString isWebURL:text] && [self canOpenURL:text]) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"web.png"]];
        }
        else {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
        }
        return cell;
    }
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.data keyAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data valueAtIndex:indexPath.section];
    if ([NSString isEmailAddress:text]) {
        [self sendEmail:nil withSubject:self.title toRecipients:[NSArray arrayWithObject:text]];
    }
    else if ([NSString isPhotoURL:text]) {
        [self openURL:text];
    }
    else if ([NSString isPhoneNumber:text]) {
        [self callNumber:text];
    }
    else if ([NSString isTwitterURL:text]) {
        [self sendTweet:[text removeTwitterURL] withURL:nil];
    }
    else if ([NSString isWebURL:text]) {
        [self openURL:text];
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = [self.data valueAtIndex:indexPath.section];
    CGFloat width = tableView.frame.size.width;
    if (tableView.style == UITableViewStyleGrouped) {
        if ([A4GDevice isIPad]){
            width -= 90.0;
        }
        else {
            width -= 20.0;
        }
    }
    CGSize size = [text sizeWithFont:[UIFont boldSystemFontOfSize:17] 
                   constrainedToSize:CGSizeMake(width, MAXFLOAT) 
                       lineBreakMode:UILineBreakModeWordWrap];
    return MAX(size.height + 15, 44.0f);
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textShareSMS]) {
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
        [self sendSMS:message];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textShareEmail]) {
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
        [self sendEmail:message withSubject:self.title toRecipients:nil];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textShareTwitter]) {
        NSMutableString *tweet = [NSMutableString stringWithString:self.title];
        NSString *url = nil;
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
                if (tweet.length > 0) {
                    [tweet appendString:@" "];
                }
                [tweet appendString:[value removeTwitterURL]];
            }
            else if ([NSString isWebURL:value]) {
                url = value;
            }
            else if (value.length > 140) {
                //ignore long text
            }
            else {
                if (tweet.length > 0) {
                    [tweet appendString:@" "];
                }
                [tweet appendString:value];
            }
        }
        [self sendTweet:tweet withURL:url];
    }
    else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:self.textPrintDetails]) {
        NSMutableString *message = [NSMutableString stringWithString:self.title];
        for (NSString *key in [self.data allKeys]) {
            NSString *value = [self.data valueForKey:key];
            [message appendFormat:@"\n%@: %@", key, value];
        }
        [self printText:message withTitle:self.title];
    } 
}

@end
