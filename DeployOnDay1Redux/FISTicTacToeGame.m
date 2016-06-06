//
//  FISTicTacToeGame.m
//  DeployOnDay1Redux
//
//  Created by Timothy Clem on 9/22/15.
//  Copyright © 2015 The Flatiron School. All rights reserved.
//

#import "FISTicTacToeGame.h"

#define kNSUserDefaultsOPlayerWinCount @"oPlayerWinCount"
#define kNSUserDefaultsXPlayerWinCount @"xPlayerWinCount"


@interface FISTicTacToeGame ()
{
    NSUInteger _xPlayerWinCount;
    NSUInteger _oPlayerWinCount;
}
@property (nonatomic, strong) NSMutableArray *board;

@end


@implementation FISTicTacToeGame

@synthesize xPlayerWinCount = _xPlayerWinCount;
@synthesize oPlayerWinCount = _oPlayerWinCount;

-(instancetype)init
{
    self = [super init];
    if(self) {
        // Do initialization of your game here, inside this if statement.
        // Leave the rest of this method alone :)
        
        [self resetBoard];

    }

    return self;
}

#pragma mark - Overriding Setters/Getters For PlayerCount
- (void)setOPlayerWinCount:(NSUInteger)oPlayerWinCount
{
    _oPlayerWinCount = oPlayerWinCount;
    
    [[NSUserDefaults standardUserDefaults] setObject:@(oPlayerWinCount) forKey:kNSUserDefaultsOPlayerWinCount];
}

- (void)setXPlayerWinCount:(NSUInteger)xPlayerWinCount
{
    _xPlayerWinCount = xPlayerWinCount;
    [[NSUserDefaults standardUserDefaults] setObject:@(xPlayerWinCount) forKey:kNSUserDefaultsXPlayerWinCount];
}

- (NSUInteger)oPlayerWinCount
{
    // Check if we've previously saved this to defaults...
    NSNumber *oCount = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsOPlayerWinCount];
    if (oCount) {
        return [oCount unsignedIntegerValue];
    }
    else {
        return _oPlayerWinCount;
    }
}

- (NSUInteger)xPlayerWinCount
{
    NSNumber *xCount = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsXPlayerWinCount];
    if (xCount) {
        return [xCount unsignedIntegerValue];
    }
    else {
        return _xPlayerWinCount;
    }
}

#pragma mark

/**
 Creates an 3x3 grid that holds all empty string objects
 */
-(void)resetBoard
{
    [self.board removeAllObjects];
    
    self.board = [[NSMutableArray alloc] initWithCapacity:3];
    
    for (NSInteger index = 0; index < 3; index++) {
        // create a row and add it to the board
        NSMutableArray *column = [[NSMutableArray alloc] initWithArray:@[@"", @"", @""]];
        [self.board addObject:column];
    }
    
}

- (void)_loadPlayerWinCount
{
    NSNumber *oWinCount = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsOPlayerWinCount];
    if (!oWinCount) {
        NSLog(@"No previous oWinCount");
    }
    else {
        _oPlayerWinCount = [oWinCount unsignedIntegerValue];
    }
    
    NSNumber *xWinCount = [[NSUserDefaults standardUserDefaults] objectForKey:kNSUserDefaultsXPlayerWinCount];
    if (!xWinCount) {
        NSLog(@"No previous xWinCount");
    }
    else {
        _xPlayerWinCount = [xWinCount unsignedIntegerValue];
    }
}

- (void)_savePlayerWinCount
{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.oPlayerWinCount) forKey:kNSUserDefaultsOPlayerWinCount];
    [[NSUserDefaults standardUserDefaults] setObject:@(self.xPlayerWinCount) forKey:kNSUserDefaultsXPlayerWinCount];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSString *)playerAtColumn:(NSUInteger)column row:(NSUInteger)row
{
    return self.board[column][row];
}

/**
 Returns YES if the col/row is a valid space the player can move to. In this case it needs to be an empty string
 */
