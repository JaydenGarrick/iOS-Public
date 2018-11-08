//
//  DMNMarsPhoto.h
//  Rover
//
//  Created by Andrew Madsen on 2/10/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMNMarsPhoto : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@property (nonatomic, readonly) NSInteger identifier;
@property (nonatomic, readonly) NSInteger sol;
@property (nonatomic, strong, readonly) NSString *cameraName;
@property (nonatomic, strong, readonly) NSDate *earthDate;

@property (nonatomic, strong, readonly) NSURL *imageURL;

@end
