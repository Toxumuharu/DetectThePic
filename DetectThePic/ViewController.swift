//
//  ViewController.swift
//  DetectThePic
//
//  Created by Toxumuharu on 2020/11/10.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var resnetModel = Resnet50()
    var results = [VNClassificationObservation]()
    var imagePicker = UIImagePickerController()
    
    func processPicture(image: UIImage){
        print(#function)
        if let model = try? VNCoreMLModel(for: resnetModel.model){
            let request = VNCoreMLRequest(model: model) { (request, error) in
                if let results = request.results as? [VNClassificationObservation]{
                    self.results = Array(results.prefix(20))
                    self.tableView.reloadData()
                }
                print(request)
            }
            
            if let imageData = image.jpegData(compressionQuality: 1.0){
                let handler = VNImageRequestHandler(data: imageData, options: [:])
                try? handler.perform([request])
            }
        }
        
    }
    
    
    @IBAction func photoTapped(_ sender: Any) {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage{
            imageView.image = image
            processPicture(image: image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        if let image = imageView.image{
            processPicture(image: image)
        }
        imagePicker.delegate = self
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let result = results[indexPath.row]
        let name = result.identifier.prefix(20)
        cell.textLabel?.text = "\(name): \(Int(result.confidence * 100))% "
        return cell
    }
    
    
}

