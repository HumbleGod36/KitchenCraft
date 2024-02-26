//
//  SearchViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 20/02/24.
//

import UIKit
import Alamofire
import SDWebImage

class SearchViewController: UIViewController {
    
    var searchData : SearchModelClass?

    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var ErrorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "RecomendedTableViewCell", bundle: nil), forCellReuseIdentifier: "RecomendedTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        
        searchTextField.delegate = self
        
        tableView.isHidden = true
        errorMessage.text = "Start Searching"
    }
    
    func fetchSearchData(searchText : String){
        let url = "https://www.themealdb.com/api/json/v1/1/search.php?s=\(searchText)"
        
        AF.request(url , method: .get , encoding: JSONEncoding.default).responseDecodable (of: SearchModelClass.self) { response in
            switch response.result {
            case.success(let list):
                print(list)
                self.searchData = list
                self.tableView.reloadData()
            case.failure(let error):
                print(error)
            }
            
        }
         
        }
    }
 
extension SearchViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  searchData?.meals.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecomendedTableViewCell", for: indexPath) as! RecomendedTableViewCell
        cell.dishImage.sd_setImage(with: URL(string: searchData?.meals[indexPath.row].strMealThumb ?? ""))
        cell.dishName.text = searchData?.meals[indexPath.row].strMeal ?? ""
        cell.dishDisc.text  =  searchData?.meals[indexPath.row].strInstructions ?? ""
        cell.DishArea.text = searchData?.meals[indexPath.row].strArea
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "DishDiscriptionViewController") as! DishDiscriptionViewController
        vc.id = searchData?.meals[indexPath.row].idMeal ?? ""
        self.present(vc, animated: true)
    }
    
    
}




extension SearchViewController : UISearchBarDelegate, UITextFieldDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        
        if searchText == "" {
            tableView.isHidden = true
            ErrorView.isHidden = false
            errorMessage.text = "Please enter a Dish Name"
            
        } else {
            fetchSearchData(searchText: searchText)
            tableView.isHidden = false
            ErrorView.isHidden = true
        }
            
            }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.searchTextField.endEditing(true)
    }
    
    
}
