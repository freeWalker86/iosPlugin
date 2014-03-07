//
//  FWChildVC.m
//  FWPluginBundle
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWChildVC.h"

@interface FWChildVC ()

@end

@implementation FWChildVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor grayColor];
    UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 280, 60)];
    textView.text = @"child view controller ";
    [self.view addSubview:textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(60, 180, 200, 40)];
    [button setTitle:@"send notification" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hostAppNotification:) name:@"kHostAppNotification" object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - logic
- (void)buttonPressed:(id)sender{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"kPluginBundleNotification" object:@"bundle value"];
}

- (void)hostAppNotification:(NSNotification*)notification{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"notification frome host app" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles: nil];
    [alertView show];
}

@end
