//
//  ViewController.swift
//  引导页Demo
//
//  Created by 咕咚咕咚 on 2019/12/25.
//  Copyright © 2019 么么直播. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "首页"
        self.view.backgroundColor = UIColor.yellow
        
        NotificationCenter.default.addObserver(self, selector: #selector(pushAd), name: NSNotification.Name(rawValue: "pushAd"), object: nil)
        
        // MARK:- ********************* 新手引导页的三种类型 *********************
        // 静态引导页
        //self.setStaticGuidePage()
        
        // 动态引导页
        //self.setDynamicGuidePage()
        
        // 视频引导页
        //setVideoGuidePage()
        
    }
    
    // MARK: - 静态图片引导页
    func setStaticGuidePage() {
        let imageNameArray: [String] = ["guide00", "guide01", "guide02"]
        let guideView = MMGuidePageView.init(imageNameArray: imageNameArray, isHiddenSkipButton: false)
        self.navigationController?.view.addSubview(guideView)
    }
    // MARK: - 动态图片引导页
    func setDynamicGuidePage() {
        let imageNameArray: [String] = ["guideImage6.gif", "guideImage7.gif", "guideImage8.gif"]
        let guideView = MMGuidePageView.init(imageNameArray: imageNameArray, isHiddenSkipButton: false)
        self.navigationController?.view.addSubview(guideView)
    }
    
    // MARK: - 视频引导页
    func setVideoGuidePage() {
        
        //网络视频
        let urlString = "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4"
        //本地视频
        let urlStr = Bundle.main.path(forResource: "1.mp4", ofType: nil)
        
        if !urlString.isEmpty {
        
            let videoURL = URL(string: urlString)
            let guideView = MMGuidePageView.init(NewvideoURL: videoURL!, isHiddenSkipButton: false)
            self.navigationController?.view.addSubview(guideView)
            
        }else{
            
            let videoUrl = NSURL.fileURL(withPath: urlStr!)
            let guideView = MMGuidePageView.init(NewvideoURL: videoUrl, isHiddenSkipButton: false)
            self.navigationController?.view.addSubview(guideView)
        }
        
    }
    
    
    @objc func pushAd()  {
        
        print("被点击了")
        let AdVc = AdViewController()
        self.navigationController?.pushViewController(AdVc, animated: true)
        
    }
    
}

