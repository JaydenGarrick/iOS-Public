//
//  DVMCard.m
//  DeckOfCardsObjectiveC
//
//  Created by Nick Reichard on 6/26/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

#import "DVMCard.h"

@implementation DVMCard

- (instancetype)initWithSuit:(NSString *)suit image:(NSString *)image
{
    if (self = [super init]) {
        _suit = [suit copy];
        _image = [image copy];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
   
    NSString *suit = dictionary[[DVMCard suitKey]];
    NSString *image = dictionary[[DVMCard imageKey]];
    
    return [self initWithSuit:suit image:image];
}

+ (NSString *)suitKey
{
    return @"suit";
}

+ (NSString *)imageKey
{
    return @"image";
}

@end
