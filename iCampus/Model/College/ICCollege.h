//
//  ICCollege.h
//  iCampus-iOS-API
//
//  Created by Darren Liu on 13-11-8.
//  Copyright (c) 2013年 Darren Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ICCollegeList.h"

@interface ICCollege : NSObject

@property (nonatomic)       NSUInteger  index;
@property (nonatomic, copy) NSString   *name ;
@property (nonatomic, copy) NSString   *mark ;

@end

#import "ICCollegeDetail.h"
