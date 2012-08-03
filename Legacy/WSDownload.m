//
//  WSDownload.m
//  MyWard
//
//  Created by Dale Zak on 12-07-24.
//  Copyright (c) 2012 Whitespace Initiatives Inc. All rights reserved.
//

#import "WSDownload.h"

@interface WSDownload ()

@property (nonatomic, strong) NSObject *object;
@property (nonatomic, strong) NSMutableData *response;
@property (nonatomic, strong) NSURLConnection *connection;

@end

@implementation WSDownload

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize delegate = _delegate;
@synthesize url = _url;
@synthesize object = _object;
@synthesize connection = _connection;
@synthesize response = _response;

- (id) initWithDelegate:(NSObject<WSDownloadDelegate>*)delegate url:(NSString *)url object:(NSObject*)object {
    if ([super init]) {
        self.delegate = delegate;
        self.url = url;
        self.object = object;
    }
    return self;
}

- (void)dealloc {
    DLog(@"%@", self.url);
    [_delegate release];
    [_url release];
    [_object release];
    [_connection release];
    [_response release];
    [super dealloc];
}

- (void) downloaded:(NSString*)response {
    DLog(@"%@ %@", self.url, response);
}

- (void)start {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    DLog(@"%@", self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSURL *url = [NSURL URLWithString:self.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void) finish {
    DLog(@"%@", self.url);
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];   
} 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    DLog(@"%@", self.url);
    self.response = [NSMutableData data];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(downloading:object:)]) {
        [self.delegate downloading:self object:self.object];
    } 
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {       
    [self.response appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {   
    DLog(@"Error %@:%@", self.url, [error description]);
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(downloaded:object:error:)]) {
        [self.delegate downloaded:self object:self.object error:error];
    } 
    [self finish];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    DLog(@"%@", self.url);
    NSString *string = [[NSString alloc] initWithData:self.response encoding:NSUTF8StringEncoding];
    if ([self.object respondsToSelector:@selector(parse:)]) {
        [self.object performSelector:@selector(parse:) withObject:string];
    }
    [string release];
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(downloaded:object:error:)]) {
        [self.delegate downloaded:self object:self.object error:nil];
    } 
    [self finish];
}

@end

