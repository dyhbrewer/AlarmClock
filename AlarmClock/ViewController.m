//
//  ViewController.m
//  AlarmClock
//
//  Created by Xu on 15/12/16.
//  Copyright © 2015年 Xu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    addAlertView=[[AddAlarmViewController alloc]init];
    addAlertView.delegate=self;
    
    //重新执行时，再调用，否则主界面显示为0，需要初始化
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    alarmArray=[[NSMutableArray alloc]initWithArray:[defaults objectForKey:@"array"]];
    
    //添加标题
    //self.navigationController.navigationItem.title=@"闹钟";
    self.navigationItem.title=@"闹钟";
//    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor redColor]};
//    [[UINavigationBar appearance] setTitleTextAttributes:attributes];

    
    //添加左侧按钮
    leftButton=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.leftBarButtonItem=leftButton;
    
    //添加右侧按钮
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addClick)];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    //添加tableView
    listTableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];//Y直接0，NavigationBar的高度计算进View，而不需要减去64
    
    listTableView.delegate=self;
    listTableView.dataSource=self;
    [self.view addSubview:listTableView];
    
    
}

//设置本地通知



//编辑按钮
- (void)editClick
{
    //NSLog(@"click edit");
    
    //对tableview的当前状态取反
    [listTableView setEditing:!listTableView.editing animated:YES];
    if (listTableView.editing) {
        leftButton.title=@"完成";
    }
    else
    {
        //[self.navigationItem.leftBarButtonItem setTitle:@"编辑"];
        leftButton.title=@"编辑";
    }
    
}
- (void)addClick
{
    //设置为带navgation效果的导航条
    UINavigationController *nav=[[UINavigationController alloc]initWithRootViewController:addAlertView];
    //页面跳转不带导航的跳转
    [self presentViewController:nav animated:YES completion:nil];
    
    
    //带 Navigation bar 页面导航的跳转
    //[self.navigationController pushViewController:addAlertView animated:YES];
}

//实现代理方法
- (void)addAlarmViewControllerDidFinishAdding:(AddAlarmViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    alarmArray=[defaults objectForKey:@"array"];
    NSLog(@"array:%@",alarmArray);
    [listTableView reloadData];
    
    
    //实现闹铃功能
    //实现多闹钟功能
    //NSDate * pushDate = [NSDate dateWithTimeIntervalSinceNow:10];
    for (int i=0; i<alarmArray.count; i++) {
        NSDictionary *dic=[alarmArray objectAtIndex:i];
        NSString *string=[dic objectForKey:@"strDate"];
    
        UILocalNotification *notification = [[UILocalNotification alloc]init];
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"HH:mm"];
        NSDate *pushDate=[dateFormatter dateFromString:string];
        if (notification != nil) {
            //设置通知的提醒时间
            notification.fireDate = pushDate;
            //设置使用时区
            notification.timeZone = [NSTimeZone defaultTimeZone];
            //设置重复间隔
            notification.repeatInterval = kCFCalendarUnitDay;
            //通知提示音 使用默认的
            notification.soundName = UILocalNotificationDefaultSoundName;
            //提醒的文字内容
            notification.alertBody = @"Wake up";//设备收到本地通知时横额或锁屏时的主要文字内容
            notification.alertAction=NSLocalizedString(@"起床了", nil);//锁屏时显示的slide to后面的文字内容
            
            //设置应用程序右上角的提醒个数
            notification.applicationIconBadgeNumber=0;
//            notification.applicationIconBadgeNumber++;
            
            //设定通知的userInfo，用来表示该通知
            NSDictionary *info = [NSDictionary dictionaryWithObject:@"test" forKey:@"name"];
            notification.userInfo = info;
            //将通知添加到系统中
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView: (UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    NSLog(@"alarmAarry count:%lu",(unsigned long)alarmArray.count);
    return [alarmArray count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     //由于此方法调用十分频繁，cell的标示声明成静态变量有利于性能优化
     static NSString *cellIdentifier=@"UITableViewCellIdentifierKey1";
     //首先根据标识去缓存池取
     UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     //如果缓存池没有到则重新创建并放到缓存池中
     if(!cell){
         cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
     }
     // Configure the cell...
     //添加右侧UISwitch，accessoryView支持任何UIView控件
     UISwitch *switchView=[[UISwitch alloc]init];
     switchView.on=YES;
     [switchView addTarget:self action:@selector(switchValueChange) forControlEvents:UIControlEventValueChanged];
     cell.accessoryView=switchView;
     
     NSDictionary *dic=[alarmArray objectAtIndex:indexPath.row];
     //NSString *codeString=[NSString stringWithString:[dic objectForKey:@"codeData"]];
     
     NSString *dateString=[NSString stringWithString:[dic objectForKey:@"strDate"]];
     cell.textLabel.text=dateString;
     //cell.detailTextLabel.text=codeString;
     cell.textLabel.font=[UIFont systemFontOfSize:40];
     return cell;
}
- (void)switchValueChange
{
    NSLog(@"value change");
    
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
     
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // Delete the row from the data source
         
         //删除数组内容
         [alarmArray removeObjectAtIndex:indexPath.row];
         
         //tableviewlist删除效果
         [listTableView deleteRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath, nil] withRowAnimation:UITableViewRowAnimationFade];
         
         //删除数组数据后再做一次储存
         NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
         [defaults setValue:alarmArray forKey:@"array"];
         [listTableView reloadData];
         
         
     } else if (editingStyle == UITableViewCellEditingStyleInsert) {
         // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
 }


/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
