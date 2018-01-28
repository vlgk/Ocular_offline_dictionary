//
//  ViewController.swift
//  Lens
//
//  Created by VLGK on 27.10.17.
//  Copyright © 2017 VLGK. All rights reserved.
//

import UIKit
import AVKit
import Vision
import AVFoundation
import Foundation


class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    // uilabel setup
    let identifierLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        label.numberOfLines = 3
        label.textAlignment = .left
        label.textColor = .white
        label.font = UIFont(name: "AvenirNextCondensed-Medium", size: 25)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let mylayer = CATextLayer()
    let animation = CABasicAnimation(keyPath: "fontSize")
    

    var mylanguage = [String: String]()
    var Dict1 = [String: String]()
    var Dict2 = [String: String]()
    var Dict3 = [String: String]()
    var Dict4 = [String: String]()
    var Dict5 = [String: String]()
    var languagetolearn = [String: String]()
    var dicttolearn = [String: String]()
    var dicttomy = [String: String]()
    var val2 = String()
    var textto = String()
    var myUtterence = AVSpeechUtterance()
    var voice = String()
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
     
        // set plist dictionaries
        let path1: String = Bundle.main.path(forResource: "Deutsch", ofType: "plist")!
        self.Dict1 = NSDictionary.init(contentsOfFile: path1) as! [String: String]
        
        let path2: String = Bundle.main.path(forResource: "Russian", ofType: "plist")!
        self.Dict2 = NSDictionary.init(contentsOfFile: path2) as! [String: String]
        
        let path3: String = Bundle.main.path(forResource: "English", ofType: "plist")!
        self.Dict3 = NSDictionary.init(contentsOfFile: path3) as! [String: String]
        
        let path4: String = Bundle.main.path(forResource: "Arabic", ofType: "plist")!
        self.Dict4 = NSDictionary.init(contentsOfFile: path4) as! [String: String]
        
        let path5: String = Bundle.main.path(forResource: "Romanian", ofType: "plist")!
        self.Dict5 = NSDictionary.init(contentsOfFile: path5) as! [String: String]
        
        // set alert language choose
        let alert1 = UIAlertController(title: "Choose language you speak",
                                       message: "",
                                       preferredStyle: .alert)
        
        let alert2 = UIAlertController(title: "Choose language you learn",
                                       message: "",
                                       preferredStyle: .alert)
        
        let action1 = UIAlertAction(title: "🇩🇪", style: .default, handler: { (action) -> Void in
            self.mylanguage = self.Dict1
            self.present(alert2, animated: true, completion: nil)
        })
        
        let action2 = UIAlertAction(title: "🇷🇺", style: .default, handler: { (action) -> Void in
            self.mylanguage = self.Dict2
            self.present(alert2, animated: true, completion: nil)
        })
        
        let action3 = UIAlertAction(title: "🇺🇸", style: .default, handler: { (action) -> Void in
            self.mylanguage = self.Dict3
            self.present(alert2, animated: true, completion: nil)
        })
        
        let action4 = UIAlertAction(title: "🇸🇦", style: .default, handler: { (action) -> Void in
            self.mylanguage = self.Dict4
            self.present(alert2, animated: true, completion: nil)
        })
        
        let action5 = UIAlertAction(title: "🇷🇴", style: .default, handler: { (action) -> Void in
            self.mylanguage = self.Dict5
            self.present(alert2, animated: true, completion: nil)
        })
        
        // allert appears
        alert1.addAction(action1)
        alert1.addAction(action2)
        alert1.addAction(action3)
        alert1.addAction(action4)
        alert1.addAction(action5)
        
        
        //set alert choose language to learn
        
        let action21 = UIAlertAction(title: "🇩🇪", style: .default, handler: { (action) -> Void in
            self.languagetolearn = self.Dict1
            self.voice = "de-DE"
        })
        
        let action22 = UIAlertAction(title: "🇷🇺", style: .default, handler: { (action) -> Void in
            self.languagetolearn = self.Dict2
            self.voice = "ru-RU"
        })
        
        let action23 = UIAlertAction(title: "🇺🇸", style: .default, handler: { (action) -> Void in
            self.languagetolearn = self.Dict3
            self.voice = "en-US"
        })
        
        let action24 = UIAlertAction(title: "🇸🇦", style: .default, handler: { (action) -> Void in
            self.languagetolearn = self.Dict4
            self.voice = "ar-SA"
        })
        
        let action25 = UIAlertAction(title: "🇷🇴", style: .default, handler: { (action) -> Void in
            self.languagetolearn = self.Dict5
            self.voice = "ro-RO"
        })
        
        // allert appears
        alert2.addAction(action21)
        alert2.addAction(action22)
        alert2.addAction(action23)
        alert2.addAction(action24)
        alert2.addAction(action25)
        
        self.present(alert1, animated: true, completion: {
            
            
        })
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.shadowImage = UIImage()
        
        
        let navlabel = UILabel()
        navlabel.text = "[ Ocular Dictionary ]"
        navlabel.textColor = UIColor(displayP3Red: 238/255, green: 148/255, blue: 40/255, alpha: 0.9)
        navlabel.font = UIFont(name: "Nelda Free", size: 45)
        navlabel.translatesAutoresizingMaskIntoConstraints = false
        
        navigationItem.titleView = navlabel
        
        // device start with camera
        let captureSession = AVCaptureSession()
        
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else { return }
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else { return }
        captureSession.addInput(input)
        
        captureSession.startRunning()

        // output cameraview

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
 
        let dataOutput = AVCaptureVideoDataOutput()
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(dataOutput)
        
        // request analized image
       
        
        setupIdentifierConfidenceLabel()
  
       // setup flurry
       Flurry.startSession("Q4KR4PPWJVDBYXVVZNNG")
       Flurry.logEvent("Tracking", timed: true)
      
    }
   
   
