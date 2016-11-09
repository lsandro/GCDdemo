//
//  OneViewController.m
//  GCDdemo
//
//  Created by YI on 16/10/7.
//  Copyright © 2016年 Sandro. All rights reserved.
//

#import "OneViewController.h"
#import "User.h"

@interface OneViewController ()

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    [self once];
//    [self once];
//    [self once];
//    [self once];
    //[self youxianji];
    
    NSDictionary*dict = @{@"name":@"Mitchell",@"age":@"10",@"sex":@"man",@"ID":@"aaa"};
    //MitchellModel *model = [MitchellModel modelWithDictionary:dict error:nil];
    User *user = [User yy_modelWithJSON:dict];
    NSLog(@"%@",user.age);
    NSLog(@"%@",user.sex);
    NSLog(@"%@",user.name);
    NSLog(@"%@",user.ID);
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dispatch_set_target_queue

- (void)youxianji{
    dispatch_queue_t serialDiapatchQueue = dispatch_queue_create("com.test.queue", NULL);
    dispatch_queue_t serialDiapatchQueue1 = dispatch_queue_create("com.test.queue", NULL);
    dispatch_queue_t dispatchgetglobalqueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0);
    dispatch_queue_t dispatchgetglobalqueue1 = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_set_target_queue(serialDiapatchQueue, dispatchgetglobalqueue);
    dispatch_set_target_queue(serialDiapatchQueue1, dispatchgetglobalqueue1);
    /*
     *将第一个参数的优先级（本来没有优先级）设为第二个参数（本来就有优先级）的优先级
     *通过打印的结果说明我们设置了queue1和queue2队列以targetQueue队列为参照对象，那么queue1和queue2中的任务将按照targetQueue的队列处理。
     dispatch_queue_t targetQueue = dispatch_queue_create("targetQueue", DISPATCH_QUEUE_SERIAL);//目标队列
     dispatch_queue_t queue1 = dispatch_queue_create("queue1", DISPATCH_QUEUE_SERIAL);//串行队列
     dispatch_queue_t queue2 = dispatch_queue_create("queue1", DISPATCH_QUEUE_CONCURRENT);//并发队列
     //设置参考
     dispatch_set_target_queue(queue1, targetQueue);
     dispatch_set_target_queue(queue2, targetQueue);
     
     
     http://www.jianshu.com/p/188d9bf62f23
     */
    dispatch_async(serialDiapatchQueue, ^{
        NSLog(@"我优先级低，先让让");
    });
    dispatch_async(serialDiapatchQueue1, ^{
        NSLog(@"我优先级最高,我第一个block");
    });
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"我优先级高,我先block");
    });
}

#pragma mark - 同步函数和串行队列
- (void)syncSerial {
    
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download1- %@", [NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download2- %@", [NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download3- %@", [NSThread currentThread]);
        
    });
    
}
#pragma mark - 同步函数和并发队列

- (void)syncConcurrent {
    
    // 创建队列
    /*
     第一个参数: C语言的字符串,标签
     第二个参数: 队列的类型
     */
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    
    // 定制任务(多任务)
    dispatch_sync(queue, ^{
        
        NSLog(@"download1- %@", [NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download2- %@", [NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download3- %@", [NSThread currentThread]);
        
    });   
}

#pragma mark - 异步函数和并发队列

- (void)asyncConcurrent {
    
    dispatch_queue_t queue = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    
    // 也可以获取全局并发队列,执行效果是一样的
    // dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    
    dispatch_async(queue, ^{
        
        NSLog(@"download1- %@", [NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        
        NSLog(@"download2- %@", [NSThread currentThread]);
        
    });
    dispatch_async(queue, ^{
        
        NSLog(@"download3- %@", [NSThread currentThread]);
        
    });
}

#pragma mark - 同步函数和主队列

- (void)syncMain {
    
    NSLog(@"---start---");
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download1- %@", [NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download2- %@", [NSThread currentThread]);
        
    });
    
    dispatch_sync(queue, ^{
        
        NSLog(@"download3- %@", [NSThread currentThread]);
        
    });
    
    NSLog(@"---end---");
    
}

#pragma mark - 异步函数和主队列

