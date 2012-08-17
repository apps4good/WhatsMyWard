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
#import "A4GLayersViewController.h"
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
#import "UIColor+A4G.h"
#import "MKPolygon+A4G.h"
#import "UIBarButtonItem+A4G.h"

@interface A4GMapViewController ()

@property (strong, nonatomic) NSMutableDictionary *overlays;
@property (strong, nonatomic) NSMutableDictionary *annotations;

- (void) mapTapped:(UITapGestureRecognizer *)recognizer;

@end

@implementation A4GMapViewController

typedef enum {
    MapViewActionNone,
    MapViewActionShowLocation,
    MapViewActionShowCallout
} MapViewAction;

@synthesize mapView = _mapView;
@synthesize flipView = _flipView;
@synthesize titleView = _titleView;
@synthesize mapType = _mapType;
@synthesize overlays = _overlays;
@synthesize annotations = _annotations;
@synthesize infoButton = _infoButton;
@synthesize refreshButton = _refreshButton;
@synthesize locateButton = _locateButton;
@synthesize settingsViewController = _settingsViewController;
@synthesize layersViewController = _layersViewController;
@synthesize detailsViewController = _detailsViewController;

#pragma mark - Handlers

- (void) addKML:(NSString*)kml {
    //DLog(@"%@", kml);
    NSURL *url = [NSURL fileURLWithPath:kml];
    KMLParser *kmlParser = [[KMLParser alloc] initWithURL:url];
    [kmlParser parseKML];
    NSMutableArray *overlays = [NSMutableArray array];
    NSMutableArray *annotations = [NSMutableArray array];
    for (id <MKOverlay> overlay in [kmlParser overlays]) {
        //DLog(@"%@ %@", [overlay class], overlay.title);
        if ([overlay isKindOfClass:[MKPolygon class]]) {
            MKPolygon *polygon = (MKPolygon*)overlay;
            //TODO check is subtitle is JSON
            if ([NSString isNilOrEmpty:overlay.subtitle] == NO) {
                A4GData *data = [[A4GData alloc] initWithJSON:overlay.subtitle];
                [polygon setData:data];
                [data release];
                overlay.subtitle = nil;
                [self.mapView addAnnotation:polygon];
                [annotations addObject:polygon];
            }
            [polygon setFillColor:[kmlParser fillColorForOverlay:overlay]];
            [polygon setStrokeColor:[kmlParser strokeColorForOverlay:overlay]];
        }
        [self.mapView addOverlay:overlay];
        [overlays addObject:overlay];
    }
    [self.overlays setObject:overlays forKey:kml];
    for (id <MKAnnotation> annotation in [kmlParser points]) {
        [self.mapView addAnnotation:annotation];
        [annotations addObject:annotation];
    }
    [self.annotations setObject:annotations forKey:kml];
    [kmlParser release];
    [self.mapView showAllOverlays:YES allAnnotations:YES];
}

- (void) removeKML:(NSString*)kml {
    //DLog(@"%@", kml);
    for (id <MKOverlay> overlay in [self.overlays objectForKey:kml]) {
        [self.mapView removeOverlay:overlay];
    }
    [self.overlays removeObjectForKey:kml];
    for (id <MKAnnotation> annotation  in [self.annotations objectForKey:kml]) {
        [self.mapView removeAnnotation:annotation];
    }
    [self.annotations removeObjectForKey:kml];
    [self.mapView showAllOverlays:YES allAnnotations:YES];
}

- (IBAction)settings:(id)sender event:(UIEvent*)event {
    DLog(@"");
    self.settingsViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.settingsViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController:self.settingsViewController animated:YES];  
}

