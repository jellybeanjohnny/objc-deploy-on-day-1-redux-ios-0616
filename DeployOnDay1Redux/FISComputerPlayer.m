//
//  FISComputerPlayer.m
//  DeployOnDay1Redux
//
//  Created by Timothy Clem on 9/22/15.
//  Copyright © 2015 The Flatiron School. All rights reserved.
//

#import "FISComputerPlayer.h"

@implementation FISComputerPlayer

+(BOOL)isEnabled
{
    return YES;
}

-(FISTicTacToePosition)nextPlay
{
    NSUInteger randomColumn = arc4random_uniform(3);
    NSUInteger randomRow = arc4random_uniform(3);
    
    // Generate random col/row until you find a valid position
    while (![self.game canPlayAtColumn:randomColumn row:randomRow]) {
        randomColumn = arc4random_uniform(3);
        randomRow = arc4random_uniform(3);
    }
    
    return FISTicTacToePositionMake(randomColumn, randomRow);
}

@end
