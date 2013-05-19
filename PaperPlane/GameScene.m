//
//  GameScene.m
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "GameScene.h"
#import "Background.h"
#import "GameLayer.h"


@implementation GameScene

+(CCScene *) scene
{
	CCScene *scene = [CCScene node];
	GameScene *layer = [GameScene node];
	[scene addChild: layer];
    
	return scene;
}

-(id)init
{
    if ((self = [super init])) {
        
        // backgrounds
//        _bg = [Background node];
        Background *bg1 = [Background node];
        Background *bg2 = [Background node];
        bg1.position = SCREENCENTER;
        bg2.position = ccp(SCREENSIZE.width/2, (bg1.position.y - bg1.contentSize.height/2));
        
        // gamelayer + set gamelayer as parent of the background
        _gameLayer = [GameLayer node];
        [self addChild:_gameLayer z:0];
        [_gameLayer setBackground1:bg1];
        [_gameLayer setBackground2:bg2];
        [_gameLayer addChild:bg1 z:-6];
        [_gameLayer addChild:bg2 z:-6];
    }
    
    return self;
}

@end
