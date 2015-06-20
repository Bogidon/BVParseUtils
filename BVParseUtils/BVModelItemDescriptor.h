//
//  BVModelItemDescriptor.h
//  Apex for Youth
//
//  Created by Bogdan Vitoc on 4/26/15.
//  Copyright (c) 2015 Vitoc Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

typedef NS_ENUM(NSUInteger, ReferenceType) {
    APXPointerReferenceType,
    APXRelationReferenceType
};

typedef NS_ENUM(NSUInteger, OrderDirection) {
    OrderAscending,
    OrderDecending
};

@interface BVModelItemDescriptor : NSObject

@property (nonatomic, weak) BVModelItemDescriptor *parent;
@property (nonatomic) NSArray *children;
@property (nonatomic) NSString* fieldContainedIn;
@property (nonatomic) ReferenceType referenceForContainment;
@property (nonatomic) PFQuery *query;
@property (nonatomic) NSString *orderField;
@property (nonatomic) OrderDirection orderDirection;
@property PFCachePolicy cachePolicy;

- (void)addChild:(BVModelItemDescriptor*)child;
- (NSArray *)lineagesOfLeaves;
@end
