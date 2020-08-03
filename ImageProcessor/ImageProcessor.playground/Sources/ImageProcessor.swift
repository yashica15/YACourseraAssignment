import Foundation
import UIKit

let filterFormula: FilterFormula = FilterFormula()

public enum FilterType : String {
    case intensifyColor = "intensifyColorFilter"
    case invertColor = "invertColorFilter"
    case colorSwap = "colorSwapFilter"
    case transperency = "transperencyFilter"
    case removeColor = "removeColorFilter"
    case contrast = "contrastFilter"
    case monochromeColor = "monochromeColorFilter"
    case brightness = "brightnessFilter"
    
    var filter : Filter {
        switch self {
        case .intensifyColor:
            return filterFormula.intensifyColorFilter
        case .invertColor:
            return filterFormula.invertColorFilter
        case .colorSwap:
            return filterFormula.colorSwapFilter
        case .transperency:
            return filterFormula.transperencyFilter
        case .removeColor:
            return filterFormula.removeColorFilter
        case .contrast:
            return filterFormula.contrastFilter
        case .monochromeColor:
            return filterFormula.monochromeColorFilter
        case .brightness:
            return filterFormula.brightnessFilter
        }
    }
}

public class ImageProcessor {
    
    private var filterList: [Filter] = []
    
    public init() {
        
    }
    
    public func addFilter(filter: FilterType, filterOption : FilterOption? = FilterOption.none, filterIntensity : FilterIntensity? = FilterIntensity.defaultIntensity) {
        filter.filter.intensity = filterIntensity
        filter.filter.option = filterOption
        filterList.append(filter.filter)
    }
    
    public func processImage(image: UIImage) -> UIImage {
        let rgbaImage = RGBAImage(image: image)!
        for y in 0..<rgbaImage.height {
            for x in 0..<rgbaImage.width {
                let index = y * rgbaImage.width + x
                for filter in filterList {
                    let pixel = rgbaImage.pixels[index]
                    rgbaImage.pixels[index] = filter.filter(pixel, filter.option, filter.intensity)
                }
                
            }
        }
        return rgbaImage.toUIImage()!
    }
}
