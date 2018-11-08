//
//  DMNMarsPhoto.m
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNMarsPhoto.h"

@implementation DMNMarsPhoto

+ (NSDateFormatter *)dateFormatter
{
	static NSDateFormatter *dateFormatter = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
		dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
		dateFormatter.dateFormat = @"yyyy-MM-dd";
	});
	return dateFormatter;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
	self = [super init];
	if (self) {
		if (!dictionary[@"id"]) { return nil; }
		_identifier = [dictionary[@"id"] integerValue];
		_sol = [dictionary[@"sol"] integerValue];
		_cameraName = dictionary[@"camera"][@"name"];
		NSString *earthDateString = dictionary[@"earth_date"];
		_earthDate = [[[self class] dateFormatter] dateFromString:earthDateString];
		_imageURL = [NSURL URLWithString:dictionary[@"img_src"]];
		if (!_imageURL) { return nil; }
	}
	return self;
}

- (BOOL)isEqual:(id)object
{
	if (!object || ![object isKindOfClass:[DMNMarsPhoto class]]) { return NO; }
	DMNMarsPhoto *photo = object;
	if (photo.identifier != self.identifier) { return NO; }
	if (photo.sol != self.sol) { return NO; }
	if (![photo.cameraName isEqualToString:self.cameraName]) { return NO; }
	if (![photo.earthDate isEqualToDate:self.earthDate]) { return NO; }
	return YES;
}

- (NSUInteger)hash
{
	return (NSUInteger)self.identifier;
}

@end
