//
//  APXParseLoader.m
//  Apex for Youth
//
//  Created by Bogdan Vitoc on 4/26/15.
//  Copyright (c) 2015 Vitoc Dev. All rights reserved.
//

#import "BVParseLoader.h"

typedef void (^APXRecurseBlock) (BVModelItemDescriptor* itemDescriptor, NSString* string);

@implementation APXParseLoader

+ (instancetype)sharedLoader {
    static APXParseLoader *sharedLoader = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLoader = [self new];
    });
    return sharedLoader;
}

- (void)loadModelItemFromDescription:(BVModelItemDescriptor*)itemDescriptor
                               block:(void (^)(NSArray *objects, NSError *error))block {
    
    //Create query
    PFQuery *query = itemDescriptor.query;
    [self addKeysToQuery:query startingItemDescriptor:itemDescriptor];
    query.cachePolicy = itemDescriptor.cachePolicy;
    
    if (itemDescriptor.orderField) {
        if (itemDescriptor.orderDirection == OrderAscending) {
            [query orderByAscending:itemDescriptor.orderField];
        }
        if (itemDescriptor.orderDirection == OrderDecending) {
            [query orderByDescending:itemDescriptor.orderField];
        }
    }
    
    //Run query
    [query findObjectsInBackgroundWithBlock:block];
}

- (void)addKeysToQuery:(PFQuery*)query startingItemDescriptor:(BVModelItemDescriptor*)itemDescriptor {
    for (NSArray *lineage in [itemDescriptor lineagesOfLeaves]) {
        NSString *includeKeys = [lineage componentsJoinedByString:@"."];
        [query includeKey:includeKeys];
    }
}

@end
