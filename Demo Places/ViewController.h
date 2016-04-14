//
//  ViewController.h
//  Demo Places
//
//  Created by paras.gorasiya on 4/2/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "Constants.h"
#import "SVProgressHUD.h"

@interface ViewController : UIViewController<GMSMapViewDelegate, UIAlertViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet GMSMapView *mapView;
@property (nonatomic, retain) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *strLat;
@property (nonatomic, strong) NSString *strLng;

- (IBAction)toolBarButtonTapped:(id)sender;



@end

