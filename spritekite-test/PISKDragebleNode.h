//
//  PISKDragebleNode.h
//  spritekite-test
//
//  Created by Maxim Berezhnoy on 17.09.14.
//  Copyright (c) 2014 Maxim Berezhnoy. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@protocol PISKDragebleNodeDelegat <NSObject>

@optional

-(void)onSelect;
-(void)onUnselect;
-(void)onMoved;

@end

@interface PISKDragebleNode : SKNode

@property (nonatomic) CGRect nodeArea;
@property (nonatomic) SKNode<PISKDragebleNodeDelegat>* targetObject;


-(PISKDragebleNode*)initFor:(SKNode*)obj;
-(PISKDragebleNode*)initFor:(SKNode*)obj withRect:(CGRect)area;

+(PISKDragebleNode*)createFor:(SKNode*)obj;
+(PISKDragebleNode*)createFor:(SKNode*)obj withRect:(CGRect)area;


@end
