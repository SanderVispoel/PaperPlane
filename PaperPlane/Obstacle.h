//
//  Obstacles.h
//  PaperPlane
//
//  Created by Sander Vispoel on 5/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Background;

@interface Obstacle : CCSprite {
    
}

@property (nonatomic, assign)float velocity;
@property (nonatomic, assign)float desiredPositionY;

+(id)obstacleWithLevel:(int)level;
+(id)obstacleForTransition;
-(id)initWithLevel:(int)level;
//+(void)generateObstacleWithLevel:(int)level;
-(void)update:(ccTime)dt background:(Background *)bg;

@end
