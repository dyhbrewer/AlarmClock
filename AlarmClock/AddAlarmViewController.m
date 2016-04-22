//
//  AddAlarmViewController.m
//  AlarmClock
//
//  Created by Xu on 15/12/22.
//  Copyright © 2015年 Xu. All rights reserved.
//

#import "AddAlarmViewController.h"

@interface AddAlarmViewController ()

@end

@implementation AddAlarmViewController
@synthesize delegate;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor=[UIColor whiteColor];
   
    
    /*self.navigationController.navigationBar.hidden=NO;
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, 44)];
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    [toolBar setItems:@[cancelButton,saveButton]];
    
    [self.view addSubview:toolBar];*/
    
    
    //应该是直接添加navigationBar
    //UINavigationBar *navigationBar=[[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 66)];
    
    //navigationBar.tintColor = [UIColor colorWithRed:200.0 green:100.0 blue:162.0 alpha:1.0];//COLOR(200, 100, 162);;
    
    // 或者 创建UINavigationItem
//    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"添加闹钟"];
//    
//    //[self.navigationController.navigationBar pushNavigationItem: navigationBarTitle animated:YES];
//    [self.navigationController.navigationBar pushNavigationItem:navigationBarTitle animated:YES];
    
    self.navigationItem.title=@"添加闹钟";
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *cancelButton=[[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancle)];
    
    UIBarButtonItem *saveButton=[[UIBarButtonItem alloc]initWithTitle:@"存储" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    
    //添加button到navigationbar,以title为基准，分左右两边
//    navigationBarTitle.leftBarButtonItem=cancelButton;
//    navigationBarTitle.rightBarButtonItem=saveButton;
    self.navigationItem.rightBarButtonItem=saveButton;
    self.navigationItem.leftBarButtonItem=cancelButton;
    
    //[self.view addSubview:navigationBar];
    
    [self drawView];
    
}



//绘制界面
- (void)drawView
{
    //NSLog(@"drawView");
//    UIImageView *ZBarImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, 150)];
//    ZBarImageView.backgroundColor=[UIColor grayColor];
//    [self.view addSubview:ZBarImageView];
    
    ZBarReaderView *readerView=[[ZBarReaderView alloc] init]; 
    readerView.frame=CGRectMake(0, 64, self.view.frame.size.width, 150);
    readerView.readerDelegate=self;
    ZBarImageScanner *scanner=readerView.scanner;
    [scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
    readerView.torchMode=0;
    
    //扫描区域
    //CGRectStandardize(CGRectMake(0, 64, <#CGFloat width#>, <#CGFloat height#>));
    
    //开始扫描
    [readerView start];
    
    [self.view addSubview:readerView];
    
    // 不用设置宽高，因为它的宽高是固定的
    UIDatePicker *timePicker=[[UIDatePicker alloc] initWithFrame:CGRectMake(0, 64+150, self.view.frame.size.width, 150)];
    
    //设置属性样式
    timePicker.datePickerMode=UIDatePickerModeTime;
    //需要监听值得改变
    [timePicker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    //设置当前时区
    [timePicker setLocale:[NSLocale currentLocale]];
    [self.view addSubview:timePicker];
    
    //添加tableview
    UITableView *tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 380, self.view.frame.size.width, self.view.frame.size.height-380) style:UITableViewStyleGrouped];
    tableView.scrollEnabled=NO;
    tableView.dataSource=self;
    tableView.delegate=self;
    [self.view addSubview:tableView];
    

}
- (void)dateChange:(UIDatePicker *)timePicker
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //获取时要设置显示格式，否则显示时间不对
    [dateFormatter setDateFormat:@"HH:mm"];
    strDate = [dateFormatter stringFromDate:timePicker.date];
    NSLog(@"Date: %@", strDate);
}

- (void)cancle
{
    //NSLog(@"cancle");
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)save
{
    //NSLog(@"save");
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
    
    NSString *codeTestData=@"111";
    //使用NSUsrdefault保存时，先获取前面的值，再把当前值加进去
    NSMutableArray *array=[[NSMutableArray alloc]initWithArray:[userDefaults objectForKey:@"array"]];
    
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]init];
    [dic setObject:strDate forKey:@"strDate"];
    [dic setObject:codeTestData forKey:@"codeData"];
    [array addObject:dic];
    
    
    [userDefaults setObject:array forKey:@"array"];
    
    [delegate addAlarmViewControllerDidFinishAdding:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -ZBarReaderDelegate
- (void)readerView:(ZBarReaderView *)readerView didReadSymbols:(ZBarSymbolSet *)symbols fromImage:(UIImage *)image
{
    NSLog(@"scaned");
    codeData = [[NSString alloc] init];
    for (ZBarSymbol *sym in symbols) {
        codeData = sym.data;
        break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"掃描結果" message:codeData delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    
//    //保存扫描结果到NSUserDefaults
//    NSUserDefaults *userDefaults=[NSUserDefaults standardUserDefaults];
//    //存储时，除NSNumber类型使用对应的类型意外，其他的都是使用setObject:forKey:
//    [userDefaults setObject:codeData forKey:@"codeData"];
    
    [readerView stop];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
#pragma mark 设置每行高度（每行高度可以不一样）
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

//对cell做编辑
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     static NSString *CellIdentifier = @"ListCellIdentifier";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     }
     
     NSArray *array=@[@"重复",@"铃声"];
     cell.textLabel.text=[array objectAtIndex:indexPath.row];
     cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
     //[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
     return cell;
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        NSLog(@"0");
        RepeatTableViewController *repeatViewController=[[RepeatTableViewController alloc]init];
        [self.navigationController pushViewController:repeatViewController animated:YES];
        //[self presentViewController:repeatViewController animated:YES completion:nil];
    }
    else
    {
        NSLog(@"1");
        RingTableViewController *ringViewController=[[RingTableViewController alloc]init];
        [self.navigationController pushViewController:ringViewController animated:YES];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

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



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
