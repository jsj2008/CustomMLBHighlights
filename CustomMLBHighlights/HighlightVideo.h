//
//  HighlightVideo.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

/*
 <headline>'Big Deal or No Big Deal'</headline>
 <kicker>MLB Network: Intentional Talk</kicker>
 <blurb>'Big Deal or No Big Deal' on Intentional Talk</blurb>
 <big-blurb>
 Chris Rose and Kevin Millar discuss the most popular headlines in baseball and debate whether or not they are a "Big Deal or No Big Deal"
 </big-blurb>
 <duration>00:05:49</duration>
 <url playback_scenario="FLASH_1800K_960X540" id="" authorization="N" login="N" mid="2014082835719167" cat_code="mlb_mlb_lg" state="MEDIA_ARCHIVE" sequence="1" cdn="MLB_FLASH_STREAM">
 http://mediadownloads.mlb.com/mlbam/2014/08/28/mlbtv_35719167_1800K.mp4
 </url>
 
 <thumbnailScenarios>
 <thumbnailScenario type="1" contentId="91855860">
 http://mediadownloads.mlb.com/mlbam/2014/08/28/images/mlbf_35719167_th_1.jpg
 </thumbnailScenario>
 
 */

#import <Foundation/Foundation.h>

@interface HighlightVideo : NSObject

@property (nonatomic, strong) NSString* metaUrl;
@property (nonatomic, strong) NSString* videoUrl;
@property (nonatomic, strong) NSString* headline;
@property (nonatomic, strong) NSString* bigBlurb;
@property (nonatomic, strong) NSString* duration;
@property (nonatomic, strong) NSString* thumbnailUrl;
@property (nonatomic, strong) NSString* dayCreated;

- (id) initWithDictionary: (NSDictionary *) dict;
- (NSDictionary *) toDictionary;

- (void) initializeVideoURL: (void(^)()) onComplete;

@end
