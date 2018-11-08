//
//  DMNPhotosCollectionViewController.m
//  Rover
//
//  Created by Andrew Madsen on 2/23/17.
//  Copyright © 2017 DevMountain. All rights reserved.
//

#import "DMNPhotosCollectionViewController.h"
#import "DMNSolDescription.h"
#import "DMNMarsRoverClient.h"
#import "DMNMarsPhoto.h"
#import "DMNPhotoCollectionViewCell.h"
#import "DMNPhotoCache.h"
#import "Rover-Swift.h"

@interface DMNPhotosCollectionViewController ()

@property (nonatomic, strong, readonly) DMNMarsRoverClient *client;
@property (nonatomic, copy) NSArray *photoReferences;

@end

@implementation DMNPhotosCollectionViewController

static NSString * const reuseIdentifier = @"PhotoCell";

- (void)viewDidLoad
{
	[super viewDidLoad];
	
	[self fetchPhotoReferences];
}

#pragma mark - Private

- (void)fetchPhotoReferences
{
	if (!self.rover || !self.sol) {
		return;
	}
	
	DMNMarsRoverClient *client = [[DMNMarsRoverClient alloc] init];
	[client fetchPhotosFromRover:self.rover onSol:self.sol.sol completion:^(NSArray *photos, NSError *error) {
		if (error) {
			NSLog(@"Error getting photo references for %@ on %@: %@", self.rover, self.sol, error);
			return;
		}
		dispatch_async(dispatch_get_main_queue(), ^{
			self.photoReferences = photos;
		});
	}];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
	return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.photoReferences.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DMNPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
	
	DMNMarsPhoto *photo = self.photoReferences[indexPath.row];
	
	DMNPhotoCache *cache = [DMNPhotoCache sharedCache];
	NSData *cachedData = [cache imageDataForIdentifier:photo.identifier];
	if (cachedData) {
		cell.imageView.image = [UIImage imageWithData:cachedData];
		return cell;
	} else {
		cell.imageView.image = [UIImage imageNamed:@"MarsPlaceholder"];
	}
	
	[self.client fetchImageDataForPhoto:photo completion:^(NSData *imageData, NSError *error) {
		if (error || !imageData) {
			NSLog(@"Error fetching image data for %@: %@", photo, error);
			return;
		}
		
		[cache cacheImageData:imageData forIdentifier:photo.identifier];
		UIImage *image = [UIImage imageWithData:imageData];
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if (![indexPath isEqual:[collectionView indexPathForCell:cell]]) {
				return; // Cell has been reused for another photo
			}
			cell.imageView.image = image;
		});
	}];
	
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"PhotoDetailSegue"]) {
		PhotoDetailViewController *detailVC = segue.destinationViewController;
		NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] firstObject];
		detailVC.photo = self.photoReferences[indexPath.row];
	}
}

#pragma mark - Properties

@synthesize client = _client;
- (DMNMarsRoverClient *)client
{
	if (!_client) {
		_client = [[DMNMarsRoverClient alloc] init];
	}
	return _client;
}

- (void)setRover:(DMNMarsRover *)rover
{
	if (rover != _rover) {
		_rover = rover;
		[self fetchPhotoReferences];
	}
}

- (void)setSol:(DMNSolDescription *)sol
{
	if (sol != _sol) {
		_sol = sol;
		[self fetchPhotoReferences];
	}
}

- (void)setPhotoReferences:(NSArray *)photoReferences
{
	if (photoReferences != _photoReferences) {
		_photoReferences = [photoReferences copy];
		[self.collectionView reloadData];
	}
}

@end
