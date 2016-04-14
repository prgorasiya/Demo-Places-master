//
//  placeDetailsViewController.m
//  Demo Places
//
//  Created by paras.gorasiya on 4/3/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#define TMP NSTemporaryDirectory()

#import "placeDetailsViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#include <unistd.h>
#include <netdb.h>

@interface placeDetailsViewController ()

@end

@implementation placeDetailsViewController
{
    NSString *strPhotoRef;
}

@synthesize arrObject, lblName, lblRating, lblVicinity, imgVwPlaceImage, btnShowOnMap;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    lblName.text = [arrObject valueForKey:kAPI_Key_name];
    
    //Checking that if user has navigated from Favorite screen
    //Doing some operations accordingly like hiding the favorite button
    if([[NSUserDefaults standardUserDefaults] boolForKey:kUD_KeyisFromFavoriteScreen])
    {
        NSString *strRating = [arrObject valueForKey:kAPI_Key_rating];
        if(strRating.length > 0)
        {
            lblRating.text = [NSString stringWithFormat:@"Rating : %@", [arrObject valueForKey:kAPI_Key_rating]];
        }
        else
        {
            lblRating.text = @"No ratings available.";
        }
        
        lblVicinity.text = [arrObject valueForKey:kAPI_Key_vicinity];
        imgVwPlaceImage.image = [UIImage imageNamed:@"placeholder-icon.png"];
        
        strPhotoRef = @"";
        strPhotoRef = [arrObject valueForKey:kAPI_Key_imageKey];
    }
    else
    {
        NSString *strRating = [[arrObject valueForKey:kAPI_Key_rating] stringValue];
        if(strRating.length > 0)
        {
            lblRating.text = [NSString stringWithFormat:@"Rating : %@", [arrObject valueForKey:kAPI_Key_rating]];
        }
        else
        {
            lblRating.text = @"No ratings available.";
        }
        
        lblVicinity.text = [arrObject valueForKey:kAPI_Key_vicinity];
        imgVwPlaceImage.image = [UIImage imageNamed:@"placeholder-icon.png"];
        
        strPhotoRef = @"";
        strPhotoRef = (NSString*)[[arrObject valueForKey:kAPI_Key_photos] valueForKey:kAPI_Key_photo_reference][0];
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 44, 44)];
        view.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"favorite-icon.png"];
        UIButton *btnFav = [[UIButton alloc] initWithFrame:CGRectMake(10, 2, 40, 40)];
        [btnFav setImage:image forState:UIControlStateNormal];
        [btnFav addTarget:self action:@selector(btnFavTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:[arrObject valueForKey:kAPI_Key_id]])
        {
            [btnFav setSelected:YES];
            [btnFav setImage:[UIImage imageNamed:@"favorite-icon-selected.png"] forState:UIControlStateSelected];
        }
        
        [view addSubview:btnFav];
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    }
    
    [btnShowOnMap addTarget:self action:@selector(btnShowOnMapTapped) forControlEvents:UIControlEventTouchUpInside];
    [self callAPIForImage];
    
    self.btnShowOnMap.layer.cornerRadius = 8.0f;
    self.btnShowOnMap.layer.masksToBounds = NO;
    
    self.btnShowOnMap.layer.shadowColor = [UIColor darkGrayColor].CGColor;
    self.btnShowOnMap.layer.shadowOpacity = 0.8;
    self.btnShowOnMap.layer.shadowRadius = 8;
    self.btnShowOnMap.layer.shadowOffset = CGSizeMake(0, 5.0f);
}


