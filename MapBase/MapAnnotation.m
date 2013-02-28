//
//  MapAnnotation.m
//  MapBase
//
//  Created by Daniel Wiedemann on 28.02.13.
//  Copyright (c) 2013 Daniel Wiedemann. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize coordinate;

- (id)initWithCoordinate:(CLLocationCoordinate2D)newCoordinate title:(NSString *)title subtitle:(NSString *)subtitle radius:(int)radius soundId:(int)soundId
{
    if ((self = [super init]))
    {
        coordinate = newCoordinate;
        self.title = title;
        self.subtitle = subtitle;
        self.radius = radius;
        self.soundId = soundId;
        self.soundPlayed = NO;
    }
    
    return self;
}

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate
{
    coordinate = newCoordinate;
}

@end
