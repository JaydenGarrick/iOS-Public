//
//  DMNPhotoCache.h
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNPhotoCache : NSObject

@property (nonatomic, readonly, class) DMNPhotoCache *sharedCache;

- (void)cacheImageData:(NSData *)data forIdentifier:(NSInteger)identifier;
- (NSData *)imageDataForIdentifier:(NSInteger)identifier;

@end
