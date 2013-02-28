//
//  AudioPlayer.h
//  MapBase
//
//  Created by Daniel Wiedemann on 28.02.13.
//  Copyright (c) 2013 Daniel Wiedemann. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


@interface AudioPlayer : NSObject
{
    AVAudioPlayer *audioPlayer;
}

- (id)initWithPath:(NSString*)fileNameWithExctension;
- (void)play;

@end