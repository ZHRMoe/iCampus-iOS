//
//  ICBusViewController.m
//  iCampus
//
//  Created by Kwei Ma on 12/2/13.
//  Copyright (c) 2013 BISTU. All rights reserved.
//

#import "ICBusViewController.h"
#import "Model/SchoolBus/ICSchoolBus.h"

#define CELL_STOPS_MAINVIEW 1001

#define CELL_NORMAL_HEIGHT 72.0
#define CELL_EXPANDING_HEIGHT 120.0

@interface ICBusViewController ()

@property (strong, nonatomic) ICSchoolBusListArray *busLines;
@property (strong, nonatomic) NSMutableArray *busList;
//@property (strong, nonatomic) ICSchoolBusList *busList;

@property NSIndexPath *expandingIndexPath;

@property (strong, nonatomic) UILabel *loadingLabel;

@end

@implementation ICBusViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"NaviBackBtn.png"] style:UIBarButtonItemStylePlain target:self action:@selector(dismissMe:)];
    backBtn.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = backBtn;
    
    self.title = @"School Bus";
    
    // Init with the first row
    // It's obviously that it impossible to be (0,0) with a expanding cell
    //self.expandingIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    self.loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 100.0, 300.0, 20.0)];
    self.loadingLabel.textColor = [UIColor lightGrayColor];
    self.loadingLabel.textAlignment = NSTextAlignmentCenter;
    self.loadingLabel.font = [UIFont systemFontOfSize:14.0];
    [self.view addSubview:self.loadingLabel];
    
    // Get Bus Info
    //NSLog(@"1");
    //self.busList = [[ICSchoolBusList alloc] init];
    self.busList = [NSMutableArray array];
    //NSLog(@"2");
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //NSLog(@"3");
        self.busLines = [ICSchoolBusListArray array];
        //NSLog(@"4");
        if (self.busLines == nil) {
            NSLog(@"Fecth Bus Data Occur Error 1.");
            self.loadingLabel.text = @"Error Occurs : 1";
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                //NSLog(@"5");
                
                for (ICSchoolBusList *list in self.busLines) {
                    if (list != nil) {
                        [self.busList addObject:list];
                    } else {
                        NSLog(@"Fecth Bus Data Occur Error 2.");
                        self.loadingLabel.text = @"Error Occurs : 2";
                    }
                }
                
                [self.loadingLabel removeFromSuperview];
                [self.tableView reloadData];
                
                //self.busList = [self.busLines schoolBusListAtIndex:0];
            });
        }
    });
    //NSLog(@"8");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.busLines count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    ICSchoolBusList *buses = [self.busList objectAtIndex:section];
    if (self.expandingIndexPath == nil) {
        return [buses count];
    } else {
        return [buses count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = nil;
    if (self.expandingIndexPath.row != indexPath.row || self.expandingIndexPath == nil) {
        CellIdentifier = @"NormalCell";
    } else {
        CellIdentifier = @"ExpandingCell";
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //UITableViewCell *cell = nil;
    
    ICSchoolBusList *buses = [self.busList objectAtIndex:indexPath.section];
    
    if (self.expandingIndexPath.row != indexPath.row || self.expandingIndexPath == nil) {
        UILabel *busNameLabel = nil;
        UILabel *busDescLabel = nil;
        UILabel *departureTimeLabel = nil;
        //UILabel *returnTimeLabel = nil;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            UIView *selectedBg = [[UIView alloc] initWithFrame:cell.frame];
            selectedBg.backgroundColor = [UIColor colorWithRed:189/255.0 green:195/255.0 blue:199/255.0 alpha:1.0];
            cell.selectedBackgroundView = selectedBg;
            
            UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(18.0, 18.0, 36.0, 36.0)];
            icon.image = [UIImage imageNamed:@"BusCellIcon.png"];
            [cell.contentView addSubview:icon];
            
            busNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 14.0, 240.0, 24.0)];
            busNameLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
            busNameLabel.font = [UIFont systemFontOfSize:18.0];
            busNameLabel.tag = 1001;
            //busNameLabel.backgroundColor = [UIColor yellowColor];
            [cell.contentView addSubview:busNameLabel];
            
            busDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.0, 40.0, 160.0, 20.0)];
            busDescLabel.textColor = [UIColor grayColor];
            busDescLabel.font = [UIFont systemFontOfSize:14.0];
            busDescLabel.tag = 1004;
            //busDescLabel.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:busDescLabel];
            
            departureTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 40.0, 55.0, 20.0)];
            departureTimeLabel.textColor = [UIColor grayColor
                                            ];
            departureTimeLabel.font = [UIFont systemFontOfSize:16.0];
            departureTimeLabel.textAlignment = NSTextAlignmentLeft;
            departureTimeLabel.tag = 1002;
            //departureTimeLabel.backgroundColor = [UIColor redColor];
            [cell.contentView addSubview:departureTimeLabel];
            
            //returnTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(260.0, 38.0, 55.0, 20.0)];
            //returnTimeLabel.textColor = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0];
            //returnTimeLabel.font = [UIFont systemFontOfSize:16.0];
            //returnTimeLabel.textAlignment = NSTextAlignmentLeft;
            //returnTimeLabel.tag = 1003;
            //returnTimeLabel.backgroundColor = [UIColor redColor];
            //[cell.contentView addSubview:returnTimeLabel];
            
            UIImageView *deprIcon = [[UIImageView alloc] initWithFrame:CGRectMake(235.0, 40.0, 20.0, 20.0)];
            deprIcon.image = [UIImage imageNamed:@"SchoolBusTimeIcon.png"];
            [cell.contentView addSubview:deprIcon];
            //UIImageView *retnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(235.0, 38.0, 20.0, 20.0)];
            //retnIcon.image = [UIImage imageNamed:@"SchoolBusRetnIcon.png"];
            //[cell.contentView addSubview:retnIcon];
            
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 71.0, 320.0, 1.0)];
            line.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
            [cell.contentView addSubview:line];
        } else {
            busNameLabel = (UILabel *)[cell.contentView viewWithTag:1001];
            busDescLabel = (UILabel *)[cell.contentView viewWithTag:1004];
            departureTimeLabel = (UILabel *)[cell.contentView viewWithTag:1002];
            //returnTimeLabel = (UILabel *)[cell.contentView viewWithTag:1003];
        }
        
        ICSchoolBus *currBus = nil;
        if (self.expandingIndexPath != nil) {
            if (indexPath.row > self.expandingIndexPath.row) {
                currBus = [buses busAtIndex:indexPath.row -1 ];
            } else {
                currBus = [buses busAtIndex:indexPath.row];
            }
        } else {
            currBus = [buses busAtIndex:indexPath.row];
        }
        
        busNameLabel.text = currBus.name;
        busDescLabel.text = currBus.description;
        
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        departureTimeLabel.text = [dateFormatter stringFromDate:currBus.departureTime];
        //returnTimeLabel.text = [dateFormatter stringFromDate:currBus.returnTime];
        //departureTimeLabel.text = @"06:40";
        //returnTimeLabel.text = @"11:25";
        
    } else {
        UIScrollView *busStopView = nil;
        UIView *stops = nil;
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            
            busStopView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320.0, CELL_EXPANDING_HEIGHT)];
            busStopView.contentSize = CGSizeMake(640.0, busStopView.frame.size.height);
            busStopView.backgroundColor = [UIColor colorWithRed:236/255.0 green:240/255.0 blue:241/255.0 alpha:1.0];
            busStopView.tag = 2001;
            busStopView.showsHorizontalScrollIndicator = NO;
            [cell.contentView addSubview:busStopView];
            
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(155.0, 0, 10.0, 10.0)];
            arrow.image = [UIImage imageNamed:@"SchoolBusExpandingCellArrow.png"];
            [cell.contentView addSubview:arrow];
        } else {
            busStopView = (UIScrollView *)[cell.contentView viewWithTag:2001];
        }
        
        stops = [self stopsLayoutForExpandingCellWithBus:[buses busAtIndex:indexPath.row - 1]];
        busStopView.contentSize = CGSizeMake(stops.frame.size.width, CELL_EXPANDING_HEIGHT);
        UIView *older = [busStopView viewWithTag:CELL_STOPS_MAINVIEW];
        if (older) {
            [older removeFromSuperview];
        }
        [busStopView addSubview:stops];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.expandingIndexPath.row != indexPath.row || self.expandingIndexPath == nil) {
        // for expanding cell
        return 72.0;
    } else {
        // for normal cell
        return CELL_EXPANDING_HEIGHT;
    }
}

