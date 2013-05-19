//
//  Background.h
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
@class Plane;

@interface Background : CCSprite {
    
}

@property (nonatomic, assign)float speed;
@property (nonatomic, assign)float velocity;
@property (nonatomic, assign)float desiredPositionY;

-(void)update:(ccTime)dt sprite:(Plane *)plane;

@end
