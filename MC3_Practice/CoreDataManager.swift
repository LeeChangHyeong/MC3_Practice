//
//  CoreDataManager.swift
//  MC3_Practice
//
//  Created by 김상현 on 2022/07/12.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    var resultArray: [NSManagedObject]?

    func saveCoreData(title: String, memo: String, image: Data) {
        // App Delegate 호출
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        
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
        object.setValue(image, forKey: "image")

        do {
            // managedContext 내부의 변경사항 저장
            try managedContext.save()
        } catch let error as NSError {
            // 에러 발생시
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func readCoreData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
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
            self.resultArray = resultCDArray

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
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

}
