//
//  FWStaticLibrary.m
//  FWStaticLibrary
//
//  Created by lv on 14-3-6.
//  Copyright (c) 2014年 FW. All rights reserved.
//

#import "FWStaticLibrary.h"

@implementation FWStaticLibrary
+ (void)staticLibraryClassMethodSayHello{
    NSLog(@">>>FWStaticLibrary  ClassMethodSayHello");
}

- (void)staticLibraryIntanceMethodSayHello{
    NSLog(@">>>FWStaticLibrary  IntanceMethodSayHello");
}
@end
