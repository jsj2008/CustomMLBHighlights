//
//  VideoPlayer.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "VideoPlayer.h"

@implementation VideoPlayer

- (id) initWithPackage: (HighlightPackage *) pack
{
    self = [super init];
    if (self) {
        self.package = pack;
        self.avItems = [NSMutableArray array];
        self.showsPlaybackControls = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(itemDidFinishPlaying:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    [self loadVideo];
    [self addTitleLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self refreshTitleLabel];
}

- (void) dealloc
{
    [self.player removeObserver:self forKeyPath:@"status"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) loadVideo
{
    for (HighlightVideo *video in self.package.videos)
    {
        [video initializeVideoURL:^{

            [self.avItems addObject:[AVPlayerItem playerItemWithURL:[NSURL URLWithString:video.videoUrl]]];

            if (self.avItems.count == self.package.videos.count)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    AVQueuePlayer* queue = [AVQueuePlayer queuePlayerWithItems:self.avItems];
                    self.player = queue;
                    [queue addObserver:self forKeyPath:@"status" options:0 context:nil];
                    self.currentIndex = 0;
                });
            }

        }];
    }
}

- (void) addTitleLabel
{
    self.titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.titleButton setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleButton.titleLabel.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.titleButton.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    [self.titleButton addTarget:self action:@selector(skip:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.titleButton];
    
    self.skipButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.skipButton.frame = CGRectMake(0, 0, 80, 44);
    self.skipButton.backgroundColor = [UIColor magentaColor];
    
    //[self.view addSubview:self.skipButton];
}

- (void) closeVideo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) refreshTitleLabel
{
    [self.titleButton setTitle:self.package.videos[self.currentIndex].headline forState:UIControlStateNormal];
    [self.titleButton sizeToFit];
    self.titleButton.center = self.view.center;
    self.skipButton.center = self.view.center;
    self.titleButton.frame = CGRectMake(self.titleButton.frame.origin.x, self.view.frame.size.height - self.titleButton.frame.size.height - 80.0f, self.titleButton.frame.size.width, self.titleButton.frame.size.height);
    //self.skipButton.frame = CGRectMake(self.skipButton.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8.0, self.skipButton.frame.size.width, self.skipButton.frame.size.height);
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.titleButton != nil)
    {
        self.titleButton.center = self.view.center;
        self.titleButton.frame = CGRectMake((size.width / 2.0f) - (self.titleButton.frame.size.width / 2.0f), size.height - self.titleButton.frame.size.height - 80.0f, self.titleButton.frame.size.width, self.titleButton.frame.size.height);
        self.skipButton.center = self.view.center;
        //self.skipButton.frame = CGRectMake(self.skipButton.frame.origin.x, self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 8.0, self.skipButton.frame.size.width, self.skipButton.frame.size.height);
    }
}

- (void) itemDidFinishPlaying:(NSNotification *) notification
{
    self.currentIndex += 1;
    if (self.currentIndex == self.package.videos.count)
        [self closeVideo];
    else
        [self refreshTitleLabel];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object
                        change:(NSDictionary *)change context:(void *)context {

    if (object == self.player && [keyPath isEqualToString:@"status"]) {
        if (self.player.status == AVPlayerStatusReadyToPlay)
        {
            NSLog(@"ready to play");
            [self.player play];
            return;
        }
    }

    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (IBAction)skip:(id)sender
{
    if (self.player)
    {
        [(AVQueuePlayer *)self.player advanceToNextItem];
        [self itemDidFinishPlaying:nil];
    }
}


@end
