//
//  PISKDragebleNode.m
//  spritekite-test
//
//  Created by Maxim Berezhnoy on 17.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import "PISKDragebleNode.h"

@implementation PISKDragebleNode {
    SKNode* _area;
}

@synthesize nodeArea = _nodeArea;
@synthesize targetObject = _targetObject;

-(void)setNodeArea:(CGRect)nodeArea
{
    _nodeArea = nodeArea;
    if (_area!=nil)
    {
        [_area removeFromParent];
    }
    UIColor * color = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
#if __MY_APP_DEV_DRAGEBLEAREA==1
    color = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.3];
#endif
    _area = [SKSpriteNode spriteNodeWithColor:color size:_nodeArea.size];
    [self addChild:_area];
}

#pragma mark Constructor
-(PISKDragebleNode*)init
{
    PISKDragebleNode* obj = [super init];

    self.userInteractionEnabled = YES;
    self.name=@"PISKDragebleNode";

    return obj;
}

-(PISKDragebleNode*)initFor:(SKNode<PISKDragebleNodeDelegat>*)obj
{
    PISKDragebleNode* s = [self init];
    s.targetObject = obj;
    return s;
}

-(PISKDragebleNode*)initFor:(SKNode<PISKDragebleNodeDelegat>*)obj withRect:(CGRect)area
{
    PISKDragebleNode* s = [self initFor:obj];
    s.nodeArea = area;
    return s;
}

+(PISKDragebleNode*)createFor:(SKNode<PISKDragebleNodeDelegat>*)obj
{
    PISKDragebleNode* s = [[PISKDragebleNode alloc] initFor:obj];
    return s;
}

+(PISKDragebleNode*)createFor:(SKNode<PISKDragebleNodeDelegat>*)obj withRect:(CGRect)area
{
    PISKDragebleNode* s = [[PISKDragebleNode alloc] initFor:obj withRect:area];
    return s;
}

#pragma mark EventListener
-(BOOL)_containPoint:(CGPoint)p
{
    return (_nodeArea.origin.x<=p.x) && (p.x<=_nodeArea.origin.x+_nodeArea.size.width) &&
              (_nodeArea.origin.y<=p.y) && (p.y<=_nodeArea.origin.y+_nodeArea.size.height);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_targetObject respondsToSelector:@selector(onSelect)])
    {
        [_targetObject onSelect];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_targetObject==nil) return;
    
    CGPoint cp;
    CGPoint pp;
    
    for (UITouch *touch in touches)
    {
        cp = [touch locationInNode:self];
        pp = [touch previousLocationInNode:self];
        if ([self _containPoint:pp] )
        {
            _targetObject.position = CGPointMake(_targetObject.position.x - pp.x + cp.x,
                                                 _targetObject.position.y - pp.y + cp.y);
            
            if ([_targetObject respondsToSelector:@selector(onMoved)])
            {
                [_targetObject onMoved];
            }

            return;
        }
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_targetObject respondsToSelector:@selector(onUnselect)])
    {
        [_targetObject onUnselect];
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if ([_targetObject respondsToSelector:@selector(onUnselect)])
    {
        [_targetObject onUnselect];
    }
}


@end
