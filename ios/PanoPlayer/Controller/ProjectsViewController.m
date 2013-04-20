//
//  ProjectsViewController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-17.
//
//

#import "ProjectsViewController.h"

@interface ProjectsViewController ()

@end

@implementation ProjectsViewController

@synthesize reflashButton;
@synthesize projectList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIBarButtonItem *rightItemBar = [[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settingConfig:)];
    self.navigationItem.rightBarButtonItem = rightItemBar;
        //NSLog(@"responseData=%@", responseData);
    [self getProjectList];
}

-(void)getProjectList{
    
    projectList = [[NSMutableArray alloc] init];
    
    NSString *mid = [self getUserInfo];
    NSLog(@"mid=%@", mid);
    NSString *ProjectListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pu/id/%@", mid];
    NSString *responseData = [self getJsonFromUrl:ProjectListUrl];
    
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        NSArray *panos = [resultsDictionary objectForKey:@"project"];
        for(int i=0; i<panos.count; i++){
            NSDictionary  *tmp = [panos objectAtIndex:i];
            NSString *projectId = [tmp objectForKey:@"id"];
            NSString *projectTitle = [tmp objectForKey:@"title"];
            NSString *projectCreated = [tmp objectForKey:@"created"];
            NSString *projectThumb = [tmp objectForKey:@"thumb"];
            [self addProject:projectId thumbImage:projectThumb projectTitle:projectTitle photoTime:projectCreated];
        }
    }
    
}




//返回UITableView共几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [projectList count];
}

//UITableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//和ChatViewCell.xib中的设置一致，这样才会完全重合
	return 110.0;
}

//该方法在UITableView显示一行时自动被调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.reflashButton.hidden = YES;
	//必须和在ChatViewCell.xib中的设置一致（也可以不一致，但UITableViewCell的重用机制将无效）
	static NSString * cellIdentifier = @"CellIdentifier";
	
	//该方法第一次调用时返回nil(因为程序刚开始运行时并没有可以重用的UITableViewCell)
	ProjectTableCell * cell = (ProjectTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		//加载ChatViewCell.xib
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"ProjectTableCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
		//选中时呈蓝色高亮
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		//[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
	
	NSUInteger row = [indexPath row];
	NSMutableDictionary * project = [projectList objectAtIndex:row];
    NSString *path = [project objectForKey:@"thumbImage"];
    NSLog(@"path=%@", path);
    //[cell.thumbImage setImage:[UIImage imageNamed:[pano objectForKey:@"thumbImage"]]];
    [cell.thumbImage setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    //NSLog(@"bbbb=%@", [pano objectForKey:@"thumbImage"]);
    cell.projectTitle.text = [project objectForKey:@"projectTitle"];
	cell.photoTime.text = [project objectForKey:@"photoTime"];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //NSLog(@"aaaaaaaaaaa");
    NSDictionary *projectInfo = [projectList objectAtIndex:indexPath.row];
    NSString *projectId = [projectInfo objectForKey:@"projectId"];
    //NSString *panoTitle = [panoInfo objectForKey:@"panoTitle"];
    //NSLog(@"idddd=%@", projectId);
    [self showTab:projectId];
    
}

- (void)addProject:(NSString *)projectId thumbImage:(NSString *)thumbImage projectTitle:(NSString *)projectTitle photoTime:(NSString *)photoTime{
    
    NSMutableDictionary * project = [[NSMutableDictionary alloc] init];
    [project setValue:projectId forKey:@"projectId"];
    [project setValue:projectTitle forKey:@"projectTitle"];
    [project setValue:photoTime forKey:@"photoTime"];
    [project setValue:thumbImage forKey:@"thumbImage"];
    
    [projectList addObject:project];
}

- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


- (NSString *)getJsonFromUrl:(NSString *)url{
    if(url == nil){
        [self getWrong:@"参数错误"];
        return @"";
    }
    NSString *responseData = [[NSString alloc] init];
    
    ASIDownloadCache *cache = [[ASIDownloadCache alloc] init];
    
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //NSString *path = [cachePath stringByAppendingPathComponent:@"Caches"];
    
    [cache setStoragePath:[cachePath stringByAppendingPathComponent:@"Caches"]];
    
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    [request setDownloadCache:cache];
    
    [request setCacheStoragePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
    [cache setShouldRespectCacheControlHeaders:NO];
    //[]
    [request setSecondsToCache:60*60*24*30*10]; //30
    
    [request startSynchronous];
    
    NSError *error = [request error];
    if (!error) {
        responseData = [request responseString];
        //NSLog(@"response%@", responseData);
    }
    else {
        [self getWrong:@"获取数据失败"];
    }
    
    
    return responseData;
}


-(NSString *) getUserInfo{
    NSString *mid = @"1";
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *path=[paths objectAtIndex:0];
    NSString *filename=[path stringByAppendingPathComponent:@"userInfo.plist"];
    
    //读文件
    NSDictionary* userInfo = [NSDictionary dictionaryWithContentsOfFile:filename];
    //NSLog(@"dic is:%@",userInfo);
    if(userInfo != nil){
        mid = [userInfo objectForKey:@"mid"];
    }
    return mid;
}

//-(void)

-(void)showTab:(NSString *)projectId{
        
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"首页" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    HomeViewController *homeView = [[HomeViewController alloc] init];
    
    homeView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:homeView animated:YES];
    
    NSString *projectTitle = @"";
    
    for (int i=0; i<projectList.count; i++) {
        NSDictionary  *tmp = [projectList objectAtIndex:i];
        NSString *projectId_tmp = [tmp objectForKey:@"projectId"];
        if([projectId isEqualToString:projectId_tmp]){
            projectTitle = [tmp objectForKey:@"projectTitle"];
        }
    }
    
    NSMutableDictionary * project = [[NSMutableDictionary alloc] init];
    [project setValue:projectId forKey:@"projectId"];
    [project setValue:projectTitle forKey:@"projectTitle"];
    
    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"projectId" object:nil userInfo:project];
    
    [homeView release];
}

-(IBAction)onClickButton:(id)sender{
    
    [self.view removeFromSuperview];
    ProjectsViewController *projectView = [[ProjectsViewController alloc] init];
    projectView.title = @"首页";
    [self.navigationController pushViewController:projectView animated:(YES)];
    
}

-(IBAction)settingConfig:(id)sender{
    [self.view removeFromSuperview];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;	// Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    
    SettingController *settingView = [[SettingController alloc] init];
    settingView.title = @"设置";
    [self.navigationController pushViewController:settingView animated:(YES)];
}


@end
