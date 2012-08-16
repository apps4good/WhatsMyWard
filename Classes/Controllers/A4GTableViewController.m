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

#import "A4GTableViewController.h"
#import "A4GDevice.h"
#import "A4GSettings.h"
#import "A4GHeaderView.h"
#import "NSString+A4G.h"

@interface A4GTableViewController ()

@end

@implementation A4GTableViewController

typedef enum {
    TableSections
} TableSection;

@synthesize tableView = _tableView;

#pragma mark - UIViewController

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([A4GDevice isIPad]) {
        [self.tableView setBackgroundView:nil];
        [self.tableView setBackgroundView:[[[UIView alloc] init] autorelease]];
    }
    if (self.tableView.style == UITableViewStylePlain) {
        self.tableView.backgroundColor = [A4GSettings tablePlainBackColor];
    }
    else {
        self.tableView.backgroundColor = [A4GSettings tableGroupedBackColor];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView flashScrollIndicators];
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return TableSections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"%d:%d", indexPath.section, indexPath.row);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.style == UITableViewStylePlain) {
     	if (indexPath.row % 2) {
            cell.backgroundColor = [A4GSettings tablePlainRowEvenColor];
        }
        else {
            cell.backgroundColor = [A4GSettings tablePlainRowOddColor];
        }   
    }
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain) {
        NSString *header = [self tableView:tableView titleForHeaderInSection:section];
        return [NSString isNilOrEmpty:header] == NO ? [A4GHeaderView getViewHeight] : 0;   
    }
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *text = @"";
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
    return MAX(size.height + 25, 44.0f);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.style == UITableViewStylePlain) {
        return [A4GHeaderView headerForTable:tableView 
                                        text:[self tableView:tableView titleForHeaderInSection:section]
                                   textColor:[A4GSettings tablePlainHeaderTextColor] 
                             backgroundColor:[A4GSettings tablePlainHeaderBackColor]];   
    }
    else {
        return [A4GHeaderView headerForTable:tableView 
                                        text:[self tableView:tableView titleForHeaderInSection:section]
                                   textColor:[A4GSettings tableGroupedHeaderTextColor] 
                             backgroundColor:[UIColor clearColor]];
    }   
}

- (CGFloat)tableView:(UITableView *)tableView heightForText:(NSString*)text withFont:(UIFont*)font {
    CGFloat width = tableView.frame.size.width;
    if (tableView.style == UITableViewStyleGrouped) {
        if ([A4GDevice isIPad]){
            width -= 90.0;
        }
        else {
            width -= 20.0;
        }
    }
    CGSize size = [text sizeWithFont:font 
                   constrainedToSize:CGSizeMake(width, MAXFLOAT) 
                       lineBreakMode:UILineBreakModeWordWrap];
    return MAX(size.height + 25, 44.0f);
}

@end
