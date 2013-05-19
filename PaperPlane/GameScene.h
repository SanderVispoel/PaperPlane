//
//  GameScene.h
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Background.h"
#import "GameLayer.h"

@interface GameScene : CCScene {
    
}

@property (nonatomic, weak) Background *bg;
@property (nonatomic, weak) GameLayer *gameLayer;

+(CCScene *) scene;

@end
