//
//  WKTextView.h
//  0824-test
//
//  Created by keke on 15/8/25.
//  Copyright (c) 2015年 keke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WKTextView : UITextView
@property(copy,nonatomic) NSString *placeholder;
@property(strong,nonatomic) UIColor *placeholderColor;
@property(assign,nonatomic) CGFloat  placeholderFont;
@property (nonatomic,assign) NSInteger  limitNum;
@property(copy,nonatomic)    NSString * limitTitle;

@property (nonatomic, assign) NSTextAlignment placeAlignment;
-(void)textViewContentDidChange:(UITextView *)textView;

- (void)setupPlaceholderFrame;

@end
