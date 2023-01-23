//  DetectController.swift
//  Created by yujinkim on 2023/01/23.

import Foundation
import AVFoundation
import Vision

extension ViewController {
    
    func setupDetector() {
        let mlmodel = Bundle.main.url(forResource: "yolov7safty", withExtension: "mlmodelc")
        
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: mlmodel!))
            let recognitions = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
            self.requests = [recognitions]
        } catch let error {
            print(error)
        }
    }
    
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let result = request.result {
                self.extractDetections(result)
            }
        }
    }
    
    //MARK: BASIC LAYER
    func setupLayers() {
        //...
    }
    
    //MARK: UPDATE BASIC LAYER
    func updateLayers() {
        //...
    }
    
    //MARK: DETECT OBJECTS WITH SHOW BOX
    func drawBox() {
        //...
    }
}
