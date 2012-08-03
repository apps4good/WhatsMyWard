//
//  WSWard.h
//  MyWard
//
//  Created by Dale Zak on 12-07-24.
//  Copyright (c) 2012 Whitespace Initiatives Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#include <stdlib.h>

@interface WSWard : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *url;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *councillor;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSString *cell;
@property (strong, nonatomic) NSString *home;
@property (strong, nonatomic) NSString *fax;
@property (strong, nonatomic) NSString *bio;
@property (strong, nonatomic) NSString *website;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) MKPolygon *polygon;

- (id) initWithDictionary:(NSDictionary *)dictionary;
- (void) parse:(NSString *)json;

@end