- (UIView *)stopsLayoutForExpandingCellWithBus:(ICSchoolBus *)bus
{
    CGFloat x=20.0;
    CGFloat y=0;
    CGFloat height = 100.0; // height of cell is 120.0. But need 20 padding
    CGFloat width = 120.0;
    
    ICSchoolBusStationList *stopList = bus.stationList;
    UIView *main = [[UIView alloc] initWithFrame:CGRectMake(10.0, 10.0, (width-10.0)*stopList.count+40.0, height)];
    main.tag = CELL_STOPS_MAINVIEW;
    
    UIImageView *deprIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 45.0, 20.0, 20.0)];
    deprIcon.image = [UIImage imageNamed:@"SchoolBusTimeIcon.png"];
    //UIImageView *retnIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10.0, 70.0, 20.0, 20.0)];
    //retnIcon.image = [UIImage imageNamed:@"SchoolBusRetnIcon.png"];
    [main addSubview:deprIcon];
    //[main addSubview:retnIcon];
    
    NSInteger count = stopList.count;
    for (int i=0; i<count; i++) {
        ICSchoolBusStation *stop = [stopList stationAtIndex:i];
        
        UIView *container = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
        
        UILabel *stopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 0, width - 20.0, 40.0)];
        UILabel *stopDeprLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 45.0, width - 20.0, 20.0)];
        //UILabel *stopRetnLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0, 70.0, width - 20.0, 20.0)];
        
        stopNameLabel.textAlignment = NSTextAlignmentCenter;
        stopDeprLabel.textAlignment = NSTextAlignmentCenter;
        //stopRetnLabel.textAlignment = NSTextAlignmentCenter;
        
        stopNameLabel.font = [UIFont systemFontOfSize:16.0];
        stopDeprLabel.font = [UIFont systemFontOfSize:14.0];
        //stopRetnLabel.font = [UIFont systemFontOfSize:14.0];
        
        stopNameLabel.textColor = [UIColor darkGrayColor];
        stopDeprLabel.textColor = [UIColor grayColor];
        //stopRetnLabel.textColor = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0];
        
        //stopNameLabel.backgroundColor = [UIColor yellowColor];
        //stopDeprLabel.backgroundColor = [UIColor colorWithRed:231/255.0 green:76/255.0 blue:60/255.0 alpha:1.0];
        //stopRetnLabel.backgroundColor = [UIColor colorWithRed:230/255.0 green:126/255.0 blue:34/255.0 alpha:1.0];
        container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SchoolBusContainerBg.png"]];
        if (i == 0) {
            container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SchoolBusContainerBgF.png"]];
        }
        if (i == count - 1) {
            container.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"SchoolBusContainerBgL.png"]];
        }
        
        stopNameLabel.numberOfLines = 2;
        
        NSDateFormatter *dateFormatter =[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"hh:mm"];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
        stopNameLabel.text = stop.name;
        stopDeprLabel.text = [dateFormatter stringFromDate:stop.time]==nil?@"-":[dateFormatter stringFromDate:stop.time];
        //stopRetnLabel.text = [dateFormatter stringFromDate:stop.returnTime];
        //stopDeprLabel.text = @"11:25";
        //stopRetnLabel.text = @"16:00";
        
        [container addSubview:stopNameLabel];
        [container addSubview:stopDeprLabel];
        //[container addSubview:stopRetnLabel];
        
        [main addSubview:container];
        x += 110.0;
    }
    
    return main;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.expandingIndexPath == nil) {
        self.expandingIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        
        [self.tableView insertRowsAtIndexPaths:@[self.expandingIndexPath] withRowAnimation:UITableViewRowAnimationTop];
    } else {
        if ((self.expandingIndexPath.row - 1) == indexPath.row) {
            self.expandingIndexPath = nil;
            NSIndexPath *delPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.tableView deleteRowsAtIndexPaths:@[delPath] withRowAnimation:UITableViewRowAnimationTop];
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        } else {
            NSIndexPath *delPath = self.expandingIndexPath.copy;
            self.expandingIndexPath = nil;
            [self.tableView deleteRowsAtIndexPaths:@[delPath] withRowAnimation:UITableViewRowAnimationNone];
            
            if (indexPath.row > delPath.row) {
                self.expandingIndexPath = [NSIndexPath indexPathForRow:(indexPath.row) inSection:indexPath.section];
            } else {
                self.expandingIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
            }
            [self.tableView insertRowsAtIndexPaths:@[self.expandingIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
    
    if (self.expandingIndexPath) {
        NSIndexPath *toPath = [NSIndexPath indexPathForRow:self.expandingIndexPath.row - 1 inSection:self.expandingIndexPath.section];
        [self.tableView scrollToRowAtIndexPath:toPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

#pragma mark - Additional Functions

- (void)dismissMe:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
