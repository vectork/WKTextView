//
//  WKTextView.m
//  0824-test
//
//  Created by keke on 15/8/25.
//  Copyright (c) 2015年 keke. All rights reserved.
//
#define COLOR_AT [UIColor blueColor]

#import "WKTextView.h"

@interface WKTextView()<UITextViewDelegate>

@property (strong,nonatomic) NSString * tmpStr;
@property (nonatomic,weak)   UILabel * PlaceholderLabel;
@end
@implementation WKTextView
-(instancetype)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if (self) {

        [self awakeFromNib];
    }
    return self;
    
}
-(instancetype)init{
    self=[super init];
    if (self) {

        [self awakeFromNib];
    }
    return self;
}


-(BOOL)checkAtWith:(NSString *)text{
    
    if ([text isEqualToString:@"@"]) {
        return YES;
    }
    
    return NO;
    
}
-(BOOL)checkSymbolWith:(NSString *)text{
    if ([self checkAtWith:text]) {
        return NO;
    }
    NSString *regex = @"(?=[\x21-\x7e]+)[^A-Za-z0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if([pred evaluateWithObject:text] || [text isEqualToString:@" "])
    {
        return YES;
    }else{
        return NO;
    }
    
}
-(void)checkAtAndSpecialSymbolWith:(NSString*)text range:(NSRange)range{
    
    NSMutableArray *locations=[NSMutableArray array];
    NSMutableArray *symbols=[NSMutableArray array];
    
    self.tmpStr=[NSString stringWithFormat:@"%@%@",self.text,text];
    if (![self checkSymbolWith:text]) {
        return;
    }
    [self checkATSymbolWith:locations :symbols];
    
}
-(void)checkATSymbolWith:(NSMutableArray*)locations :(NSMutableArray*)symbols{
    
    
    
    if (!self.font) {
        self.font = [UIFont systemFontOfSize:14];
    }
    if (!self.textColor) {
        self.textColor = [UIColor blackColor];
    }
    
    NSString * contentStr=self.tmpStr;
    for (NSInteger i= 0; i <contentStr.length ; i++) {
        NSString * tmpboldyStr=[contentStr substringWithRange:NSMakeRange(i, 1)];
        if ([self checkAtWith:tmpboldyStr]) {//存储所有 @ 位置
            [locations addObject:[NSNumber numberWithInteger:i]];
        }
    }
    
    if (locations.count>0) {
        for (NSInteger i= 0; i <locations.count ; i++) {
            NSInteger inter=[locations[i] integerValue];
            NSString * boldyStr=[self.tmpStr substringFromIndex:inter];
            for (NSInteger n = 0; n <boldyStr.length; n++) {
                NSString * tmpboldyStr=[boldyStr substringWithRange:NSMakeRange(n, 1)];
                if ([self checkSymbolWith:tmpboldyStr]) {//存储所有与 @对应的符号的位置
                    [symbols addObject:[NSNumber numberWithInteger:n+inter]];
                    break;
                }
            }
            
        }
        
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:self.text];
        
        if (symbols.count==0 || locations.count-symbols.count==1) {
            
            NSInteger at=[locations[locations.count-1] integerValue];
            NSDictionary *boldItalicAttributes = @{NSForegroundColorAttributeName: self.textColor};
            
            [attriString addAttributes:boldItalicAttributes range:NSMakeRange(at, self.text.length-at)];
            
            for (NSInteger i = 0 ; i < symbols.count; i ++) {
                
                NSInteger at=[locations[i] integerValue];
                NSInteger sym=[symbols[i] integerValue]-at;
                
                NSDictionary *boldItalicAttributes = @{
                                                        NSForegroundColorAttributeName:self.textColor};
                
                [attriString addAttributes:boldItalicAttributes range:NSMakeRange(at, sym)];
                
            }
            
            
        }else{
            for (NSInteger i = 0 ; i < symbols.count; i ++) {
                
                NSInteger at=[locations[i] integerValue];
                NSInteger sym=[symbols[i] integerValue]-at;
                NSDictionary *boldItalicAttributes = @{NSForegroundColorAttributeName:COLOR_AT};
                
                [attriString addAttributes:boldItalicAttributes range:NSMakeRange(at, sym)];
                
            }
        }
        
        [attriString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.text.length)];
        
        self.attributedText=attriString;

        
    }
}
#pragma mark PlaceholderLabel
- (void)awakeFromNib {
    [super awakeFromNib];
    self.delegate=self;


    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DidChange:) name:UITextViewTextDidChangeNotification object:self];
    
    float left=5,top=9,hegiht=14;
    
    UILabel*  PlaceholderLabel=[[UILabel alloc] initWithFrame:CGRectMake(left, top
                                                               , CGRectGetWidth(self.frame)-2*left, hegiht)];
    
    self.PlaceholderLabel=PlaceholderLabel;
    PlaceholderLabel.backgroundColor=[UIColor clearColor];
    PlaceholderLabel.numberOfLines=1;
    PlaceholderLabel.textColor=self.placeholderColor;
    [self addSubview:PlaceholderLabel];
    PlaceholderLabel.text=self.placeholder;
    
}

-(void)setPlaceholder:(NSString *)placeholder{
    if (placeholder.length == 0 || [placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    else
    _PlaceholderLabel.text=placeholder;
    _placeholder=placeholder;
    
    
}

-(void)DidChange:(NSNotification*)noti{
    
    if (self.placeholder.length == 0 || [self.placeholder isEqualToString:@""]) {
        _PlaceholderLabel.hidden=YES;
    }
    
    if (self.text.length > 0) {
        _PlaceholderLabel.hidden=YES;
    }
    else{
        _PlaceholderLabel.hidden=NO;
    }
    
    NSRange range =NSMakeRange(self.text.length, 0);
    NSString *text = [self.text substringWithRange:NSMakeRange(self.text.length-1, 1)];
    [self checkAtAndSpecialSymbolWith:text range:range];
}
-(void)textViewDidChange:(UITextView *)textView{
    
    [self textViewContentDidChange:textView];
}

-(void)textViewContentDidChange:(UITextView *)textView{
    
    if (!self.limitNum) {
        self.limitNum = NSIntegerMax;
    }
    NSString *toBeString = textView.text;
    // 键盘输入模式
    NSString *lang = [[UIApplication sharedApplication]textInputMode].primaryLanguage;
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textView markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > self.limitNum) {
                textView.text = [toBeString substringToIndex:self.limitNum];
     
                
                UIAlertController*alertController=[UIAlertController alertControllerWithTitle:@"提示"message:self.limitTitle preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:okAction];
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];

            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > self.limitNum) {
            textView.text = [toBeString substringToIndex:self.limitNum];
        
            
            UIAlertController*alertController=[UIAlertController alertControllerWithTitle:@"提示"message:self.limitTitle preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:okAction];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
            
            
        }
    }
}


- (void)setPlaceAlignment:(NSTextAlignment)placeAlignment {
    _placeAlignment = placeAlignment;
    self.PlaceholderLabel.textAlignment = placeAlignment;
}

- (void)setupPlaceholderFrame {
    float left=5,top=9,hegiht=14;
    self.PlaceholderLabel.frame = CGRectMake(left, top, CGRectGetWidth(self.frame)-2*left, hegiht);
}
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    self.PlaceholderLabel.textColor = placeholderColor;
    
}
-(void)setPlaceholderFont:(CGFloat)placeholderFont{
    _placeholderFont = placeholderFont;
    self.PlaceholderLabel.font = [UIFont systemFontOfSize:placeholderFont];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_PlaceholderLabel removeFromSuperview];
    
}
@end
