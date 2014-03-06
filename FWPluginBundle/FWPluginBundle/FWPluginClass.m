//
//  FWPluginClass.m
//  FWPluginBundle
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWPluginClass.h"
#import "FWStaticLibrary.h"
#import "FWTestStaticFramework.h"

@implementation FWPluginClass
- (void)sayHello{
    NSLog(@">>>FWPluginClass  hello!");
    FWStaticLibrary *objLib = [[FWStaticLibrary alloc]init];
    [objLib staticLibraryIntanceMethodSayHello];
    [FWStaticLibrary staticLibraryClassMethodSayHello];
    
    FWTestStaticFramework *objFw = [[FWTestStaticFramework alloc] init];
    [objFw staticFrameworkIntanceMethodSayHello];
    [FWTestStaticFramework staticFrameworkClassMethodSayHello];
}
@end
