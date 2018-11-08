//
//  DMNMarsRover.h
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DMNMarsRoverStatus) {
	DMNMarsRoverStatusActive,
	DMNMarsRoverStatusComplete,
};

@interface DMNMarsRover : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, strong, readonly) NSString *name;

@property (nonatomic, strong, readonly) NSDate *launchDate;
@property (nonatomic, strong, readonly) NSDate *landingDate;

@property (nonatomic, readonly) DMNMarsRoverStatus status;

@property (nonatomic, readonly) NSInteger maxSol;
@property (nonatomic, strong, readonly) NSDate *maxDate;

@property (nonatomic, readonly) NSInteger numberOfPhotos;

@property (nonatomic, strong, readonly) NSArray *solDescriptions;

@end
