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

#import "A4GInputTableViewCell.h"
#import "NSString+A4G.h"

@interface A4GInputTableViewCell()

@end

@implementation A4GInputTableViewCell

@synthesize textView = _textView;
@synthesize indexPath = _indexPath;
@synthesize delegate = _delegate;
@synthesize placeholder = _placeholder;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.backgroundColor = self.backgroundColor;
}

- (void)dealloc {
    _delegate = nil;
    [_textView release];
    [_indexPath release];
    [_placeholder release];
    [super dealloc];
}

- (void) setText:(NSString *)text {
    if ([NSString isNilOrEmpty:text]) {
        self.textView.text = self.placeholder;
        self.textView.textColor = [UIColor lightGrayColor];
    }
    else {
     	self.textView.text = text;   
        self.textView.textColor = [UIColor blackColor];
    }
}

- (NSString *)text {
    return [self.textView.text isEqualToString:self.placeholder] ? nil : self.textView.text;
}

- (void) setTextAlignment:(UITextAlignment)textAlignment {
    self.textView.textAlignment = textAlignment;   
}

- (UITextAlignment) textAlignment {
    return self.textView.textAlignment;
}

- (void) setSpellCheckingType:(UITextSpellCheckingType)spellCheckingType {
    self.textView.spellCheckingType = spellCheckingType;    
}

- (UITextSpellCheckingType) spellCheckingType {
    return self.textView.spellCheckingType;
}

- (void) setReturnKeyType:(UIReturnKeyType)returnKeyType {
    self.textView.returnKeyType = returnKeyType;    
}

- (UIReturnKeyType) returnKeyType {
    return self.textView.returnKeyType;
}

- (void) setAutocapitalizationType:(UITextAutocapitalizationType)autocapitalizationType {
    self.textView.autocapitalizationType = autocapitalizationType;
}

- (UITextAutocapitalizationType) autocapitalizationType {
    return self.textView.autocapitalizationType;
}

- (void) setAutocorrectionType:(UITextAutocorrectionType)autocorrectionType {
    self.textView.autocorrectionType = autocorrectionType;
}

- (UITextAutocorrectionType) autocorrectionType {
    return self.textView.autocorrectionType;
}

- (void) setKeyboardType:(UIKeyboardType)keyboardType {
    self.textView.keyboardType = keyboardType;
}

- (UIKeyboardType) keyboardType {
    return self.textView.keyboardType;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(inputTableViewCell:index:text:)]) {
        if ([self.textView.text isEqualToString:self.placeholder] == NO) {
            [self.delegate inputTableViewCell:self index:self.indexPath text:self.textView.text];
        }
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.textView.text isEqualToString:self.placeholder]) {
        self.textView.text = nil;   
        self.textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([NSString isNilOrEmpty:self.textView.text]) {
        self.textView.text = self.placeholder;
        self.textView.textColor = [UIColor lightGrayColor];
    }
}

@end
