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

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "A4GViewController.h"

@class A4GDetailsViewController;
@class A4GLayersViewController;
@class A4GSettingsViewController;
@class A4GLoadingButton;

@interface A4GMapViewController : A4GViewController<MKMapViewDelegate,
                                                    UISplitViewControllerDelegate,
                                                    UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIButton *titleView;
@property (strong, nonatomic) IBOutlet UIButton *flipView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *mapType;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) IBOutlet A4GLoadingButton *refreshButton;
@property (strong, nonatomic) IBOutlet A4GLoadingButton *locateButton;
@property (strong, nonatomic) IBOutlet A4GSettingsViewController *settingsViewController;
@property (strong, nonatomic) IBOutlet A4GDetailsViewController *detailsViewController;
@property (strong, nonatomic) IBOutlet A4GLayersViewController *layersViewController;

- (void) addKML:(NSString*)kml;
- (void) removeKML:(NSString*)kml;

- (IBAction) settings:(id)sender event:(UIEvent*)event;
- (IBAction) locate:(id)sender event:(UIEvent*)event;
- (IBAction) layers:(id)sender event:(UIEvent*)event;
- (IBAction) showInfo:(id)sender event:(UIEvent*)event;
- (IBAction) mapTypeChanged:(id)sender event:(UIEvent*)event;
- (IBAction) mapTypeCancelled:(id)sender event:(UIEvent*)event;

@end
