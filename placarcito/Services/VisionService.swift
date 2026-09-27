//
//  VisionService.swift
//  placarcito
//

import Foundation
import UIKit
import Vision
import CoreImage
import CoreImage.CIFilterBuiltins

public struct VisionService {
    
    /// Removes background from UIImage using Vision VNGenerateForegroundInstanceMaskRequest on iOS 17+ or return clean image
    public static func removeBackground(from image: UIImage, completion: @escaping (UIImage?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(image)
            return
        }
        
        if #available(iOS 17.0, *) {
            let request = VNGenerateForegroundInstanceMaskRequest()
            let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    try handler.perform([request])
                    guard let result = request.results?.first else {
                        DispatchQueue.main.async { completion(image) }
                        return
                    }
                    
                    let maskPixelBuffer = try result.generateScaledMaskForImage(forInstances: result.allInstances, from: handler)
                    let ciImage = CIImage(cgImage: cgImage)
                    let maskImage = CIImage(cvPixelBuffer: maskPixelBuffer)
                    
                    let filter = CIFilter.blendWithMask()
                    filter.inputImage = ciImage
                    filter.backgroundImage = CIImage(color: .white)
                    filter.maskImage = maskImage
                    
                    if let outputCI = filter.outputImage {
                        let ciContext = CIContext()
                        if let outputCG = ciContext.createCGImage(outputCI, from: ciImage.extent) {
                            let processedImage = UIImage(cgImage: outputCG)
                            DispatchQueue.main.async { completion(processedImage) }
                            return
                        }
                    }
                    DispatchQueue.main.async { completion(image) }
                } catch {
                    print("Vision background removal error: \(error)")
                    DispatchQueue.main.async { completion(image) }
                }
            }
        } else {
            completion(image)
        }
    }
}
