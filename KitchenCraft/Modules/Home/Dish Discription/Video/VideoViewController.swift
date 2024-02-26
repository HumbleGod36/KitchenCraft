//
//  VideoViewController.swift
//  KitchenCraft
//
//  Created by Tony Michael on 17/02/24.
//

import UIKit
import YouTubePlayer

class VideoViewController: UIViewController {
    
    var videoPath: String = ""
   
    @IBOutlet weak var youtubePlayerView: YouTubePlayerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let myVideoURL = NSURL(string: videoPath)
        youtubePlayerView.loadVideoURL(myVideoURL! as URL)
    }

}
