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
#import "A4GSettings.h"
#import "A4GTableViewCellFactory.h"
#import "A4GImageTableViewCell.h"
#import "A4GButtonTableViewCell.h"

@interface A4GSettingsViewController ()

@end

@implementation A4GSettingsViewController

@synthesize tableView = _tableView;
@synthesize navigationBar = _navigationBar;

typedef enum {
    TableSectionAbout,
    TableSections
} TableSection;

typedef enum {
    TableSectionAboutRowImage,
    TableSectionAboutRowUrl,
    TableSectionAboutRows
} TableSectionAboutRow;

#pragma mark - Handlers

- (IBAction) done:(id)sender event:(UIEvent*)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController

- (void)dealloc {
    [_navigationBar release];
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [A4GSettings tableBackgroundColor];
    self.navigationBar.tintColor = [A4GSettings navBarColor];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == TableSectionAbout) {
        return TableSectionAboutRows;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableSectionAbout) {
        if (indexPath.row == TableSectionAboutRowImage) {
            A4GImageTableViewCell *cell = [A4GTableViewCellFactory imageTableViewCell:tableView delegate:self index:indexPath];
            cell.image = [UIImage imageNamed:@"logo.png"];
            return cell;
        }
        else if (indexPath.row == TableSectionAboutRowUrl) {
            A4GButtonTableViewCell *cell = [A4GTableViewCellFactory buttonTableViewCell:tableView delegate:self index:indexPath];
            cell.title = @"http://apps4good.ca";
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableSectionAbout) {
        if (indexPath.row == TableSectionAboutRowImage) {
            UIImage *image = [UIImage imageNamed:@"logo.png"];
            return image.size.height;
        }
        else if (indexPath.row == TableSectionAboutRowUrl) {
            return 44;
        } 
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == TableSectionAbout) {
        [self openURL:@"http://apps4good.ca"];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
