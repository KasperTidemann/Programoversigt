//
//  MandrilGenerator.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 12/15/10.
//  Copyright 2010 Meeho!. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericGenerator.h"

@interface MandrilGenerator : GenericGenerator {
    NSInteger currentIndex;
    NSInteger noOfItems;
}

- (NSArray *)arraysFromFile:(NSString *)path;
- (NSDictionary *)getProgram;

@end
