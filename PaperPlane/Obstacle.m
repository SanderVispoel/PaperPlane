//
//  Obstacles.m
//  PaperPlane
//
//  Created by Sander Vispoel on 5/10/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Obstacle.h"
#import "GameLayer.h"
#import "Background.h"


@implementation Obstacle

+(id)obstacleWithLevel:(int)level
{
    // create obstacle from level
    return [[self alloc] initWithLevel:level];
    
}

+(id)obstacleForTransition
{
    return [[self alloc] initWithLevel:0];
}

-(id)initWithLevel:(int)level
{
    if ((self = [super initWithFile:[NSString stringWithFormat:@"shape_%02d.png", level]])) {
        
        _velocity = 5.0f;
        _desiredPositionY = 0.0f;
    }
    
    return self;
}

-(void)update:(ccTime)dt background:(Background *)bg
{
    _velocity = bg.velocity;
    int speed = bg.speed;
    _desiredPositionY = position_.y + ((_velocity * speed) * dt);
}

@end
