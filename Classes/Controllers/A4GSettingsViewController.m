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

#import "A4GSettingsViewController.h"
#import "A4GTableViewCellFactory.h"
#import "UIViewController+A4G.h"
#import "A4GImageTableViewCell.h"
#import "A4GSettings.h"
#import "A4GDevice.h"

@interface A4GSettingsViewController ()

@property (strong, nonatomic) A4GShareController *shareController;

@end

@implementation A4GSettingsViewController

@synthesize shareController = _shareController;

typedef enum {
    TableSectionApp,
    TableSectionAbout,
    TableSections
} TableSection;

typedef enum {
    TableSectionAppRowText,
    TableSectionAppRowVersion,
    TableSectionAppRowEmail,
    TableSectionAppRowUrl,
    TableSectionAppRows
} TableSectionAppRow;

typedef enum {
    TableSectionAboutRowText,
    TableSectionAboutRowEmail,
    TableSectionAboutRowUrl,
    TableSectionAboutRowLogo,
    TableSectionAboutRows
} TableSectionAboutRow;

#pragma mark - UIViewController

- (void)dealloc {
    [_shareController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.shareController = [[A4GShareController alloc] initWithController:self];
}

- (void) viewDidUnload {
    [super viewDidUnload];
    self.shareController = nil;
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == TableSectionApp) {
        return TableSectionAppRows;
    }
    if (section == TableSectionAbout) {
        return TableSectionAboutRows;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableSectionApp) {
        UITableViewCell *cell = [A4GTableViewCellFactory defaultTableViewCell:tableView];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [A4GSettings tableGroupedTextColor];
        cell.textLabel.numberOfLines = 0;
        if (indexPath.row == TableSectionAppRowText) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            cell.textLabel.text = [A4GSettings appText];
        }
        else if (indexPath.row == TableSectionAppRowVersion) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Version", nil), [A4GSettings appVersion]];
        }
        else if (indexPath.row == TableSectionAppRowEmail) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
            cell.textLabel.text = NSLocalizedString(@"Share Application", nil);
        }
        else if (indexPath.row == TableSectionAppRowUrl) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"web.png"]];
            cell.textLabel.text = NSLocalizedString(@"Visit App Store", nil);
        }
        return cell;
    }
    else if (indexPath.section == TableSectionAbout) {
        if (indexPath.row == TableSectionAboutRowLogo) {
            A4GImageTableViewCell *cell = [A4GTableViewCellFactory imageTableViewCell:tableView delegate:self index:indexPath];
            cell.image = [UIImage imageNamed:@"logo.png"];
            return cell;
        }
        UITableViewCell *cell = [A4GTableViewCellFactory defaultTableViewCell:tableView];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:17];
        cell.textLabel.textColor = [A4GSettings tableGroupedTextColor];
        cell.textLabel.numberOfLines = 0;
        if (indexPath.row == TableSectionAboutRowText) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = nil;
            cell.textLabel.text = [A4GSettings aboutText];
        }
        else if (indexPath.row == TableSectionAboutRowEmail) {
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"email.png"]];
            cell.textLabel.text = [A4GSettings aboutEmail];
        }
        else if (indexPath.row == TableSectionAboutRowUrl) {
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"web.png"]];
            cell.textLabel.text = [A4GSettings aboutURL];
        }
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = nil;
    if (indexPath.section == TableSectionApp) {
        if (indexPath.row == TableSectionAppRowText) {
            text = [A4GSettings appText];
        }
        else if (indexPath.row == TableSectionAppRowEmail) {
            text = NSLocalizedString(@"Share Application", nil);
        }
        else if (indexPath.row == TableSectionAppRowUrl) {
            text = NSLocalizedString(@"Visit App Store", nil);
        }
    }
    else if (indexPath.section == TableSectionAbout) {
        if (indexPath.row == TableSectionAboutRowText) {
            text = [A4GSettings aboutText];
        }
        else if (indexPath.row == TableSectionAboutRowEmail) {
            text = [A4GSettings aboutEmail];
        }
        else if (indexPath.row == TableSectionAboutRowUrl) {
            text = [A4GSettings aboutURL];
        }
        else if (indexPath.row == TableSectionAboutRowLogo) {
            return 200;
        }
    }
    return [self tableView:tableView heightForText:text withFont:[UIFont boldSystemFontOfSize:17]];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == TableSectionApp) {
        return NSLocalizedString(@"App", nil);
    }
    else if (section == TableSectionAbout) {
        return NSLocalizedString(@"About", nil);
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableSectionApp) {
        if (indexPath.row == TableSectionAppRowEmail) {
            NSMutableString *email = [NSMutableString string];
            [email appendFormat:@"%@", [A4GSettings appText]];
            [email appendString:@"<br/><br/>"];
            [email appendFormat:@"<a href='%@'>%@</a>", [A4GSettings appURL], [A4GSettings appURL]];
            [self.shareController sendEmail:email 
                                withSubject:[A4GSettings appName] 
                                toRecipient:nil];
        }
        else if (indexPath.row == TableSectionAppRowUrl) {
            [self.shareController openURL:[A4GSettings appURL]];
        }
    }
    else if (indexPath.section == TableSectionAbout) {
        if (indexPath.row == TableSectionAboutRowUrl) {
            [self.shareController openURL:[A4GSettings aboutURL]];
        }
        else if (indexPath.row == TableSectionAboutRowEmail) {
            [self.shareController sendEmail:nil 
                                withSubject:[A4GSettings appName] 
                                toRecipient:[A4GSettings aboutEmail]];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