-(BOOL)canPlayAtColumn:(NSUInteger)column row:(NSUInteger)row
{
    NSString *possibleMove = self.board[column][row];
    if ([possibleMove isEqualToString:@""]) {
        return YES;
    }
    return NO;
}

-(void)playXAtColumn:(NSUInteger)column row:(NSUInteger)row
{
    self.board[column][row] = @"X";
}

-(void)playOAtColumn:(NSUInteger)column row:(NSUInteger)row
{
    self.board[column][row] = @"O";
}

-(NSString *)winningPlayer
{
    // Check each column
    NSString *column = [self _checkColumn];
    if (![column isEqualToString:@""]) {
        return column;
    }
    
    // check each row
    NSString *row = [self _checkRows];
    if (![row isEqualToString:@""]) {
        return row;
    }
    
    // check diagnals
    NSString *diag = [self _checkDiagnal];
    if (![diag isEqualToString:@""]){
        return diag;
    }
    
    return @"";
}


/**
 Returns either X or O if all there are the same in a column, otherwise returns an empty string
 */
- (NSString *)_checkColumn
{
    for (NSArray *column in self.board) {
        NSString *firstSpace = column[0];
        
        // if a segment contains an empty string it cannot be part of a win
        if ([firstSpace isEqualToString:@""]) {
            continue;
        }
        NSSet *segmentSet = [[NSSet alloc] initWithArray:column];
        
        if (segmentSet.count == 1) {
            return [segmentSet anyObject];
        }
    }
    return @"";
}

/**
 Returns either X or O if all there are the same in a column, otherwise returns an empty string
 */
- (NSString *)_checkRows
{
    for (NSUInteger row = 0; row < 3; row++) {
        NSMutableSet *rowSet = [[NSMutableSet alloc] initWithCapacity:3];
        for (NSUInteger col = 0; col < 3; col++) {
            [rowSet addObject:self.board[col][row]];
        }
        if (rowSet.count == 1 && ![[rowSet anyObject] isEqualToString:@""]) {
            return [rowSet anyObject];
        }
    }
    
    return @"";
}

- (NSString *)_checkDiagnal
{
    /*
     // top left to bottom right
     [0][0] [1][1] [2][2]
     
     
     // bottom left to top right
     [0][2] [1][1] [2][0]
     */
    
    NSString *candidate = [self _checkTopLeftToBottomRight];
    if (![candidate isEqualToString:@""]) {
        return candidate;
    }
    
    NSString *anotherCandidate = [self _checkBottomLeftToTopRight];
    if (![anotherCandidate isEqualToString:@""]) {
        return anotherCandidate;
    }
    
    return @"";
}

- (NSString *)_checkTopLeftToBottomRight
{
    NSMutableSet *topLeftToBottomRightSet = [[NSMutableSet alloc] initWithCapacity:3];
    
    NSUInteger row = 0;
    for (NSUInteger col = 0; col < 3; col++) {
        [topLeftToBottomRightSet addObject:self.board[col][row]];
        row++;
    }
    
    if (topLeftToBottomRightSet.count == 1 && ![[topLeftToBottomRightSet anyObject] isEqualToString:@""]) {
        return [topLeftToBottomRightSet anyObject];
    }
    return @"";
}

- (NSString *)_checkBottomLeftToTopRight
{
    NSMutableSet *bottomLeftToTopRightSet = [[NSMutableSet alloc] initWithCapacity:3];
    
    NSUInteger row = 2;
    for (NSUInteger col = 0; col < 3; col++) {
        [bottomLeftToTopRightSet addObject:self.board[col][row]];
        row--;
    }

    if (bottomLeftToTopRightSet.count == 1 && ![[bottomLeftToTopRightSet anyObject] isEqualToString:@""]) {
        return [bottomLeftToTopRightSet anyObject];
    }
    
    return @"";
}

-(BOOL)isADraw
{
    if ([[self winningPlayer] isEqualToString:@""] && [self _isBoardFull]) {
        return YES;
    }
    
    return NO;
}

- (BOOL)_isBoardFull
{
    for (NSArray *column in self.board) {
        if ([column containsObject:@""]) {
            return NO;
        }
    }
    return YES;
}



@end
