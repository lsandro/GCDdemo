//
//  TwoViewController.m
//  GCDdemo
//
//  Created by YI on 16/10/7.
//  Copyright © 2016年 Sandro. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController (){
    NSOperationQueue *queue1;
}

@end

@implementation TwoViewController
__weak id reference = nil;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //[self depend];
    for (int i = 0; i < 10000; ++i) {
        @autoreleasepool {
            NSString *str = @"Abc";
            str = [str lowercaseString];
            str = [str stringByAppendingString:@"xyz"];
            
            NSLog(@"%@", str);
        }
    }

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear-%@", reference); // Console: sunnyxx
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear-%@", reference); // Console: (null)
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    NSLog(@"viewDidDisappear-%@", reference); // Console: (null)
}

#pragma mark - NSInvocationOperation

- (void)InvocationOperation{
    // 创建操作并封装任务
    NSInvocationOperation *op1 = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(task) object:nil];
    
    // 启动操作
    [op1 start];
}

- (void)task {
    NSLog(@"%s--%@", __func__, [NSThread currentThread]);
}

#pragma mark - NSBlockOperation

- (void)BlockOperation {
    // 创建操作
    NSBlockOperation *bop1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1--%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *bop2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2--%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *bop3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3--%@", [NSThread currentThread]);
    }];
    
    // 追加任务
    [bop3 addExecutionBlock:^{
        NSLog(@"4--%@", [NSThread currentThread]);
    }];
    
    [bop3 addExecutionBlock:^{
        NSLog(@"5--%@", [NSThread currentThread]);
    }];
    
    [bop3 addExecutionBlock:^{
        NSLog(@"6--%@", [NSThread currentThread]);
    }];
    
    // 启动
    [bop1 start];
    [bop2 start];
    [bop3 start];
    

}

#pragma mark - NSBlockOperation 配合 NSOperationQueue 使用

- (void)NSOperationQueue{
    // 创建操作
    NSBlockOperation *bop1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"1--%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *bop2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"2--%@", [NSThread currentThread]);
    }];
    
    NSBlockOperation *bop3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"3--%@", [NSThread currentThread]);
    }];
    
    // 创建队列
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    // 添加操作到队列,  内部已经调用了 start 方法
    [queue addOperation:bop1];
    [queue addOperation:bop2];
    [queue addOperation:bop3];
    
    // 追加任务
    [bop2 addExecutionBlock:^{
        NSLog(@"4--%@", [NSThread currentThread]);
    }];
    
    [bop2 addExecutionBlock:^{
        NSLog(@"5--%@", [NSThread currentThread]);
    }];
    
    [bop2 addExecutionBlock:^{
        NSLog(@"6--%@", [NSThread currentThread]);
    }];
}

#pragma mark - 最大并发数

- (void)addOperationWithBlock
{
    queue1 = [[NSOperationQueue alloc]init];
    
    queue1.maxConcurrentOperationCount = 4;//最小为1，等于1的时候串行队列，
    
    [queue1 addOperationWithBlock:^{
        NSLog(@"-------1------%@",[NSThread currentThread]);
    }];
    
    [queue1 addOperationWithBlock:^{
        NSLog(@"-------2------%@",[NSThread currentThread]);
    }];
    
    [queue1 addOperationWithBlock:^{
        NSLog(@"-------3------%@",[NSThread currentThread]);
        
        
    }];
    
    
    [queue1 addOperationWithBlock:^{
        NSLog(@"-------14------%@",[NSThread currentThread]);
    }];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //暂停任务，当调用suspended或者cancelAllOperations都会把当前任务执行完然后再暂停或者取消
    if (queue1.isSuspended) {
        queue1.suspended = NO;
    }else{
        queue1.suspended = YES;
    }
    //    [self.queue cancelAllOperations];
}

#pragma mark - 操作的监听\操作依赖

- (void)depend{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    
    NSBlockOperation *op1 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"________第一个任务%@____",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op2 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"________第二个任务%@____",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op3 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"________第三个任务%@____",[NSThread currentThread]);
    }];
    
    NSBlockOperation *op4 = [NSBlockOperation blockOperationWithBlock:^{
        NSLog(@"________第四个任务%@____",[NSThread currentThread]);
    }];
    
    //op4完成后回调
    op4.completionBlock = ^{
        NSLog(@"________第四个");
    };
    //设置依赖
    [op2 addDependency:op1];
    [op3 addDependency:op2];
    [op4 addDependency:op3];
    
    //添加任务到队列中
    [queue addOperation:op1];
    [queue addOperation:op2];
    [queue addOperation:op3];
    [queue addOperation:op4];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
