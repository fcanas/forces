//
//  GameScene.swift
//  Forces
//
//  Created by Fabian Canas on 12/10/14.
//  Copyright (c) 2014 Fabian Canas. All rights reserved.
//

import SpriteKit

public func - (lhs: CGPoint, rhs: CGPoint) -> CGVector {
    return CGVector(dx: lhs.x-rhs.x, dy: lhs.y-rhs.y)
}

public func - (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx-rhs.dx, dy: lhs.dy-rhs.dy)
}

public func -= (inout lhs: CGVector, rhs: CGVector) {
    lhs = CGVector(dx: lhs.dx-rhs.dx, dy: lhs.dy-rhs.dy)
}

public func + (lhs: CGVector, rhs: CGVector) -> CGVector {
    return CGVector(dx: lhs.dx+rhs.dx, dy: lhs.dy+rhs.dy)
}

public func += (inout lhs: CGVector, rhs: CGVector) {
    lhs = CGVector(dx: lhs.dx+rhs.dx, dy: lhs.dy+rhs.dy)
}

public func magnitude(v: CGVector) -> CGFloat {
    return sqrt(v.dx*v.dx + v.dy*v.dy)
}

public func normalize(v: CGVector) -> CGVector {
    if v == CGVector.zeroVector {
        return CGVector.zeroVector
    }
    let m = magnitude(v)
    return CGVector(dx: v.dx/m, dy: v.dy/m)
}

public func + (lhs: CGPoint, rhs: CGVector) -> CGPoint {
    return CGPoint(x: lhs.x+rhs.dx, y: lhs.y+rhs.dy)
}

infix operator • { associativity left precedence 160 }

public func • (lhs: CGVector, rhs: CGVector) -> CGFloat {
    return lhs.dx*rhs.dx + lhs.dy*rhs.dy
}

///

class thing {
    var position :CGPoint = CGPoint.zeroPoint
    var velocity :CGVector = CGVector.zeroVector
    init(position: CGPoint, velocity: CGVector) {
        self.position = position
        self.velocity = velocity
    }
}

func distance(p1: CGPoint, p2: CGPoint) -> CGVector {
    return p1 - p2
}

func distance(thing1: thing, thing2: thing) -> CGVector {
    return thing1.position - thing2.position
}

//let things = [thing(position: CGPoint.zeroPoint, velocity: CGVector.zeroVector),
//    thing(position: CGPoint(x: 80.0, y: 0.0), velocity: CGVector.zeroVector)]

func scale(v: CGVector, s: CGFloat) -> CGVector {
    return CGVector(dx: v.dx*s, dy: v.dy*s)
}

func field(distance: CGVector) -> CGVector {
    return CGVector(dx: singletonField(distance.dx), dy: singletonField(distance.dy))
}

func singletonField(v: CGFloat) -> CGFloat {
    return -(v-40)/10000
}



class GameScene: SKScene {
    var things :[thing] = []
    var sprites :[SKSpriteNode] = []
    override func didMoveToView(view: SKView) {
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            let location = touch.locationInNode(self)
            
            let sprite = SKSpriteNode(imageNamed:"Spaceship")
            sprites.append(sprite)
            things.append(thing(position: location, velocity: CGVector.zeroVector))
            
            sprite.xScale = 0.5
            sprite.yScale = 0.5
            sprite.position = location
            
            let action = SKAction.rotateByAngle(CGFloat(M_PI), duration:1)
            
//            sprite.runAction(SKAction.repeatActionForever(action))
            
            self.addChild(sprite)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        for var idx = 0; idx < things.count; idx++ {
            let thing1 = things[idx]
            for var idx2 = idx+1; idx2 < things.count; idx2++ {
                let thing2 = things[idx2]
                let force = field(distance(thing1, things[idx2]))
                thing1.velocity += force
                thing2.velocity -= force
            }
        }
        
        for var idx = 0; (idx < things.count); idx++ {
            let thing = things[idx]
            thing.position = thing.position + thing.velocity
            sprites[idx].position = thing.position
        }
    }
}
