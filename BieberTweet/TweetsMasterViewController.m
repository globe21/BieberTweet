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


/*
@interface TweetsMasterViewController () {
    NSMutableArray *_objects;
}
@end
*/

#define Queue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)

#define searchurl [NSURL URLWithString:@"http://search.twitter.com/search.json?q=%23bieber&result_type=mixed"]

@implementation TweetsMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tweetController = [[TweetController alloc] init];
}

- (void)viewDidLoad
{
    
    self.title= @"#Bieber";
    
    dispatch_async(Queue, ^{
        NSData* data = [NSData dataWithContentsOfURL:searchurl];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
        
    });
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    /*self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;*/
}

-(void) fetchedData:(NSData*)responseData{
    NSError* error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:&error];
    NSArray* returnedTweets = [json objectForKey:@"results"];
    for (int i = 0; i < returnedTweets.count; i++) {
        NSDictionary* curr_json = [returnedTweets objectAtIndex:i];
        Tweets* tweet = [[Tweets alloc] initWithUsername:[curr_json objectForKey:@"from_user_name"] handle:[curr_json objectForKey:@"from_user"] caption:[curr_json objectForKey:@"text"] url:[curr_json objectForKey:@"profile_image_url"] date:[curr_json objectForKey:@"created_at"]];
        tweet.date = [tweet.date substringToIndex:17];
        [self.tweetController addTweetwithTweet:tweet];
        NSLog(@"user name: %@", [curr_json objectForKey:@"from_user_name"]);
    }
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
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
        //NSDate *object = _objects[indexPath.row];
        //[[segue destinationViewController] setDetailItem:object];
    }
}

@end
