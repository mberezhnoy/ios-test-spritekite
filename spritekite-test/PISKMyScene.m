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
    SKSpriteNode* _transformedImage;
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
    
    [self imageTransform];

}

-(void)imageTransform
{
    static BOOL thread_lock;
    static BOOL fire_next;
    
    if (thread_lock)
    {
        fire_next = YES;
        return;
    }
    
    thread_lock = YES;
    dispatch_async(dispatch_get_global_queue(0,0), ^{
        UIImage * img = [UIImage imageNamed:@"Spaceship"];
        CIImage * imgIn = [[CIImage alloc] initWithImage:img];
        CIFilter *filter = [CIFilter filterWithName:@"CIPerspectiveTransform"];
        [filter setDefaults];
        [filter setValue:imgIn forKey:@"inputImage"];
        PISKPointNode *p = _points[0];
        NSArray * filterKeys = @[@"inputBottomLeft", @"inputBottomRight", @"inputTopRight", @"inputTopLeft"];
        float top = p.position.y;
        float bottom = p.position.y;
        float left = p.position.x;
        float right = p.position.x;
        for(int i=0; i<4;i++)
        {
            p = _points[i];
            [filter setValue:[CIVector vectorWithX:p.position.x Y:p.position.y ] forKey:filterKeys[i]];
            if(p.position.y > top) top = p.position.y;
            if(p.position.y < bottom) bottom = p.position.y;
            if(p.position.x > right) right = p.position.x;
            if(p.position.x < left) left = p.position.x;
        }

        CIContext *context = [CIContext contextWithOptions:nil];
        CIImage *imgOut = [filter outputImage];
        CGImageRef cg = [context createCGImage:imgOut fromRect:[imgOut extent]];
        SKTexture * texture = [SKTexture textureWithCGImage:cg];
        SKSpriteNode* theSprite = [SKSpriteNode spriteNodeWithTexture: texture];
        theSprite.position = CGPointMake( (left+right)/2, (top+bottom)/2);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self addChild:theSprite];
            if (_transformedImage != nil) [_transformedImage removeFromParent];
            _transformedImage = theSprite;
        });
        
        thread_lock = NO;
        if (fire_next)
        {
            fire_next = NO;
            [self imageTransform];
        }
    });
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    for (UITouch *touch in touches) {
//    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
