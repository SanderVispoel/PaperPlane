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
    if ([_obstacles count] < 10) {
        _level++;
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
            _objectsOffscreen++;
        }
    }
    
    // remove obstacle
    for (Obstacle  *obsToDelete in removeObs) {
        [_obstacles removeObject:obsToDelete];
        NSLog(@"< _obstacles count: %i >", [_obstacles count]);
    }
}

-(void)generateLevel
{
    int leftOrRight = 0; // 0 = left
    
//    for (int i = 0; i < kMaxObjects; i++) {
    for (int i = 0; i < 10; i++) { // test
        Obstacle *obs = [Obstacle obstacleWithLevel:_level];
        [obs.texture setAliasTexParameters];
        
        if (i == 0) {
            // left
            if (_lastObstacle == NULL) {
                // very first obstacle
                obs.position = ccp(obs.contentSize.width/2, 0);
            } else {
                // next level first obstacle
                float posY = _lastObstacle.position.y - (_lastObstacle.contentSize.height + 20);
                obs.position = ccp(obs.contentSize.width/2, posY);
            }
            leftOrRight = 1;
        } else {
            if (leftOrRight == 0) {
                // left
                float posY = _lastObstacle.position.y - (obs.contentSize.height + 20);
                obs.position = ccp(obs.contentSize.width/2, posY);
                leftOrRight = 1;
            } else {
                // right
                float posY = _lastObstacle.position.y - (obs.contentSize.height + 20);
                obs.position = ccp(SCREENSIZE.width-obs.contentSize.width/2, posY);
                leftOrRight = 0;
            }
        }
        
        [self addChild:obs];
        [_obstacles addObject:obs];
        _lastObstacle = obs;
    }
    
    [self generateTransition];
}

-(void)generateTransition
{
    Obstacle *anchorObs = _lastObstacle;
    
    // left
    for (int i = 0; i < 10; i++) {
        
        Obstacle *obstacle = [Obstacle obstacleForTransition];
        if (i == 0) {
            float posY = anchorObs.position.y - (obstacle.contentSize.height + 20);
            obstacle.position = ccp(obstacle.contentSize.width/2, posY);
        } else {
            float posY = _lastObstacle.position.y - (obstacle.contentSize.height + 3);
            obstacle.position = ccp(obstacle.contentSize.width/2, posY);
        }
        
        [self addChild:obstacle];
        [_obstacles addObject:obstacle];        // put in different array?
        
        _lastObstacle = obstacle;
    }
    
    // right
    for (int i = 0; i < 10; i++) {
        
        Obstacle *obstacle = [Obstacle obstacleForTransition];
        if (i == 0) {
            float posY = anchorObs.position.y - (obstacle.contentSize.height + 20);
            obstacle.position = ccp(SCREENSIZE.width - obstacle.contentSize.width/2, posY);
        } else {
            float posY = _lastObstacle.position.y - (obstacle.contentSize.height + 3);
            obstacle.position = ccp(SCREENSIZE.width - obstacle.contentSize.width/2, posY);
        }
        
        [self addChild:obstacle];
        [_obstacles addObject:obstacle];        // put in different array?
        
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
