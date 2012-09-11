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

#import "A4GInternet.h"
#import "UIAlertView+A4G.h"

@interface A4GInternet ()

- (void) reachabilityChanged:(NSNotification *)notification;
- (void) reachabilityChanged:(NSNotification *)notification;
@end

@implementation A4GInternet

@synthesize network = _network;
@synthesize wifi = _wifi;
@synthesize delegate = _delegate;

- (id) initWithDelegate:(id<A4GInternetDelegate>)delegate {
    if (self = [super init]){
        self.delegate = delegate;
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(reachabilityChanged:) 
                                                     name:kReachabilityChangedNotification 
                                                   object:nil];
        self.network = [Reachability reachabilityForInternetConnection];
        self.wifi = [Reachability reachabilityForLocalWiFi];
    }
    return self;
}

- (void)dealloc {
    _delegate = nil;
    [_network release];
    [_wifi release];
    [super dealloc];
}


- (void)listen {
    DLog(@"");
    [self.wifi startNotifier];
    [self.network startNotifier];
}

- (void)stop {
    [self.wifi stopNotifier];
    [self.network stopNotifier];
}

- (BOOL) hasNetwork {
    NetworkStatus status = [self.network currentReachabilityStatus];
    if (status == NotReachable) {
        DLog(@"NotReachable");
    }
    else if (status == ReachableViaWWAN) {
        DLog(@"ReachableViaWWAN");
    }
    else if (status == ReachableViaWiFi) {
        DLog(@"ReachableViaWiFi");
    }
    return status != NotReachable;
}

- (BOOL) hasWiFi {
    NetworkStatus status = [self.wifi currentReachabilityStatus];
    if (status == NotReachable) {
        DLog(@"NotReachable");
    }
    else if (status == ReachableViaWWAN) {
        DLog(@"ReachableViaWWAN");
    }
    else if (status == ReachableViaWiFi) {
        DLog(@"ReachableViaWiFi");
    }
    return status == ReachableViaWiFi;
}

- (void)alertNetworkNotAvailable:(id<UIAlertViewDelegate>)delegate {
    [UIAlertView showWithTitle:NSLocalizedString(@"No Internet Connection", nil) 
                       message:NSLocalizedString(@"Please verify your internet connection and try again.", nil) 
                      delegate:delegate 
                           tag:0
             cancelButtonTitle:NSLocalizedString(@"OK", nil) 
             otherButtonTitles:nil];
}

- (void)alertWifFiNotAvailable:(id<UIAlertViewDelegate>)delegate {
    [UIAlertView showWithTitle:NSLocalizedString(@"No Wi-Fi Connection", nil) 
                       message:NSLocalizedString(@"Please verify your internet connection and try again.", nil) 
                      delegate:delegate 
                           tag:0
             cancelButtonTitle:NSLocalizedString(@"OK", nil) 
             otherButtonTitles:NSLocalizedString(@"Settings", nil), nil];
}

- (BOOL) isSettings:(NSString*)button {
    return [NSLocalizedString(@"Settings", nil) isEqualToString:button];
}

- (void) reachabilityChanged:(NSNotification *)notification {
    Reachability *reachability = [notification object];
    NetworkStatus status = [reachability currentReachabilityStatus];
    if (reachability == self.network) {
        if (status == ReachableViaWiFi) {
            DLog(@"Network: ReachableViaWiFi");
        }
        else if (status == ReachableViaWWAN) {
            DLog(@"Network: ReachableViaWWAN");
        }
        else if (status == NotReachable) {
            DLog(@"Network: NotReachable");
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(networkChanged:connected:)]) {
            [self.delegate networkChanged:self connected:(status == ReachableViaWWAN)]; 
        }
    }
    else if (reachability == self.wifi) {
        if (status == ReachableViaWiFi) {
            DLog(@"WiFi: ReachableViaWiFi");
        }
        else if (status == ReachableViaWWAN) {
            DLog(@"WiFi: ReachableViaWWAN");
        }
        else if (status == NotReachable) {
            DLog(@"WiFi: NotReachable");
        }
        if (self.delegate != nil && [self.delegate respondsToSelector:@selector(wifiChanged:connected:)]) {
            [self.delegate wifiChanged:self connected:(status == ReachableViaWiFi)];    
        }
    }
}

@end
