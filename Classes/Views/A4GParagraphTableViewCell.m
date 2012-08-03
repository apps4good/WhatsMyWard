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

#import "A4GParagraphTableViewCell.h"
#import "A4GDevice.h"

#define CELL_MARGIN 20.0f
#define CELL_PADDING 10.0f
#define CELL_HEIGHT 44.0f
#define CELL_WIDTH_PORTRAIT_IPHONE 300.0f
#define CELL_WIDTH_LANDSCAPE_IPHONE 460.0f
#define CELL_WIDTH_PORTRAIT_IPAD 678.0f
#define CELL_WIDTH_LANDSCAPE_IPAD 678.0f

@interface A4GParagraphTableViewCell ()

@end

@implementation A4GParagraphTableViewCell

@synthesize indexPath = _indexPath;
@synthesize textLabel;

- (void) setText:(NSString *)text {
	self.textLabel.text = text;
}

- (NSString *)text {
    return self.textLabel.text;
}

- (CGFloat) cellHeightForText:(NSString*)text {
    CGFloat width;
    if ([A4GDevice isIPad]) {
        width = [A4GDevice isPortraitMode] ? CELL_WIDTH_PORTRAIT_IPAD - CELL_MARGIN : CELL_WIDTH_LANDSCAPE_IPAD - CELL_MARGIN;
    }
    else {
        width = [A4GDevice isPortraitMode] ? CELL_WIDTH_PORTRAIT_IPHONE - CELL_MARGIN : CELL_WIDTH_LANDSCAPE_IPHONE - CELL_MARGIN;
    }    
    CGSize size = [text sizeWithFont:self.textLabel.font 
                   constrainedToSize:CGSizeMake(width, 20000.0f)
                       lineBreakMode:self.textLabel.lineBreakMode];
    CGFloat height = MAX(size.height, CELL_HEIGHT);
    DLog(@"Size:%fx%f Height:%f", size.width, size.height, height);
    return height + (CELL_PADDING * 2);
}

- (void)dealloc {
    [_indexPath release];
    [textLabel release];
    [super dealloc];
}

@end
