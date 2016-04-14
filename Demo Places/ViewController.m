//
//  ViewController.m
//  Demo Places
//
//  Created by paras.gorasiya on 4/2/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import "ViewController.h"
#import "ResultsViewController.h"
#include <unistd.h>
#include <netdb.h>

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)


@interface ViewController ()

@end

@implementation ViewController
{
    CLLocationCoordinate2D currentCentre;
    BOOL isDataReceived;
    
    UIPickerView *pickerVwRadius;
    UIView *vwForPicker;
    
    NSMutableArray *arrPickerData;
    NSMutableArray *arrPlacesPickerData;
    int numProductSelectionIndex;
    
    NSString *strRadius;
    NSString *strPlaceType;
}

@synthesize mapView, locationManager, strLat, strLng;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView.myLocationEnabled = YES;
    mapView.mapType = kGMSTypeNormal;
    mapView.settings.compassButton = YES;
    mapView.settings.myLocationButton = YES;
    mapView.delegate = self;
    
    locationManager = [[CLLocationManager alloc] init];
    locationManager.Delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    //Starting the location manager update to fetch device location
    if([CLLocationManager locationServicesEnabled])
    {
        if(IS_OS_8_OR_LATER)
        {
            [locationManager requestAlwaysAuthorization];
        }
        
        [locationManager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLocationDisabled_AlertTitle message:kLocationDisabled_AlertMsg delegate:self cancelButtonTitle:kBtnCancel_Title otherButtonTitles:kBtnSettings_Title, nil];
        
        [alert show];
    }

    //Initializing picker data
    arrPickerData = [[NSMutableArray alloc] initWithObjects:@"100", @"200", @"500", @"1000", @"1500", @"2000", @"2500", @"3000", @"3500", @"4000", @"4500", @"5000", nil];
    arrPlacesPickerData = [[NSMutableArray alloc] initWithObjects:@"food", @"gym", @"school", @"hospital", @"spa", @"restaurant", nil];
    
    pickerVwRadius = [[UIPickerView alloc] init];
    pickerVwRadius.frame = CGRectMake(0, 0, self.view.frame.size.width, pickerVwRadius.frame.size.height);
    pickerVwRadius.delegate = self;
    pickerVwRadius.dataSource = self;
    [pickerVwRadius setBackgroundColor:[UIColor whiteColor]];
    
    UIToolbar *toolBar= [[UIToolbar alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,44)];
    [toolBar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:kBtnDone_Title
                                                                      style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    
    toolBar.items = [[NSArray alloc] initWithObjects:barButtonDone, nil];
    barButtonDone.tintColor=[UIColor blackColor];
    
    vwForPicker = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, pickerVwRadius.frame.size.width, pickerVwRadius.frame.size.height)];
    vwForPicker.backgroundColor = [UIColor clearColor];
    
    [vwForPicker addSubview:pickerVwRadius];
    [vwForPicker addSubview:toolBar];
    [self.view addSubview:vwForPicker];
    
    if([[NSUserDefaults standardUserDefaults] boolForKey:kUD_Key_isFromDetailScreen])
    {
        self.navigationItem.rightBarButtonItem = nil;
        [self addMarkerOnMap];
        mapView = nil;
        mapView = [[GMSMapView alloc] init];
    }

    
    //Retrieving previously stored lat, lon details of the device
//    NSDictionary *userLoc=[[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
//    NSLog(@"lat %@",[userLoc objectForKey:@"lat"]);
//    NSLog(@"long %@",[userLoc objectForKey:@"long"]);
}


//Checking internet connection
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


//Adding marker on map view when user wants to see place on map
-(void)addMarkerOnMap
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[strLat doubleValue]
                                                            longitude:[strLng doubleValue]
                                                                 zoom:13];
    
    mapView.camera = camera;
    
    mapView.myLocationEnabled = NO;
    mapView.settings.myLocationButton = NO;
    
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake([strLat doubleValue], [strLng doubleValue]);
    marker.appearAnimation = kGMSMarkerAnimationPop;
    marker.map = mapView;
}


