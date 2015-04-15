//
//  GameScene.m
//  dodgecat
//
//  Created by Economy, Michael on 12/9/14.
//  Copyright (c) 2014 Economy, Michael. All rights reserved.
//

#import "GameScene.h"

typedef NS_ENUM(NSUInteger, CatState) {
    CatUp,
    CatDown,
    CatDodged
};

@implementation GameScene
{
    SKSpriteNode *_cat;
    SKSpriteNode *_roll;
    SKSpriteNode *_paperMiddle;
    SKSpriteNode *_paperBottom;
    SKSpriteNode *_pile;
    SKLabelNode *_scoreLabel;
    
    CatState _cat_state;
    
    int score;
}

-(void)didMoveToView:(SKView *)view {
    score = 0;
    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
    
    
    
    SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    bg.position = CGPointMake(CGRectGetMidX(self.frame),
                              CGRectGetMidY(self.frame));
    [self addChild:bg];
    
    _roll = [SKSpriteNode spriteNodeWithImageNamed:@"roll"];
    _roll.position = CGPointMake(220.0f, 220.0f);
    [self addChild:_roll];
    
    
    _paperMiddle = [SKSpriteNode spriteNodeWithImageNamed:@"paper_middle"];
    _paperMiddle.position = CGPointMake(217.0f, 214.0f);
    [self addChild:_paperMiddle];
    
    _paperBottom = [SKSpriteNode spriteNodeWithImageNamed:@"paper_bottom"];
    _paperBottom.position = CGPointMake(217.0f, 214.0f);
    [self addChild:_paperBottom];
    
    _cat = [SKSpriteNode spriteNodeWithImageNamed:@"cat"];
    _cat.position = CGPointMake(250.0f, 140.0f);
    
    _cat.zPosition = 3.0f;
    [self addChild:_cat];
    
    
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    _scoreLabel.text = @"0";
    _scoreLabel.fontSize = 36;
    _scoreLabel.fontColor = [UIColor blackColor];
    _scoreLabel.position = CGPointMake(280.0f,
                                       530.0f);
    
    [self addChild:_scoreLabel];

}

-(void)pullTP {
    
    score += 1;
    _scoreLabel.text = [NSString stringWithFormat:@"%d", score];
    
    if (score < 10) {
        CGPoint middle_pos = _paperMiddle.position;
        middle_pos.y -= 5;
        _paperMiddle.position = middle_pos;
        
        _paperMiddle.yScale += 1.0f;
        
        CGPoint bottom_pos = _paperBottom.position;
        bottom_pos.y -= 10;
        _paperBottom.position = bottom_pos;
    }
    
    if (score == 10) {
        [self removeChildrenInArray:@[_paperBottom]];
        _pile = [SKSpriteNode spriteNodeWithImageNamed:@"pile1"];
        _pile.position = CGPointMake(220.0f, 130.0f);
        _pile.zPosition = 2.0f;
        [self addChild:_pile];
    }
    
    if (score == 20) {
        _pile.texture = [SKTexture textureWithImageNamed:@"pile2"];
    }
    
    if (score == 30) {
        _pile.texture = [SKTexture textureWithImageNamed:@"pile3"];
    }
    
    if (score == 40) {
        _pile.texture = [SKTexture textureWithImageNamed:@"pile4"];
    }
    
    if (score == 50) {
        // DO NEXT LEVEL
    }

}

-(Boolean)touchedInTPArea:(CGPoint) touch_location {
//    NSLog(@"touch at %f %f", touch_location.x, touch_location.y);
    CGRect cat_click_area = CGRectMake(195.0, 121, 70, 120);
    
    return CGRectContainsPoint(cat_click_area, touch_location);
}


-(Boolean)touchInDodgeArea:(CGPoint) touch_location {
    CGRect dodge_click_area = CGRectMake(47, 65, 140, 95);
    
    return CGRectContainsPoint(dodge_click_area, touch_location);
}

-(void) moveCat {
    if (_cat_state == CatDodged) {
        _cat.position = CGPointMake(87.0f, 65.0f);
    }
    else if (_cat_state == CatDown) {
        _cat.position = CGPointMake(250.0f, 140.0f);
    }
    else if (_cat_state == CatUp) {
        _cat.position = CGPointMake(250.0f, 130.0f);
        
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
//    [event ]
    UITouch *touch = (UITouch*)[[touches allObjects] firstObject];
    CGPoint touch_location = [touch locationInNode:self];
    
    
    if ([self touchedInTPArea:touch_location]) {
        if (_cat_state == CatDodged) {
            _cat_state = CatDown;
        }
        else if (_cat_state == CatDown) {
            _cat_state = CatUp;
        }
        else if (_cat_state == CatUp) {
            _cat_state = CatDown;
            [self pullTP];
        }
        
    }
    else if ([self touchInDodgeArea:touch_location]) {
        _cat_state = CatDodged;
    }
    [self moveCat];
    
    
//    for (UITouch *touch in touches) {
//        CGPoint location = [touch locationInNode:self];
//        
//        SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
//        
//        sprite.xScale = 0.5;
//        sprite.yScale = 0.5;
//        sprite.position = location;
//        
//        SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
//        
//        [sprite runAction:[SKAction repeatActionForever:action]];
//        
//        [self addChild:sprite];
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
