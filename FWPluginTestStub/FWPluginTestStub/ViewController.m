//
//  ViewController.m
//  FWPluginTestStub
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "ViewController.h"
#import "TBZip.h"

typedef long (*cFunctionPtr)(void) ;
#define kBufferSize 4096


@interface ViewController ()<UITableViewDelegate , UITableViewDataSource>
{
    UITableView             *_tableView;
    NSArray                 *_contentArray;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"FWPluginTestStub";
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_tableView setDelegate:self];
    [_tableView setDataSource:self];
    [self.view addSubview:_tableView];
    _tableView.clipsToBounds = NO;
    
    _contentArray = @[@"1.load bundle from FWPluginTestStub.app",
                      @"2.load bundle from Server:localhost",
                      ];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return  1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_contentArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = nil;
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil){
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
	}
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = [_contentArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *methodStr = [NSString stringWithFormat:@"test%d",indexPath.row];
    SEL method = NSSelectorFromString(methodStr);
    [self performSelector:method withObject:nil];
}

#pragma mark - Common
- (void)testCFunction:(NSString*)bundlePath{
    NSLog(@">>>testCFunction start<<<<<<");
    NSURL *bundleURL = [NSURL fileURLWithPath:bundlePath];
    CFBundleRef cfBundle = CFBundleCreate(kCFAllocatorDefault, (__bridge CFURLRef)bundleURL);
    if (cfBundle) {
        // Function pointer.
        cFunctionPtr funPtr = NULL;
        
        // Get a pointer to the function.
        funPtr = (void*)CFBundleGetFunctionPointerForName(cfBundle, CFSTR("functionSayHello") );
        
        // If the function was found, call it with a test value.
        if (funPtr){
            funPtr();
        }
        
        CFRelease(cfBundle);
        cfBundle = NULL;
    }
    NSLog(@">>>testCFunction end<<<<<<");
}

- (void)testObjcMethod:(NSBundle*)bundle{
    
    NSLog(@">>>testObjcMethod start<<<<<<");
    Class PluginClass = [bundle principalClass];
    id instance = [[PluginClass alloc] init];
    [instance performSelector:@selector(sayHello) withObject:nil];
    
    PluginClass = [bundle classNamed:@"FWPluginClass"];
    instance = [[PluginClass alloc] init];
    [instance performSelector:@selector(sayHello) withObject:nil];
    NSLog(@">>>testObjcMethod end<<<<<<");

}

- (void)loadVCWithXibName:(NSString *)vcName bundle:(NSBundle*)bundle{
    Class cls = [bundle classNamed:vcName];
    //Class cls = NSClassFromString(vcName);
    NSLog(@">>>Class = %@",NSStringFromClass(cls));
    UIViewController* vc = [[cls alloc] initWithNibName:vcName bundle:bundle];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)loadVCWithOutXibName:(NSString *)vcName bundle:(NSBundle*)bundle{
    //Class cls = [bundle classNamed:vcName];
    Class cls = NSClassFromString(vcName);
    NSLog(@">>>Class = %@",NSStringFromClass(cls));
    UIViewController* vc = [[cls alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - load bundle from FWPluginTestStub.app
- (void)test0
{
    NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"FWPluginBundle.bundle"];
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSError *err = nil;
    if([bundle loadAndReturnError:&err]){
        [self testCFunction:bundlePath];
        [self testObjcMethod:bundle];
        //[self loadVCWithXibName:@"FWVCWithXib" bundle:bundle];
        [self loadVCWithOutXibName:@"FWVCWithoutXib" bundle:bundle];
    }else{
        NSLog(@">>>loadAndReturnError Error %@  %@",err, [err userInfo]);
    }
}

#pragma mark - load bundle from Server
- (void)test1{
    NSString* bundlePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"FWPluginBundle.bundle"];
    [[NSFileManager defaultManager] removeItemAtPath:bundlePath  error:nil];
    if (![[NSFileManager defaultManager] fileExistsAtPath:bundlePath]) {
        NSData  *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://localhost/FWPluginBundle.bundle.zip"]];
        NSString *zipPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"DownloadBundle.zip"];
        [data writeToFile:zipPath atomically:YES];
        [ViewController unzipFilePath:zipPath toPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]];
    }
    
    
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    NSError *err = nil;
    if([bundle loadAndReturnError:&err]){
        [self testObjcMethod:bundle];
        //[self loadVCWithXibName:@"FWVCWithXib" bundle:bundle];
        [self loadVCWithOutXibName:@"FWVCWithoutXib" bundle:bundle];
    }else{
        NSLog(@">>>loadAndReturnError Error %@  %@",err, [err userInfo]);
    }
}


