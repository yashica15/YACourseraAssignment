//: Playground - noun: a place where people can play

import UIKit

let image = UIImage(named: "sample")!

// Process the image!

var imageProcessor: ImageProcessor = ImageProcessor()

// Adding 5 filters
// Comment uncomment for other filters
imageProcessor.addFilter(filter: FilterType.redColor)
//imageProcessor.addFilter(filter: FilterType.greenColor)
//imageProcessor.addFilter(filter: FilterType.blueColor)
//imageProcessor.addFilter(filter: FilterType.invertColor)
imageProcessor.addFilter(filter: FilterType.colorSwap)
//imageProcessor.addFilter(filter: FilterType.removeColor)
imageProcessor.addFilter(filter: FilterType.transperency)
//imageProcessor.addFilter(filter: FilterType.contrast)
imageProcessor.addFilter(filter: FilterType.brightness)
imageProcessor.addFilter(filter: FilterType.monochromeColor)

// Processing the image
imageProcessor.processImage(image: image)
