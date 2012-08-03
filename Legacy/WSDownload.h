//
//  WSDownload.h
//  MyWard
//
//  Created by Dale Zak on 12-07-24.
//  Copyright (c) 2012 Whitespace Initiatives Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WSDownloadDelegate;

@interface WSDownload : NSOperation<NSURLConnectionDelegate>

@property (nonatomic, retain) NSObject<WSDownloadDelegate> *delegate;
@property (nonatomic, strong) NSString *url;

@property (readonly) BOOL isExecuting;
@property (readonly) BOOL isFinished;

- (id) initWithDelegate:(NSObject<WSDownloadDelegate>*)delegate url:(NSString *)url object:(NSObject*)object;

@end


@protocol WSDownloadDelegate <NSObject>

@optional

- (void) downloading:(WSDownload*)download object:(NSObject*)object;
- (void) downloaded:(WSDownload*)download object:(NSObject*)object error:(NSError*)error;

@end
