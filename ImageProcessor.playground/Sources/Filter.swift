import Foundation

public enum FilterIntensity : Double {
    case lowestIntensity = 0.0
    case lowIntensity = 0.5
    case defaultIntensity = 1.0
    case highIntensity = 1.5
    case highestIntensity = 2.0
}

public enum FilterOption : Int {
    case none = 0
    case colorRed = 1
    case colorGreen = 2
    case colorBlue = 3
    
    case modifier = 255
}

public class Filter {
    public var option: FilterOption? = FilterOption.none
    public var intensity: FilterIntensity? = FilterIntensity.defaultIntensity
    public var filter: ((Pixel, FilterOption?, FilterIntensity?) -> (Pixel))
    
    public init(filter: @escaping ((Pixel, FilterOption?, FilterIntensity?) -> (Pixel)), option: FilterOption = FilterOption.none, intensity: FilterIntensity = FilterIntensity.defaultIntensity) {
        self.option = option
        self.filter = filter
        self.intensity = intensity
    }
}

public class FilterFormula {
    private var defaultOption : FilterOption = FilterOption.none
    private var defaultIntensity : FilterIntensity = FilterIntensity.defaultIntensity
    
    public init() {
        
    }
    
    func Clamp(number:Double) -> UInt8 {
        //Returns a UInt8 value clamped between 0 and 255 for use with RGBA pixels
        let clamped = UInt8(max(0, min(255, number)))
        return clamped
    }
    
    public func intensifyColor(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let intensityValue = (intensity ?? defaultIntensity).rawValue
        var pixel = pixel
        
        switch option {
        case .colorRed:
            pixel.red = Clamp(number: 255 * intensityValue)
            break
        case .colorGreen:
            pixel.green = Clamp(number: 255 * intensityValue)
            break
        case .colorBlue:
            pixel.blue = Clamp(number: 255 * intensityValue)
            break
        default:
            break
        }
        
        return pixel
    }
    
    public func invertColor(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let intensityValue = (intensity ?? defaultIntensity).rawValue
        var pixel = pixel
        pixel.red = Clamp(number: 255-Double(pixel.red) * intensityValue)
        pixel.green = Clamp(number: 255-Double(pixel.green) * intensityValue)
        pixel.blue = Clamp(number: 255-Double(pixel.blue) * intensityValue)
        return pixel
    }

    public func swapColor(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let intensityValue = (intensity ?? defaultIntensity).rawValue
        var pixel = pixel
        if(option == FilterOption.colorBlue) {
            let temp = Clamp(number: Double(pixel.red) * intensityValue)
            pixel.red = Clamp(number: Double(pixel.blue) * intensityValue)
            pixel.blue = Clamp(number: Double(pixel.green) * intensityValue)
            pixel.green = temp
        } else if(option == FilterOption.colorGreen) {
            let temp = Clamp(number: Double(pixel.blue) * intensityValue)
            pixel.blue = Clamp(number: Double(pixel.red) * intensityValue)
            pixel.red = Clamp(number: Double(pixel.green) * intensityValue)
            pixel.green = temp
        }
        return pixel
    }

    public func removeColor(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        var pixel = pixel
        if(option == FilterOption.colorRed) {
            pixel.red = 0
        } else if(option == FilterOption.colorGreen) {
            pixel.green = 0
        } else if(option == FilterOption.colorBlue) {
            pixel.blue = 0
        }
        return pixel
    }

    public func changeTransperency(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let intensityValue = (intensity ?? defaultIntensity).rawValue
        var pixel = pixel
        pixel.alpha = Clamp(number: 255 * intensityValue)
        return pixel
    }

    public func changeContrast(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let modifier = (option ?? defaultOption).rawValue
        
        var pixel = pixel
        let avgRed = 118
        let avgGreen = 98
        let avgBlue = 83
        let redDelta = Int(pixel.red) - avgRed
        let greenDelta = Int(pixel.green) - avgGreen
        let blueDelta = Int(pixel.blue) - avgBlue

        pixel.red = Clamp(number: Double(avgRed + modifier * redDelta))
        pixel.green = Clamp(number: Double(avgGreen + modifier * greenDelta))
        pixel.blue = Clamp(number: Double(avgBlue + modifier * blueDelta))
        return pixel
    }

    public func changeBrightness(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let intensityValue = (intensity ?? defaultIntensity).rawValue
        var pixel = pixel
        pixel.red = Clamp(number: Double(pixel.red) * intensityValue)
        pixel.green = Clamp(number: Double(pixel.green) * intensityValue)
        pixel.blue = Clamp(number: Double(pixel.blue) * intensityValue)
        return pixel
    }

    public func monochromeColor(pixel: Pixel, option: FilterOption?, intensity : FilterIntensity?) -> Pixel {
        let intensityValue = (intensity ?? defaultIntensity).rawValue
        var pixel = pixel
        pixel.red = Clamp(number: Double(pixel.red) * intensityValue)
        pixel.green = Clamp(number: Double(pixel.red) * intensityValue)
        pixel.blue = Clamp(number: Double(pixel.red) * intensityValue)
        return pixel
    }
    
    // Make the intensifyColor Filter
    lazy var intensifyColorFilter = Filter(filter: filterFormula.intensifyColor)
    
    // Make the invertColor Filter
    lazy var invertColorFilter = Filter(filter: filterFormula.invertColor)
    
    // Make the colorSwapper Filter
    lazy var colorSwapFilter = Filter(filter: swapColor)
    
    // Make the removeColor Filter
    lazy var removeColorFilter = Filter(filter: removeColor)
    
    // Make the transperency Filter
    lazy var transperencyFilter = Filter(filter: changeTransperency)
    
    // Make the contrast Filter
    lazy var contrastFilter = Filter(filter: changeContrast)
    
    // Make the brightness Filter
    lazy var brightnessFilter = Filter(filter: changeBrightness)
    
    // Make the monochromeColor Filter
    lazy var monochromeColorFilter = Filter(filter: monochromeColor)

}
