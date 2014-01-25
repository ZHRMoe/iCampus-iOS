//
//  ICControllerConfig.h
//  iCampus
//
//  Created by Darren Liu on 13-12-19.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import "../ICConfig.h"

//=====================================================================

#   pragma mark - Debug options

#   define IC_CONTROLLER_MODULE_DEBUG
#   ifdef IC_CONTROLLER_MODULE_DEBUG
#       define IC_YELLOWPAGE_DIAL_MODULE_DEBUG
#   endif

//=====================================================================

#   pragma mark - Segue identifiers

static const NSString *ICNewsListToChannelIdentifier          = @"IC_NEWS_LIST_TO_CHANNEL"         ;
static const NSString *ICNewsListToDetailIdentifier           = @"IC_NEWS_LIST_TO_DETAIL"          ;
static const NSString *ICSchoolListToDetailIdentifier         = @"IC_SCHOOL_LIST_TO_DETAIL"        ;
static const NSString *ICYellowPageDepartmentToListIdentifier = @"IC_YELLOWPAGE_DEPARTMENT_TO_LIST";

//=====================================================================