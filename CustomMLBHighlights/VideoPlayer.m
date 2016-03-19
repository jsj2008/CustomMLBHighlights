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
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.package = pack;
        self.currentIndex = 0;
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void) loadVideo
{
    [self addVideoPlayer];
    [self playNextVideo];
}

- (void) addVideoPlayer
{
    if (self.player == nil)
    {
        MPMoviePlayerController *p = [[MPMoviePlayerController alloc] init];
        self.player = p;
        
        self.player.scalingMode = MPMovieScalingModeAspectFit;
        self.player.controlStyle = MPMovieControlStyleFullscreen;
        self.player.shouldAutoplay = YES;
        
        [self.player.view setFrame: self.view.bounds];
        self.player.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.player.view];
        
        //Notifications
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayBackDidFinish:)
                                                     name:MPMoviePlayerPlaybackDidFinishNotification
                                                   object:self.player];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(moviePlayerLoadStateDidChangeNotification:)
                                                     name:MPMoviePlayerLoadStateDidChangeNotification
                                                   object:self.player];
        
        
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                     name:MPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                                   object:self.player];
         */
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont systemFontOfSize:24.0f];
        [self.view addSubview:self.titleLabel];
    }
}

- (void) moviePlayerLoadStateDidChangeNotification:(NSNotification*)notification
{
    NSLog(@"NExt?");
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification
{
    NSNumber *reason = [[notification userInfo] objectForKey:MPMoviePlayerPlaybackDidFinishReasonUserInfoKey];
    switch ([reason integerValue])
    {
            /* The end of the movie was reached. */
        case MPMovieFinishReasonPlaybackEnded:
            [self playNextVideo];
            break;
            
            /* An error was encountered during playback. */
        case MPMovieFinishReasonPlaybackError:
        {
            NSLog(@"An error was encountered during playback");
            UIAlertView *error = [[UIAlertView alloc] initWithTitle:@"Video Error" message:@"An error was encountered during playback" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles: nil];
            [error show];
            
            break;
        }
            /* The user stopped playback. */
        case MPMovieFinishReasonUserExited:
        {
            [self closeVideo];
            
            break;
        }   
        default:
            break;
    }
}

- (void) closeVideo
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) playNextVideo
{
    if (self.currentIndex < self.package.videos.count)
    {
        //self.player.movieSourceType = MPMovieSourceTypeStreaming;
        self.player.movieSourceType = MPMovieSourceTypeUnknown;
        
        HighlightVideo* video = [self.package.videos objectAtIndex:self.currentIndex];
        
        self.titleLabel.text = video.headline;
        [self.titleLabel sizeToFit];
        self.titleLabel.center = self.view.center;
        self.titleLabel.frame = CGRectMake(self.titleLabel.frame.origin.x, self.view.frame.size.height - self.titleLabel.frame.size.height - 80.0f, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
        
        [video initializeVideoURL:^{
        
            dispatch_async(dispatch_get_main_queue(), ^{
                if (video.videoUrl != nil)
                {
                    self.player.contentURL = [NSURL URLWithString:video.videoUrl];
                    [self.player prepareToPlay];
                    self.currentIndex += 1;
                }
            });
        }];
    }
    else
    {
        [self closeVideo];
    }
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    if (self.titleLabel != nil)
    {
        self.titleLabel.center = self.view.center;
        self.titleLabel.frame = CGRectMake((size.width / 2.0f) - (self.titleLabel.frame.size.width / 2.0f), size.height - self.titleLabel.frame.size.height - 80.0f, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    }
}

@end
