//  DetectController.swift
//  Created by yujinkim on 2023/01/23.

import Foundation
import AVFoundation
import Vision
import UIKit

class ObjectDetectViewController: ViewController, ObservableObject {

    private var requests = [VNRequest]()
    private var detectionOverlay: CALayer! = nil
    private var firstLabel: String = ""
    private var firstConfidence: Float = 0.0
    
    @discardableResult
    func setupDetector() -> NSError? {
        //Object Detection 모델의 확장자 정의 및 NSError 캐치
        guard let mlmodel = Bundle.main.url(forResource: "yolov7tiny", withExtension: "mlmodelc") else {
            return NSError(domain: "ObjectDetectViewController", code: -1, userInfo: [NSLocalizedDescriptionKey: "Object Detection Model file is missing."])
        }
        //ML 모델이 성공적으로 로드 되었다면 실행
        do {
            let visionModel = try VNCoreMLModel(for: MLModel(contentsOf: mlmodel))
            let request = VNCoreMLRequest(model: visionModel, completionHandler: detectionDidComplete)
        } catch let error as NSError {
            print("Object Detection Model loading went something wrong: \(error)")
        }
    }
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let result = request.result {
                self.extractDetections(result)
            }
        }
    }
    
    func drawVisionRequestResults(_ results: [Any]) {
        CATransaction.begin()
        CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
        //Remove all the old recognized objects
        detectionOverlay.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard observation is VNRecognizedObjectObservation else {
                continue
            }
            
            //Select only the label with the highest confidence
            let topLabelObservation = (observation as AnyObject).labels[0]
            let objectBounds = VNImageRectForNormalizedRect(observation.boundingBox, Int(bufferSize.width), Int(bufferSize.height))
           
            let shapeLayer = self.createRoundedRectLayerWithBounds(objectBounds)
            
            let textLayer = self.createTextSubLayerInBounds(objectBounds,
                                                            identifier: topLabelObservation.identifier,
                                                            confidence: topLabelObservation.confidence)
            shapeLayer.addSublayer(textLayer)
            detectionOverlay.addSublayer(shapeLayer)
        }
        self.updateLayerGeometry()
        CATransaction.commit()
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, orientation: .right, options: [:])
        do {
            try imageRequestHandler.perform([self.coreMLRequest])
            guard let results = self.VNCoreMLRequest.results as? [VNRecognizedObjectObservation] else { return }
            for result in results {
                let label = observation.identifier
            }
        } catch let error {
            print(error)
        }
    }
    
    override func setupAVCapture() {
        super.setupAVCapture()
        
        // setup Vision parts
        setupLayers()
        updateLayerGeometry()
        setupVision()
        
        // start the capture
        startCaptureSession()
    }
    
    //MARK: BASIC LAYER
    func setupLayers() {
        detectionOverlay = CALayer() // container layer that has all the renderings of the observations
        detectionOverlay.name = "DetectionOverlay"
        detectionOverlay.bounds = CGRect(x: 0.0,
                                         y: 0.0,
                                         width: bufferSize.width,
                                         height: bufferSize.height)
        detectionOverlay.position = CGPoint(x: rootLayer.bounds.midX, y: rootLayer.bounds.midY)
        rootLayer.addSublayer(detectionOverlay)
    }
    
    //MARK: UPDATE BASIC LAYER
    func updateLayerGeometry() {
            let bounds = rootLayer.bounds
            var scale: CGFloat
            
            let xScale: CGFloat = bounds.size.width / bufferSize.width
            let yScale: CGFloat = bounds.size.height / bufferSize.height
            
            scale = fmax(xScale, yScale)
            if scale.isInfinite {
                scale = 1.0
            }
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            // Rotate the layer into screen orientation and scale and mirror
            // Change the quotient to 1.0 for portrait
            detectionOverlay.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(0.0)).scaledBy(x: scale, y: -scale))
            // Centre layer
            detectionOverlay.position = CGPoint(x: bounds.midX, y: bounds.midY)
            CATransaction.commit()
        }
    
    //MARK: Text Sub Layer 생성 함수
    func createTextSubLayerInBounds(_ bounds: CGRect, identifier: String, confidence: VNConfidence) -> CATextLayer {
        let textLayer = CATextLayer()
        textLayer.name = "Object label"
        //Confidence 지정
        let formattedString = NSMutableAttributedString(string: String(format: "\(identifier)\nConfidence:  %.2f", confidence))
        //Font setting
        let largeFont = UIFont(name: "Helvetica", size: 24.0)!
        formattedString.addAttributes([NSAttributedString.Key.font: largeFont], range: NSRange(location: 0, length: identifier.count))
        textLayer.string = formattedString
        textLayer.bounds = CGRect(x: 0, y: 0, width: bounds.size.height - 10, height: bounds.size.width - 10)
        textLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        textLayer.shadowOpacity = 0.7
        textLayer.shadowOffset = CGSize(width: 2, height: 2)
        textLayer.foregroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [0.0, 0.0, 0.0, 1.0])
        textLayer.contentsScale = 2.0 // retina rendering
        // rotate the layer into screen orientation and scale and mirror
        textLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat(.pi / 2.0)).scaledBy(x: 1.0, y: -1.0))
        return textLayer
    }
    
    //MARK: 사각형 형태의 CA Layer 생성 함수
    func createRoundedRectLayerWithBounds(_ bounds: CGRect) -> CALayer {
        let shapeLayer = CALayer()
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        shapeLayer.name = "Object"
        shapeLayer.backgroundColor = CGColor(colorSpace: CGColorSpaceCreateDeviceRGB(), components: [1.0, 1.0, 0.2, 0.4])
        shapeLayer.cornerRadius = 7
        return shapeLayer
    }
}
