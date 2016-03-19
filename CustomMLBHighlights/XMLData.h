//
//  XMLData.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

@protocol XMLData <NSObject>

+ (NSString *) rootElementName;
- (void) processElement: (NSString *) name withValue: (NSString *) value;

@end
