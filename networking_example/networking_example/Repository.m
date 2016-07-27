//
//  Repository.m
//  networking_example
//
//  Created by Menzarar on 25.07.16.
//  Copyright © 2016 noveo. All rights reserved.
//

#import "Repository.h"

@implementation Repository

-(instancetype)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

-(instancetype)initWithName:(NSString *)name
         lastCommiterAuthor:(NSString *)lastCommiterAuthor
             lastCommitDate:(NSString *)lastCommitDate
{
    self = [super init];
    if (self) {
        _name = name;
        _lastCommitDate = lastCommitDate;
        _lastCommiterAuthor = lastCommiterAuthor;
    }
    return self;
}


@end
