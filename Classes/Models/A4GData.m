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

#import "A4GData.h"
#import "SBJson.h"

@interface A4GData ()

@property (strong, nonatomic) NSString *json;
@property (strong, nonatomic) NSMutableArray *keys;
@property (strong, nonatomic) NSMutableArray *values;
@property (strong, nonatomic) NSDictionary *dictionary; 
@end

@implementation A4GData

@synthesize json = _json;
@synthesize keys = _keys;
@synthesize values = _values;
@synthesize dictionary = _dictionary;

- (id)initWithJSON:(NSString *)json {
	if (self = [super init]) {
        self.json = json;
        self.keys = [NSMutableArray arrayWithCapacity:0];
        self.values = [NSMutableArray arrayWithCapacity:0];
        self.dictionary = [json JSONValue];
        if (self.dictionary != nil) {
            [self.keys addObjectsFromArray:[[self.dictionary allKeys] sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
                NSInteger first = [self.json rangeOfString:a].location;
                NSInteger second = [self.json rangeOfString:b].location;
                return first > second;
            }]];
            for (NSString *key in self.keys) {
                [self.values addObject:[self.dictionary objectForKey:key]];
            }
        }
        else {
            [self.keys addObject:@""];
            [self.values addObject:json];
        }
    }
    return self;
}

- (NSInteger)count {
    return self.keys.count;
}

- (NSArray *)allKeys {
    return self.keys;
}

- (NSString *)keyAtIndex:(NSInteger)index {
    return self.keys.count > index ? [self.keys objectAtIndex:index] : nil;
}

- (NSString *)valueAtIndex:(NSInteger)index {    
    return self.values.count > index ? [self.values objectAtIndex:index] : nil;
}

- (NSString *)valueForKey:(NSString*)key {
    return [self.dictionary objectForKey:key];
}

- (void)dealloc {
    [_json release];
    [_keys release];
    [_values release];
    [_dictionary release];
    [super dealloc];
}


@end
