//
//  Tweets.h
//  BieberTweet
//
//  Created by Jordan Bangia on 5/8/13.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweets : NSObject
@property (nonatomic, copy) NSString* username;
@property (nonatomic, copy) NSString* handle;
@property (nonatomic, copy) NSString* caption;
@property (nonatomic, copy) NSString* url;
@property (nonatomic, copy) UIImage* pic;
@property (nonatomic, copy) NSString* date;
@property (nonatomic, copy) NSString* dateFull;

- (id)initWithUsername:(NSString*)username  handle:(NSString*)handle caption:(NSString*) caption url:(NSString*)url date:(NSString*) date;

@end
