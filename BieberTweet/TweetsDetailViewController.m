//
//  TweetsDetailViewController.m
//  BieberTweet
//
//  Created by Jordan Bangia on 5/8/13.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import "TweetsDetailViewController.h"
#import "Tweets.h"
@interface TweetsDetailViewController ()
- (void)configureView;
@end

@implementation TweetsDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(Tweets*) newTweet
{
    if (_tweet != newTweet) {
        _tweet = newTweet;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.tweet) {
        self.usernameLabel.text = self.tweet.username;
        self.handleLabel.text = [NSString stringWithFormat:@"@%@", self.tweet.handle];
        self.dateLabel.text = self.tweet.dateFull;
        self.captionLabel.text = self.tweet.caption;
        
        CGSize itemSize = CGSizeMake(96,96);
        UIGraphicsBeginImageContext(itemSize);
        CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
        [self.tweet.pic drawInRect:imageRect];
        self.imagePic.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.title = [NSString stringWithFormat:@"@%@", self.tweet.handle];
        //self.imagePic.image = self.tweet.pic;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
