//
//  TweetController.h
//  BieberTweet
//
//  Created by Jordan Bangia on 5/8/13.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Tweets;

@interface TweetController : NSObject
@property (nonatomic, copy) NSMutableArray* masterTweetList;

-(NSUInteger) countofList;
-(Tweets*) objectInListAtIndex:(NSUInteger) index;
-(void) addTweetwithTweet:(Tweets*)tweet;

@end
