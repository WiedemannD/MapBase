//
//  AudioPlayer.m
//  MapBase
//
//  Created by Daniel Wiedemann on 28.02.13.
//  Copyright (c) 2013 Daniel Wiedemann. All rights reserved.
//

#import "AudioPlayer.h"

@implementation AudioPlayer

- (id)initWithPath:(NSString*)fileNameWithExtension
{
    if ((self = [super init]))
    {
        NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], fileNameWithExtension]];
        
        NSError *error;
        audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        
        if (audioPlayer == nil)
        {
            NSLog(@"AudioPlayer error: %@", [error description]);
        }
    }
    
    
    return self;
}

- (void)play
{
    [audioPlayer play];
}

/*-(void)dealloc {
    [audioPlayer release];
}*/
@end
