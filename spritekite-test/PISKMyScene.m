//
//  PISKMyScene.m
//  spritekite-test
//
//  Created by Maxim Berezhnoy on 16.09.14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "PISKMyScene.h"
#import "PISKPointNode.h"

@implementation PISKMyScene {
    NSArray * _points;
    SKShapeNode * _borderNode;
}

-(id)initWithSize:(CGSize)size {
    //[CIFilter filterNamesInCategory:kCICategoryBlur];
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:1.0];
        
        PISKPointNode * p1 = [PISKPointNode createWithColor:[SKColor cyanColor]];
        PISKPointNode * p2 = [PISKPointNode createWithColor:[SKColor magentaColor]];
        PISKPointNode * p3 = [PISKPointNode createWithColor:[SKColor yellowColor]];
        PISKPointNode * p4 = [PISKPointNode createWithColor:[SKColor purpleColor]];
        p1.zPosition = 1;
        p2.zPosition = 1;
        p3.zPosition = 1;
        p4.zPosition = 1;
        p1.position = CGPointMake(30, 30);
        p2.position = CGPointMake(size.width-30, 30);
        p3.position = CGPointMake(size.width-30, size.height-30);
        p4.position = CGPointMake(30, size.height-30);
        [self addChild:p1];
        [self addChild:p2];
        [self addChild:p3];
        [self addChild:p4];
        _points = @[p1, p2, p3, p4];
        
        _borderNode = [SKShapeNode node];
        _borderNode.strokeColor = [SKColor greenColor];
        _borderNode.lineWidth = 3;
        [self updatePoints];
        [self addChild:_borderNode];
    }
    return self;
}

-(void)updatePoints
{
    CGMutablePathRef pathToDraw = CGPathCreateMutable();
    NSInteger cnt = [_points count];
    PISKPointNode *p = _points[cnt-1];
    CGPathMoveToPoint(pathToDraw, NULL, p.position.x, p.position.y);
    for(NSInteger i=0; i<cnt; i++)
    {
        p = _points[i];
        CGPathAddLineToPoint(pathToDraw, NULL, p.position.x, p.position.y);
    }
    _borderNode.path = pathToDraw;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *touch in touches) {
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
