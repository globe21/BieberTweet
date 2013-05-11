//
//  PictureDownloader.h
//  BieberTweet
//
//  Created by DX086 on 13-05-09.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tweets;
@interface PictureDownloader : NSObject

@property (nonatomic, strong) Tweets *tweet;
@property (nonatomic, copy) void (^completionHandler)(void);

- (void)startDownload;
- (void)cancelDownload;

@end
