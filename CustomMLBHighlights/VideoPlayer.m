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
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24.0f];
    [self.contentOverlayView addSubview:self.titleLabel];
}

- (void) closeVideo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) refreshTitleLabel
{
    self.titleLabel.text = self.package.videos[self.currentIndex].headline;
    [self.titleLabel sizeToFit];
    self.titleLabel.center = self.view.center;
    NSLog(@"frame: %f, %f", self.view.frame.size.width, self.view.frame.size.height);
    self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.view.frame.size.height - self.titleLabel.frame.size.height - 80.0f, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);

}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.titleLabel != nil)
    {
        self.titleLabel.center = self.view.center;
        self.titleLabel.frame = CGRectMake((size.width / 2.0f) - (self.titleLabel.frame.size.width / 2.0f), size.height - self.titleLabel.frame.size.height - 80.0f, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
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


@end
