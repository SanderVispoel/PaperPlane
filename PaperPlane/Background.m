//
//  Background.m
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Background.h"
#import "Plane.h"


@implementation Background

-(id)init
{
    if ((self=[super initWithFile:@"background.gif"])) {
        
        _speed = 40;
        
        [self.texture setAliasTexParameters];
    }
    
    return self;
}

-(void)update:(ccTime)dt sprite:(Plane *)plane
{
    float rotation = fabsf(plane.rotation);
    
    // check rotation for horizontal speed, bigger angle = faster
    if (rotation == 0.0) {
        _velocity = 5.0f;
    } else if (rotation >= 5.0 && rotation < 10.0) {
        _velocity = 5.0f;
    } else if (rotation >= 10.0 && rotation < 30.0) {
        _velocity = 4.5f;
    } else if (rotation >= 30.0 && rotation < 45.0) {
        _velocity = 3.7f;
    } else if (rotation >= 45.0 && rotation < 60.0) {
        _velocity = 2.5f;
    } else if (rotation >= 60.0 && rotation <= 75.0) {
        _velocity = 2.0f;
    }

    _desiredPositionY = position_.y + ((_velocity * _speed) * dt);
}

//-(void)update:(ccTime)dt sprite:(Plane *)plane
//{
//    // 
//}

@end