- (void)asyncMain {
    
    dispatch_queue_t queue = dispatch_get_main_queue();
    
    dispatch_async(queue, ^{
        
        NSLog(@"download1- %@", [NSThread currentThread]);
        
    });
    
    dispatch_async(queue, ^{
        
        NSLog(@"download2- %@", [NSThread currentThread]);
        
    });
    
    dispatch_async(queue, ^{
        
        NSLog(@"download3- %@", [NSThread currentThread]);
        
    });
    
}

#pragma mark - GCD 线程间通信
- (void)xiazai{
    // 开启子线程下载图片
    // dispatch_sync 和 dispatch_async 两者效果一样,因为是在子线程下载的
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 网络图片 url
        NSURL *url = [NSURL URLWithString:@"http://pic12.nipic.com/20110114/6621051_221433460330_2.jpg"];
        
        // 下载二进制数据到本地
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // 获取图片
        UIImage *image = [[UIImage alloc] initWithData:data];
        
        // 回到主线程刷新 UI 图片
        dispatch_async(dispatch_get_main_queue(), ^{
            self.imageView.image = image;
        });
        
    });
}

#pragma mark - delay 延迟操作
- (void)delay{
    NSLog(@"-----start-----");
    
    // 延迟方法 第一种
    [self performSelector:@selector(task) withObject:nil afterDelay:3.0];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"GCD1-%@", [NSThread currentThread]);
    });
    
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), queue, ^{
        NSLog(@"GCD2-%@", [NSThread currentThread]);
    });
    
    dispatch_queue_t queue1 = dispatch_queue_create("download", DISPATCH_QUEUE_CONCURRENT);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), queue1, ^{
        NSLog(@"GCD3-%@", [NSThread currentThread]);
    });
}

- (void)task {
    NSLog(@"task-%@", [NSThread currentThread]);
}

#pragma mark - once 一次性执行
- (void)once{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"once - %@", [NSThread currentThread]);
    });
}

#pragma mark - GCD 栅栏函数

- (void)zhalan{
    // 创建并发队列
    dispatch_queue_t queue = dispatch_queue_create("aaa", DISPATCH_QUEUE_CONCURRENT);
    
    // 异步函数
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; ++i) {
            NSLog(@"download1 - %@", [NSThread currentThread]);
        }
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; ++i) {
            NSLog(@"download2 - %@", [NSThread currentThread]);
        }
    });
    
    // 栅栏函数
    dispatch_barrier_async(queue, ^{
        NSLog(@"++++++++++++++++++++++++++++++++++++++++");
    });
    
    dispatch_async(queue, ^{
        for (int i = 0; i < 10; ++i) {
            NSLog(@"download3 - %@", [NSThread currentThread]);
        }
    });
}

#pragma mark - GCD 的 apply (快速迭代)

- (void)apply{
    NSDate* tmpStartData = [NSDate date];
    
    for (int i = 0; i < 10000; ++i) {
        NSLog(@"for- %d -- %@", i, [NSThread currentThread]);
    }
    
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"for 耗时 = %f", deltaTime);
    
    NSDate* tmpStartData1 = [NSDate date];
    
    /*
     第一个参数: 迭代次数
     第二个参数: 线程队列(并发队列)
     第三个参数: index 索引
     */
    dispatch_apply(10000, dispatch_get_global_queue(0, 0), ^(size_t index) {
        NSLog(@"GCD- %zd -- %@", index, [NSThread currentThread]);
    });
    
    double deltaTime1 = [[NSDate date] timeIntervalSinceDate:tmpStartData1];
    NSLog(@"GCD 耗时 = %f", deltaTime1);
}

#pragma mark - GCD 队列组

- (void)group{
    // 创建队列
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0);
    
    // 创建队列组
    dispatch_group_t group = dispatch_group_create();
    
    //队列组异步函数执行任务
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1 -- %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2 -- %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务3 -- %@", [NSThread currentThread]);
    });
    
    // 队列组拦截通知模块(内部本身是异步执行的,不会阻塞线程)
    dispatch_group_notify(group, queue, ^{
        NSLog(@"------队列租任务执行完毕-------");
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务4 -- %@", [NSThread currentThread]);
    });
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
