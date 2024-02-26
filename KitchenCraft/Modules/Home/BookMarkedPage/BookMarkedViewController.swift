//
//  BookMarkedViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 18/02/24.
//

import UIKit
import GRDB
import SDWebImage
class BookMarkedViewController: UIViewController {

    var bookmarkData : [DishBookMarked]?
    var db : DatabaseQueue?
    
    
    var dbPath : String {
        let filemanager = FileManager.default
        let documentDirectory = try? filemanager.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let filePath = documentDirectory?.appendingPathComponent("KitchenCraft.sqlite")
        return filePath?.path() ?? ""
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "RecomendedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecomendedTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        db = try? DatabaseQueue(path: dbPath)
        
        self.bookmarkData = fetchBookMarkData()
    }
    
    func fetchBookMarkData() -> [DishBookMarked] {
        let data: [DishBookMarked]? = try? db?.read { db in
            try DishBookMarked.fetchAll(db)
        }
        return data ?? []
    }


}
extension BookMarkedViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookmarkData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendedTableViewCell", for: indexPath) as! RecomendedTableViewCell
        cell.dishImage.sd_setImage(with: URL(string: bookmarkData?[indexPath.row].DishIMage ?? ""))
        cell.dishName.text = bookmarkData?[indexPath.row].Dishname ?? ""
        cell.dishDisc.text  = bookmarkData?[indexPath.row].Instruction ?? ""
        cell.DishArea.text = "nil"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DishDiscriptionViewController") as! DishDiscriptionViewController
        vc.modalPresentationStyle = .fullScreen
        vc.id = bookmarkData?[indexPath.row].dishID ?? ""
        self.present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let dishId = bookmarkData?[indexPath.row].dishID ?? ""
        bookmarkData?.remove(at: indexPath.row)
        do {
            let _ = try db?.inDatabase({ db in
                try DishBookMarked.deleteOne(db, key: dishId)
            })
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadRows(at: [indexPath], with: .left)
        }
        catch {
            print(error)
        }
    }
    
}
