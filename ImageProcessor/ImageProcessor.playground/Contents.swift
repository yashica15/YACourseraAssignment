//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!

var imageProcessor: ImageProcessor = ImageProcessor()

// Adding 5 filters
// Comment uncomment for other filters
//imageProcessor.addFilter(filter: FilterType.intensifyColor, filterOption: FilterOption.colorRed, filterIntensity: FilterIntensity.highIntensity)
//imageProcessor.addFilter(filter: FilterType.invertColor, filterIntensity: FilterIntensity.defaultIntensity)
imageProcessor.addFilter(filter: FilterType.colorSwap, filterOption: FilterOption.colorBlue, filterIntensity: FilterIntensity.highIntensity)
//imageProcessor.addFilter(filter: FilterType.removeColor, filterOption: FilterOption.colorBlue)
//imageProcessor.addFilter(filter: FilterType.transperency, filterIntensity: FilterIntensity.lowIntensity)
//imageProcessor.addFilter(filter: FilterType.contrast, filterOption: FilterOption.modifier)
//imageProcessor.addFilter(filter: FilterType.brightness, filterIntensity: FilterIntensity.highIntensity)
//imageProcessor.addFilter(filter: FilterType.monochromeColor, filterIntensity: FilterIntensity.defaultIntensity)

// Processing the image
imageProcessor.processImage(image: image)
