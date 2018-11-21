//
//  CalendarController.m
//  TestInterface
//
//  Created by Snow WarLock on 2017/4/17.
//  Copyright © 2017年 Snow WarLock. All rights reserved.
//

#import "CalendarController.h"
#import "FSCalendar.h"

@interface CalendarController ()<FSCalendarDelegate,FSCalendarDataSource> {
    NSDate *_begainDate;
    NSDate *_endDate;
}

@property (weak, nonatomic) FSCalendar *calendar;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSCalendar *gregorian;
@property(nonatomic ,strong) UILabel  *labelTitle;

@end

@implementation CalendarController

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.textColor = UIColor.whiteColor;
        _labelTitle.font = [UIFont systemFontOfSize:11];
        _labelTitle.text = @"请选择结束时间";
        _labelTitle.frame = CGRectMake(0, 0, 90, 20);
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _labelTitle;
}
- (NSDateFormatter *)dateFormatter {
    if (!_dateFormatter) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        _dateFormatter.dateFormat = @"MM月-dd日";
    }
    return _dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:13/255.0 green:14/255.0 blue:17/255.0 alpha:1.0];
    self.title = @"选择日期";
    // Do any additional setup after loading the view.
    
    self.gregorian = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    self.calendar.accessibilityIdentifier = @"calendar";
}



- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    self.view = view;
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height - 65;
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:CGRectMake(0+15,  0, view.frame.size.width-30, height)];
    calendar.dataSource = self;
    calendar.delegate = self;
    calendar.pagingEnabled = NO;
    calendar.swipeToChooseGesture.enabled = YES;
    calendar.allowsMultipleSelection = NO;
    calendar.appearance.headerMinimumDissolvedAlpha = 0;
    calendar.placeholderType = FSCalendarPlaceholderTypeNone;
    [view addSubview:calendar];
    self.calendar = calendar;
    
    calendar.calendarHeaderView.backgroundColor = [UIColor colorWithRed:13/255.0 green:14/255.0 blue:17/255.0 alpha:1.0];
    calendar.calendarWeekdayView.backgroundColor = [UIColor colorWithRed:13/255.0 green:14/255.0 blue:17/255.0 alpha:1.0];
    calendar.appearance.eventSelectionColor = [UIColor whiteColor];
    calendar.appearance.eventOffset = CGPointMake(0, -7);
    calendar.backgroundColor = [UIColor colorWithRed:13/255.0 green:14/255.0 blue:17/255.0 alpha:1.0];
    calendar.appearance.headerTitleColor = [UIColor colorWithRed:169/255.0 green:128/255.0 blue:84/255.0 alpha:1.0];
    calendar.appearance.titleTodayColor = [UIColor colorWithRed:169/255.0 green:128/255.0 blue:84/255.0 alpha:1.0];
    calendar.appearance.subtitleTodayColor = [UIColor orangeColor];
    calendar.appearance.weekdayTextColor = [UIColor colorWithRed:169/255.0 green:128/255.0 blue:84/255.0 alpha:1.0];
    calendar.appearance.titleWeekendColor = [UIColor colorWithRed:169/255.0 green:128/255.0 blue:84/255.0 alpha:1.0];
    calendar.today = nil;
    calendar.appearance.titleDefaultColor = [UIColor whiteColor];
    calendar.appearance.caseOptions = FSCalendarCaseOptionsHeaderUsesDefaultCase | FSCalendarCaseOptionsWeekdayUsesSingleUpperCase;

}

- (void)previousClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *previousMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:-1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:previousMonth animated:YES];
}

- (void)nextClicked:(id)sender
{
    NSDate *currentMonth = self.calendar.currentPage;
    NSDate *nextMonth = [self.gregorian dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:currentMonth options:0];
    [self.calendar setCurrentPage:nextMonth animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FSCalendarDataSource

- (NSDate *)minimumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate dateWithTimeInterval:0 sinceDate:[NSDate date]];
}

