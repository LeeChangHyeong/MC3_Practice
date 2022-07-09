//
//  ViewController.swift
//  MC3_Practice
//
//  Created by 이창형 on 2022/07/09.
//

import UIKit

class ViewController: UIViewController {
    let imageView = UIImageView(image: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        createButton()
    
//        view.addSubview(imageView)
//        // 오토레이아웃을 따르겠다
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 400).isActive = true
//        imageView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 100).isActive = true
//        imageView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -80).isActive = true
//        imageView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -100).isActive = true
    }
    func createButton() {
        let button = UIButton(type: .custom)
        let image = UIImage(systemName: "photo", withConfiguration: UIImage.SymbolConfiguration(pointSize: view.bounds.height / 10))
        
        // 이미지뷰가 비었을때 image 차있을 때 imageView
        button.setImage(imageView.image == nil ? image : imageView.image, for: .normal)
        button.imageView?.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.systemGray.cgColor
        button.layer.cornerRadius = 10
        button.tintColor = .systemGray
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
    func observeButton() {
        
    }
    
    @objc fileprivate func didTapButton(_ sender: UIButton){
        // 객체 인스턴스 생성
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }   
}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image

        }

        createButton()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

