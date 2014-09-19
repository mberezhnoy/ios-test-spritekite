//
//  PISKPointNode.h
//  spritekite-test
//
//  Created by Maxim Berezhnoy on 17.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "PISKDragebleNode.h"

@interface PISKPointNode : SKNode <PISKDragebleNodeDelegat>

@property (nonatomic) SKColor* pointColor;
@property (nonatomic) CGFloat pointSize;
@property (nonatomic) CGFloat touchAreaSize;

-(PISKPointNode*)initWithColor:(SKColor*)color;
-(PISKPointNode*)initWithColor:(SKColor*)color andSize:(CGFloat)diameter;

+(PISKPointNode*)createWithColor:(SKColor*)color;
+(PISKPointNode*)createWithColor:(SKColor*)color andSize:(CGFloat)diameter;

@end