- (NSDate *)maximumDateForCalendar:(FSCalendar *)calendar
{
    return [NSDate dateWithTimeInterval:24*60*60*365 sinceDate:[NSDate date]];
}

- (NSString *)calendar:(FSCalendar *)calendar titleForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @"今天";
    }
    return nil;
}

#pragma mark - FSCalendarDelegate

- (void)calendar:(FSCalendar *)calendar boundingRectWillChange:(CGRect)bounds animated:(BOOL)animated
{
//    calendar.frame = (CGRect){calendar.frame.origin,bounds.size};
//    self.tableView.frame = CGRectMake(0, CGRectGetMaxY(calendar.frame)+5, self.view.frame.size.width, self.view.frame.size.height - calendar.frame.size.height);
//    [self.tableView layoutIfNeeded];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    if ([date isEqual:_begainDate]) {
        return NO;
    }
    return YES;
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition
{
    FSCalendarCell *cell = [calendar cellForDate:date atMonthPosition:monthPosition];
    if (_endDate == nil) {
        self.labelTitle.hidden = NO;
        [cell addSubview:self.labelTitle];
        self.labelTitle.frame = CGRectMake((cell.frame.size.width - self.labelTitle.frame.size.width) * 0.5, -22, 90, 16);
    }else {
        self.labelTitle.hidden = YES;
    }
   
    [self selectDate:date];
}

- (BOOL)calendar:(FSCalendar *)calendar shouldDeselectDate:(NSDate *)date atMonthPosition:(FSCalendarMonthPosition)monthPosition {
    return YES;
}

- (NSArray<UIColor *> *)calendar:(FSCalendar *)calendar appearance:(FSCalendarAppearance *)appearance eventDefaultColorsForDate:(NSDate *)date
{
    if ([self.gregorian isDateInToday:date]) {
        return @[[UIColor whiteColor]];
    }
    return @[appearance.eventDefaultColor];
}

- (NSString *)weekStringWithDate:(NSDate *)date weekDays:(NSArray *)array timeZone:(NSTimeZone *)zone{
   
    [self.gregorian setTimeZone:zone];
    NSDateComponents *theComponents = [self.gregorian components: NSCalendarUnitWeekday fromDate:date];
    NSString *weekStringForm = [array objectAtIndex:theComponents.weekday];
    return weekStringForm;
}
- (void)selectDate:(NSDate *)date{
    
    if (_begainDate == nil) {
        _begainDate = date;
        return;
    }else if (_begainDate != nil && _endDate == nil){
        NSComparisonResult result = [date compare:_begainDate];
        if (result == NSOrderedAscending) {
            _begainDate = date;
            _endDate = nil;
            return;
        }else{
            _endDate = date;
        }
    }
    
    NSDateComponents *component = [self.gregorian components:NSCalendarUnitDay fromDate:_begainDate toDate:_endDate options:0];
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六", nil];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    NSString *beginWeek = [self weekStringWithDate:_begainDate weekDays:weekdays timeZone:timeZone];
    NSString *endWeek = [self weekStringWithDate:_endDate weekDays:weekdays timeZone:timeZone];
    NSString *firstString = [self.dateFormatter stringFromDate:_begainDate];
    NSString *secondString = [self.dateFormatter stringFromDate:_endDate];
    
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *upload_begin_time = [self.dateFormatter stringFromDate:_begainDate];
    NSString *upload_end_time = [self.dateFormatter stringFromDate:_endDate];
    if (self.calendarControllerBlock) {
        NSDictionary *dic = @{@"beginTime": (firstString != nil ? firstString : @""),
                              @"endTime":(secondString != nil ? secondString : @""),
                              @"days":[NSString stringWithFormat:@"%ld", component.day],
                              @"benginWeek":beginWeek != nil ? beginWeek : @"",
                              @"endWeek":endWeek != nil ? endWeek : @"",
                              @"begin_time": upload_begin_time,
                              @"end_time": upload_end_time
                              };
        self.calendarControllerBlock(dic);
    }
    [self.navigationController dismissViewControllerAnimated:true completion:nil];
}

@end
