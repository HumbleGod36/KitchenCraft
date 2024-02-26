//
//  DishDiscriptionViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 17/02/24.
//

import UIKit
import SDWebImage
import Alamofire
import GRDB

class DishDiscriptionViewController: UIViewController {
    
    var dishData : DishModelClass?
    var id = ""
    var db : DatabaseQueue?
    var isBookMarked : Bool?
    var dbPath : String {
        let filemanager = FileManager.default
        let documentDirectory = try? filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filePath = documentDirectory?.appendingPathComponent("KitchenCraft.sqlite")
        return filePath?.path() ?? ""
    }
    
    @IBOutlet weak var instructionText: UILabel!
    
    @IBOutlet weak var ingrediant6: UILabel!
    @IBOutlet weak var ingrediant5: UILabel!
    @IBOutlet weak var ingrediant4: UILabel!
    @IBOutlet weak var ingrediant3: UILabel!
    @IBOutlet weak var ingrediant2: UILabel!
    @IBOutlet weak var ingrediant1: UILabel!
    @IBOutlet weak var dishImage: UIImageView!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var loaderView: UIView!
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBOutlet weak var bookMarkButton: UIButton!
    @IBAction func bookmarkButtonClicked(_ sender: UIButton) {
        if isBookMarked == false {
            sender.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
            isBookMarked  = true
            writeDBData()
        } else {
            sender.setImage(UIImage(systemName: "bookmark" ), for: .normal)
            isBookMarked = false
            deleteOneDBData()
            
        }
 
        
    
    }
    
    @IBAction func WatchAVideoButtonClicked(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "VideoViewController")as! VideoViewController
        vc.videoPath = dishData?.meals.first?.strYoutube ?? ""
        self.present(vc, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(id)
        mainView.isHidden  = true
        loaderView.isHidden = false
        fetchDishData(id: id)
        db = try? DatabaseQueue(path: dbPath)
        print(dbPath)
        createTableDB()
        isBookMarked = false
        fetchOneDBData()
    
    }
    
    
    func updateUI() {
        guard let dishData = dishData?.meals.first else {
            print("data error")
            return
        }
        
        ingrediant1.text = dishData.strIngredient1
        ingrediant2.text = dishData.strIngredient2
        ingrediant3.text = dishData.strIngredient3
        ingrediant4.text = dishData.strIngredient4
        ingrediant5.text = dishData.strIngredient5
        ingrediant6.text = dishData.strIngredient6
        
        instructionText.text = dishData.strInstructions
        dishImage.sd_setImage(with: URL(string: dishData.strMealThumb ))
        
    }
    
    
    
    func fetchDishData(id:String) {
        let url = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        
        AF.request(url , method: .get , encoding: JSONEncoding.default ).responseDecodable (of: DishModelClass.self) { response in
            switch response.result {
            case.success(let list):
                print(list)
                self.dishData = list
                self.mainView.isHidden  = false
                self.loaderView.isHidden = true
                
                self.updateUI()
                
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    
    func createTableDB() {
        do{
            try db?.write({ db in
                try?  db.create(table: "DishBookMarked", body: { t in
                    t.primaryKey("dishID", .text)
                    t.column("Dishname", .text).notNull()
                    t.column("DishIMage", .text).notNull()
                    t.column("Instruction", .text).notNull()
                })
            })
        }catch {
            print(error)
        }
    }
    
    
    func writeDBData(){
        try? db?.write { db in
            try? DishBookMarked(dishID: id, Dishname: dishData?.meals.first?.strMeal ?? "", DishIMage: dishData?.meals.first?.strMealThumb ?? "", Instruction: dishData?.meals.first?.strInstructions  ?? "").insert(db)
        }
    }
    
    func deleteOneDBData(){
        do {
            let _ =  try db?.inDatabase({ db in
                try DishBookMarked.deleteOne(db, key: id)
            })
        } catch {
            print(error)
        }
        
    }
    
    func fetchOneDBData(){
        do{
            var _ = try db?.inDatabase({ db in
             let bookmarked = try DishBookMarked.fetchOne(db, key: id)
                if bookmarked == nil {
                    isBookMarked = false
                    bookMarkButton.setImage(UIImage(systemName: "bookmark"), for: .normal)
                } else {
                    isBookMarked = true
                    bookMarkButton.setImage(UIImage(systemName: "bookmark.fill"), for: .normal)
                }
            })
        } catch {
            print(error)
        }
    }
}
