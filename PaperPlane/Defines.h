//
//  Defines.h
//  PaperPlane
//
//  Created by Sander Vispoel on 5/7/13.
//
//

#ifndef PaperPlane_Defines_h
#define PaperPlane_Defines_h

// measures
#define SCREENSIZE      [[CCDirector sharedDirector] winSize]
#define SCREENCENTER    ccp(SCREENSIZE.width/2, SCREENSIZE.height/2)
#define CURTIME         CACurrentMediaTime()

// functions
#define random_range(low,high)  (arc4random()%(high-low+1))+low
#define frandom                 (float)arc4random()/UINT64_C(0x100000000)
#define frandom_range(low,high) ((high-low)*frandom)+low

// game specific
#define PLANE_SPEED     50
#define kMaxObjects     20  // level dependant?

typedef enum _ActionState {
    kActionStateIdle = 0,
    kActionStateTurningLeft,
    kActionStateTurningRight
} ActionState;

#endif