//Adding the current place to favorites list into core data
-(void)btnFavTapped:(UIButton*)button
{
    if([button isSelected])
    {
        return;
    }
    
    [button setSelected:YES];
    [button setImage:[UIImage imageNamed:@"favorite-icon-selected.png"] forState:UIControlStateSelected];
    
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    
    NSManagedObject *favPlace;
    favPlace = [NSEntityDescription
                  insertNewObjectForEntityForName:@"Favorites"
                  inManagedObjectContext:context];

    NSString *strLat = [[[[arrObject valueForKey:kAPI_Key_geometry] valueForKey:kAPI_Key_location] valueForKey:kAPI_Key_lat] stringValue];
    NSString *strLng = [[[[arrObject valueForKey:kAPI_Key_geometry] valueForKey:kAPI_Key_location] valueForKey:kAPI_Key_lng] stringValue];
    
    [favPlace setValue:[arrObject valueForKey:kAPI_Key_icon] forKey:kAPI_Key_icon];
    [favPlace setValue:strPhotoRef forKey:kAPI_Key_imageKey];
    [favPlace setValue:strLat forKey:kAPI_Key_latitude];
    [favPlace setValue:strLng forKey:kAPI_Key_longitude];
    [favPlace setValue:[arrObject valueForKey:kAPI_Key_name] forKey:kAPI_Key_name];
    [favPlace setValue:[[arrObject valueForKey:kAPI_Key_rating] stringValue] forKey:kAPI_Key_rating];
    [favPlace setValue:[arrObject valueForKey:kAPI_Key_vicinity] forKey:kAPI_Key_vicinity];
    
    NSError *error;
    if(![context save:&error])
    {
        NSLog(@"Error : %@", error);
    }
    
    //Setting bool to YES for making the place favorite
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[arrObject valueForKey:@"id"]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//Showing the place on map
-(void)btnShowOnMapTapped
{
    UIStoryboard *mainStoryboard= [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    ViewController *mainView = [mainStoryboard instantiateViewControllerWithIdentifier:@"homeView"];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUD_KeyisFromDetailScreen];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *strLat;
    NSString *strLng;
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kUD_KeyisFromFavoriteScreen])
    {
        strLat = [arrObject valueForKey:kAPI_Key_latitude];
        strLng = [arrObject valueForKey:kAPI_Key_longitude];
    }
    else
    {
        strLat = [[[[arrObject valueForKey:kAPI_Key_geometry] valueForKey:kAPI_Key_location] valueForKey:kAPI_Key_lat] stringValue];
        strLng = [[[[arrObject valueForKey:kAPI_Key_geometry] valueForKey:kAPI_Key_location] valueForKey:kAPI_Key_lng] stringValue];
    }
    
    mainView.strLat = strLat;
    mainView.strLng = strLng;
    
    [self.navigationController pushViewController:mainView animated:YES];
}


//Checking if the internet is available
-(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    
    if (hostinfo == NULL)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}


//Calling the API for fetching the image from photo ref key
-(void)callAPIForImage
{
    if(strPhotoRef.length > 0)
    {
        UIImage *imgCachedImage = [self getCachedImage];
        
        if(imgCachedImage)
        {
            imgVwPlaceImage.image = imgCachedImage;
            
            [SVProgressHUD dismiss];
            return;
        }
        
        if(![self isNetworkAvailable])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No working internet!" message:@"No internet available.\nPlease turn on wifi or cellular data." delegate:nil cancelButtonTitle:kBtnOk_Title otherButtonTitles:nil, nil];
            [alert show];
            
            [SVProgressHUD dismiss];
            imgVwPlaceImage.image = [UIImage imageNamed:@"no_photo_icon.png"];
            
            return;
        }
        
        NSString *url = [NSString stringWithFormat:kURL_PlaceImageRef, strPhotoRef, kConst_Google_APIKey];
        
        NSURL *googleRequestURL=[NSURL URLWithString:url];
        
        dispatch_async(kBgQueue, ^{
            NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
            [self performSelectorOnMainThread:@selector(dataReceived:) withObject:data waitUntilDone:YES];
        });
    }
    else
    {
        [SVProgressHUD dismiss];
        imgVwPlaceImage.image = [UIImage imageNamed:@"no_photo_icon.png"];
    }
}


//If image is received from the API call then caching it
-(void)dataReceived:(NSData *)responseData
{
    UIImage *image = [UIImage imageWithData:responseData];
    imgVwPlaceImage.image = image;
    
    if (strPhotoRef.length > 0)
    {
        [self cacheImage:image];
    }
    
    [SVProgressHUD dismiss];
}


//Caching the image to show it again from the cache memory
- (void)cacheImage:(UIImage *)image
{
    NSString *filename = strPhotoRef;
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    // Check for file existence
    if(![[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        // The file doesn't exist, we should get a copy of it
        [UIImagePNGRepresentation(image) writeToFile: uniquePath atomically: YES];
    }
}


//Fetching the cached image from the memory
- (UIImage *)getCachedImage
{
    NSString *filename = strPhotoRef;
    NSString *uniquePath = [TMP stringByAppendingPathComponent: filename];
    
    UIImage *image;
    
    // Check for a cached version
    if([[NSFileManager defaultManager] fileExistsAtPath: uniquePath])
    {
        image = [UIImage imageWithContentsOfFile: uniquePath];
        return image;
    }
    
    return nil;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
