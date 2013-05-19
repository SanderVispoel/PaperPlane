//
//  ActionSprite.m
//  PaperPlane
//
//  Created by Sander Vispoel on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "ActionSprite.h"


@implementation ActionSprite

-(void)update:(ccTime)dt
{
    // touching screen, update plane rotation
    if (_actionState == kActionStateTurningLeft || _actionState == kActionStateTurningRight) {
        
        [self updatePlane];
    }
    [self setDesiredPositionX:dt];
}

-(void)idle
{
    if (_actionState != kActionStateIdle) {
        // no turning
        _actionState = kActionStateIdle;
    }
}

-(void)updatePlane
{
    if (_actionState == kActionStateTurningLeft) {
        // rotate left
        if (rotation_ < 75.0f) {
            _desiredAngle = rotation_ + 5.0f;
        }
    } else if (_actionState == kActionStateTurningRight) {
        // rotate right
        if (rotation_ > -75.0f) {
            _desiredAngle = rotation_ - 5.0f;
        }
    }
    
    // mirror sprite if going left
//    if (rotation_ >= 0.0f)
//        self.scaleX = 1.0;
//    else
//        self.scaleX = -1.0;
    
    // check rotation for horizontal speed, bigger angle = faster
    float rotation = fabsf(_desiredAngle);
    if (rotation == 0.0) {
        _velocity = 0.0 * _flySpeed;
    } else if (rotation >= 5.0 && rotation < 10.0) {
        _velocity = 0.5 * _flySpeed;
    } else if (rotation >= 10.0 && rotation < 30.0) {
        _velocity = 1.2 * _flySpeed;
    } else if (rotation >= 30.0 && rotation < 45.0) {
        _velocity = 2.0 * _flySpeed;
    } else if (rotation >= 45.0 && rotation < 60.0) {
        _velocity = 2.5 * _flySpeed;
    } else if (rotation >= 60.0 && rotation <= 75.0) {
        _velocity = 3.0 * _flySpeed;
    }
}

-(void)setDesiredPositionX:(ccTime)dt
{
    // update desired position
    // if going left, change velocity for it
    if (rotation_ > 0.0) {
        // left
        _desiredPositionX = position_.x + (-_velocity * dt);
    } else {
        _desiredPositionX = position_.x + (_velocity * dt);
    }
}

-(void)turn:(CGPoint)location
{
    if (_actionState != kActionStateTurningLeft || _actionState != kActionStateTurningRight) {
        // we need to turn our plane based on touch position
        if (location.x < SCREENCENTER.x)
            _actionState = kActionStateTurningLeft;
        else if (location.x >= SCREENCENTER.x)
            _actionState = kActionStateTurningRight;
    }
}

@end
