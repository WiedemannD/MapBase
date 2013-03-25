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
    
    self.btn3.target = self;
    self.btn3.action = @selector(btn3Pressed);
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
        
        MapAnnotation *anno = [[MapAnnotation alloc] initWithCoordinate:location title:(NSString *)[spot objectForKey:@"title"] subtitle:(NSString *)[spot objectForKey:@"subtitle"] radius:[(NSNumber *)[spot objectForKey:@"radius"] intValue] soundId:[(NSNumber *)[spot objectForKey:@"soundId"] intValue] imageId:[(NSNumber *)[spot objectForKey:@"imageId"] intValue]];
        
        [self.mapView addAnnotation:anno];
    }
}


#pragma mark MapBase functions

/////////////////
// MapBase functions
/////////////////

- (void)activateMapAnnotation:(MapAnnotation *) anno withDistance:(float) dist
{
    /////////////////
    // !!!!!!!!!!!!!!
    // THIS WILL GET EXECUTED FOR A HOTSPOT/MAPANNOTATION WHEN THE DEVICE LOCATION IS WITHIN THE CORRESPONDING RADIUS.
    // PLACE YOU MAPANNOTATION SPECIFIC CODE IN THIS FUNCTION.
    // !!!!!!!!!!!!!!
    /////////////////
    
    // shows the corresponding image
    [self showImageLayerWithId:anno.imageId];
    
    // plays the corresponding sound
    [self playSoundWithId:anno.soundId];
    
    // Sets MapAnnotation to activated, like this anno won't be activated several times.
    anno.activated = YES;
    
    NSLog(@"HotSpot/MapAnnotation '%@' activated with distance %f", anno.title, dist);
}

- (void)showImageLayerWithId:(int)imageId
{
    NSArray *images = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/images.plist", [[NSBundle mainBundle] resourcePath]]];
    
    if(imageId < images.count)
    {
        
        NSString *filename = [images objectAtIndex:imageId];
        NSString *path = [NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], filename];
        UIImage *currentImage = [UIImage imageWithContentsOfFile:path];
       
        [self.imageLayer setImage:currentImage forState:UIControlStateNormal];

        // The following line sets the imageView to aspect fill the view with image. Comment out if you want the image just to be displayed completely and not cropped if the display is to small.
        self.imageLayer.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [UIView beginAnimations:@"showImageLayer" context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        [UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:[self.view superview] cache:NO];
        
        [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
        
        [UIView commitAnimations];
        
        NSLog(@"Show image: %@", filename);
    }
    else
    {
        NSLog(@"Show image failed: imageId is non existent");
    }
}

- (IBAction)hideImageLayer:(id)sender
{
    [UIView beginAnimations:@"hideImageLayer" context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:[self.view superview] cache:NO];
    
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView commitAnimations];
}

- (void)playSoundWithId:(int)soundId
{
    NSArray *sounds = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/sounds.plist", [[NSBundle mainBundle] resourcePath]]];
    
    if(soundId < sounds.count)
    {
        
        NSString *filename = [sounds objectAtIndex:soundId];
        
        self.currentAudioPlayer = [[AudioPlayer alloc] initWithPath:filename];
        [self.currentAudioPlayer play];
        
        NSLog(@"Play sound: %@", filename);
    }
    else
    {
        NSLog(@"Play sound failed: soundId is non existent");
    }
}

- (void)resetMapAnnotationsActivated
{
    for (int i = 0; i < self.mapView.annotations.count; i++)
    {
        MapAnnotation *anno = [self.mapView.annotations objectAtIndex:i];
        
        if(![anno.title isEqualToString:@"Current Location"])
        {
            anno.activated = NO;
        }
    }
    
    NSLog(@"Sound played reset");
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
            if(!anno.activated && dist <= anno.radius / 2)
            {
                [self activateMapAnnotation:anno withDistance:dist];
            }
        }
    }
}


#pragma mark button functions

/////////////////
// button functions
/////////////////

- (void)btn1Pressed
{
    NSLog(@"btn1Pressed playSoundWithId:0");
    
    [self playSoundWithId:0];
}

- (void)btn2Pressed
{
    NSLog(@"btn2Pressed resetMapAnnotationsActivated");
    
    [self resetMapAnnotationsActivated];
}

- (void)btn3Pressed
{
    NSLog(@"btn3Pressed showImageLayerWithId");
    
    [self showImageLayerWithId:0];
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
