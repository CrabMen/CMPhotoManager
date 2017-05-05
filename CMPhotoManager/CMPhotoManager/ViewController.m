//
//  ViewController.m
//  CMPhotoManager
//
//  Created by CrabMan on 2017/5/5.
//  Copyright © 2017年 CrabMan. All rights reserved.
//

#import "ViewController.h"
#import "CMPhotoManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    
    button.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:button];
    
    
    [button addTarget:self action:@selector(saveImage:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)saveImage:(UIButton *)sender {
    CMPhotoManager *mgr = [CMPhotoManager new];
    [mgr saveImage:[UIImage imageNamed:@"comment_bar_at_icon_click"]];


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
