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

#import "A4GTableViewCellFactory.h"
#import "A4GCheckTableViewCell.h"
#import "A4GImageTableViewCell.h"

@interface A4GTableViewCellFactory ()

@end

@implementation A4GTableViewCellFactory

+ (A4GCheckTableViewCell*) checkTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath {
    A4GCheckTableViewCell *cell = (A4GCheckTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GCheckTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GCheckTableViewCell" owner:delegate options:nil];
        cell = (A4GCheckTableViewCell*)[objects lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = delegate;
    cell.indexPath = indexPath;
    cell.titleLabel.text = nil;
    cell.subtitleLabel.text = nil;
    return cell; 
}

+ (A4GImageTableViewCell*) imageTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath  {
    A4GImageTableViewCell *cell = (A4GImageTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GImageTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GImageTableViewCell" owner:delegate options:nil];
        cell = (A4GImageTableViewCell*)[objects lastObject];
    }
    cell.indexPath = indexPath;
    return cell;
}

+ (UITableViewCell *) defaultTableViewCell:(UITableView*)tableView {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleDefault"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCellStyleDefault"] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    return cell;
}

+ (UITableViewCell *) subtitleTableViewCell:(UITableView*)tableView  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleSubtitle"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"UITableViewCellStyleSubtitle"] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    return cell;
}

+ (UITableViewCell *) valueTableViewCell:(UITableView*)tableView  {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCellStyleValue1"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCellStyleValue1"] autorelease];
        cell.textLabel.font = [UIFont boldSystemFontOfSize:18];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    return cell;
}

@end
