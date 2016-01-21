//
//  GameViewController.swift
//  DearZoo_iOS
//
//  Created by WLD_MBP_20 on 04/12/2015.
//  Copyright (c) 2015 leeprobert. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController, SCNSceneRendererDelegate {
    
    @IBOutlet weak var scnView: SCNView!
    @IBOutlet weak var uiView: UIView!
    
    var cameraNode: SCNNode?
    var camera: SCNCamera?
    var cameraOrbit: SCNNode?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/DearZooScene.scn")!
        
        // init the camera
        camera = SCNCamera()
//        camera!.usesOrthographicProjection = true
        camera!.zNear = 0
        camera!.zFar = 1000
        cameraNode = SCNNode()
        cameraNode!.position = SCNVector3Make(0, 0, 50)
        cameraNode!.camera = camera
        cameraOrbit = SCNNode()
        cameraOrbit!.addChildNode(cameraNode!)
//        cameraOrbit?.rotation = SCNVector4Make(0, 0.5, 0, 0)
        
        scene.rootNode.addChildNode(cameraOrbit!)
        
//        let lookConstraint = SCNLookAtConstraint(target: scene.rootNode)
//        let transConstraint = SCNTransformConstraint(inWorldSpace: true) { (node, m4) -> SCNMatrix4 in
//        
//            print(m4)
//            let t = Float(self.scnView.sceneTime)
//            let newMatrix4 = SCNMatrix4Translate(m4, cos(t)*6, 4+(cos(t)*2), sin(t)*10)
//            return newMatrix4
//        }
        
//        lookConstraint.gimbalLockEnabled = true
//        camera!.constraints = [transConstraint]
//        camera!.constraints = [lookConstraint, transConstraint]
        
        // set the scene to the view
        scnView!.scene = scene
        scene.background.contents = ["cubemap_side.png", "cubemap_side.png", "cubemap_top.png", "cubemap_bottom.png", "cubemap_side.png", "cubemap_side.png"]
        
        // allows the user to manipulate the camera
//        scnView!.allowsCameraControl = true
        cameraOrbit!.runAction(SCNAction.rotateByX(-0.5, y: 0, z: 0, duration: 0))
        cameraOrbit!.runAction(SCNAction.repeatActionForever(SCNAction.rotateByX(0, y: 2, z: 0, duration: 1)))
        
        // show statistics such as fps and timing information
        scnView!.showsStatistics = true
        
        // add a tap gesture recognizer
//        let tapGesture = UITapGestureRecognizer(target: self, action: "handleTap:")
//        scnView.addGestureRecognizer(tapGesture)
    }
    
    func handleTap(gestureRecognize: UIGestureRecognizer) {
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        
        // check what nodes are tapped
        let p = gestureRecognize.locationInView(scnView)
        let hitResults = scnView.hitTest(p, options: nil)
        // check that we clicked on at least one object
        
        if hitResults.count > 0 {
            // retrieved the first clicked object
            let result: AnyObject! = hitResults[0]
            
            // get its material
            let material = result.node!.geometry!.firstMaterial!
            
            // highlight it
            SCNTransaction.begin()
            SCNTransaction.setAnimationDuration(0.5)
            
            // on completion - unhighlight
            SCNTransaction.setCompletionBlock {
                SCNTransaction.begin()
                SCNTransaction.setAnimationDuration(0.5)
                
                material.emission.contents = UIColor.blackColor()
                
                SCNTransaction.commit()
            }
            
            material.emission.contents = UIColor.redColor()
            
            SCNTransaction.commit()
        }
    }

    // MARK: renderer delegate ---------------------------------------------------
    
    func renderer(renderer: SCNSceneRenderer, updateAtTime time: NSTimeInterval) {
        
//        let t = Float(time)
//        cameraOrbit?.rotation = SCNVector4Make(cos(t)*6, 4+(cos(t)*2), 0, 0)
    }

}
