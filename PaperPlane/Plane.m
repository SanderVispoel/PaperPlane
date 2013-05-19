//
//  Plane.m
//  PaperPlane
//
//  Created by Sander Vispoel on 5/9/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Plane.h"


@implementation Plane

-(id)init
{
    if ((self = [super initWithFile:@"paper_plane_crop.png"])) {
        
        self.flySpeed = PLANE_SPEED;
//        [self.texture setAliasTexParameters]; // keep pixelated
        
        // init all sprite animations here
        //
        //
    }
    
    return self;
}

@end
