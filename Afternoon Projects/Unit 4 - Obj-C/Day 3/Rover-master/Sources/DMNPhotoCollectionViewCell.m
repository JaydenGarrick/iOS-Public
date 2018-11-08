//
//  DMNPhotoCollectionViewCell.m
//  Rover
//
//  Created by Andrew Madsen on 2/23/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNPhotoCollectionViewCell.h"

@implementation DMNPhotoCollectionViewCell

- (void)prepareForReuse
{
	[super prepareForReuse];
	
	self.imageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
}

@end