#pragma mark - Util
/**
 *  解压zip文件到指定目录
 *
 *  @param zipFilePath zip压缩文件所在路径
 *  @param path        解压后文件位置
 *
 *  @return 是否成功
 */
+ (BOOL)unzipFilePath:(NSString *)zipFilePath toPath:(NSString *)path{
    if (zipFilePath==nil || path ==nil){
		return NO;
	}
	
	BI_UnzFile unzSkinFile = BIUnzOpen((const char*)[zipFilePath UTF8String]);
	if(!unzSkinFile){
        return NO;
	}
    
	int ret = BIUnzGoToFirstFile(unzSkinFile);
	if(kUnzOK != ret){
        return NO;
	}
    
    unsigned char  buffer[kBufferSize] = {0};
    NSFileManager* defautFileManager   = [NSFileManager   defaultManager];
	do {
        ret = BIUnzOpenCurrentFile(unzSkinFile);
		if(kUnzOK != ret){
			break;
		}
        
		BI_UnzFileInfo fileInfo = {0};
		ret = BIUnzGetCurrentFileInfo(unzSkinFile, &fileInfo, NULL, 0, NULL, 0, NULL, 0);
		if(kUnzOK != ret){
			BIUnzCloseCurrentFile(unzSkinFile);
			break;
		}
        
		char* filename = (char*)malloc(fileInfo.size_filename +1);
		BIUnzGetCurrentFileInfo(unzSkinFile, &fileInfo, filename, fileInfo.size_filename + 1, NULL, 0, NULL, 0);
		filename[fileInfo.size_filename] = '\0';
		
        NSString* filePath = [NSString stringWithCString:filename encoding:NSUTF8StringEncoding];
        if(NSNotFound != [filePath rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"\\"]].location){
			filePath = [filePath stringByReplacingOccurrencesOfString:@"\\" withString:@"/"];
		}
        
        BOOL isDirectory = [[filePath substringFromIndex:filePath.length - 1] isEqualToString:@"/"];
        filePath = [path stringByAppendingPathComponent:filePath];
        free(filename);
        
        
        if ([defautFileManager fileExistsAtPath:filePath isDirectory:nil]){ //Always overwrite the file
            [defautFileManager removeItemAtPath:filePath error:nil];
        }
        
        if (isDirectory){
            [defautFileManager createDirectoryAtPath:filePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        else{
            [defautFileManager createDirectoryAtPath:[filePath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil];
            
            FILE* fp = fopen((const char*)[filePath UTF8String], "wb");
            while(fp){
                int read = BIUnzReadCurrentFile(unzSkinFile, buffer, kBufferSize);
                if(read > 0){
                    fwrite(buffer, read, 1, fp);
                }
                else{
                    break;
                }
            }
            
            if(fp){
                fclose(fp);
                
                NSCalendar*       gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
                NSDateComponents* dateComponents    = [[NSDateComponents alloc] init];
                dateComponents.second = fileInfo.tmu_date.tm_sec;
                dateComponents.minute = fileInfo.tmu_date.tm_min;
                dateComponents.hour   = fileInfo.tmu_date.tm_hour;
                dateComponents.day    = fileInfo.tmu_date.tm_mday;
                dateComponents.month  = fileInfo.tmu_date.tm_mon + 1;
                dateComponents.year   = fileInfo.tmu_date.tm_year;
                NSDate* modificationDate = [gregorianCalendar dateFromComponents:dateComponents];
                //                [dateComponents    release];
                //                [gregorianCalendar release];
                
                NSDictionary* attributes = [NSDictionary dictionaryWithObject:modificationDate forKey:NSFileModificationDate];
                [[NSFileManager defaultManager] setAttributes:attributes ofItemAtPath:filePath error:nil];
            }
        }
        
		BIUnzCloseCurrentFile(unzSkinFile);
		ret = BIUnzGoToNextFile(unzSkinFile);
	} while(ret == kUnzOK && ret != kUnzEndOfListOfFile);
    return kUnzOK == BIUnzClose(unzSkinFile) && kUnzEndOfListOfFile == ret;
}

@end
