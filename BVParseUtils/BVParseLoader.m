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
        NSLog(@"%@",includeKeys);
    }
}

//- (NSArray*)generateChildrenPathsFromItemDescriptor:(BVModelItemDescriptor*)itemDescriptor {
//    NSMutableArray *includeKeys = [NSMutableArray new];
//    
//
//    
//    NSMutableArray *paths = [NSMutableArray array];
//
//    __block __weak APXRecurseBlock weak_recurse;
//    APXRecurseBlock recurse;
//    weak_recurse = recurse = [^(BVModelItemDescriptor* itemDescriptor, NSString* string) {
//        for (APXChildDescription *childDescription in itemDescriptor.children) {
//            
//            NSString *newKey = childDescription.parseKey;
//            if (!string) {
//                string = newKey;
//            } else {
//                string = [NSString stringWithFormat:@"%@.%@",string,newKey];
//            }
//            
//            weak_recurse(childDescription.descriptor, string);
//        };
//        
//        if (itemDescriptor.children.count == 0) {
//            //Done with path
//            NSLog(@"%@", string);
//            [paths addObject:string];
//        }
//    } copy];
//    
//    recurse(itemDescriptor, string);
//    return paths;
//};

//- (void)recursiveLoadFromParent:(PFObject*)parent
//             withItemDescriptor:(BVModelItemDescriptor*)itemDescriptor {
//    
//    //Load children
//    if (itemDescriptor.children) {
//        
//        //Target object count
//        //                    NSUInteger total = [itemDescriptor.children count];
//        //                    __block NSUInteger count = 0;
//        
//        //Create check for load completion
//        //                    void (^check)(NSUInteger a, NSUInteger b) = ^(NSUInteger a, NSUInteger b){
//        //                        if (a >= b) {
//        //                            //Fire callback if they have
//        //                            result(result);
//        //                        }
//        //                    };
//        
//        for (APXChildDescription *childDescription in itemDescriptor.children) {
//            [self loadChildrenFromParent:parent childDescription:childDescription
//                                   block:^(NSArray *children)
//             {
//                 //Save children in local property of parent
//                 [parent setValue:children forKey:childDescription.localKey];
//                 
//                 //Recurse for each child
//                 for (PFObject* child in children) {
//                     [self recursiveLoadFromParent:child withItemDescriptor:childDescription.descriptor];
//                 }
//             }];
//        }
//    }
//}
//
//- (void) loadChildrenFromParent:(PFObject*)parent
//                   childDescription:(APXChildDescription*)childDescription
//                              block:(void (^)(NSArray *result))block {
//    
//    if (childDescription.reference == APXPointerReferenceType) {
//        [self loadChildrenFromPointersOnParent:parent
//                              childDescription:childDescription
//                                         block:block];
//    }
//}
//
//- (void)loadChildrenFromPointersOnParent:(PFObject*)parent
//                  childDescription:(APXChildDescription*)childDescription
//                                   block:(void (^)(NSArray *result))block {
//    
//    //Array where objects are put
//    NSMutableArray *result = [NSMutableArray array];
//    
//    //Target object count
//    NSUInteger total = [parent[childDescription.parseKey] count];
//    __block NSUInteger count = 0;
//    
//    //Create check for load completion
//    void (^check)(NSUInteger a, NSUInteger b) = ^(NSUInteger a, NSUInteger b){
//        if (a >= b) {
//            //Fire callback if they have
//            block(result);
//        }
//    };
//    
//    //Run check in case total = 0
//    check(count, total);
//    
//    //Loop for each objectId
//    for (NSString *objectId in  parent[childDescription.parseKey]) {
//        
//
//        PFQuery *query = [PFQuery queryWithClassName:childDescription.descriptor.name];
//        
//        [query getObjectInBackgroundWithId:objectId
//                                     block:^(PFObject *object, NSError *error)
//        {
//                                         
//            //Generate dictionary from object
//            NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
//            
//            //Add specified fields to a dictionary
//            for (NSString *field in childDescription.descriptor.fields) {
//                [dictionary setObject:object[field] forKey:field];
//            }
//            
//            //Add dictionary to result
//            [result addObject:dictionary];
//            
//            //Detect if all have loaded
//            count++;
//            check(count, total);
//        }];
//        
//    }
//}
//
@end
