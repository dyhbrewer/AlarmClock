//
//  AddAlarmViewController.h
//  AlarmClock
//
//  Created by Xu on 15/12/22.
//  Copyright © 2015年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBarSDK.h"
#import "RepeatTableViewController.h"
#import "RingTableViewController.h"

@protocol AddAlarmViewControllerDelegate;

@interface AddAlarmViewController : UIViewController<ZBarReaderDelegate,ZBarReaderViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    NSString *strDate;
    NSString *codeData;
    id<AddAlarmViewControllerDelegate>delegate;
}
//要声明属性才能有调用，ViewController,代理一般使用弱引用(weak)
@property (nonatomic,retain)id<AddAlarmViewControllerDelegate>delegate;

@end
@protocol AddAlarmViewControllerDelegate

- (void)addAlarmViewControllerDidFinishAdding:(AddAlarmViewController *)controller;

@end