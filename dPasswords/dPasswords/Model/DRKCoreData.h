//
//  DRKCoreData.h
//  dEnglishTask
//
//  Created by ZHOU DENGFENG on 17/8/14.
//  Copyright (c) 2014 ZHOU DENGFENG (DEREK). All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface DRKCoreData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

+ (instancetype)sharedCoreData;

@end
