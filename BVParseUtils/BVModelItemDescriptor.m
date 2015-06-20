//
//  BVModelItemDescriptor.m
//  Apex for Youth
//
//  Created by Bogdan Vitoc on 4/26/15.
//  Copyright (c) 2015 Vitoc Dev. All rights reserved.
//

#import "BVModelItemDescriptor.h"

@interface BVModelItemDescriptor ()
@property (nonatomic) NSMutableArray *_privateChildren;
@end

@implementation BVModelItemDescriptor

- (instancetype)init {
    if (self = [super init]) {
        self._privateChildren = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Tree methods
//Props to danh on stackoverflow: http://stackoverflow.com/q/30290954/1888489

//Get lineage going up from a leaf
- (NSArray *)lineage {
    if (!self.parent) {
        return [NSArray arrayWithObjects:self.fieldContainedIn, nil]; //Returns blank array if the fieldContainedIn property is nil
    } else {
        NSMutableArray *lineage = [[self.parent lineage] mutableCopy];
        [lineage addObject:self.fieldContainedIn];
        return lineage;
    }
}

//Perform block with bottom-most leaves
- (void)depthFirst:(void (^)(BVModelItemDescriptor *))block {
    for (BVModelItemDescriptor *node in self.children) {
        [node depthFirst:block];
    }
    return block(self);
}

//Get bottom-most leaves
- (NSArray *)leaves {
    NSMutableArray *leaves = [NSMutableArray new];
    [self depthFirst:^(BVModelItemDescriptor *node) {
        if (!node.children || node.children.count == 0) [leaves addObject:node];
    }];
    return leaves;
}

//Get lineage from bottom-most leaves
- (NSArray *)lineagesOfLeaves {
    NSMutableArray *lineages = [NSMutableArray new];
    for (BVModelItemDescriptor *leaf in [self leaves]) {
        [lineages addObject:[leaf lineage]];
    }
    return lineages;
}

#pragma mark - Getters
- (NSArray*)children {
    return [NSArray arrayWithArray:self._privateChildren];
}

#pragma mark - Convenience
- (void)addChild:(BVModelItemDescriptor*)child {
    [self._privateChildren addObject:child];
}

@end
