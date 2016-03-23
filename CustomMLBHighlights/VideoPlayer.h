//
//  VideoPlayer.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

@import UIKit;
@import AVKit;
@import AVFoundation;

#import "HighlightPackage.h"

@interface VideoPlayer : AVPlayerViewController

@property (nonatomic, strong) UIButton* titleButton;
@property (nonatomic, strong) UIButton* skipButton;
@property (nonatomic, strong) HighlightPackage* package;
@property (nonatomic, strong) NSMutableArray<AVPlayerItem*>* avItems;
@property NSUInteger currentIndex;

- (id) initWithPackage: (HighlightPackage *) pack;

@end
