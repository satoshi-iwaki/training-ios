//
//  ViewController.swift
//  VisionCamera
//
//  Created by Iwaki Satoshi on 2017/11/05.
//  Copyright © 2017年 Satoshi Iwaki. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate, URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate {
    var captureSession: AVCaptureSession!
    var mlModel: VNCoreMLModel?
    var urlSession: URLSession!
    @IBOutlet weak var previewView: UIView!
    @IBOutlet weak var resultLabel: UILabel!
    
    var queue = OperationQueue()

    deinit {
        teardownAVCapture()
        teardownVison()
        
        urlSession.invalidateAndCancel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        url.appendPathComponent("MobileNet.mlmodel", isDirectory: false)
        if FileManager.default.fileExists(atPath: url.path) {
            setupVison(url: url)
            setupAVCapture()
            return
        } else {
            downloadMlModel(url: URL(string: "https://docs-assets.developer.apple.com/coreml/models/MobileNet.mlmodel")!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadMlModel(url: URL) {
        urlSession = URLSession(configuration: URLSessionConfiguration.default,
                                delegate: self,
                                delegateQueue: nil)
        let request = URLRequest(url: url)
        let task = urlSession.downloadTask(with: request)
        task.resume()
    }
    
    func setupAVCapture() {
        captureSession = AVCaptureSession()
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            captureSession.sessionPreset = .vga640x480
        } else {
            captureSession.sessionPreset = .photo
        }

        do {
            guard let device = AVCaptureDevice.default(for: .video) else {
                return
            }
            let deviceInput = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(deviceInput) {
                captureSession.addInput(deviceInput)
            }
        } catch {
            return
        }
        
        let videoDataOutput = AVCaptureVideoDataOutput()
        videoDataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCMPixelFormat_32BGRA]
        videoDataOutput.alwaysDiscardsLateVideoFrames = true
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoDataOutputQueue"))
        
        if captureSession.canAddOutput(videoDataOutput) {
            captureSession.addOutput(videoDataOutput)
        }
        
        let connection = videoDataOutput.connection(with: .video)
        connection?.isEnabled = true
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.backgroundColor = UIColor.black.cgColor
        previewLayer.videoGravity = .resizeAspect
        
        let rootLayer = previewView.layer
        rootLayer.masksToBounds = true
        previewLayer.frame = rootLayer.bounds
        rootLayer.addSublayer(previewLayer)
        
        captureSession.startRunning()
    }

    func teardownAVCapture() {
        captureSession.stopRunning()
    }
    
    func setupVison(url: URL) {
        let compiledUrl: URL
        do {
            compiledUrl = try MLModel.compileModel(at: url)
        } catch {
            print("Failed to comlile Core ML model, error=\(error.localizedDescription)")
            return
        }

        let fileManager = FileManager.default
        let directory = try! fileManager.url(for: .applicationSupportDirectory,
                                                       in: .userDomainMask,
                                                       appropriateFor: compiledUrl,
                                                       create: true)
        let permanentUrl = directory.appendingPathComponent(compiledUrl.lastPathComponent)
        do {
            if fileManager.fileExists(atPath: permanentUrl.absoluteString) {
                _ = try fileManager.replaceItemAt(permanentUrl, withItemAt: compiledUrl)
            } else {
                try fileManager.copyItem(at: compiledUrl, to: permanentUrl)
            }
        } catch {
            print("Failed to copy compiled Core ML model, error=\(error.localizedDescription)")
            return
        }
        
        do {
            let model = try MLModel(contentsOf: permanentUrl)
            self.mlModel = try VNCoreMLModel(for: model)
        } catch {
            print("Failed to copy compiled Core ML model, error=\(error.localizedDescription)")
            return
        }
    }

    func teardownVison() {
        self.mlModel = nil;
    }
    
    //MARK: AVCaptureVideoDataOutputSampleBufferDelegate
    
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        analyze(pixelBuffer: pixelBuffer)
    }
    
    func analyze(pixelBuffer: CVPixelBuffer) {
        guard let mlModel = mlModel else {
            return
        }
        
        let request = VNCoreMLRequest(model: mlModel) { (request, error) in
            if let result: VNClassificationObservation = request.results?.first as? VNClassificationObservation {
                DispatchQueue.main.async {
                    self.resultLabel.text = result.identifier
                }
            }
        }
        
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform handler, error=\(error.localizedDescription)")
        }
    }
    
    //MARK: URLSessionDelegate, URLSessionTaskDelegate, URLSessionDownloadDelegate

    public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if let error = error {
            print("Failed to download CoreML model file, error=%@.", error)
        }
    }
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        var url = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask).first!
        url.appendPathComponent("MobileNet.mlmodel", isDirectory: false)
        
        do {
            try FileManager.default.moveItem(at: location, to: url)
        } catch {
            print("Failed to move CoreML model file, error=%@.", error)
            return
        }
        
        setupVison(url: url)
        setupAVCapture()
    }
}

