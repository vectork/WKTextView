//
//  ViewController.m
//  WKTextView_@
//
//  Created by keke on 2017/3/9.
//  Copyright © 2017年 keke. All rights reserved.
//
#define DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define DEVICE_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#import "ViewController.h"
#import "WKTextView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKTextView * textView = [[WKTextView alloc]initWithFrame:CGRectMake(10, 50, DEVICE_WIDTH - 20, DEVICE_HEIGHT - 100)];
    
    textView.backgroundColor = [UIColor whiteColor];
    textView.layer.borderWidth = 1;
    textView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.5].CGColor;
    textView.textColor = [UIColor blackColor];
      textView.font = [UIFont systemFontOfSize:14];

    textView.placeholder = @"我就是个placeholder";
    textView.placeholderColor = [UIColor lightGrayColor];
    textView.placeholderFont = 14.f;
    
    textView.limitNum = 100;
    textView.limitTitle = @"超出字符限制";
    textView.placeAlignment = NSTextAlignmentLeft;
    
    
    [self.view addSubview:textView];
    
    
   
}


@end
