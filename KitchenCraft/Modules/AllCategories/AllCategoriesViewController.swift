//
//  AllCategoriesViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 16/02/24.
//

import UIKit
import SDWebImage
import Alamofire

class AllCategoriesViewController: UIViewController {
    var categoriesData  :  CategoryModelClass?
    @IBOutlet weak var categoriesCollectionView: UICollectionView!
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        catergoryFetchData()
        
        categoriesCollectionView.register(UINib(nibName: "AllCategoriesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "AllCategoriesCollectionViewCell")
        categoriesCollectionView.dataSource = self
        categoriesCollectionView.delegate = self
        navigationItem.title = "Categories"
    }
    
    func catergoryFetchData() {
        let url = "https://www.themealdb.com/api/json/v1/1/categories.php"
        
        AF.request(url , method: .get , encoding: JSONEncoding.default ).responseDecodable (of: CategoryModelClass.self) { response in
            switch response.result {
            case.success(let list):
                print(list)
                self.categoriesData = list
                self.categoriesCollectionView.reloadData()
            case.failure(let error):
                print(error)
            }
        }
    }
    

}
extension AllCategoriesViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesData?.categories.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AllCategoriesCollectionViewCell", for: indexPath) as! AllCategoriesCollectionViewCell
        cell.categoryImage.sd_setImage(with: URL(string: categoriesData?.categories[indexPath.row].strCategoryThumb ?? ""))
        cell.categoryName.text = categoriesData?.categories[indexPath.row].strCategory
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (collectionView.frame.height) / 3
        let width = (collectionView.frame.width - 20 ) / 3
        
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "CategoriesDiscViewController") as! CategoriesDiscViewController
        vc.cateogiesData = categoriesData?.categories[indexPath.row]
      
        self.present(vc, animated: true)
    }
    
}
