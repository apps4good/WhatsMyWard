//
//  WSWard.m
//  MyWard
//
//  Created by Dale Zak on 12-07-24.
//  Copyright (c) 2012 Whitespace Initiatives Inc. All rights reserved.
//

#import "WSWard.h"
#import "SBJson.h"

@interface WSWard ()

@end

@implementation WSWard

@synthesize name = _name;
@synthesize url = _url;
@synthesize color = _color;
@synthesize councillor = _councillor;
@synthesize email = _email;
@synthesize cell = _cell;
@synthesize home = _home;
@synthesize fax = _fax;
@synthesize bio = _bio;
@synthesize website = _website;
@synthesize photo = _photo;
@synthesize polygon = _polygon;

- (id) initWithDictionary:(NSDictionary *)dictionary {
    if (self = [super init]){
        self.name = [dictionary objectForKey:@"Name"];
        self.url = [dictionary objectForKey:@"URL"];
        self.councillor = [dictionary objectForKey:@"Councillor"];
        self.color = [dictionary objectForKey:@"Color"];
        self.email = [dictionary objectForKey:@"Email"];
        self.cell = [dictionary objectForKey:@"Cell"];
        self.home = [dictionary objectForKey:@"Home"];
        self.fax = [dictionary objectForKey:@"Fax"];
        self.bio = [dictionary objectForKey:@"Bio"];
        self.website = [dictionary objectForKey:@"Website"];
        self.photo = [dictionary objectForKey:@"Photo"];
    }
    return self;
}

- (void)dealloc {
    [_name release];
    [_url release];
    [_councillor release];
    [_color release];
    [_email release];
    [_cell release];
    [_home release];
    [_fax release];
    [_bio release];
    [_photo release];
    [_website release];
    [super dealloc];
}

- (void) parse:(NSString *)response {
    DLog(@"%@", response);
    NSDictionary *json = [response JSONValue];
    NSMutableArray *boundaries = [NSMutableArray array];
    for (NSArray *array1 in [json objectForKey:@"coordinates"]) {
        for (NSArray *array2 in [array1 objectAtIndex:0]) {
            for (NSArray *array3 in [array1 objectAtIndex:0]) {
                [boundaries addObject:array3];
            }
        }
    }
    NSInteger index = 0;
    CLLocationCoordinate2D coordinates[boundaries.count];
    for (NSArray *array in boundaries) {
        CLLocationDegrees latitude = [[array objectAtIndex:1] doubleValue];
        CLLocationDegrees longitude = [[array objectAtIndex:0] doubleValue];
        coordinates[index] = CLLocationCoordinate2DMake(latitude, longitude);
        index++;
    }
    self.polygon = [MKPolygon polygonWithCoordinates:coordinates count:boundaries.count];
    self.polygon.title = self.name;
    self.polygon.subtitle = self.councillor;
}

@end
