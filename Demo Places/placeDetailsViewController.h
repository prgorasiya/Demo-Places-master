//
//  placeDetailsViewController.h
//  Demo Places
//
//  Created by paras.gorasiya on 4/3/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVProgressHUD.h"
#import "Constants.h"

@interface placeDetailsViewController : UIViewController
{
    
}

@property (strong, nonatomic) NSArray *arrObject;
@property (strong, nonatomic) IBOutlet UIImageView *imgVwPlaceImage;
@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblRating;
@property (strong, nonatomic) IBOutlet UILabel *lblVicinity;
@property (strong, nonatomic) IBOutlet UIButton *btnShowOnMap;

@end
