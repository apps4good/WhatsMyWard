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
#import "A4GTableViewCellFactory.h"
#import "A4GSwitchTableViewCell.h"
#import "A4GOptionTableViewCell.h"
#import "A4GButtonTableViewCell.h"
#import "A4GImageTableViewCell.h"
#import "A4GParagraphTableViewCell.h"
#import "A4GInputTableViewCell.h"

@interface A4GTableViewCellFactory ()

@end

@implementation A4GTableViewCellFactory

+ (A4GSwitchTableViewCell*) switchTableViewCell:(UITableView*)tableView delegate:(id<A4GSwitchTableViewCellDelegate>)delegate index:(NSIndexPath*)indexPath  {
    A4GSwitchTableViewCell *cell = (A4GSwitchTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GSwitchTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GSwitchTableViewCell" owner:delegate options:nil];
        cell = (A4GSwitchTableViewCell*)[objects lastObject];
    }
    cell.delegate = delegate;
    cell.indexPath = indexPath;
    cell.title = nil;
    cell.details = nil;
    return cell;
}

+ (A4GOptionTableViewCell*) optionTableViewCell:(UITableView*)tableView delegate:(id<A4GOptionTableViewCellDelegate>)delegate index:(NSIndexPath*)indexPath {
    A4GOptionTableViewCell *cell = (A4GOptionTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GOptionTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GOptionTableViewCell" owner:delegate options:nil];
        cell = (A4GOptionTableViewCell*)[objects lastObject];
    }
    cell.delegate = delegate;
    cell.indexPath = indexPath;
    cell.textLabel.text = nil;
    cell.detailTextLabel.text = nil;
    return cell;
}

+ (A4GButtonTableViewCell*) buttonTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath  {
    A4GButtonTableViewCell *cell = (A4GButtonTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GButtonTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GButtonTableViewCell" owner:delegate options:nil];
        cell = (A4GButtonTableViewCell*)[objects lastObject];
    }
    cell.indexPath = indexPath;
    cell.title = nil;
    cell.details = nil;
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

+ (A4GParagraphTableViewCell*) paragraphTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath  {
    A4GParagraphTableViewCell *cell = (A4GParagraphTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GParagraphTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GParagraphTableViewCell" owner:delegate options:nil];
        cell = (A4GParagraphTableViewCell*)[objects lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    cell.text = nil;
    return cell;
}

+ (A4GInputTableViewCell*) inputTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath {
    A4GInputTableViewCell *cell = (A4GInputTableViewCell*)[tableView dequeueReusableCellWithIdentifier:@"A4GInputTableViewCell"];
    if (cell == nil) {
        NSArray *objects = [[NSBundle mainBundle] loadNibNamed:@"A4GInputTableViewCell" owner:delegate options:nil];
        cell = (A4GInputTableViewCell*)[objects lastObject];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.delegate = delegate;
    cell.indexPath = indexPath;
    cell.text = nil;
    cell.placeholder = nil;
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