//Handling the toolbar button tap action for letting user select radius and type
- (IBAction)toolBarButtonTapped:(id)sender
{
    if(![self isNetworkAvailable])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No working internet!" message:@"No internet available.\nPlease turn on wifi or cellular data." delegate:nil cancelButtonTitle:kBtnOk_Title otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    
    
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPermissionDenied_AlerTitle
                                               message:kPermissionDenied_AlerMsg
                                              delegate:nil
                                     cancelButtonTitle:kBtnOk_Title
                                     otherButtonTitles:nil];
            [alert show];
            return;
        }
        
        if(IS_OS_8_OR_LATER)
        {
            [locationManager requestAlwaysAuthorization];
        }
        
        [locationManager startUpdatingLocation];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kLocationDisabled_AlerTitle message:@"Demo Places needs your location to display nearby places.\nPlease turn on Location Services in your device settings." delegate:self cancelButtonTitle:kBtnCancel_Title otherButtonTitles:kBtnSettings_Title, nil];
        
        [alert show];
        return;
    }
    
    [mapView setUserInteractionEnabled:NO];

    [UIView animateWithDuration:0.3
                     animations:
     ^{
         vwForPicker.frame = CGRectMake(0, self.view.frame.size.height - vwForPicker.frame.size.height, pickerVwRadius.frame.size.width, pickerVwRadius.frame.size.height);
     }
     ];
}


//Searching for places nearby
-(void)queryGooglePlaces:(NSString *)radius type:(NSString*)placeType
{
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeBlack];
    
    NSString *url = [NSString stringWithFormat:kURL_GooglePlaceSearch, currentCentre.latitude, currentCentre.longitude, radius, placeType,  kConst_Google_APIKey];
    
    NSURL *googleRequestURL=[NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^{
        NSData* data = [NSData dataWithContentsOfURL: googleRequestURL];
        [self performSelectorOnMainThread:@selector(fetchedData:) withObject:data waitUntilDone:YES];
    });
}


//Received data, now showing them in table view
-(void)fetchedData:(NSData *)responseData
{
    if(responseData == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle_Sorry message:kAlertMsg_NoData delegate:nil cancelButtonTitle:kBtnOk_Title otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:responseData
                          options:kNilOptions
                          error:&error];
    
    [SVProgressHUD dismiss];
    
    NSArray* places = [json objectForKey:kAPI_Key_results];
    
    if([places count] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertTitle_Sorry message:kAlertMsg_NoResult delegate:nil cancelButtonTitle:kBtnOk_Title otherButtonTitles:nil, nil];
        [alert show];
        
        return;
    }
    UIStoryboard *mainStoryboard= [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    
    ResultsViewController *resultsTableView = [mainStoryboard instantiateViewControllerWithIdentifier:kAPI_Key_results];
    
    resultsTableView.arrResults = places;
    [self.navigationController pushViewController:resultsTableView animated:YES];
}


//Done button tap method, calling the method for fetching nearby places
- (IBAction)doneButtonTapped:(UIBarButtonItem*)sender
{
    NSInteger row;
    row = [pickerVwRadius selectedRowInComponent:0];
    
    strRadius = [arrPickerData objectAtIndex:row];
    
    row = [pickerVwRadius selectedRowInComponent:1];
    strPlaceType = [arrPlacesPickerData objectAtIndex:row];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         vwForPicker.frame = CGRectMake(0, self.view.frame.size.height, pickerVwRadius.frame.size.width, pickerVwRadius.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         [mapView setUserInteractionEnabled:YES];
                         [self queryGooglePlaces:strRadius type:strPlaceType];
                     }];
    
    
}


#pragma mark Location Delegates
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:15.0];
    [mapView animateToCameraPosition:camera];
    
    currentCentre = newLocation.coordinate;

    //Storing lat, lon details to UserDefaults
    NSNumber *lat = [NSNumber numberWithDouble:newLocation.coordinate.latitude];
    NSNumber *lon = [NSNumber numberWithDouble:newLocation.coordinate.longitude];
    NSDictionary *userLocation=@{@"lat":lat,@"long":lon};
    
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:kUD_Key_Userlocation];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//When user taps on my location button
- (BOOL)didTapMyLocationButtonForMapView:(GMSMapView *)mapVw
{
    if([CLLocationManager locationServicesEnabled])
    {
        if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kPermissionDenied_AlerTitle
                                                            message:kPermissionDenied_AlerMsg
                                                           delegate:nil
                                                  cancelButtonTitle:kBtnOk_Title
                                                  otherButtonTitles:nil];
            [alert show];
            return 0;
        }
    }
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentCentre.latitude
                                                            longitude:currentCentre.longitude
                                                                 zoom:13];
    
    [mapVw animateToCameraPosition:camera];
    return YES;
}


#pragma mark AlertView Delegates
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1)
    {
        [[UIApplication sharedApplication] openURL:[NSURL  URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark PickerView Delegates
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return arrPickerData.count;
    }
    else
    {
        return [arrPlacesPickerData count];
    }
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component == 0)
    {
        return [NSString stringWithFormat:@"%@m", [arrPickerData objectAtIndex:row]];
    }
    else
    {
        return [NSString stringWithFormat:@"%@", [arrPlacesPickerData objectAtIndex:row]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
