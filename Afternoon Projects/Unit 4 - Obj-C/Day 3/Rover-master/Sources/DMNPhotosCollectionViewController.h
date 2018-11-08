//
//  DMNPhotosCollectionViewController.h
//  Rover
//
//  Created by Andrew Madsen on 2/23/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DMNMarsRover;
@class DMNSolDescription;

@interface DMNPhotosCollectionViewController : UICollectionViewController

@property (nonatomic, strong) DMNMarsRover *rover;
@property (nonatomic, strong) DMNSolDescription *sol;

@end