// setup uilabel low
    fileprivate func setupIdentifierConfidenceLabel() {
        view.addSubview(identifierLabel)
        identifierLabel.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -0).isActive = true
        identifierLabel.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        identifierLabel.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        identifierLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
    
   
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection){
        
     
        // solved problem with output orientation and recognition only in landscape orientation
        if connection.videoOrientation != .portrait {
            connection.videoOrientation = .portrait
            return }
        
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
   
        // initializing model
        
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { return } // why so complicated?
        let request = VNCoreMLRequest(model: model) { (finishedReq, err) in
            
            guard let results = finishedReq.results as? [VNClassificationObservation] else { return }
            
            guard let firstObservation = results.first else { return }
         
            DispatchQueue.main.async {
             
                    if firstObservation.confidence > 0.5 {
                
                        
                        for (key, val) in self.languagetolearn {
                            if firstObservation.identifier == key {
                                self.val2 = (self.mylanguage[key]) ?? ""
                                self.identifierLabel.text = " 🏆 \(val) \n" +
                                " 🎯 \(self.val2)"
                                
                                self.textto = val
                                if let CommaRange = self.textto.range(of: ",") {
                                    self.textto.removeSubrange(CommaRange.lowerBound..<self.textto.endIndex)
                                }
                                
                                // add text to speech
                                let mySynthesizer = AVSpeechSynthesizer()
                                self.myUtterence = AVSpeechUtterance(string: self.textto)
                                self.myUtterence.voice = AVSpeechSynthesisVoice(language: self.voice)
                                self.myUtterence.rate = 0.45
                                
                               mySynthesizer.speak(self.myUtterence)
                               
                            }
                        }
                
                        
                } else if firstObservation.confidence >= 0.2 && firstObservation.confidence < 0.3 {
                    self.identifierLabel.text = "        ⚽️                  🥅"
                        self.mylayer.removeFromSuperlayer()
                } else if firstObservation.confidence >= 0.3 && firstObservation.confidence < 0.4 {
                    self.identifierLabel.text = "                  ⚽️        🥅"
                        self.mylayer.removeFromSuperlayer()
                }
                else if firstObservation.confidence >= 0.4 && firstObservation.confidence < 0.5 {
                    self.identifierLabel.text = "                          ⚽️🥅"
                        self.mylayer.removeFromSuperlayer()
                }
                else {
                    self.identifierLabel.text = ""
                        self.mylayer.removeFromSuperlayer()
                    }
                
            }
        }
        
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
    
}
