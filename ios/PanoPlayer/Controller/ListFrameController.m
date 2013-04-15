//
//  ListFrameController.m
//  PanoPlayer
//
//  Created by yiluhao on 13-4-15.
//
//

#import "ListFrameController.h"
//#import "HomeViewController.h"
#import "PlayerViewController.h"

@interface ListFrameController ()

@end

@implementation ListFrameController

@synthesize imageProgressIndicator;
@synthesize panoList;
@synthesize panoListUrl;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame: frame])) {
        
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.cornerRadius = 10;    //设置弹出框为圆角视图
        self.layer.masksToBounds = YES;
        self.layer.borderWidth = 3;   //设置弹出框视图边框宽度
        self.layer.borderColor = [[UIColor colorWithRed:0.10 green:0.10 blue:0.10 alpha:0.5] CGColor];   //设置弹出框边框颜色
        self.autoresizesSubviews = YES;
        
        int width = frame.size.width-10;
        int height = frame.size.height-30;
        
        tableView = [[UITableView alloc] initWithFrame: CGRectMake(5, 20, width, height)];
        tableView.delegate = self;
        tableView.dataSource = self;
        
    }
    CGSize result = frame.size;
    width = result.width-35;
    
    panoId = [[self getProjectId] intValue];
    panoListUrl = [NSString stringWithFormat:@"http://mb.yiluhao.com/ajax/m/pl/id/%d", panoId];
    [self getPanoInfo];
    //NSLog(@"ADF%@", @"SDFSADF");
    [self addSubview:tableView];
    [self setCloseButton];
    return self;
}

-(void) setCloseButton{
    closeBt = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [closeBt setFrame:CGRectMake(width, -5, 40, 40)];
    
    //设置button标题
    [closeBt setTitle:@"关闭" forState:UIControlStateNormal];
    [closeBt setImage:[UIImage imageNamed:@"winclose.png"] forState:UIControlStateNormal];
    [closeBt addTarget:self action:@selector(onClickButton:) forControlEvents:UIControlEventTouchUpInside];
    closeBt.tag = 1;
    [self addSubview:closeBt];
}
-(IBAction)onClickButton:(id)sender{
    [self removeFromSuperview];
}

-(void) getPanoInfo{
    
    panoList = [[NSMutableArray alloc] init];
	
	NSString *responseData = [self getJsonFromUrl:panoListUrl];
    if(responseData !=nil){
        NSDictionary *resultsDictionary = [responseData objectFromJSONString];
        NSArray *panos = [resultsDictionary objectForKey:@"panos"];
        for(int i=0; i<panos.count; i++){
            NSDictionary  *tmp = [panos objectAtIndex:i];
            NSString *panoId = [tmp objectForKey:@"id"];
            NSString *panoTitle = [tmp objectForKey:@"title"];
            NSString *panoCreated = [tmp objectForKey:@"created"];
            NSString *panoThumb = [tmp objectForKey:@"thumb"];
            //NSLog(@"panoTilet=%@", panoThumb);
            [self addPano:panoId thumbImage:panoThumb panotitle:panoTitle photoTime:panoCreated];
        }
    }
}


-(NSString *)getProjectId{
    
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *plistPath1 = [paths objectAtIndex:0];
    
    NSString *filename=[plistPath1 stringByAppendingPathComponent:@"project_list.plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:filename];
    
    NSString *project_id = [data objectForKey:@"project_id"];
    if (project_id == nil) {
        //[self showLogin];
        project_id = @"1001";
    }
    return project_id;
}

//返回UITableView共几行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [panoList count];
}

//UITableView行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//和ChatViewCell.xib中的设置一致，这样才会完全重合
	return 85.0;
}

//该方法在UITableView显示一行时自动被调用
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//必须和在ChatViewCell.xib中的设置一致（也可以不一致，但UITableViewCell的重用机制将无效）
	static NSString * cellIdentifier = @"CellIdentifier";
	//该方法第一次调用时返回nil(因为程序刚开始运行时并没有可以重用的UITableViewCell)
	HomeTableCell * cell = (HomeTableCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	if (cell == nil)
	{
		//加载ChatViewCell.xib
        NSArray * array = [[NSBundle mainBundle] loadNibNamed:@"HomeTableCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
		//选中时呈蓝色高亮
		[cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
		//[cell setSelectionStyle:UITableViewCellSelectionStyleGray];
	}
	
	NSUInteger row = [indexPath row];
	NSMutableDictionary * pano = [panoList objectAtIndex:row];
    NSString *path = [pano objectForKey:@"thumbImage"];
    //NSLog(@"path=%@", path);
    //[cell.thumbImage setImage:[UIImage imageNamed:[pano objectForKey:@"thumbImage"]]];
    [cell.thumbImage setImageWithURL:[NSURL URLWithString:path] placeholderImage:[UIImage imageNamed:@"loading.gif"]];
    //NSLog(@"bbbb=%@", [pano objectForKey:@"thumbImage"]);
    cell.panoTitle.text = [pano objectForKey:@"panoTitle"];
	cell.photoTime.text = [pano objectForKey:@"photoTime"];
	
	return cell;
	
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *panoInfo = [panoList objectAtIndex:indexPath.row];
    NSString *panoId = [panoInfo objectForKey:@"panoId"];
    
    PlayerViewController *playerView = [[PlayerViewController alloc] init];
    
    NSDictionary *dic=[[NSDictionary alloc] initWithObjectsAndKeys:panoId,@"panoId", nil];
    
    //发送消息.@"pass"匹配通知名，object:nil 通知类的范围
    [[NSNotificationCenter defaultCenter] postNotificationName:@"panoId" object:nil userInfo:dic];
    [self removeFromSuperview];
    self.hidden = YES;
    [playerView release];
    
}

- (void)addPano:(NSString *)panoId thumbImage:(NSString *)thumbImage panotitle:(NSString *)panoTitle photoTime:(NSString *)photoTime{
    
    NSMutableDictionary * pano = [[NSMutableDictionary alloc] init];
    [pano setValue:panoId forKey:@"panoId"];
    [pano setValue:panoTitle forKey:@"panoTitle"];
    [pano setValue:photoTime forKey:@"photoTime"];
    [pano setValue:thumbImage forKey:@"thumbImage"];
    
    [panoList addObject:pano];
}
- (void) getWrong:(NSString*)str{
    NSString *msg = [NSString stringWithFormat:@"%@", str];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    [alert release];
}


/**
 获取全景图信息列表
 */

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

@end
