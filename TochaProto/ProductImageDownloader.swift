//
//  ProductImageDownloader.swift
//  Docha
//
//  Created by Mathis D on 12/10/2016.
//  Copyright © 2016 Slymoover. All rights reserved.
//

import Foundation
import Kingfisher

protocol ProductImageDownloaderDelegate {
    
    func didFinishedDownloadImages(withProducts products: [Product])
}

class ProductImageDownloader {
    
    var productsWithImages: [Product]?
    var productsDelegate: ProductImageDownloaderDelegate?
    
    open func downloadImages(withProducts products: [Product]!, fail failure: @escaping(_ error: Error?) -> Void) {
        let products = products as [Product]
        var imagesDownloadedCpt = 0
        
        for index in 0..<products.count {
            let imageUrl = URL(string: products[index].imageUrl)
            
            if let imageUrl = imageUrl {
                ImageDownloader.default.downloadImage(with: imageUrl, options: [], progressBlock: nil,
                    completionHandler: { (image, error, _, _) in
                        
                        if error != nil {
                            debugPrint(error as Any)
                            failure(error)
                            return
                        }
                        
                        products[index].image = image
                        imagesDownloadedCpt += 1
                        
                        if imagesDownloadedCpt == products.count {
                            self.productsDelegate?.didFinishedDownloadImages(withProducts: products)
                        }
                    }
                )
            }
        }
    }
}
