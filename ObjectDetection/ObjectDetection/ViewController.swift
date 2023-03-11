//  ViewController.swift

import SwiftUI
import UIKit
import AVFoundation
import Vision

/**
 * 1. AVCaptureSession을 사용
 * 2. Preview Layer를 지정
 * 3. 객체를 탐지하고, 이를 바운딩 박스를 통해 아웃풋을 표현
 * 3. 이와 관련된 View Controller를 Root Layer에 연결 (메인 쓰레드와 연관이 있다고 봄)
 */
class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    private var permissionGranted = false
    private let captureSession = AVCaptureSession()
    //AVCaptureSession을 사용하기 위한 디스패치 큐
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private var previewLayer = AVCaptureVideoPreviewLayer()
    var screenRect: CGRect! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard permissionGranted  else { return }
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
    
    //MARK: 디바이스의 기본 방향에 대한 케이스 함수
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        screenRect = UIScreen.main.bounds
        self.previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        
        switch UIDevice.current.orientation {
            
            //HOME BUTTON ON TOP ?
            case UIDeviceOrientation.portraitUpsideDown:
                self.previewLayer.connection?.videoOrientation = .portraitUpsideDown
            
            //HOME BUTTON ON RIGHT ?
            case UIDeviceOrientation.landscapeRight:
                self.previewLayer.connection?.videoOrientation = .landscapeRight
            
            //HOME BUTTON ON BOTTOM ?
            case UIDeviceOrientation.portrait:
                self.previewLayer.connection?.videoOrientation = .portrait
            
            //HOME BUTTON ON LEFT ?
            case UIDeviceOrientation.landscapeLeft:
                self.previewLayer.connection?.videoOrientation = .landscapeLeft
            
            default:
                break
        }
    }
    //MARK: 사용 권한 확인 함수
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            case .authorized:
                permissionGranted = true
            case .notDetermined:
                requestPermission()
            default:
                permissionGranted = false
        }
    }
    //MARK: Not determind 시 권한 요청을 하기 위한 함수
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in self.permissionGranted = granted
            self.sessionQueue.resume()
        }
    }
    
    //MARK: 카메라 허용 및 셋업 함수
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInDualCamera, for: .video, position: .back) else { return }
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        //session?.beginConfiguration()
        //session?.sessionPreset = .vga640x480
        
        guard captureSession.canAddInput(videoDeviceInput) else { return }
        captureSession.addInput(videoDeviceInput)
        
        screenRect = UIScreen.main.bounds
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.connection?.videoOrientation = .portrait
        
        DispatchQueue.main.async { [weak self] in self!.view.layer.addSublayer(self!.previewLayer)
        }
    }
}

//MARK: REPRESENTABLE
struct HostedViewController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
