//
//  XMLParser.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "XMLParser.h"

@implementation XMLParser

- (NSMutableArray *) getObjectsOfType: (Class) objectType fromXMLData: (NSData *) xmlData
{
    currentObjectType = objectType;
    self.currentObjects = [[NSMutableArray alloc] init];
    if (xmlData != nil)
    {
        self.xmlParser = [[NSXMLParser alloc] initWithData:xmlData];
        
        [self.xmlParser setDelegate:self];
        [self.xmlParser setShouldProcessNamespaces:NO];
        [self.xmlParser setShouldReportNamespacePrefixes:NO];
        [self.xmlParser setShouldResolveExternalEntities:NO];
        [self.xmlParser parse];
    }
    
    return [NSMutableArray arrayWithArray:self.currentObjects];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError
{
    NSString * errorString = [NSString stringWithFormat:@"Unable to download data.  Check your internet connection. (%ld)", [parseError code]];
    NSLog(@"error parsing XML: %@", errorString);
//    [self performSelector:@selector(showXMLError:) onThread:[NSThread mainThread] withObject:errorString waitUntilDone:NO];
    self.currentObjects = nil;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    //NSLog(@"found this element: %@", elementName);
    self.currentElement = [elementName copy];
    if ([elementName isEqualToString:[currentObjectType rootElementName]]) {
        self.currentValues = [[NSMutableDictionary alloc] init];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    //NSLog(@"ended element: %@", elementName);
    if ([elementName isEqualToString:[currentObjectType rootElementName]]) {
        NSObject <XMLData> *p = [[(Class) currentObjectType alloc] init];
        
        for (int x = 0; x < [self.currentValues count]; x++) {
            [p processElement:[[self.currentValues allKeys] objectAtIndex:x] withValue:[[self.currentValues allValues] objectAtIndex:x]];
        }
        
        [self.currentObjects addObject:p];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    //NSLog(@"found characters: %@", string);
    
    bool found = NO;
    
    for (int x = 0; x < [self.currentValues count]; x++) {
        if ([[[self.currentValues allKeys] objectAtIndex:x] isEqualToString:self.currentElement]) {
            found = YES;
        }
    }
    
    NSString *currValue = @"";
    
    if (found) {
        currValue = [NSString stringWithString:[self.currentValues valueForKey:self.currentElement]];
    }
    
    if ([self.currentElement isEqualToString:@"url"])  //janky
    {
        currValue = [currValue stringByAppendingFormat:@"%@,", string];
    }
    else
    {
        currValue = [currValue stringByAppendingString:string];
    }
    
    
    [self.currentValues setValue:currValue forKey:self.currentElement];
}

@end
