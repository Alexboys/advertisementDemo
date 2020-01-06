//
//  MMGuidePageView.swift
//  引导页Demo
//
//  Created by 咕咚咕咚 on 2019/12/25.
//  Copyright © 2019 么么直播. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import AVKit

let MMScreenWidth = UIScreen.main.bounds.size.width
let MMScreenHeight = UIScreen.main.bounds.size.height

class MMGuidePageView: UIView {
    
    var imageArray:[String]?
    var guidePageView: UIScrollView!
    var imagePageControl: UIPageControl?
    
    
    
    var playerItem: AVPlayerItem?
    var newPlayerController: AVPlayerViewController!
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    deinit {
        print("deinit")
    }
    
    
    // MARK: - /************************View life************************/
    /// init
    ///
    /// - Parameters:
    ///   - imageNameArray: 引导页图片数组
    ///   - isHiddenSkipButton:  跳过按钮是否隐藏
    init(imageNameArray:[String], isHiddenSkipButton: Bool) {
        let frame = CGRect.init(x: 0, y: 0, width: MMScreenWidth, height: MMScreenHeight)
        super.init(frame: frame)
        self.imageArray = imageNameArray
        if self.imageArray == nil || self.imageArray?.count == 0 {
            return
        }
        self.addScrollView(frame: frame)
        self.addSkipButton(isHiddenSkipButton: isHiddenSkipButton)
        self.addImages()
        self.addPageControl()
    }
        
    
    // MARK: - /************************ video ************************/
    init(NewvideoURL: URL, isHiddenSkipButton: Bool) {
        let frame = CGRect.init(x: 0, y: 0, width: MMScreenWidth, height: MMScreenHeight)
        super.init(frame: frame)
        
        newPlayerController = AVPlayerViewController()
        newPlayerController.view.frame = frame
        newPlayerController.view.alpha = 1.0
        //设置填充模式
        newPlayerController.videoGravity = AVLayerVideoGravity(rawValue: AVLayerVideoGravity.resizeAspectFill.rawValue)
        //设置是否显示媒体播放组件
        newPlayerController.showsPlaybackControls = false
        //多分屏功能取消
        newPlayerController.allowsPictureInPicturePlayback = false;
        playerItem = AVPlayerItem(url: NewvideoURL)
        //设置AVPlayerViewController内部的AVPlayer为刚创建的AVPlayer
        newPlayerController.player = AVPlayer(playerItem: playerItem)
        self.addSubview(newPlayerController.view)
        newPlayerController.player?.play()
        self.addSkipButton(isHiddenSkipButton: isHiddenSkipButton)
        
        
        // 视频引导页进入按钮
        let movieStartButton = UIButton.init(frame: CGRect.init(x: 20, y: MMScreenHeight-70, width: MMScreenWidth-40, height: 40))
        movieStartButton.layer.borderWidth = 1.0
        movieStartButton.layer.cornerRadius = 20
        movieStartButton.layer.borderColor = UIColor.white.cgColor
        movieStartButton.setTitle("开始体验", for: .normal)
        movieStartButton.alpha = 0.0
        self.addSubview(movieStartButton)
        movieStartButton.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
        UIView.animate(withDuration: 1.0) {
            movieStartButton.alpha = 1.0
        }
    }
}

// MARK: - /************************普通方法************************/
extension MMGuidePageView {
    func addScrollView(frame: CGRect)  {
        self.guidePageView = UIScrollView.init(frame: frame)
        guidePageView.backgroundColor = UIColor.lightGray
        guidePageView.contentSize = CGSize.init(width: MMScreenWidth * (CGFloat)((self.imageArray?.count)!), height: MMScreenHeight)
        guidePageView.bounces = false
        guidePageView.isPagingEnabled = true
        guidePageView.showsHorizontalScrollIndicator = false
        guidePageView.delegate = self
        self.addSubview(guidePageView)
    }
    // 跳过按钮
    func addSkipButton(isHiddenSkipButton: Bool) -> Void {
        if isHiddenSkipButton {
            return
        }
        let skipButton = UIButton.init(frame: CGRect.init(x: MMScreenWidth * 0.8, y: MMScreenWidth * 0.1, width: 70, height: 35))
        skipButton.setTitle("跳过", for: .normal)
        skipButton.backgroundColor = UIColor.gray
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.layer.cornerRadius = skipButton.frame.size.height * 0.5
        skipButton.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
        self.addSubview(skipButton)
    }
    @objc func skipButtonClick() -> Void {
        UIView.animate(withDuration: 1, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    // 图片
    func addImages() -> Void {
        guard let imageArray = self.imageArray else {
            return
        }
        for i in 0..<imageArray.count {
            let imageView = UIImageView.init(frame: CGRect.init(x: MMScreenWidth * CGFloat(i), y: 0, width: MMScreenWidth, height: MMScreenHeight))
            let idString = (imageArray[i] as NSString).substring(from: imageArray[i].count - 3)
            if idString == "gif" {
                imageView.image = UIImage.gifImageWithName(imageArray[i])
                self.guidePageView.addSubview(imageView)
            } else {
                imageView.image = UIImage.init(named: imageArray[i])
                self.guidePageView.addSubview(imageView)
            }
            
            // 在最后一张图片上显示开始体验按钮
            if i == imageArray.count - 1 {
                imageView.isUserInteractionEnabled = true
                let startButton = UIButton.init(frame: CGRect.init(x: MMScreenWidth*0.1, y: MMScreenHeight*0.8, width: MMScreenWidth*0.8, height: MMScreenHeight*0.08))
                startButton.setTitle("开始体验", for: .normal)
                startButton.setTitleColor(UIColor.white, for: .normal)
                startButton.setBackgroundImage(UIImage.init(named: "guide_btn_bg"), for: .normal)
                startButton.addTarget(self, action: #selector(skipButtonClick), for: .touchUpInside)
                imageView.addSubview(startButton)
            }
        }
    }
    func addPageControl() -> Void {
        // 设置引导页上的页面控制器
        self.imagePageControl = UIPageControl.init(frame: CGRect.init(x: 0, y: MMScreenHeight*0.9, width: MMScreenWidth, height: MMScreenHeight*0.1))
        self.imagePageControl?.currentPage = 0
        self.imagePageControl?.numberOfPages = self.imageArray?.count ?? 0
        self.imagePageControl?.pageIndicatorTintColor = UIColor.gray
        self.imagePageControl?.currentPageIndicatorTintColor = UIColor.white
        self.addSubview(self.imagePageControl!)
    }
}
// MARK: - /************************代理方法************************/
extension MMGuidePageView: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.frame.size.width
        self.imagePageControl?.currentPage = Int(page)
    }
    
}
