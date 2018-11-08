//
//  DMNMarsRoverClient.h
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMNMarsRover;
@class DMNMarsPhoto;

@interface DMNMarsRoverClient : NSObject

- (void)fetchAllMarsRoversWithCompletion:(void(^)(NSArray *roverNames, NSError *error))completion;
- (void)fetchMissionManifestForRoverNamed:(NSString *)name completion:(void(^)(DMNMarsRover *rover, NSError *error))completion;
- (void)fetchPhotosFromRover:(DMNMarsRover *)rover onSol:(NSInteger)sol completion:(void(^)(NSArray *photos, NSError *error))completion;
- (void)fetchImageDataForPhoto:(DMNMarsPhoto *)photo completion:(void(^)(NSData *imageData, NSError *error))completion;

@end
