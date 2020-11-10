//
//  ViewController.swift
//  DetectThePic
//
//  Created by Toxumuharu on 2020/11/10.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var resnetModel: Resnet50 = try! Resnet50(configuration: MLModelConfiguration.init())
    
    func processPicture(image: UIImage){
        print(#function)
        if let model = try? VNCoreMLModel(for: resnetModel.model){
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation]{
                    print(results)
                }
            }
            if let imageData = image.jpegData(compressionQuality: 1.0){
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let image = imageView.image{
            processPicture(image: image)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = "Hello"
        
        return cell
    }
    

}

