//
//  XMLParser.h
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMLData.h"

@interface XMLParser : NSObject <NSXMLParserDelegate> {
    Class<XMLData> currentObjectType;
}

@property (nonatomic,strong) NSMutableArray *currentObjects;
@property (nonatomic,strong) NSXMLParser *xmlParser;
@property (nonatomic,strong) NSMutableDictionary *currentValues;
@property (nonatomic,strong) NSString *currentElement;
@property (nonatomic,strong) NSString *currentParameter;

- (NSMutableArray *) getObjectsOfType: (Class) objectType fromXMLData: (NSData *) xmlData;

@end
