//
//  ViewController.m
//  MapBase
//
//  Created by Daniel Wiedemann on 27.02.13.
//  Copyright (c) 2013 Daniel Wiedemann. All rights reserved.
//

#import "ViewController.h"
#import "AudioPlayer.h"
#import "MapAnnotation.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    /////////////////
    // setup toolbar button
    /////////////////
    
    self.btn1.target = self;
    self.btn1.action = @selector(btn1Pressed);
    
    self.btn2.target = self;
    self.btn2.action = @selector(btn2Pressed);
}

- (void)viewWillAppear:(BOOL)animated
{
    /////////////////
    // setup map
    /////////////////
    
    NSDictionary *hotSpots = [NSDictionary dictionaryWithContentsOfFile:[NSString stringWithFormat:@"%@/hotSpots.plist", [[NSBundle mainBundle] resourcePath]]];
    NSDictionary *startUpSetting = [hotSpots objectForKey:@"startUpSetting"];
    
    CLLocationCoordinate2D startUpLocation;
    startUpLocation.latitude = [(NSNumber *)[startUpSetting objectForKey:@"lat"] floatValue];
    startUpLocation.longitude= [(NSNumber *)[startUpSetting objectForKey:@"lon"] floatValue];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(startUpLocation, [(NSNumber *)[startUpSetting objectForKey:@"regionDistance"] intValue], [(NSNumber *)[startUpSetting objectForKey:@"regionDistance"] intValue]);
    
    [self.mapView setRegion:viewRegion animated:YES];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    
    /////////////////
    // setup maps additional features/annotations
    /////////////////
    
    NSArray *spots = (NSArray *)[hotSpots objectForKey:@"spots"];
    
    for (int i = 0; i < spots.count; i++)
    {
        NSDictionary *spot = (NSDictionary *)[spots objectAtIndex:i];
        CLLocationCoordinate2D location;
        location.latitude = [(NSNumber *)[spot objectForKey:@"lat"] floatValue];
        location.longitude= [(NSNumber *)[spot objectForKey:@"lon"] floatValue];
        
        MapAnnotation *anno = [[MapAnnotation alloc] initWithCoordinate:location title:(NSString *)[spot objectForKey:@"title"] subtitle:(NSString *)[spot objectForKey:@"subtitle"] radius:[(NSNumber *)[spot objectForKey:@"radius"] intValue] soundId:[(NSNumber *)[spot objectForKey:@"soundId"] intValue]];
        
        [self.mapView addAnnotation:anno];
    }
}


#pragma mark map delegate functions

/////////////////
// map delegate functions
/////////////////

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    for (int i = 0; i < self.mapView.annotations.count; i++)
    {
        MapAnnotation *anno = [self.mapView.annotations objectAtIndex:i];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:anno.coordinate.latitude longitude:anno.coordinate.longitude];
        float dist = [newLocation distanceFromLocation:loc];

        if(![anno.title isEqualToString:@"Current Location"])
        {
            if(!anno.soundPlayed && dist <= anno.radius / 2)
            {
                [self playSoundWithId:anno.soundId];
                anno.soundPlayed = YES;
                
                NSLog(@"dist %@ (soundPlayed %d): %f PLAY SOUND", anno.title, anno.soundPlayed, dist);
            }
            
            //NSLog(@"dist %@ (soundPlayed %d): %f", anno.title, anno.soundPlayed, dist);
        }
    }
}


#pragma mark button functions

/////////////////
// button functions
/////////////////

- (void)btn1Pressed
{
    NSLog(@"btn1Pressed");
    
    [self playSoundWithId:1];
}

- (void)btn2Pressed
{
    NSLog(@"btn2Pressed");
    
    [self resetSoundPlayed];
}


#pragma mark sound functions

/////////////////
// sound functions
/////////////////

- (void)playSoundWithId:(int)soundId
{
    NSArray *sounds = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/sounds.plist", [[NSBundle mainBundle] resourcePath]]];
    NSString *filename = [sounds objectAtIndex:soundId];
    
    self.currentAudioPlayer = [[AudioPlayer alloc] initWithPath:filename];
    [self.currentAudioPlayer play];
    
    NSLog(@"Play sound: %@", filename);
}

- (void)resetSoundPlayed
{
    for (int i = 0; i < self.mapView.annotations.count; i++)
    {
        MapAnnotation *anno = [self.mapView.annotations objectAtIndex:i];
        
        if(![anno.title isEqualToString:@"Current Location"])
        {
            anno.soundPlayed = NO;
        }
    }
    
    NSLog(@"Sound played reset");
}

#pragma mark memory functions

/////////////////
// memory functions
/////////////////

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
