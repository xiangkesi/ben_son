//
//  CalendarController.h
//  TestInterface
//
//  Created by Snow WarLock on 2017/4/17.
//  Copyright © 2017年 Snow WarLock. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^CalendarControllerBlock)(NSDictionary *dic);
@interface CalendarController : UIViewController

@property(nonatomic ,copy) CalendarControllerBlock calendarControllerBlock;

@end
