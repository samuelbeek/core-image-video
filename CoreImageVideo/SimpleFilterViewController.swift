//
//  ViewController.swift
//  CoreImageVideo
//
//  Created by Chris Eidhof on 03/04/15.
//  Copyright (c) 2015 objc.io. All rights reserved.
//

import UIKit
import AVFoundation

class SimpleFilterViewController: UIViewController {
    var source: CaptureBufferSource?
    var coreImageView: CoreImageView?

    var angleForCurrentTime: Float {
        return Float(NSDate.timeIntervalSinceReferenceDate() % M_PI*2)
    }

    override func loadView() {
        coreImageView = CoreImageView(frame: CGRect())
        self.view = coreImageView
    }
    
    override func viewDidAppear(animated: Bool) {
        setupCameraSource()
    }
    
    override func viewDidDisappear(animated: Bool) {
        source?.running = false
    }
    
    func getImageWithColor(color: UIColor, size: CGSize) -> UIImage {
        let rect = CGRectMake(0, 0, size.width, size.height)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }

    
    func setupCameraSource() {
        
        source = CaptureBufferSource(position: AVCaptureDevicePosition.Front) { [unowned self] (buffer, transform) in
            
            let input = CIImage(buffer: buffer).imageByApplyingTransform(transform)
            let cropped = crop(CGRectMake(-784.0, -600, 600,600))

            let filter = blur(10) >>> hueAdjust(5) >>> compositeSourceOver(cropped(input))
            self.coreImageView?.image = filter(input)
        }
        source?.running = true
    }
}

