//
//  Alert.m
//  Spelunker
//
//  Created by Renaud Holcombe on 6/11/17.
//  Copyright © 2017 Renaud Holcombe. All rights reserved.
//

#import "Alert.h"
#import "Constants.h"

const NSInteger POLLINGSCHEDULEFREQUENCY = 2; //minutes

@implementation Alert

@synthesize alertId, alertName, alertType, scheduleTime, searchString, isValid, timer, schedulerTimeInterval;

-(id) init
{
    self = [super init];
    alertId = [NSUUID UUID];

    [self SetDefaults];

    return self;
}

-(void)SetDefaults
{
    alertName = @"New alert";
    alertType = Polling;
    searchString = @"* earliest=-1h";
    isValid = false;
}

+(BOOL)propertyIsOptional:(NSString *)propertyName
{
    NSArray *optionProps = @[ @"" ]; //used to add fields during development

    if([optionProps containsObject:propertyName])
        return YES;

    return NO;
}

-(NSDate *) nextFireTime
{
    NSDate *nextFireTime = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components;

    components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitTimeZone) fromDate:nextFireTime];

    if(alertType == Polling)
    {
        NSInteger nextFive = (POLLINGSCHEDULEFREQUENCY - (components.minute % POLLINGSCHEDULEFREQUENCY)) * 60;
        nextFireTime = [nextFireTime dateByAddingTimeInterval:nextFive];
    } else { // scheduled. definitely a bit more complex

        NSInteger currentHour = components.hour;
        NSInteger currentMinute = components.minute;

        NSDateComponents *scheduleComponents = [calendar components:(NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:scheduleTime];
        NSInteger scheduledHour = scheduleComponents.hour;
        NSInteger scheduledMinute = scheduleComponents.minute;
        NSInteger plusDays = 0;

        if(scheduledHour < currentHour)
        {
            NSInteger rollingHour = scheduledHour;
            while ((rollingHour + (24 * plusDays)) < currentHour )
            {
                rollingHour += (schedulerTimeInterval < 1 || schedulerTimeInterval > 24)? 24: schedulerTimeInterval;
                if(rollingHour > 23){
                    plusDays += floor((double)rollingHour/24.00);
                }

                rollingHour = rollingHour % 23;

            }

            currentHour = rollingHour;
        }

        if(scheduledMinute < currentMinute && plusDays == 0 && currentHour == scheduledHour)
        {
            currentHour += schedulerTimeInterval;
            if(currentHour > 23)
            {
                plusDays = floor((double)currentHour/24.00);
                currentHour = currentHour % 23;
            }
        } /*else {
            currentHour = scheduledHour;
        }*/

        components.hour = currentHour;
        components.minute = scheduledMinute;
        components.day += plusDays; //might need to change this to a date-with-timeinterval in case it doesn't handle crossing over a year well

        nextFireTime = [calendar dateFromComponents:components];



        NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
        NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];

        NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:nextFireTime];
        NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:nextFireTime];
        NSTimeInterval interval = (destinationGMTOffset - sourceGMTOffset) * -1;

        nextFireTime = [[NSDate alloc] initWithTimeInterval:interval sinceDate:nextFireTime];

    }
    return nextFireTime;
}

@end

@implementation AlertList

@end