- (IBAction)locate:(id)sender event:(UIEvent*)event {
    DLog(@"");
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

- (IBAction)layers:(id)sender event:(UIEvent*)event {
    DLog(@"");
    self.layersViewController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    self.layersViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self.navigationController presentModalViewController:self.layersViewController animated:YES];  
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

- (IBAction) showMapType:(id)sender event:(UIEvent*)event {
    DLog(@"");
    self.mapType.selectedSegmentIndex = self.mapView.mapType;
    [self animatePageCurlUp:0.5];
}

#pragma mark - UIViewController

- (void)dealloc {
    [_mapView release];
    [_titleView release];
    [_refreshButton release];
    [_locateButton release];
    [_overlays release];
    [_annotations release];
    [_detailsViewController release];
    [_settingsViewController release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.titleView setTitle:[A4GSettings appName] forState:UIControlStateNormal];
    [self.titleView setTitle:[A4GSettings appName] forState:UIControlStateSelected];
    [self.flipView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"pattern.png"]]];
    
    [self.mapType setTitle:NSLocalizedString(@"Standard", nil) forSegmentAtIndex:MKMapTypeStandard];
    [self.mapType setTitle:NSLocalizedString(@"Satellite", nil) forSegmentAtIndex:MKMapTypeSatellite];
    [self.mapType setTitle:NSLocalizedString(@"Hybrid", nil) forSegmentAtIndex:MKMapTypeHybrid];
    [self.mapView addTapGestureWithTarget:self action:@selector(mapTapped:)];
    [self.mapView showAllOverlays:YES allAnnotations:YES];
    
    self.overlays = [NSMutableDictionary dictionary];
    self.annotations = [NSMutableDictionary dictionary];
    for (NSString *kml in [A4GSettings kmlFiles]) {
        [self addKML:kml];
    }
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
    if ([overlay isKindOfClass:[MKPolygon class]]) {
        MKPolygon *polygon = (MKPolygon *)overlay;
        return [polygon overlayViewForMap:mapView];
    }
    //TODO show other overlay types
    return nil;
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[MKPolygon class]]) {
        MKAnnotationView *annotationView = [mapView getLabelForAnnotation:annotation withText:[annotation.title stringWithNumbersOnly]];
        annotationView.canShowCallout = YES;
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return annotationView;
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]]) {
        MKPinAnnotationView *annotationView = [mapView getPinForAnnotation:annotation withColor:MKPinAnnotationColorGreen];
        annotationView.canShowCallout = NO;
        CLLocationCoordinate2D coordinate = mapView.userLocation.coordinate;
        for (id <MKOverlay> overlay in self.mapView.overlays) {
            MKMapPoint userPoint = MKMapPointForCoordinate(coordinate);
            if (MKMapRectContainsPoint(overlay.boundingMapRect, userPoint) ) {
                annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
                annotation.title = overlay.title;
                annotation.subtitle = overlay.subtitle;  
                annotationView.canShowCallout = YES;
                break;
            }
        }
        return annotationView;
    }
    else {
        MKPinAnnotationView *annotationView = [mapView getPinForAnnotation:annotation withColor:MKPinAnnotationColorRed];
        annotationView.canShowCallout = YES;
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
    if (polygonView != nil && [polygonView isKindOfClass:[MKPolygonView class]]) {
        polygonView.fillColor = [polygonView.fillColor colorWithAlphaComponent:0.75];
        polygonView.strokeColor = [polygonView.strokeColor colorWithAlphaComponent:0.90];  
        [polygonView setNeedsDisplay];
        mapView.tag = MapViewActionShowLocation;
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
                if (mapView.tag == MapViewActionShowLocation) {
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
    if (mapView.tag == MapViewActionShowCallout) {
        [mapView selectAnnotation:view.annotation animated:NO];
        mapView.tag = MapViewActionNone;
    }
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    DLog(@"%@ %@", [view class], view.annotation.title);
    self.detailsViewController.title = view.annotation.title;
    id <MKAnnotation> annotation = view.annotation;
    if ([annotation respondsToSelector:@selector(data)]) {
        self.detailsViewController.data = [annotation performSelector:@selector(data)];
    }
    else if ([annotation isKindOfClass:[MKUserLocation class]]) {
        for (id <MKOverlay> overlay in mapView.overlays) {
            if ([overlay.title isEqualToString:annotation.title]) {
                if ([overlay respondsToSelector:@selector(data)]) {
                    A4GData *data = [overlay performSelector:@selector(data)];
                    if (data != nil) {
                        DLog(@"%@ %@", [overlay class], overlay.title);
                        self.detailsViewController.data = data;
                        break;    
                    }
                }
            }
        }      
    }
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
        DLog(@"Tapped:%@", overlay.title);
        for (id <MKAnnotation> annotation in self.mapView.annotations) {
            if ([annotation.title isEqualToString:overlay.title] && 
                self.mapView.selectedAnnotations.count == 0) {
                self.mapView.tag = MapViewActionShowCallout;
                [self.mapView selectAnnotation:annotation animated:YES];
                return;
            }
        }        
    }
}

#pragma mark - UISplitViewController

- (void)splitViewController:(UISplitViewController *)splitController 
     willHideViewController:(UIViewController *)viewController 
          withBarButtonItem:(UIBarButtonItem *)barButtonItem 
       forPopoverController:(UIPopoverController *)popoverController {
    barButtonItem.image = [UIImage imageNamed:@"layers.png"];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}

- (void)splitViewController:(UISplitViewController *)splitController 
     willShowViewController:(UIViewController *)viewController 
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem borderedItemWithImage:[UIImage imageNamed:@"hide.png"] 
                                                                            target:[[UIApplication sharedApplication] delegate] 
                                                                            action:@selector(sidebar:event:)];
 }

- (BOOL)splitViewController: (UISplitViewController*)splitController 
   shouldHideViewController:(UIViewController *)viewController 
              inOrientation:(UIInterfaceOrientation)orientation {
    if (orientation == UIInterfaceOrientationLandscapeLeft) {
        return NO;
    }
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        return NO;
    }
    if (orientation == UIInterfaceOrientationPortrait) {
        return YES;
    }
    if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}

@end
