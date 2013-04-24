//
//  ProjectsViewController.h
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import <UIKit/UIKit.h>
#import "HomeViewController.h"

/*
#import "InfoViewController.h"
#import "MapViewController.h"
 */

#import "SettingController.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
/*
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "AOWaterView.h"
 */

#import "ProjectTableCell.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "ConfigDataSource.h"


@interface ProjectsViewController : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    /*
    UINavigationController *navLoginController;
    UINavigationController *navHomeController;
    UINavigationController *navInfoController;
    UINavigationController *navMapController;
     
    UITabBarController *tabBarController;
     */
    IBOutlet UIButton *reflashButton;
    NSMutableArray *projectList;
    ConfigDataSource *configDatas;
    UITableView *tableView;
    Boolean reflashDatas;
}

@property(retain, nonatomic) NSMutableArray *projectList;
@property(retain, nonatomic) IBOutlet UIButton *reflashButton;



- (void)addProject:(NSString *)projectId thumbImage:(NSString *)thumbImage projectTitle:(NSString *)projectTitle photoTime:(NSString *)photoTime;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSString *)getJsonFromUrl:(NSString *)url;
-(IBAction)onClickButton:(id)sender;

-(IBAction)settingConfig:(id)pressed;

@end
