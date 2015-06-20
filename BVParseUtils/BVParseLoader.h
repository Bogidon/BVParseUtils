//
//  APXParseLoader.h
//  Apex for Youth
//
//  Created by Bogdan Vitoc on 4/26/15.
//  Copyright (c) 2015 Vitoc Dev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

#import "BVModelItemDescriptor.h"

@interface APXParseLoader : NSObject

+ (instancetype)sharedLoader;
- (void)loadModelItemFromDescription:(BVModelItemDescriptor*)itemDescriptor block:(void (^)(NSArray *objects, NSError *error))block;

@end
