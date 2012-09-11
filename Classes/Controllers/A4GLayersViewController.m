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

#import "A4GLayersViewController.h"
#import "A4GCheckTableViewCell.h"
#import "A4GTableViewCellFactory.h"
#import "A4GMapViewController.h"
#import "A4GSettings.h"
#import "NSString+A4G.h"
#import "KMLParser.h"
#import "A4GLayer.h"

@interface A4GLayersViewController ()

@property (strong, nonatomic) NSMutableArray *layers;

@end

@implementation A4GLayersViewController

@synthesize mapViewController = _mapViewController;
@synthesize layers = _layers;

#pragma mark - UIViewController

- (void)dealloc {
    [_layers release];
    [_mapViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.topItem.title = NSLocalizedString(@"Layers", nil);
    NSArray *kmlFiles = [A4GSettings kmlFiles];
    self.layers = [NSMutableArray arrayWithCapacity:kmlFiles.count];
    for (NSString *kml in kmlFiles) {
        DLog(@"KML:%@", kml);
        NSURL *url = [NSURL fileURLWithPath:kml];
        KMLParser *kmlParser = [[KMLParser alloc] initWithURL:url];
        [kmlParser parseKML];
        A4GLayer *layer = [[A4GLayer alloc] initWithURL:kml];
        layer.title = kmlParser.title;
        layer.overlays = kmlParser.overlays.count;
        layer.points = kmlParser.points.count;
        layer.selected = YES;
        [self.layers addObject:layer];
        [layer release];
        [kmlParser release];
    }
}

#pragma mark - UITableViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.layers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    A4GCheckTableViewCell *cell = [A4GTableViewCellFactory checkTableViewCell:tableView delegate:self index:indexPath];
    A4GLayer *layer = [self.layers objectAtIndex:indexPath.row];
    if (layer.title != nil) {
        cell.titleLabel.text = layer.title;    
    }
    else {
        cell.titleLabel.text = [[layer.url lastPathComponent] makePretty];
    }
    NSMutableString *description = [NSMutableString string];
    if (layer.overlays == 1) {
        [description appendFormat:@"1 %@", NSLocalizedString(@"layer", nil)];
    }
    else if (layer.overlays > 1) {
        [description appendFormat:@"%d %@", layer.overlays, NSLocalizedString(@"layers", nil)];
    }
    if (layer.points == 1) {
        if (description.length > 0) {
            [description appendString:@", "];
        }
        [description appendFormat:@"1 %@", NSLocalizedString(@"point", nil)];
    }
    else if (layer.points > 1) {
        if (description.length > 0) {
            [description appendString:@", "];
        }
        [description appendFormat:@"%d %@", layer.points, NSLocalizedString(@"points", nil)];
    }
    cell.subtitleLabel.text = description;
    cell.checked = layer.selected;
    return cell;
}

#pragma mark - A4GCheckTableViewCell

- (void) checkTableViewCellChanged:(A4GCheckTableViewCell *)cell index:(NSIndexPath *)indexPath checked:(BOOL)checked {
    A4GLayer *layer = [self.layers objectAtIndex:indexPath.row];
    if (checked) {
        DLog(@"Add: %@", layer.title);
        [self.mapViewController addKML:layer.url];
        layer.selected = YES;
    }
    else {
        DLog(@"Remove: %@", layer.title);
        [self.mapViewController removeKML:layer.url];
        layer.selected = NO;
    }
}

@end
