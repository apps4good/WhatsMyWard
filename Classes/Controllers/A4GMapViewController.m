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

#import "A4GMapViewController.h"
#import "A4GDetailsViewController.h"
#import "A4GSettingsViewController.h"
#import "A4GLoadingButton.h"
#import "A4GSettings.h"
#import "A4GDevice.h"
#import "UIColor+A4G.h"
#import "UIAlertView+A4G.h"
#import "NSString+A4G.h"
#import "MKMapView+A4G.h"
#import "UILabel+A4G.h"
#import "SBJson.h"
#import "A4GData.h"
#import "KMLParser.h"
#import "UIViewController+A4G.h"

@interface A4GMapViewController ()

@property (strong, nonatomic) NSMutableDictionary *overlays;
@property (strong, nonatomic) NSMutableDictionary *strokeColors;
@property (strong, nonatomic) NSMutableDictionary *fillColors;

- (void) mapTapped:(UITapGestureRecognizer *)recognizer;
- (void) loadKmlFilesFromBundle;

@end

@implementation A4GMapViewController

typedef enum {
    MapViewActionNone,
    MapViewActionShowUserCallout,
    MapViewActionShowCurrentCallout
} MapViewAction;

@synthesize mapView = _mapView;
@synthesize flipView = _flipView;
@synthesize mapType = _mapType;
@synthesize infoButton = _infoButton;
@synthesize strokeColors = _strokeColors;
@synthesize fillColors = _fillColors;
@synthesize overlays = _overlays;
@synthesize refreshButton = _refreshButton;
@synthesize locateButton = _locateButton;
@synthesize settingsViewController = _settingsViewController;
@synthesize detailsViewController = _detailsViewController;

#pragma mark - Handlers

- (IBAction)locate:(id)sender event:(UIEvent*)event {
    DLog(@"");
    [self.locateButton setLoading:YES];
    if (self.mapView.userLocationVisible) {
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            if ([annotation class] == MKUserLocation.class) {
                [self.mapView removeAnnotation:annotation];
                DLog(@"Removed:%@", [annotation class]);
                break;
            }
        }   
    }
    [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
    [self.mapView setShowsUserLocation:NO];
    [self.mapView setShowsUserLocation:YES];
}

- (IBAction)settings:(id)sender event:(UIEvent*)event {
    DLog(@"");
    self.settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.settingsViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self.navigationController presentModalViewController:self.settingsViewController animated:YES];  
}

- (IBAction) mapTypeChanged:(id)sender event:(UIEvent*)event {
    DLog(@"");
	self.mapView.mapType = self.mapType.selectedSegmentIndex;
    [self animatePageCurlDown:0.5];
}

- (void)mapTypeCancelled:(id)sender event:(UIEvent*)event {
    DLog(@"");
    [self animatePageCurlDown:0.5];
}

- (IBAction) showInfo:(id)sender event:(UIEvent*)event {
    DLog(@"");
    self.mapType.selectedSegmentIndex = self.mapView.mapType;
    [self animatePageCurlUp:0.5];
}

#pragma mark - UIViewController

- (void)dealloc {
    [_mapView release];
    [_refreshButton release];
    [_locateButton release];
    [_settingsViewController release];
    [_detailsViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [A4GSettings navBarColor];
    self.title = [A4GSettings appName];
    
    self.flipView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]];
    [self.mapType setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:MKMapTypeStandard];
    [self.mapType setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:MKMapTypeSatellite];
    [self.mapType setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:MKMapTypeHybrid];
    
    self.overlays = [NSMutableDictionary dictionary];
    self.fillColors = [NSMutableDictionary dictionary];
    self.strokeColors = [NSMutableDictionary dictionary];
    
    [self.mapView addTapGestureWithTarget:self action:@selector(mapTapped:)];
    
    [self loadKmlFilesFromBundle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.mapView.showsUserLocation == NO) {
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self.mapView setShowsUserLocation:YES];   
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if ([self isTopView:self.flipView]) {
        [self animatePageCurlDown:0.0];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.mapView setShowsUserLocation:NO]; 
}

