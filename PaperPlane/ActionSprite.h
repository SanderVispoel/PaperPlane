//
//  ActionSprite.h
//  PaperPlane
//
//  Created by Sander Vispoel on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface ActionSprite : CCSprite {
    
}

@property (nonatomic, assign)ActionState actionState;
@property (nonatomic, assign)float desiredAngle;
@property (nonatomic, assign)float desiredPositionX;
@property (nonatomic, assign)float velocity;
@property (nonatomic, assign)float flySpeed;

// sprite methods
-(void)idle;
-(void)updatePlane;
-(void)setDesiredPositionX:(ccTime)dt;
-(void)turn:(CGPoint)location;

// scheduled methods
-(void)update:(ccTime)dt;

@end
