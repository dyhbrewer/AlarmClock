//
//  ViewController.h
//  AlarmClock
//
//  Created by Xu on 15/12/16.
//  Copyright © 2015年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddAlarmViewController.h"

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AddAlarmViewControllerDelegate>
{
    UITableView *listTableView;
    AddAlarmViewController *addAlertView;
    NSMutableArray *alarmArray;
    UIBarButtonItem *leftButton;
    
}
@property(nonatomic,strong)UITableView *tableView;
@end

