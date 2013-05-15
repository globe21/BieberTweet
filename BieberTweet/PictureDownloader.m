//
//  PictureDownloader.m
//  BieberTweet
//
//  Created by DX086 on 13-05-09.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import "PictureDownloader.h"
#import "Tweets.h"

#define Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)

@interface PictureDownloader()
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;

@end

@implementation PictureDownloader

#pragma mark
- (void) startDownload{
    //need to do this in a background thread
    self.activeDownload = [NSMutableData data];
    
    
    dispatch_async(Queue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.tweet.url]];
        [self performSelectorOnMainThread:@selector(didFinishLoading:) withObject:data waitUntilDone:YES];
        
    });
}

- (void)cancelDownload{
    [self.imageConnection cancel];
    self.imageConnection = nil;
}


#pragma mark - NSURLConnectionDelegate
- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData *)data{
    [self.activeDownload appendData:data];
}

-(void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error{
    self.activeDownload = nil;
    self.imageConnection = nil;
}

-(void) didFinishLoading:(NSData*)responseData{
    UIImage *image = [[UIImage alloc] initWithData:responseData];
    self.tweet.pic = image;
    self.activeDownload = nil;
    self.imageConnection = nil;
    if (self.completionHandler)
        self.completionHandler();
}

@end
