//
//  favoritesViewController.m
//  Demo Places
//
//  Created by paras.gorasiya on 4/3/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import "favoritesViewController.h"
#import "AppDelegate.h"
#import "favoritesTableViewCell.h"
#import "placeDetailsViewController.h"

@interface favoritesViewController ()

@end

@implementation favoritesViewController
{
    NSMutableArray *arrFavPlaces;
}

@synthesize tblVwFavPlaces;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    tblVwFavPlaces.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self fetchData];
}


//Fetching the data from core data to display list of favorite places
- (IBAction)fetchData
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSEntityDescription *entityDesc =
    [NSEntityDescription entityForName:@"Favorites"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
        
    NSError *error;
    arrFavPlaces = [[context executeFetchRequest:request error:&error] mutableCopy];
    
    if ([arrFavPlaces count] > 0)
    {
        NSLog(@"Value : %@", [arrFavPlaces valueForKey:kAPI_Key_icon][0]);
        [tblVwFavPlaces reloadData];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle_Sorry message:kAlertMsg_NoPlaces delegate:nil cancelButtonTitle:kBtnOk_Title otherButtonTitles:nil, nil];
        [alert show];
    }
    
    //Taken this userdefault for checking if the navigation is form place detail screen and to do some operation differently as per the navigation
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUD_KeyisFromDetailScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Taken this userdefault for checking if the navigation is form favorite screen and to do some operation differently as per the navigation
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kUD_KeyisFromFavoriteScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


#pragma mark TableView Delegate Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrFavPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"cell";
    
    favoritesTableViewCell *cell = [tblVwFavPlaces dequeueReusableCellWithIdentifier:MyIdentifier];
    
    if (cell == nil)
    {
        cell = [[favoritesTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:MyIdentifier];
    }
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[[arrFavPlaces objectAtIndex:indexPath.row] valueForKey:kAPI_Key_icon]]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            cell.imgVwPlace.image = image;
        });
    });
    
    cell.lblTitle.text = [[arrFavPlaces objectAtIndex:indexPath.row] valueForKey:kAPI_Key_name];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIStoryboard *mainStoryboard= [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    placeDetailsViewController *placeDetails = [mainStoryboard instantiateViewControllerWithIdentifier:@"placeDetails"];
    
    placeDetails.arrObject = [arrFavPlaces objectAtIndex:indexPath.row];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUD_KeyisFromFavoriteScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController pushViewController:placeDetails animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [appDelegate managedObjectContext];
        
        [context deleteObject:[arrFavPlaces objectAtIndex:indexPath.row]];
        
        NSError *error = nil;
        if (![context save:&error])
        {
            NSLog(@"Can't Delete! %@ %@", error, [error localizedDescription]);
            return;
        }
        
        [arrFavPlaces removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [tblVwFavPlaces reloadData];
    }
}


- (void)didReceiveMemoryWarnin {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
