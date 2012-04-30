//
//  GatNewsGenerator.h
//  ProgramoversigtApp
//
//  Created by Troels Trebbien on 2/11/12.
//  Copyright (c) 2012 Technical University of Denmark. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GenericGenerator.h"

@interface GatNewsGenerator : GenericGenerator {
    
@private
    NSArray *newsItemClasses;
    NSArray *breakingItemClasses;
    BOOL isBreaking;
    NSInteger curTime;
}

@end
