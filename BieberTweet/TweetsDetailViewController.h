//
//  TweetsDetailViewController.h
//  BieberTweet
//
//  Created by Jordan Bangia on 5/8/13.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TweetsDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
