//
//  VideoPlayer.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MediaPlayer;
#import "HighlightPackage.h"

@interface VideoPlayer : UIViewController

@property (nonatomic, strong) MPMoviePlayerController *player;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) HighlightPackage* package;
@property (nonatomic) NSInteger currentIndex;

- (id) initWithPackage: (HighlightPackage *) pack;
- (void) loadVideo;

@end
