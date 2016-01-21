//
//  ViewController.m
//  Runtime_test
//
//  Created by neusoftliang on 16/1/21.
//  Copyright © 2016年 neusoftliang. All rights reserved.
//

#import "ViewController.h"
#import <objc/objc-runtime.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label_test;
@property (strong,nonatomic) UIColor* blue_color;
@end

@implementation ViewController

-(UIColor *)blue_color
{
    if (_blue_color==nil) {
        _blue_color = [UIColor blueColor];
    }
    return _blue_color;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label_test.backgroundColor = self.blue_color;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendMessage:(id)sender {
    objc_msgSend(self,@selector(labelMethod_bg));
}
- (IBAction)addAcc:(id)sender {
    //①动态获取类中的所有属性[当然包括私有]
    unsigned int count = 0;
    Ivar *ivar = class_copyIvarList([self class], &count);
    //②遍历属性找到对应字段
    for (int i=0;i<count;i++) {
        Ivar var = ivar[i];
        const char *get_name = ivar_getName(var);
        NSString *name = [NSString stringWithUTF8String:get_name];
        if ([name isEqualToString:@"_blue_color"]) {
            //③修改对应的字段值
            object_setIvar(self, var, [UIColor yellowColor]);
            break;
        }
    }
    
    self.label_test.backgroundColor = self.blue_color;
}
- (IBAction)changeMethod:(id)sender {
    Method m1 = class_getInstanceMethod([self class], @selector(labelMethod_text));
    Method m2 = class_getInstanceMethod([self class], @selector(labelMethod_bg));
    method_exchangeImplementations(m2, m1);
    [self labelMethod_bg];
}
- (IBAction)addProperty:(id)sender {
}
-(void)labelMethod_bg
{
    self.label_test.backgroundColor = [UIColor redColor];
}
-(void)labelMethod_text
{
    self.label_test.backgroundColor = [UIColor orangeColor];
    self.label_test.text = @"orange";
}
@end
