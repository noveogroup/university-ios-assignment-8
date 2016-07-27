//
//  Repository.h
//  networking_example
//
//  Created by Menzarar on 25.07.16.
//  Copyright © 2016 noveo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Repository : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *lastCommiterAuthor;
@property (nonatomic, copy) NSString *lastCommitDate;

-(instancetype)initWithName:(NSString *)name;

-(instancetype)initWithName:(NSString *)name
         lastCommiterAuthor:(NSString *)lastCommiterAuthor
             lastCommitDate:(NSString *)lastCommitDate;

@end
