//
//  GameLayer.h
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Plane.h"
#import "Background.h"
#import "Obstacle.h"

@interface GameLayer : CCLayer {
    
    // todo: all sprites in single file
//    CCSpriteBatchNode *_batchNode;
    
    // plane sprite
    Plane *_plane;
    
    // obstacles
    CCArray *_obstacles;
    Obstacle *_lastObstacle;
    
    int _level;
}

//@property (nonatomic, assign)Background *background;
@property (nonatomic, assign)Background *background1;
@property (nonatomic, assign)Background *background2;

-(void)initPlane;
-(void)update:(ccTime)dt;
-(void)updatePositions;
-(void)generateLevel;
-(void)generateTransition;


@end
