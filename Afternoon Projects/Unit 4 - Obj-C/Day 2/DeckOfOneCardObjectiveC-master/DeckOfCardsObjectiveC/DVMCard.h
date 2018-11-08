//
//  DVMCard.h
//  DeckOfCardsObjectiveC
//
//  Created by Nick Reichard on 6/26/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DVMCard : NSObject

@property (nonatomic, copy, readonly) NSString *suit;
@property (nonatomic, copy, readonly) NSString *image;

- (instancetype)initWithSuit:(NSString *)suit image:(NSString *)image;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary; 

@end
