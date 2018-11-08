//
//  DVMCardController.m
//  DeckOfCardsObjectiveC
//
//  Created by Nick Reichard on 6/26/18.
//  Copyright © 2018 Nick Reichard. All rights reserved.
//

#import "DVMCardController.h"
#import "DVMCard.h"

//NSString * const baseURLString = @"https://deckofcardsapi.com/api/deck/new/draw/";

@implementation DVMCardController

+ (instancetype)sharedController
{
    static DVMCardController *sharedController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedController = [[DVMCardController alloc] init];
    });
    return sharedController;
}

+ (NSURL *)baseURL
{
    return [NSURL URLWithString:@"https://deckofcardsapi.com/api/deck/new/draw/"];
}

- (void)drawNewCard:(NSInteger)numberOfCards completion:(void (^)(NSArray<DVMCard *> *, NSError *))completion
{
    
    NSString *cardCount = [@(numberOfCards) stringValue];
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:[DVMCardController baseURL] resolvingAgainstBaseURL:true];
    
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"count" value:cardCount];
    urlComponents.queryItems = @[queryItem];
    NSURL *searchURL = urlComponents.URL;
    
    
    [[[NSURLSession sharedSession] dataTaskWithURL:searchURL completionHandler:^(NSData * data, NSURLResponse *response, NSError * error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return completion(nil, [NSError errorWithDomain:@"error Fetching json" code:(NSInteger)-1 userInfo:nil]);
        }
        
        if (!data) {
            NSLog(@"Error: no data returned from task");
            return completion(nil, [NSError errorWithDomain:@"error Fetching Data" code:(NSInteger)-1 userInfo:nil]);
        }
        
        NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
        
        if (!jsonDictionary || ![jsonDictionary isKindOfClass:[NSDictionary class]]) {
            NSDictionary *userInfo = nil;
            if (error) { userInfo = @{NSUnderlyingErrorKey : error}; }
            NSError *localError = [NSError errorWithDomain:@"com.DevMountain.RedditUnit3Test.ErrorDomain" code:-1 userInfo:userInfo];
            NSLog(@"%@", error.localizedDescription);
            return completion(nil, localError);
        }
        
        NSArray *cardsArray = jsonDictionary[@"cards"];
        NSMutableArray *cardsPlaceholder = [NSMutableArray array];
        
        for (NSDictionary *cardDictionary in cardsArray) {
            
            DVMCard *card = [[DVMCard alloc] initWithDictionary: cardDictionary];
            [cardsPlaceholder addObject: card];
        }
        completion(cardsPlaceholder, nil);
        
        
    }]resume];
}


- (void)fetchCardImage:(DVMCard *)card completion:(void (^)(UIImage *, NSError * ))completion
{
    
    NSURL *imageURL = [NSURL URLWithString:card.image];
    
    [[[NSURLSession sharedSession] dataTaskWithURL:imageURL completionHandler:^(NSData * data, NSURLResponse *  response, NSError * error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
            return completion(nil, [NSError errorWithDomain:@"error Fetching json" code:(NSInteger)-1 userInfo:nil]);
        }
        
        if (!data) {
            NSLog(@"Error: no image data returned from task");
            return completion(nil, [NSError errorWithDomain:@"error Fetching Image Data" code:(NSInteger)-1 userInfo:nil]);
        }
        
        UIImage *cardImage = [UIImage imageWithData:data];
        completion(cardImage, nil);
        
    }]resume];
}


@end






