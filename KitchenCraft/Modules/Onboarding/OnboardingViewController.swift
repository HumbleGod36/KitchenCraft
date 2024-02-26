//
//  OnboardingViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 12/02/24.
//

import UIKit
import SDWebImage

class OnboardingViewController: UIViewController {
  
    var onBoardingdata = [OnboardingModel]()
    
    var currentPage = 0 {
        didSet {
            pageController.currentPage = currentPage
            if currentPage == onBoardingdata.count - 1 {
                nxtButton.setTitle("Get Started", for: .normal)
            }
            else {
                nxtButton.setTitle("Next", for: .normal)
            }
                    
        }
    }

    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var nxtButton: UIButton!
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
        if currentPage == onBoardingdata.count - 1 {
            let vc = storyboard?.instantiateViewController(identifier: "LoginViewController") as! LoginViewController
            UserDefaults.standard.set(1, forKey: "isLogedIn")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)

        } else {
            currentPage += 1
            
            let indexpath = IndexPath(item: currentPage, section: 0)
            collectionView.isPagingEnabled = false
            collectionView.scrollToItem(at: indexpath, at: .centeredHorizontally, animated: true)
            collectionView.isPagingEnabled = true
        }
        }
    
        

    @IBOutlet weak var pageController: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchOnboardingData()
        
        collectionView.register(UINib(nibName: "OnboardingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
       
    }
       
    
    func fetchOnboardingData(){
        if let path = Bundle.main.path(forResource: "OnboardingData", ofType: "json")  {
            do {
                let data =  try Data(contentsOf: URL(filePath: path), options: .mappedIfSafe)
                do {
                    let list = try JSONDecoder().decode([OnboardingModel].self, from: data)
                    print (list)
                    self.onBoardingdata = list
                    collectionView.reloadData()
                }catch {
                    
                    print(error)
                }
                
            }catch {
                print(error)
            }
            
        }
    }
    

}
extension OnboardingViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onBoardingdata.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.image.sd_setImage(with: URL(string:onBoardingdata[indexPath.row].foodImage))
        cell.Header.text = onBoardingdata[indexPath.row].foodHeader
        cell.discription.text = onBoardingdata[indexPath.row].foodDisc
        cell.imageBackGroundView.layer.borderColor = UIColor.systemBrown.cgColor
        cell.imageBackGroundView.layer.borderWidth = 2
      

       
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        
        return CGSize(width: width, height: height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        
        currentPage  = Int(scrollView.contentOffset.x / width)
        
        print(scrollView.contentOffset)
        
    }
    
    
}
