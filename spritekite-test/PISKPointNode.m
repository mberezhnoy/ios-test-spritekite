//
//  PISKPointNode.m
//  spritekite-test
//
//  Created by Maxim Berezhnoy on 17.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PISKPointNode.h"
#import "PISKMyScene.h"

@implementation PISKPointNode {
    PISKDragebleNode * _dragebleArea;
    SKShapeNode * _pointNode;
    SKSpriteNode * _wrapNode;
}

float const kDefaultSize = 30;
float const kDefaultColorR = 1;
float const kDefaultColorG = 1;
float const kDefaultColorB = 1;
float const kMinTouchSize = 40;
float const kWrapSizeMultiplier = 1.7;
float const kWrapPulsFactor = 1.5;
float const kWrapPulsTime = 2;
float const kWrapDisappearTime = 0.5;
float const kWrapRotate = -5*M_2_PI;
NSString * const kWrapSprite = @"round";


@synthesize pointColor = _pointColor;
@synthesize pointSize = _pointSize;
@synthesize touchAreaSize = _touchAreaSize;

-(void)setPointColor:(UIColor *)pointColor
{
    _pointColor = pointColor;
    [self _updatePointNode];
}

-(void)setPointSize:(CGFloat)pointSize
{
    _pointSize = pointSize;
    [self _updatePointNode];
}

-(void)setTouchAreaSize:(CGFloat)size
{
    _touchAreaSize = size;
    _dragebleArea.nodeArea = CGRectMake(-size/2, -size/2, size, size);
}

-(void)_updatePointNode
{
    if (_pointNode!=nil)
    {
        [_pointNode removeFromParent];
    }
    CGRect circle = CGRectMake(-_pointSize/2, -_pointSize/2, _pointSize, _pointSize);
    _pointNode = [SKShapeNode node];
    _pointNode.path = [UIBezierPath bezierPathWithOvalInRect:circle].CGPath;
    _pointNode.fillColor = _pointColor;
    _pointNode.strokeColor = _pointColor;
    _pointNode.lineWidth = 0.01;
    _pointNode.zPosition = 1;
    [self addChild:_pointNode];
    
    if(_wrapNode==nil)
    {
        _wrapNode = [SKSpriteNode spriteNodeWithImageNamed:kWrapSprite];
        _wrapNode.alpha = 0;
        SKAction * puls = [SKAction group:@[
                                            [SKAction rotateByAngle:kWrapRotate duration:kWrapPulsTime],
                                            [SKAction sequence:@[
                                                                 [SKAction scaleBy:kWrapPulsFactor duration:kWrapPulsTime/2],
                                                                 [SKAction scaleBy:1/kWrapPulsFactor duration:kWrapPulsTime/2]
                                                                 ] ] ] ];
        puls = [SKAction repeatActionForever:puls];
        [_wrapNode runAction:puls];
        [self addChild:_wrapNode];
    }
    [_wrapNode setSize:CGSizeMake(kWrapSizeMultiplier*_pointSize, kWrapSizeMultiplier*_pointSize)];
}

#pragma mark Constructor
-(PISKPointNode*)init
{
    SKColor * color = [SKColor colorWithRed:kDefaultColorR green:kDefaultColorG blue:kDefaultColorB alpha:1];
    PISKPointNode* node = [self initWithColor:color andSize:kDefaultSize];
    return node;
}

-(PISKPointNode*)initWithColor:(SKColor*)color
{
    PISKPointNode* node = [self initWithColor:color andSize:kDefaultSize];
    return node;
}

-(PISKPointNode*)initWithColor:(SKColor*)color andSize:(CGFloat)diameter
{
    self = [super init];
    _pointSize = diameter;
    _pointColor = color;
    [self _updatePointNode];
    
    _dragebleArea = [PISKDragebleNode createFor:self];
    _dragebleArea.zPosition = 2;
    self.touchAreaSize = diameter>kMinTouchSize ? diameter : kMinTouchSize;
    [self addChild:_dragebleArea];
    
    return self;
}

+(PISKPointNode*)createWithColor:(SKColor*)color
{
    PISKPointNode* node = [[PISKPointNode alloc] initWithColor:color];
    return node;
}

+(PISKPointNode*)createWithColor:(SKColor*)color andSize:(CGFloat)diameter
{
    PISKPointNode* node = [[PISKPointNode alloc] initWithColor:color andSize:diameter];
    return node;
}

#pragma mark PISKDragebleNodeDelegat
-(void)onMoved
{
    PISKMyScene *scren = (PISKMyScene*)self.parent;
    [scren updatePoints];
}

-(void)onSelect
{
    [_wrapNode runAction:[SKAction fadeAlphaTo:1 duration:kWrapDisappearTime]];
}

-(void)onUnselect
{
    [_wrapNode runAction:[SKAction fadeAlphaTo:0 duration:kWrapDisappearTime]];
}

@end
