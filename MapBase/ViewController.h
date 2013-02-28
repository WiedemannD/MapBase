//
//  ViewController.h
//  MapBase
//
//  Created by Daniel Wiedemann on 27.02.13.
//  Copyright (c) 2013 Daniel Wiedemann. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "AudioPlayer.h"

@interface ViewController : UIViewController <CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn1;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *btn2;
@property (strong, nonatomic) AudioPlayer *currentAudioPlayer;

@end
