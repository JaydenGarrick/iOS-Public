//
//  DMNSolDescription.h
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNSolDescription : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSInteger sol;
@property (nonatomic, readonly) NSInteger numberOfPhotos;
@property (nonatomic, strong, readonly) NSArray *cameras;

@end
