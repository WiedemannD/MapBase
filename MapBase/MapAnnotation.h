//
//  MapAnnotation.h
//  MapBase
//
//  Created by Daniel Wiedemann on 28.02.13.
//  Copyright (c) 2013 Daniel Wiedemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>

@property (readwrite, nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite) int radius;
@property (nonatomic, readwrite) int soundId;
@property (nonatomic, readwrite) BOOL soundPlayed;

- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate title:(NSString *)title subtitle:(NSString *)subtitle radius:(int)radius soundId:(int)soundId;
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

@end
