//
//  MemoViewController.swift
//  MC3_Practice
//
//  Created by 이창형 on 2022/07/11.
//

import UIKit
import CoreData

class MemoViewController: UIViewController {
    static let shared = MemoViewController()
    
    let imageView = UIImageView(image: nil)
    let button = UIButton(type: .custom)
    let field = UITextField()
    let textView = UITextView()
    let textViewPlaceHolder = "메모를 입력해주세요."
    let date = NSDate() // 현재 시간 가져오기
    let formatter = DateFormatter()
    
    var resultArray: [NSManagedObject]?
    
    
    // 키보드 아무화면이나 누르면 내려가게
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "완료", style: .plain, target: self, action: #selector(finishMemo(_:)))
        
    
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        titleTextField()
        createImageButton()
        memoTextView()

        
        
    }
    
    
    func saveCoreData(title: String, memo: String) -> Bool {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        
        // App Delegate 내부에 있는 viewContext 호출
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // managedContext 내부에 있는 entity 호출
        let entity = NSEntityDescription.entity(forEntityName: "Entity", in: managedContext)!
        
        // entity 객체 생성
        let object = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 값 설정
        object.setValue(title, forKey: "title")
        object.setValue(memo, forKey: "memo")
        object.setValue(Date(), forKey: "date")
        object.setValue(UUID(), forKey: "id")
        
        do {
            // managedContext 내부의 변경사항 저장
            try managedContext.save()
            return true
        } catch let error as NSError {
            // 에러 발생시
            print("Could not save. \(error), \(error.userInfo)")
            return false
        }
        
    }
    
    func readCoreData() throws -> [NSManagedObject]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Entity의 fetchRequest 생성
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Entity")
        
        // 정렬 또는 조건 설정
        //    let sort = NSSortDescriptor(key: "createDate", ascending: false)
        //    fetchRequest.sortDescriptors = [sort]
        //    fetchRequest.predicate = NSPredicate(format: "isFinished = %@", NSNumber(value: isFinished))
        
        do {
            // fetchRequest를 통해 managedContext로부터 결과 배열을 가져오기
            let resultCDArray = try managedContext.fetch(fetchRequest)
            return resultCDArray
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            throw error
        }
    }
    
    func deleteCoreData(id: UUID) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "entity")
        
        // 아이디를 삭제 기준으로 설정
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let objectToDelete = result[0] as! NSManagedObject
            managedContext.delete(objectToDelete)
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func updateCoreData(id: UUID, title: String, memo: String) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Diffuser")
        fetchRequest.predicate = NSPredicate(format: "id = %@", id.uuidString)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            let object = result[0] as! NSManagedObject
            
            object.setValue(title, forKey: "title")
            object.setValue(memo, forKey: "memo")
            
            try managedContext.save()
            return true
        } catch let error as NSError {
            print("Could not update. \(error), \(error.userInfo)")
            return false
        }
    }

    
    
    func titleTextField() {
        
        field.placeholder = "제목을 입력해주세요."
        field.textAlignment = .center
        field.font = UIFont.systemFont(ofSize: 30)
        
        self.view.addSubview(field)
        field.translatesAutoresizingMaskIntoConstraints = false
        field.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        field.heightAnchor.constraint(equalToConstant: view.bounds.height / 20).isActive = true
        field.topAnchor.constraint(equalTo: view.topAnchor, constant: view.bounds.height / 8).isActive = true
        field.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func createImageButton() {
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
        button.widthAnchor.constraint(equalToConstant: view.bounds.width / 1.3).isActive = true
        button.heightAnchor.constraint(equalToConstant: view.bounds.height / 3).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.topAnchor.constraint(equalTo: field.bottomAnchor, constant: 10   ).isActive = true
    }
    
    
    func memoTextView() {
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.delegate = self
        textView.backgroundColor = .clear
        
        self.view.addSubview(textView)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.widthAnchor.constraint(equalToConstant: view.bounds.width - 20).isActive = true
        textView.heightAnchor.constraint(equalToConstant: view.bounds.height / 4.5).isActive = true
        textView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: button.bottomAnchor, constant: 10).isActive = true
    }
    
    
    @objc fileprivate func finishMemo(_ sender: UIButton){
        // 객체 인스턴스 생성
//        formatter.locale = Locale(identifier: "ko") // 로케일 변경
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss EEEE"
//        print("현재시간: " + formatter.string(from: date as Date))
        _ = saveCoreData(title: field.text ?? "제목이 없어요", memo: field.text ?? "메모가 없어요")
        do {
            self.resultArray = try readCoreData()
        } catch {
            print(error)
        }
        self.dismiss(animated: true)
    }
    
    
    @objc fileprivate func didTapButton(_ sender: UIButton){
        // 객체 인스턴스 생성
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}


extension MemoViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            imageView.image = image
        }
        createImageButton()
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension MemoViewController: UITextViewDelegate {
    // 클릭 되있을때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = nil
            textView.textColor = .black
        }
        if self.view.frame.origin.y == 0 {
                        self.view.frame.origin.y -= view.bounds.height / 4.5
                }
    }
    
    // 입력이 끝났을때
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            textView.text = textViewPlaceHolder
            textView.textColor = .lightGray
        }
    }
}

