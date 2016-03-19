//
//  JSONObject.m
//  CustomMLBHighlights
//
//  Created by Patrick Rills on 3/19/16.
//  Copyright © 2016 BaseballHackDay. All rights reserved.
//

#import "JSONObject.h"
#import <objc/runtime.h>

@implementation JSONObject

- (id) initWithJSON: (NSDictionary *) dict {
    self = [super init];
    if (self) {
        [self initializeWithValues:dict];
    }
    return self;
}

- (void) initializeWithValues: (NSDictionary *) dict
{
    //match dictionary names to properties
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        NSString *propertyAttr = [NSString stringWithUTF8String:property_getAttributes(property)];
        Class propClass = [self getTypeFromPropertyAttributes:propertyAttr];
        
        for (int k = 0; k < [[dict allKeys] count]; k++)
        {
            NSString *currentKey = (NSString *)[[dict allKeys] objectAtIndex:k];
            if ([[currentKey lowercaseString] isEqualToString:[propertyName lowercaseString]]) {
                id val = [dict objectForKey:currentKey];
                
                if (propClass != nil && [propClass isSubclassOfClass:(Class)[JSONObject class]] && [val isKindOfClass:(Class)[NSDictionary class]])
                {
                    if (val != [NSNull null])
                        [self setValue:[(JSONObject *) [propClass alloc] initWithJSON:(NSDictionary*)val] forKey:propertyName];
                }
                else
                {
                    if (val == [NSNull null])
                    {
                        val = @"";
                    }
                    
                    [self setValue:val forKey:propertyName];
                }
            }
        }
    }
    free(properties);
}

- (Class) getTypeFromPropertyAttributes: (NSString *) allAttributes
{
    NSArray* attrColl = [allAttributes componentsSeparatedByString:@","];
    for (NSString* attr in attrColl)
    {
        if ([attr hasPrefix:@"T@"])
        {
            NSArray* typeParts = [attr componentsSeparatedByString:@"\""];
            if (typeParts.count >= 2)
            {
                return NSClassFromString(typeParts[1]);
            }
        }
    }
    
    return nil;
}

- (NSDictionary *) toJSON
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        if ([propertyValue isKindOfClass:[JSONObject class]])
        {
            [dict setObject:[(JSONObject *)propertyValue toJSON] forKey:(NSString *)propertyName];
        }
        else if ([propertyValue isKindOfClass:[NSMutableArray class]])
        {
            NSMutableArray *jsonArray = [NSMutableArray array];
            
            for (JSONObject* child in (NSMutableArray *)propertyValue)
            {
                [jsonArray addObject:[child toJSON]];
            }
            
            [dict setObject:jsonArray forKey:(NSString *)propertyName];
        }
        else
        {
            if (propertyValue != nil)
                [dict setObject:propertyValue forKey:(NSString *)propertyName];
        }
    }
    free(properties);
    
    return dict;
}

- (NSData *) toJSONData
{
    return [self convertJSON:[self toJSON]];
}

- (NSString *) toJSONString
{
    NSData *j = [self toJSONData];
    if (j != nil)
        return [[NSString alloc] initWithData:j encoding:NSUTF8StringEncoding];
    
    return @"";
}

- (NSData *) convertJSON: (NSDictionary *) dict
{
    NSError *err;
    NSData *j = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&err];
    if (err == nil)
        return j;
    
    return nil;
}

- (NSMutableArray *) convertChildArrayToClass: (Class) c withValues: (NSObject *) child
{
    //This method will convert an NSArray of NSDictionary(s) (a JSON array) to a mutable array of strongly typed NSObject(s)
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    if (child != nil && child != [NSNull null] && [child isKindOfClass:[NSArray class]]) {
        for (NSDictionary *d in (NSArray *)child) {
            JSONObject *x = [(JSONObject *)[c alloc] initWithJSON:d];
            [arr addObject:x];
        }
    }
    
    return arr;
}

@end
