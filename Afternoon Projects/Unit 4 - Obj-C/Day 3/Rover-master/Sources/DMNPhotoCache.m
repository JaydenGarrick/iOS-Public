//
//  DMNPhotoCache.m
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNPhotoCache.h"

@interface DMNPhotoCache ()

@property (nonatomic, strong) NSCache *cache;

@end

@implementation DMNPhotoCache

+ (instancetype)sharedCache
{
	static DMNPhotoCache *sharedCache = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedCache = [[self alloc] init];
	});
	return sharedCache;
}

- (instancetype)init
{
	self = [super init];
	if (self) {
		_cache = [[NSCache alloc] init];
		_cache.name = @"com.DevMountain.MarsRover.PhotosCache";
	}
	return self;
}

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier
{
	[self.cache setObject:data forKey:@(identifier) cost:[data length]];
}

- (NSData *)imageDataForIdentifier:(NSInteger)identifier
{
	return [self.cache objectForKey:@(identifier)];
}

@end
