//
//  DMNSolDescription.m
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNSolDescription.h"

@implementation DMNSolDescription

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		_sol = [dictionary[@"sol"] integerValue];
		_numberOfPhotos = [dictionary[@"total_photos"] integerValue];
		_cameras = [dictionary[@"cameras"] copy];
	}
	return self;
}

@end
