//
//  favoritesViewController.h
//  Demo Places
//
//  Created by paras.gorasiya on 4/3/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface favoritesViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *tblVwFavPlaces;

@end
