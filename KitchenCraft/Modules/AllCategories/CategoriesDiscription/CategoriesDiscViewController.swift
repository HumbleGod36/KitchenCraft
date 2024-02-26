//
//  CategoriesDiscViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 17/02/24.
//

import UIKit
import Alamofire

class CategoriesDiscViewController: UIViewController {
   
    var cateogiesData : Category?
    var dishData: RecomemdedModelClass?
    
    @IBOutlet weak var loaderView: UIView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDishesData(option: cateogiesData?.strCategory ?? "")
        tableView.register(UINib(nibName: "RecomendedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecomendedTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
        
        self.tableView.reloadData()
        image.sd_setImage(with: URL(string: cateogiesData?.strCategoryThumb ?? ""))
        categoryName.text = cateogiesData?.strCategory
        navigationItem.title = cateogiesData?.strCategory
        navigationItem.backBarButtonItem?.tintColor = .orange
        
        loaderView.isHidden = false
        tableView.isHidden = true
    }
    
    func fetchDishesData(option : String){
        let url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(option)"
        
        AF.request(url , method: .get , encoding: JSONEncoding.default ).responseDecodable (of: RecomemdedModelClass.self) { response in
            switch response.result {
            case.success(let list):
                print(list)
             
                self.dishData = list
                self.loaderView.isHidden = true
                self.tableView.isHidden = false
                self.tableView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }

}
extension CategoriesDiscViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(dishData?.meals.count ?? 0)
        return dishData?.meals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendedTableViewCell", for: indexPath) as! RecomendedTableViewCell
        cell.dishImage.sd_setImage(with: URL(string: dishData?.meals[indexPath.row].strMealThumb ?? ""))
        cell.dishName.text = dishData?.meals[indexPath.row].strMeal
//        cell.dishDisc.text = "In a medium-sized bowl, whisk together 2 cups of flour, 1 teaspoon of baking powder, and a pinch of salt. In a separate bowl, beat 2 eggs and mix in 1 cup of milk and 2 tablespoons of melted butter. Combine wet and dry ingredients until smooth. Heat a skillet over medium heat and pour batter to make pancakes."
        cell.view.layer.shadowColor = UIColor.gray.cgColor
        cell.view.layer.shadowOpacity = 0.5
        cell.view.layer.shadowRadius = 1
        cell.view.layer.shadowOffset = CGSize(width: 5, height: 5 )
        cell.view.clipsToBounds = false
        
        
        
        cell.dishImage.layer.borderColor = UIColor.gray.cgColor
        cell.dishImage.layer.borderWidth = 2
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DishDiscriptionViewController") as! DishDiscriptionViewController
        vc.id = dishData?.meals[indexPath.row].idMeal ?? ""
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
}
