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

#import "A4GOptionTableViewCell.h"

@implementation A4GOptionTableViewCell

@synthesize indexPath = _indexPath;
@synthesize segmentControl = _segmentControl;
@synthesize delegate = _delegate;
@synthesize options = _options;

- (void)setOption:(NSInteger)index {
	self.segmentControl.selectedSegmentIndex = index;
}

- (NSInteger)option {
    return self.segmentControl.selectedSegmentIndex;
}

- (void)setOptions:(NSArray *)titles {
    [self.segmentControl removeAllSegments];
    for (NSInteger i=0; i<titles.count; i++) {
        [self.segmentControl insertSegmentWithTitle:[titles objectAtIndex:i] atIndex:i animated:NO];
    }
}

- (NSArray *)options {
    NSMutableArray *titles = [NSMutableArray arrayWithCapacity:self.segmentControl.numberOfSegments];
    for (NSUInteger i=0; i<self.segmentControl.numberOfSegments; i++) {
        [titles addObject:[self.segmentControl titleForSegmentAtIndex:i]];
    }
    return titles;
}

- (IBAction) changed:(id)sender {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(optionTableViewCell:index:option:)]) {
        [self.delegate optionTableViewCell:self index:self.indexPath option:self.segmentControl.selectedSegmentIndex];
	}
}

- (void)dealloc {
    _delegate = nil;
    [_indexPath release];
    [_segmentControl release];
    [super dealloc];
}

@end