#pragma mark - MKMapViewDelegate

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {
    MKPolygonView *polygon = [[[MKPolygonView alloc] initWithOverlay:overlay] autorelease];
    polygon.lineWidth = 1;

    UIColor *fillColor = [self.fillColors objectForKey:overlay.title];
    polygon.fillColor = [fillColor colorWithAlphaComponent:0.25];

    UIColor *strokeColor = [self.strokeColors objectForKey:overlay.title];
    polygon.strokeColor = [strokeColor colorWithAlphaComponent:0.75];    

    return polygon;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView *annotationView = [mapView getPinForAnnotation:annotation];
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorGreen;
        CLLocationCoordinate2D coordinate = mapView.userLocation.coordinate;
        for (id <MKOverlay> overlay in self.mapView.overlays) {
            MKMapPoint userPoint = MKMapPointForCoordinate(coordinate);
            if (MKMapRectContainsPoint(overlay.boundingMapRect, userPoint) ) {
                annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                annotation.title = overlay.title;
                annotation.subtitle = overlay.subtitle;      
                break;
            }
        }
        return annotationView;
    }
    else if ([self.overlays objectForKey:annotation.title] != nil) {
        MKAnnotationView *annotationView = [mapView getLabelForAnnotation:annotation withText:[annotation.title stringWithNumbersOnly]];
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.canShowCallout = YES;
        return annotationView;
    }
    else {
        MKPinAnnotationView *annotationView = [mapView getPinForAnnotation:annotation];
        annotationView.canShowCallout = YES;
        annotationView.pinColor = MKPinAnnotationColorRed;
        annotationView.rightCalloutAccessoryView = nil;
        return annotationView;
    }
    return nil;
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    DLog(@"");
    [self.locateButton setLoading:YES];
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    DLog(@""); 
    [self.locateButton setLoading:NO];
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    DLog(@"%f,%f", userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude);
    MKPolygonView *polygonView = [mapView polygonViewForCoordinate:userLocation.coordinate];
    if (polygonView != nil) {
        polygonView.fillColor = [polygonView.fillColor colorWithAlphaComponent:0.70];
        polygonView.strokeColor = [polygonView.strokeColor colorWithAlphaComponent:0.90];  
        [polygonView setNeedsDisplay];
        mapView.tag = MapViewActionShowUserCallout;
    }
    [self.locateButton setLoading:NO];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error  {
    DLog(@"Error:%@", [error description]);
    if (error != nil) {
        [UIAlertView showWithTitle:NSLocalizedString(@"Locate Error", nil) 
                           message:[error description] 
                          delegate:self 
                               tag:0 
                 cancelButtonTitle:NSLocalizedString(@"OK", nil) 
                 otherButtonTitles:nil];
    }
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    if (mapView.selectedAnnotations.count == 0) {
        for (MKAnnotationView *annotationView in views) {
            if ([annotationView.annotation isKindOfClass:[MKUserLocation class]]) {
                if (mapView.tag == MapViewActionShowUserCallout) {
                    DLog(@"User:%@", annotationView.annotation.title);
                    [mapView selectAnnotation:annotationView.annotation animated:YES];
                    mapView.tag = MapViewActionNone;  
                }
            }
        }   
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    DLog(@"%@", view.annotation.title);
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view {
    if (mapView.tag == MapViewActionShowCurrentCallout) {
        [mapView selectAnnotation:view.annotation animated:NO];
        mapView.tag = MapViewActionNone;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    DLog(@"%@", view.annotation.title);
    self.detailsViewController.title = view.annotation.title;
    self.detailsViewController.data = [self.overlays objectForKey:view.annotation.title];
    self.detailsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.detailsViewController.modalPresentationStyle = UIModalPresentationPageSheet;
    [self.navigationController pushViewController:self.detailsViewController animated:YES]; 
}

#pragma mark - UITapGestureRecognizer

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)mapTapped:(UITapGestureRecognizer *)recognizer {
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        self.mapView.tag = MapViewActionNone;
        CGPoint point = [recognizer locationInView:self.mapView];
        id<MKOverlay> overlay = [self.mapView overlayForPoint:point];
        if (overlay != nil && [self.overlays objectForKey:overlay.title] != nil) {
            DLog(@"Tapped:%@", overlay.title);
            for (id <MKAnnotation> annotation in self.mapView.annotations) {
                if ([annotation.title isEqualToString:overlay.title] && 
                    self.mapView.selectedAnnotations.count == 0) {
                    self.mapView.tag = MapViewActionShowCurrentCallout;
                    [self.mapView selectAnnotation:annotation animated:YES];
                    return;
                }
            }
        }
    }
}

#pragma mark - Parse KML

- (void) loadKmlFilesFromBundle {
    for (NSString *kml in [[NSBundle mainBundle] pathsForResourcesOfType:@"kml" inDirectory:nil]) { 
        NSURL *url = [NSURL fileURLWithPath:kml];
        KMLParser *kmlParser = [[KMLParser alloc] initWithURL:url];
        [kmlParser parseKML];
        for (id <MKOverlay> overlay in [kmlParser overlays]) {
            if ([NSString isNilOrEmpty:overlay.subtitle] == NO) {
                DLog(@"%@ : %@", overlay.title, overlay.subtitle);
                A4GData *data = [[A4GData alloc] initWithJSON:overlay.subtitle];
                [self.overlays setObject:data forKey:overlay.title];
                [data release];
                overlay.subtitle = nil;
            }
            UIColor *fillColor = [kmlParser fillColorForOverlay:overlay];
            if (fillColor == nil) {
                fillColor = [UIColor randomColor];
            }
            [self.fillColors setObject:fillColor forKey:overlay.title];
            
            UIColor *strokeColor = [kmlParser strokeColorForOverlay:overlay];
            if (strokeColor == nil) {
                strokeColor = fillColor;
            }
            [self.strokeColors setObject:strokeColor forKey:overlay.title];    
            
            [self.mapView addOverlay:overlay];
            [self.mapView addAnnotation:overlay];
        }
        for (id <MKAnnotation> annotation in [kmlParser points]) {
            [self.mapView addAnnotation:annotation];
        }
        [kmlParser release];
    }
    [self.mapView showAllOverlays:YES allAnnotations:NO];
}

@end
