import Foundation
import UIKit

let filterFormula: FilterFormula = FilterFormula()

public enum FilterType : String {
    case redColor = "redColorFilter"
    case greenColor = "greenColorFilter"
    case blueColor = "blueColorFilter"
    case invertColor = "invertColorFilter"
    case colorSwap = "colorSwapFilter"
    case transperency = "transperencyFilter"
    case removeColor = "removeColorFilter"
    case contrast = "contrastFilter"
    case monochromeColor = "monochromeColorFilter"
    case brightness = "brightnessFilter"
    
    var filter : Filter {
        switch self {
        case .redColor:
            return filterFormula.redColorFilter
        case .greenColor:
            return filterFormula.greenColorFilter
        case .blueColor:
            return filterFormula.blueColorFilter
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
    
    public var filterList: [Filter] = []

    public init() {

    }

    public func addFilter(filter: FilterType) {
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
