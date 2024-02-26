//
//  HomePageViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 14/02/24.
//

import UIKit
import SDWebImage
import Alamofire

class HomePageViewController: UIViewController {
    var RdishesData : RecomemdedModelClass?
    var categoryData : CategoryModelClass?
    var dishData : DishModelClass?
    var VairableADded : Bool?

 
    
    var option : String = ""
     
    @IBOutlet weak var userButton: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var recommendedDishesTableView: UITableView!
    @IBOutlet weak var categoriesCollectionVIew: UICollectionView!
    
    
    @IBAction func profileButtonClicked(_ sender: UIButton) {
//        let vc = storyboard?.instantiateViewController(identifier: "LogoutViewController") as! LogoutViewController
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "BookMark", style: .default, handler: { alert in
            let vc = self.storyboard?.instantiateViewController(identifier: "BookMarkedViewController")as! BookMarkedViewController
            self.present(vc, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Logout", style: .default, handler: { alert in
            let alert = UIAlertController(title: "Are you sure?", message: nil, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Logout", style: .destructive ,handler: { alert in
                let vc = self.storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
                
                if let sd = self.view.window?.windowScene?.delegate as? SceneDelegate , let window = sd.window {
                    window.rootViewController = vc
                    UserDefaults.standard.set(1, forKey: "isLogedIn")
                }
                
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
                
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default))
            self.present(alert, animated: true)
           
        }))
    
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
        
    }
    
    @IBAction func seeAllCategoryButtonClicked(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "AllCategoriesViewController") as! AllCategoriesViewController
        
        vc.categoriesData = categoryData 
        self.present(vc, animated: true)
    }
    
    @IBAction func recommendedSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 : fetchDishesData(option: "Vegetarian")
            recommendedDishesTableView.reloadData()
        case 1 : fetchDishesData(option: "Chicken")
            recommendedDishesTableView.reloadData()
        default : fetchDishesData(option: "Vegetarian")
            recommendedDishesTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDishesData(option: "Vegetarian")
        catergoryFetchData()
        
        recommendedDishesTableView.register(UINib(nibName: "RecomendedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecomendedTableViewCell")
        recommendedDishesTableView.dataSource = self
        recommendedDishesTableView.delegate = self
        
        categoriesCollectionVIew.register(UINib(nibName: "CategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "CategoryCollectionViewCell")
        categoriesCollectionVIew.delegate = self
        categoriesCollectionVIew.dataSource = self
        
        
    }
    
    func fetchDishesData(option : String){
        let url = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(option)"
        
        AF.request(url , method: .get , encoding: JSONEncoding.default ).responseDecodable (of: RecomemdedModelClass.self) { response in
            switch response.result {
            case.success(let list):
                print(list)
                self.RdishesData = list
                self.recommendedDishesTableView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
    
    func catergoryFetchData() {
        let url = "https://www.themealdb.com/api/json/v1/1/categories.php"
        
        AF.request(url , method: .get , encoding: JSONEncoding.default ).responseDecodable (of: CategoryModelClass.self) { response in
            switch response.result {
            case.success(let list):
                print(list)
                self.categoryData = list
                self.categoriesCollectionVIew.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    
   
    
    
    
    

}
extension HomePageViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return RdishesData?.meals.count ?? 0
      
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendedTableViewCell", for: indexPath) as! RecomendedTableViewCell
        cell.dishImage.sd_setImage(with: URL(string: RdishesData?.meals[indexPath.row].strMealThumb ?? ""))
        cell.dishName.text = RdishesData?.meals[indexPath.row].strMeal
        cell.dishDisc.text = "In a medium-sized bowl, whisk together 2 cups of flour, 1 teaspoon of baking powder, and a pinch of salt. In a separate bowl, beat 2 eggs and mix in 1 cup of milk and 2 tablespoons of melted butter. Combine wet and dry ingredients until smooth. Heat a skillet over medium heat and pour batter to make pancakes."
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
        vc.id = RdishesData?.meals[indexPath.row].idMeal ?? ""
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
        
        
    }
    
    
}
extension HomePageViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.categoryName.text = categoryData?.categories[indexPath.row].strCategory
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.frame.height)
        let weight = (collectionView.frame.width - 10) / 3.5
        
        return CGSize(width: weight, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "CategoriesDiscViewController") as! CategoriesDiscViewController
        vc.cateogiesData = categoryData?.categories[indexPath.row]
        self.present(vc, animated: true)
    }
    
    
}
