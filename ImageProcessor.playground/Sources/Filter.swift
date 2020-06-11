import Foundation

public class Filter {
    public var option: Int = 0
    public var intensity: Double = 1.0
    public var filter: ((Pixel, Int?, Double?) -> (Pixel))
    
    public init(filter: @escaping ((Pixel, Int?, Double?) -> (Pixel)), option: Int? = 0, intensity: Double? = 1) {
        self.option = option ?? 0
        self.filter = filter
        self.intensity = intensity ?? 1.0
    }
}

public class FilterFormula {
    public var defaultOption : Int = 0
    public var defaultIntensity : Double = 1.0
    
    public init() {
        
    }
    
    public func redColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.red = UInt8(max(min(255, 255 * (intensity ?? defaultIntensity)), 0))
        return pixel
    }
    
    public func greenColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.green = UInt8(max(min(255, 255 * (intensity ?? defaultIntensity)), 0))
        return pixel
    }
    
    public func blueColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.blue = UInt8(max(min(255, 255 * (intensity ?? defaultIntensity)), 0))
        return pixel
    }

    public func invertColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.red = UInt8(255)-pixel.red
        pixel.green = UInt8(255)-pixel.green
        pixel.blue = UInt8(255)-pixel.blue
        return pixel
    }

    public func swapColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        if(option == 0) {
            let temp = pixel.red
            pixel.red = pixel.blue
            pixel.blue = pixel.green
            pixel.green = temp
        } else {
            let temp = pixel.blue
            pixel.blue = pixel.red
            pixel.red = pixel.green
            pixel.green = temp
        }
        return pixel
    }

    public func removeColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        if(option == 0) {
            pixel.red = 0
        } else if(option == 1) {
            pixel.green = 0
        } else if(option == 2) {
            pixel.blue = 0
        }
        return pixel
    }

    public func changeTransperency(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.alpha = UInt8(max(min(255, 255 * (intensity ?? defaultIntensity)), 0))
        return pixel
    }

    public func changeContrast(pixel: Pixel, modifier: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        let avgRed = 118
        let avgGreen = 98
        let avgBlue = 83
        let redDelta = Int(pixel.red) - avgRed
        let greenDelta = Int(pixel.green) - avgGreen
        let blueDelta = Int(pixel.blue) - avgBlue
        pixel.red = UInt8(max(min(255, avgRed + (modifier ?? defaultOption) * redDelta), 0))
        pixel.green = UInt8(max(min(255, avgGreen + (modifier ?? defaultOption) * greenDelta), 0))
        pixel.blue = UInt8(max(min(255, avgBlue + (modifier ?? defaultOption) * blueDelta), 0))
        return pixel
    }

    public func changeBrightness(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.red = UInt8(max(0, min(255, (intensity ?? defaultIntensity) * Double(pixel.red))))
        pixel.green = UInt8(max(0, min(255, (intensity ?? defaultIntensity) * Double(pixel.green))))
        pixel.blue = UInt8(max(0, min(255, (intensity ?? defaultIntensity) * Double(pixel.blue))))
        return pixel
    }

    public func monochromeColor(pixel: Pixel, option: Int?, intensity : Double?) -> Pixel {
        var pixel = pixel
        pixel.red = UInt8(max(min(255, (intensity ?? defaultIntensity) * Double(pixel.red)), 0))
        pixel.green = UInt8(max(min(255, (intensity ?? defaultIntensity) * Double(pixel.red)), 0))
        pixel.blue = UInt8(max(min(255, (intensity ?? defaultIntensity) * Double(pixel.red)), 0))
        return pixel
    }
    
    // Make the redColor Filter
    lazy var redColorFilter = Filter(filter: redColor, intensity: 0.5)
    
    // Make the greenColor Filter
    lazy var greenColorFilter = Filter(filter: greenColor, intensity: 1.0)
    
    // Make the blueColor Filter
    lazy var blueColorFilter = Filter(filter: blueColor, intensity: 1)
    
    // Make the invertColor Filter
    lazy var invertColorFilter = Filter(filter: invertColor)
    
    // Make the colorSwapper Filter
    lazy var colorSwapFilter = Filter(filter: swapColor, option: 1)
    
    // Make the removeColor Filter
    lazy var removeColorFilter = Filter(filter: removeColor, option: 0)
    
    // Make the transperency Filter
    lazy var transperencyFilter = Filter(filter: changeTransperency, intensity: 0.5)
    
    // Make the contrast Filter
    lazy var contrastFilter = Filter(filter: changeContrast, option: 255)
    
    // Make the brightness Filter
    lazy var brightnessFilter = Filter(filter: changeBrightness, intensity: 1.5)
    
    // Make the monochromeColor Filter
    lazy var monochromeColorFilter = Filter(filter: monochromeColor, option: 1, intensity: 0.5)

}
