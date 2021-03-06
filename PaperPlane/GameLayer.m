//
//  GameLayer.m
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameLayer.h"
#import "GameScene.h"

@implementation GameLayer

-(void)dealloc
{
    _plane = nil;
    [_obstacles removeAllObjects];
    _obstacles = nil;
}

-(id)init
{
    if((self=[super init])) {
        // create our paper plane
        [self initPlane];
        
        // get obstacles on screen
        _level = 1;
//        _obstacles = [[CCArray alloc] initWithCapacity:kMaxObjects];
        _obstacles = [[CCArray alloc] init];
        [self initObjects];
        
        // enable touch
        self.isTouchEnabled = YES;
        
        // updaters
        [self scheduleUpdate];
    }
    
    return self;
}

-(void)initPlane
{
    _plane = [Plane node];
    _plane.position = ccp(SCREENSIZE.width/2, (SCREENSIZE.height - (SCREENSIZE.height/4)));
    _plane.rotation = 0.0f;
    [_plane idle];
    [self addChild:_plane];
}

-(void)initObjects
{
    [self generateLevel];
}

-(void)update:(ccTime)dt
{   
    [_plane update:dt];
    [_background1 update:dt sprite:_plane];
    [_background2 update:dt sprite:_plane];
    
    Obstacle *obs;
    CCARRAY_FOREACH(_obstacles, obs) {
        [obs update:dt background:_background1];
    }
    
    [self updatePositions];
    
    // check for next level
    if ([_obstacles count] < 14) {
        _level++;
        if (_level == 6)
            _level = 1;    // TESTING
        
        [self generateLevel];
        NSLog(@"< Level %i! >", _level);
    }
}

-(void)updatePositions
{
    // update plane rotation    
    _plane.rotation = _plane.desiredAngle;
    
    // update plane position
    // check what is smallest
    // MIN(right wall, MAX(left wall, desired position from plane))
    float posX = MIN(SCREENSIZE.width - (_plane.contentSize.width / 2), MAX(_plane.contentSize.width / 2, _plane.desiredPositionX));
    _plane.position = ccp(posX, _plane.position.y);
    
    // update scrolling background position    
    _background1.position = ccp(_background1.position.x, _background1.desiredPositionY);
    _background2.position = ccp(_background2.position.x, _background2.desiredPositionY);
    
    // check if any have gone out of screen
    if (_background1.position.y > _background1.contentSize.height) {
        _background1.position = ccp(SCREENSIZE.width/2, (_background2.position.y - _background2.contentSize.height/2) + 2);
    }
    
    if (_background2.position.y > _background2.contentSize.height) {
        _background2.position = ccp(SCREENSIZE.width/2, _background1.position.y - _background1.contentSize.height/2);
    }
    
    // update obstacles
    Obstacle *obs;
    NSMutableArray *removeObs = [[NSMutableArray alloc] init];
    CCARRAY_FOREACH(_obstacles, obs) {
        obs.position = ccp(obs.position.x, obs.desiredPositionY);
        
        // remove if offscreen
        if (obs.position.y > (SCREENSIZE.height + obs.contentSize.height/2)) {
            [removeObs addObject:obs];
        }
    }
    
    // remove obstacle
    for (Obstacle  *obsToDelete in removeObs) {
        [_obstacles removeObject:obsToDelete];
//        NSLog(@"< _obstacles count: %i >", [_obstacles count]);
    }
}

-(void)generateLevel
{
    int leftOrRight = 0; // 0 = left
    
    for (int i = 0; i < 20; i++) { // test
        Obstacle *obs = [Obstacle obstacleWithLevel:_level];
        Obstacle *obs2;
        int r = (rand()%5) + 1;
        
        float startSpacing = 60.0;
        float spacing;
        if (_level >= 0 && _level < 3) {
            spacing = frandom_range(130, 90);
        } else if (_level >= 3) {
            spacing = frandom_range(100, 60);
        }
        
        if (i == 0) {
            // left
            if (_lastObstacle == NULL) {
                // very first obstacle
                obs.position = ccp(obs.contentSize.width/2, 0);
            } else {
                // next level first obstacle
                float posY = _lastObstacle.position.y - (_lastObstacle.contentSize.height + startSpacing);
                obs.position = ccp(obs.contentSize.width/2, posY);
            }
            leftOrRight = 1;
            
        } else {
            
            if (leftOrRight == 0) {
                // LEFT
                float posY = _lastObstacle.position.y - (obs.contentSize.height + spacing);
                obs.position = ccp(obs.contentSize.width/2, posY);
                
                // double obstacles
                if (r == 1) {
                    obs2 = [Obstacle obstacleWithLevel:_level];
                    float posX = frandom_range(SCREENSIZE.width, SCREENSIZE.width + obs2.contentSize.width/5);
                    obs2.position = ccp(posX, obs.position.y);
                }
                leftOrRight = 1;
            } else {
                // RIGHT
                float posY = _lastObstacle.position.y - (obs.contentSize.height + spacing);
                obs.position = ccp(SCREENSIZE.width-obs.contentSize.width/2, posY);
                
                // double obstacles
                if (r == 1) {
                    obs2 = [Obstacle obstacleWithLevel:_level];
                    float posX = frandom_range(-20.0, obs2.contentSize.width/8);
                    obs2.position = ccp(posX, obs.position.y);
                }
                leftOrRight = 0;
            }
        }
        
        [self addChild:obs];
        [_obstacles addObject:obs];
        if (obs2) {
            [self addChild:obs2];
            [_obstacles addObject:obs2];
        }
        _lastObstacle = obs;
    }
    
    [self generateTransition];
}

-(void)generateTransition
{
    Obstacle *anchorObs = _lastObstacle;
    float anchorSpacing = 60.0;
    
    // left
    for (int i = 0; i < 10; i++) {
        
        Obstacle *obstacle = [Obstacle obstacleForTransition];
        
        if (i == 0) {
            float posY = anchorObs.position.y - (obstacle.contentSize.height + anchorSpacing);
            obstacle.position = ccp(obstacle.contentSize.width/2, posY);
        } else {
            float posY = _lastObstacle.position.y - (obstacle.contentSize.height + 1);
            obstacle.position = ccp(obstacle.contentSize.width/2, posY);
        }
        
        [self addChild:obstacle];
        [_obstacles addObject:obstacle];
        _lastObstacle = obstacle;
    }
    
    // right
    for (int i = 0; i < 10; i++) {
        
        Obstacle *obstacle = [Obstacle obstacleForTransition];
        
        if (i == 0) {
            float posY = anchorObs.position.y - (obstacle.contentSize.height + anchorSpacing);
            obstacle.position = ccp(SCREENSIZE.width - obstacle.contentSize.width/2, posY);
        } else {
            float posY = _lastObstacle.position.y - (obstacle.contentSize.height + 1);
            obstacle.position = ccp(SCREENSIZE.width - obstacle.contentSize.width/2, posY);
        }
        
        [self addChild:obstacle];
        [_obstacles addObject:obstacle];
        _lastObstacle = obstacle;
    }
}

#pragma mark - Touch

-(void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint loc = [self convertTouchToNodeSpace:touch];
    [_plane turn:loc];
}

-(void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint loc = [self convertTouchToNodeSpace:touch];
    [_plane turn:loc];
}

-(void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // stop turning
    [_plane idle];
}

@end
