//
//  DVMCardController.h
//  DeckOfCardsObjectiveC
//
//  Created by Nick Reichard on 6/26/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class DVMCard;

@interface DVMCardController : NSObject

NS_ASSUME_NONNULL_BEGIN

+ (instancetype)sharedController;

- (void)drawNewCard:(NSInteger)numberOfCards completion:(void(^) (NSArray<DVMCard *> *cards, NSError *error))completion;
- (void)fetchCardImage:(DVMCard *)card completion:(void(^) (UIImage *image, NSError *error))completion;

NS_ASSUME_NONNULL_END

@end
