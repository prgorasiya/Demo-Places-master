//
//  ResultsViewController.h
//  Demo Places
//
//  Created by paras.gorasiya on 4/2/15.
//  Copyright (c) 2015 paras.gorasiya. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property (strong, nonatomic) IBOutlet UITableView *tblVwResults;
@property (strong, nonatomic) NSArray *arrResults;

@end
