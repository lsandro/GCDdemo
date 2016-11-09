//
//  ViewController.m
//  GCDdemo
//
//  Created by YI on 16/10/7.
//  Copyright © 2016年 Sandro. All rights reserved.
//

#import "ViewController.h"
#import "OneViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)nextAc:(id)sender {
    OneViewController *oneVc = [[OneViewController alloc] init];
    [self.navigationController pushViewController:oneVc animated:YES];
}
@end
