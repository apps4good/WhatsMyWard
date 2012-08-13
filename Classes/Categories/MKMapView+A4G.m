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

#import "MKMapView+A4G.h"
#import "NSString+A4G.h"
#import "UILabel+A4G.h"

@implementation MKMapView (A4G)

- (void) showAllOverlays:(BOOL)showOverlays allAnnotations:(BOOL)showAnnotations {
    MKMapRect visibleMapRect = MKMapRectNull;
    if (showOverlays) {
        for (id <MKOverlay> overlay in self.overlays) {
            if (MKMapRectIsNull(visibleMapRect)) {
                visibleMapRect = [overlay boundingMapRect];
            } 
            else {
                visibleMapRect = MKMapRectUnion(visibleMapRect, [overlay boundingMapRect]);
            }
        }
    }
    if (showAnnotations) {
        for (id <MKAnnotation> annotation in self.annotations) {
            if ([annotation isKindOfClass:[MKUserLocation class]] == NO) {
                MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0, 0);
                if (MKMapRectIsNull(visibleMapRect)) {
                    visibleMapRect = pointRect;
                } 
                else {
                    visibleMapRect = MKMapRectUnion(visibleMapRect, pointRect);
                }
            }
        }
    }
    self.visibleMapRect = visibleMapRect;   
}

- (id <MKOverlay>) overlayForPoint:(CGPoint)point {
    for (id<MKOverlay> overlay in self.overlays) {
        MKOverlayView *view = [self viewForOverlay:overlay];
        if (view) {
            CGRect frame = [view.superview convertRect:view.frame toView:self];
            if (CGRectContainsPoint(frame, point)) {
                return overlay;
            }
        }
    }
    return nil;
}

- (id <MKOverlay>) overlayForCoordinate:(CLLocationCoordinate2D)coordinate {
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    for (id <MKOverlay> overlay in self.overlays) {
        MKPolygonView *polygonView = (MKPolygonView *)[self viewForOverlay:overlay];
        CGPoint point = [polygonView pointForMapPoint:mapPoint];
        if (CGPathContainsPoint(polygonView.path, NULL, point, NO)) {
            return overlay;
        }
    }
    return nil;
}

- (MKPolygonView *) polygonViewForCoordinate:(CLLocationCoordinate2D)coordinate {
    MKMapPoint mapPoint = MKMapPointForCoordinate(coordinate);
    for (id <MKOverlay> overlay in self.overlays) {
        MKPolygonView *polygonView = (MKPolygonView *)[self viewForOverlay:overlay];
        CGPoint point = [polygonView pointForMapPoint:mapPoint];
        if (CGPathContainsPoint(polygonView.path, NULL, point, NO)) {
            return polygonView;
        }
    }
    return nil;
}

- (MKPinAnnotationView *) getPinForAnnotation:(id <MKAnnotation>)annotation withColor:(MKPinAnnotationColor)pinColor {
    NSString *const identifer = @"MKPinAnnotationView";
	MKPinAnnotationView *annotationView = (MKPinAnnotationView *)[self dequeueReusableAnnotationViewWithIdentifier:identifer];
	if (annotationView == nil) {
		annotationView = [[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer] autorelease];
	}
	annotationView.animatesDrop = NO;
	annotationView.canShowCallout = YES;
    annotationView.pinColor = pinColor;
    return annotationView;
}

- (MKAnnotationView *) getLabelForAnnotation:(id <MKAnnotation>)annotation withText:(NSString*)text {
    NSString *const identifer = @"MKAnnotationView";
    MKAnnotationView *annotationView = [self dequeueReusableAnnotationViewWithIdentifier:identifer];
    if (annotationView == nil) {
        annotationView = [[[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifer] autorelease];
    }
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 30)] autorelease];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor blackColor];
    label.text = text;
    label.alpha = 0.6;
    label.frame = [label frameThatFitsText];
    
    [annotationView addSubview:label];  
    annotationView.frame = label.frame;
    annotationView.canShowCallout = YES;
    
    return annotationView;
}

- (void) addTapGestureWithTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGesture.delegate = target;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    tapGesture.cancelsTouchesInView = NO;
    [self addGestureRecognizer:tapGesture];
    [tapGesture release];
}

@end
