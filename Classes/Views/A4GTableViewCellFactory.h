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

@class A4GSwitchTableViewCell;
@class A4GOptionTableViewCell;
@class A4GImageTableViewCell;
@class A4GButtonTableViewCell;
@class A4GParagraphTableViewCell;
@class A4GInputTableViewCell;
@class A4GCheckTableViewCell;

@protocol A4GSwitchTableViewCellDelegate;
@protocol A4GOptionTableViewCellDelegate;
@protocol A4GKioskTableViewCellDelegate;
@protocol A4GInputTableViewCellDelegate;
@protocol A4GCheckTableViewCellDelegate;

@interface A4GTableViewCellFactory : NSObject

+ (UITableViewCell *) defaultTableViewCell:(UITableView*)tableView;

+ (UITableViewCell *) subtitleTableViewCell:(UITableView*)tableView;

+ (UITableViewCell *) valueTableViewCell:(UITableView*)tableView;

+ (A4GSwitchTableViewCell*) switchTableViewCell:(UITableView*)tableView delegate:(id<A4GSwitchTableViewCellDelegate>)delegate index:(NSIndexPath*)indexPath;

+ (A4GOptionTableViewCell*) optionTableViewCell:(UITableView*)tableView delegate:(id<A4GOptionTableViewCellDelegate>)delegate index:(NSIndexPath*)indexPath;

+ (A4GButtonTableViewCell*) buttonTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath;

+ (A4GImageTableViewCell*) imageTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath;

+ (A4GParagraphTableViewCell*) paragraphTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath;

+ (A4GInputTableViewCell*) inputTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath;

+ (A4GCheckTableViewCell*) checkTableViewCell:(UITableView*)tableView delegate:(id)delegate index:(NSIndexPath*)indexPath;

@end
