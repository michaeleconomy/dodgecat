//
//  GameScene.m
//  dodgecat
//
//  Created by Economy, Michael on 12/9/14.
//  Copyright (c) 2014 Economy, Michael. All rights reserved.
//

#import "GameScene.h"

#define OFF_SCREEN (CGPointMake(9999.0f, 9999.0f))


typedef NS_ENUM(NSUInteger, CatState) {
    CatUp,
    CatDown,
    CatDodged,
    CatHurt,
};

@implementation GameScene
{
    SKTexture *_normalCatTexture;
    SKTexture *_dodgedCatTexture;
    
    SKSpriteNode *_cat;
    SKSpriteNode *_roll;
    SKSpriteNode *_paperMiddle;
    SKSpriteNode *_paperBottom;
    SKSpriteNode *_pile;
    SKLabelNode *_scoreLabel;
    
    NSArray *_pileTextures;
    
    NSTimer *_projectileTimer;
    
    CatState _cat_state;
    
    int level_score;
    
    int total_score;
    
    int level;
}

-(void)didMoveToView:(SKView *)view {
    /* Setup your scene here */
//    SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//    
//    myLabel.text = @"Hello, World!";
//    myLabel.fontSize = 65;
//    myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                   CGRectGetMidY(self.frame));
//    
//    [self addChild:myLabel];
    
    
    [self setUpGame];
}

-(void)setUpGame {
    level = 1;
    total_score = 0;

    
    SKSpriteNode * bg = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    bg.position = CGPointMake(CGRectGetMidX(self.frame),
                              CGRectGetMidY(self.frame));
    [self addChild:bg];
    
    _roll = [SKSpriteNode spriteNodeWithImageNamed:@"roll"];
    
    [self addChild:_roll];
    
    
    _paperMiddle = [SKSpriteNode spriteNodeWithImageNamed:@"paper_middle"];
    
    [self addChild:_paperMiddle];
    
    _paperBottom = [SKSpriteNode spriteNodeWithImageNamed:@"paper_bottom"];
    [self addChild:_paperBottom];
    
    _normalCatTexture = [SKTexture textureWithImageNamed:@"cat"];
    _dodgedCatTexture = [SKTexture textureWithImageNamed:@"dodged_cat"];
    _cat = [SKSpriteNode spriteNodeWithTexture:_normalCatTexture];
    _cat.position = CGPointMake(250.0f, 140.0f);
    
    _cat.zPosition = 3.0f;
    [self addChild:_cat];
    
    
    
    _scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    
    _scoreLabel.text = @"0";
    _scoreLabel.fontSize = 36;
    _scoreLabel.fontColor = [UIColor blackColor];
    _scoreLabel.position = CGPointMake(280.0f, 530.0f);
    
    [self addChild:_scoreLabel];
    _pileTextures = @[[SKTexture textureWithImageNamed:@"pile1"],
                      [SKTexture textureWithImageNamed:@"pile2"],
                      [SKTexture textureWithImageNamed:@"pile3"],
                      [SKTexture textureWithImageNamed:@"pile4"]];
    
    _pile = [SKSpriteNode spriteNodeWithTexture:_pileTextures[0]];
    _pile.zPosition = 2.0f;
    [self addChild:_pile];
    
    [self setUpLevel];
}

-(void)setUpLevel {
    level_score = 0;
    
    
    _pile.position = OFF_SCREEN;
    _roll.position = CGPointMake(220.0f, 220.0f);
    
    _paperMiddle.position = CGPointMake(217.0f, 215.0f);
    _paperMiddle.yScale = 1.0f;
    
    
    _paperBottom.position = CGPointMake(217.0f, 214.0f);
    
    
    _cat.texture = _normalCatTexture;
    _cat.position = CGPointMake(250.0f, 140.0f);
    _cat_state = CatDown;
    
    
    //TODO: tell the user what level they're on
    
    //TODO - start projectile timer
}

-(void)levelComplete {
    //TODO - stop projectile timer
    //TODO - TP falls off roll
    //TODO- cat celebrate
    level++;
    [self setUpLevel];
}

-(void)pullTP {
    
    level_score++;
    total_score++;
    _scoreLabel.text = [NSString stringWithFormat:@"%d", total_score];
    
    if (level_score < 10) {
        CGPoint middle_pos = _paperMiddle.position;
        middle_pos.y -= 5;
        _paperMiddle.position = middle_pos;
        
        _paperMiddle.yScale += 1.0f;
        
        CGPoint bottom_pos = _paperBottom.position;
        bottom_pos.y -= 10;
        _paperBottom.position = bottom_pos;
    }
    
    if (level_score == 10) {
        _paperBottom.position = OFF_SCREEN;
        _pile.position = CGPointMake(220.0f, 130.0f);
        _pile.texture = _pileTextures[0];
    }
    
    if (level_score == 20) {
        _pile.texture = _pileTextures[1];
    }
    
    if (level_score == 30) {
        _pile.texture = _pileTextures[2];
    }
    
    if (level_score == 40) {
        _pile.texture = _pileTextures[3];
    }
    
    if (level_score == 50) {
        [self levelComplete];
    }

}

-(Boolean)touchedInTPArea:(CGPoint) touch_location {
//    NSLog(@"touch at %f %f", touch_location.x, touch_location.y);
    CGRect cat_click_area = CGRectMake(195.0, 121, 70, 120);
    
    return CGRectContainsPoint(cat_click_area, touch_location);
}


-(Boolean)touchInDodgeArea:(CGPoint) touch_location {
    CGRect dodge_click_area = CGRectMake(47, 65, 140, 150);
    
    return CGRectContainsPoint(dodge_click_area, touch_location);
}

-(void) moveCat {
    if (_cat_state == CatDodged) {
        _cat.position = CGPointMake(107.0f, 105.0f);
        _cat.texture = _dodgedCatTexture;
    }
    else if (_cat_state == CatDown) {
        _cat.position = CGPointMake(250.0f, 140.0f);
        _cat.texture = _normalCatTexture;
    }
    else if (_cat_state == CatUp) {
        _cat.position = CGPointMake(250.0f, 130.0f);
        _cat.texture = _normalCatTexture;
        
    }
    _cat.size = _cat.texture.size;
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
