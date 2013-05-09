//
//  Tweets.m
//  BieberTweet
//
//  Created by Jordan Bangia on 5/8/13.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import "Tweets.h"

@implementation Tweets

-(id)initWithUsername:(NSString *)username handle:(NSString *)handle caption:(NSString *)caption url:(NSString *)url date:(NSString *)date{
    self = [super init];
    if (self){
        _username = username;
        _handle = handle;
        _caption = caption;
        _url = url;
        _date = date;
        _pic = nil;
        return self;
    }
    return nil;
}

@end
