//
//  ICNewsDetailViewController.h
//  iCampus
//
//  Created by Kwei Ma on 13-11-11.
//  Copyright (c) 2013年 BISTU. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ICNews;

@interface ICNewsDetailViewController : UIViewController

@property (strong, nonatomic) ICNews *news;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
