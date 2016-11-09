//
//  User.h
//  GCDdemo
//
//  Created by YI on 16/10/8.
//  Copyright © 2016年 Sandro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"
@interface User : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSDate *created;


@property(nonatomic,assign)NSNumber * age;
@property(nonatomic,strong)NSString * sex;
@property(nonatomic,strong)NSString * ID;

@end
