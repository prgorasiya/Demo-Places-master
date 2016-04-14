//
//  ResultsViewController.m
//  Demo Places
//
//  Created by paras.gorasiya on 4/2/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import "ResultsViewController.h"
#import "resultsTableViewCell.h"
#import "placeDetailsViewController.h"
#import "favoritesViewController.h"


@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize tblVwResults, arrResults;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:kBtnTitle_Favorites
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(showFavPlaces)];
    
    self.navigationItem.rightBarButtonItem = flipButton;
    
    tblVwResults.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Taken this userdefault for checking if the navigation is form place detail screen and to do some operation differently as per the navigation
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUD_KeyisFromDetailScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Taken this userdefault for checking if the navigation is form favorite screen and to do some operation differently as per the navigation
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUD_KeyisFromFavoriteScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//Navigate to favorite screen
-(void)showFavPlaces
{
    UIStoryboard *mainStoryboard= [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    favoritesViewController *favorites = [mainStoryboard instantiateViewControllerWithIdentifier:@"favorites"];
        
    [self.navigationController pushViewController:favorites animated:YES];
}


#pragma mark TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrResults count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    
    resultsTableViewCell *cell = [tblVwResults dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[resultsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:MyIdentifier];
    }
    
    cell.imgVwThumbnail.image = [UIImage imageNamed:@""];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[arrResults objectAtIndex:indexPath.row] valueForKey:kAPI_Key_icon]]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.imgVwThumbnail.image = image;
        });
    });
    
    cell.lblTitle.text = [[arrResults objectAtIndex:indexPath.row] valueForKey:kAPI_Key_name];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard= [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    placeDetailsViewController *placeDetails = [mainStoryboard instantiateViewControllerWithIdentifier:@"placeDetails"];
    
    placeDetails.arrObject = [arrResults objectAtIndex:indexPath.row];
    
    [self.navigationController pushViewController:placeDetails animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
