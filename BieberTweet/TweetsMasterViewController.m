//
//  TweetsMasterViewController.m
//  BieberTweet
//
//  Created by Jordan Bangia on 5/8/13.
//  Copyright (c) 2013 Jordan Bangia. All rights reserved.
//

#import "TweetsMasterViewController.h"
#import "TweetsDetailViewController.h"
#import "Tweets.h"
#import "TweetController.h"
#import "PictureDownloader.h"



@interface TweetsMasterViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableDictionary *imageDownloadsInProgress;
@end


#define Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)

#define searchurl [NSURL URLWithString:@"http://search.twitter.com/search.json?q=%23bieber&result_type=recent"]


@implementation TweetsMasterViewController
#pragma mark
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tweetController = [[TweetController alloc] init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title= @"#Bieber";
    
    dispatch_async(Queue, ^{
        NSData* data = [NSData dataWithContentsOfURL:searchurl];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
    });
    
    //self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)];
    self.navigationItem.rightBarButtonItem = refreshButton;
}

-(void) fetchedData:(NSData*)responseData{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* returnedTweets = [json objectForKey:@"results"];
    self.refreshURL = [json objectForKey:@"refresh_url"];
    for (int i = returnedTweets.count-1; i >= 0; i--) {
        NSDictionary* curr_json = [returnedTweets objectAtIndex:i];
        Tweets* tweet = [[Tweets alloc] initWithUsername:[curr_json objectForKey:@"from_user_name"] handle:[curr_json objectForKey:@"from_user"] caption:[curr_json objectForKey:@"text"] url:[curr_json objectForKey:@"profile_image_url"] date:[curr_json objectForKey:@"created_at"]];
        NSLog(tweet.dateFull);
        //NSLog((tweet.date));
        [self.tweetController addTweetwithTweet:tweet];
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSArray* allDownloads = [self.imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
    [self.imageDownloadsInProgress removeAllObjects];
}

-(void) refresh:(id)sender{
    dispatch_async(Queue, ^{
        NSData* data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://search.twitter.com/search.json%@", self.refreshURL]]];
        [self performSelectorOnMainThread:@selector(fetchedRefresh:) withObject:data waitUntilDone:YES];
        
    });
}

-(void) fetchedRefresh:(NSData*)responseData{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* returnedTweets = [json objectForKey:@"results"];
    self.refreshURL = [json objectForKey:@"refresh_url"];
    NSLog([NSString stringWithFormat:@"table pre count %d", [self.tweetController countofList]]);
    NSLog([NSString stringWithFormat:@"refresh count %d", [returnedTweets count]]);
    if ([returnedTweets count] !=0){
        for (int j = returnedTweets.count-1; j >=0; j--){
            NSDictionary* curr_json = [returnedTweets objectAtIndex:j];
            Tweets* tweet = [[Tweets alloc] initWithUsername:[curr_json objectForKey:@"from_user_name"] handle:[curr_json objectForKey:@"from_user"] caption:[curr_json objectForKey:@"text"] url:[curr_json objectForKey:@"profile_image_url"] date:[curr_json objectForKey:@"created_at"]];
            [self.tweetController addTweetwithTweet:tweet];
        }
//        for (int j = 0; j< [self.tweetController countofList]; j++){
//            [self.tweetController addTweetwithTweet:[self.tweetController objectInListAtIndex:j]];
//        }
        if ([self.tweetController countofList] >200){
            for (int i = 0; i < ([self.tweetController countofList]-25); i++){
                [self.tweetController removeTweetfromEnd];
            }
        }
        [self.tableView reloadData];
    }
    NSLog([NSString stringWithFormat:@"table post count %d", [self.tweetController countofList]]);
    
}

/*- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}*/

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweetController countofList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellId = @"TweetCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId forIndexPath:indexPath];
    Tweets* tweetAtIndex = [self.tweetController objectInListAtIndex:indexPath.row];
    cell.textLabel.text = tweetAtIndex.caption;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"@%@     %@", tweetAtIndex.handle, tweetAtIndex.date];
    
    UIImage* image;
    if (!tweetAtIndex.pic){
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO){
            [self startIconDownload:tweetAtIndex forIndexPath:indexPath];
        }
        image=[UIImage imageNamed:@"default.png"];
    }else{
        image = tweetAtIndex.pic;
    }
    
    CGSize itemSize = CGSizeMake(48,48);
    UIGraphicsBeginImageContext(itemSize);
    CGRect imageRect = CGRectMake(0, 0, itemSize.width, itemSize.height);
    [image drawInRect:imageRect];
    cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return cell;
}


#pragma mark - Table cell image support
- (void)startIconDownload:(Tweets*)tweet forIndexPath:(NSIndexPath*) indexPath{
    PictureDownloader* picdownloader = [self.imageDownloadsInProgress objectForKey:indexPath];
    if (picdownloader == nil){
        picdownloader = [[PictureDownloader alloc] init];
        picdownloader.tweet = tweet;
        [picdownloader setCompletionHandler:^{
            UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
            cell.imageView.image = tweet.pic;
            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
        }];
        [self.imageDownloadsInProgress setObject:picdownloader forKey:indexPath];
        [picdownloader startDownload];
    }
}

- (void) loadImagesForOnScreenRows{
    if([self.tweetController countofList] > 0) {
        NSArray* visiblePaths = [self.tableView indexPathsForVisibleRows];
        for(NSIndexPath *indexPath in visiblePaths){
            Tweets* tweet = [self.tweetController objectInListAtIndex:indexPath.row];
            if (!tweet.pic){
                [self startIconDownload:tweet forIndexPath:indexPath ];
            }
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



#pragma mark - UIScrollViewDelegate
-(void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!decelerate){
        [self loadImagesForOnScreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self loadImagesForOnScreenRows];
}

/*- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [_objects removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        TweetsDetailViewController* controller = (TweetsDetailViewController*)segue.destinationViewController;
        controller.tweet = [self.tweetController objectInListAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:[self.tweetController objectInListAtIndex:indexPath.row]];
    }
}



@end
