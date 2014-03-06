//
//  FWVCWithoutXib.m
//  FWPluginBundle
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWVCWithoutXib.h"
#import "FWChildVC.h"

@interface FWVCWithoutXib ()
{
    UITextView *_textView;
}
@end

@implementation FWVCWithoutXib

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
	// Do any additional setup after loading the view.
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, 280, 300)];
    _textView.text = @"just test create viewController without xib. Loading Objective-C Classes \
    If you are writing a Cocoa application, you can load the code for an entire class using the methods of NSBundle. The NSBundle methods for loading a class are for use with Objective-C classes only and cannot be used to load classes written in C++ or other object-oriented languages. \
    If a loadable bundle defines a principal class, you can load it using the principalClass method of NSBundle. The principalClass method uses the NSPrincipalClass key of the bundle’s Info.plist file to identify and load the desired class. Using the principal class alleviates the need to agree on specific naming conventions for external classes, instead letting you focus on the behavior of those interfaces. For example, you might use an instance of the principal class as a factory for creating other relevant objects. \
    If you want to load an arbitrary class from a loadable bundle, call the classNamed: method of NSBundle. This method searches the bundle for a class matching the name you specify. If the class exists in the bundle, the method returns the corresponding Class object, which you can then use to create instances of the class.";
    [self.view addSubview:_textView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setFrame:CGRectMake(60, 10, 200, 40)];
    [button setTitle:@"go to next VC" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Pressed
- (void)buttonPressed:(id)sender{
    FWChildVC * vc = [[FWChildVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
