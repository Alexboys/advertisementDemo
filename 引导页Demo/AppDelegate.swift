//
//  AppDelegate.swift
//  引导页Demo
//
//  Created by 咕咚咕咚 on 2019/12/25.
//  Copyright © 2019 么么直播. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var advertView = AdvertView()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        //newsetAdGuidePage()
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        let vc = ViewController()
        let nav = UINavigationController.init(rootViewController: vc)
        self.window?.rootViewController = nav
        self.window?.makeKeyAndVisible()
        
        loadAdGuidePage()
        return true
        
    }
    
    
    /// MARK: - 广告页
    func newsetAdGuidePage() {
        
        ///MARK: - 网络
        //网络图片
        let adImageJPGUrl = "http://p5.image.hiapk.com/uploads/allimg/150112/7730-150112143S3.jpg"
        //网络gif
        //let adimageGIFUrl = "http://img.ui.cn/data/file/3/4/6/210643.gif"
        
        ///MARK: - 本地
        //本地图片
        //let adImageJPGPath = Bundle.main.path(forResource: "adImage2", ofType: "jpg") ?? ""
        //本地gif
        //let adImageGifPath = Bundle.main.path(forResource: "adImage3", ofType: "gif") ?? ""
        
        let _ = AdvertisementView(adUrl: adImageJPGUrl, isIgnoreCache: false, placeholderImage: nil, completion: { (isGotoDetailView) in
            print(isGotoDetailView)
        })
    }
    

    
    /// MARK: - 应用启动后加载广告
    func loadAdGuidePage() {
        
        // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
        let image = UserDefaults.standard.value(forKey: adImageName) as! String? ?? " "
        let filePath = NSHomeDirectory().appending("/Documents/\(image)")
        //let isExist = self.isFileExist(withFilePath: (filePath))
        let isExist = AdPageManager.isFileExist(withFilePath: (filePath))
        if isExist {
            advertView = AdvertView.init(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHight))
            advertView.advView.image = UIImage(contentsOfFile: filePath)
            advertView.backgroundColor = UIColor.red
            advertView.show()
        }
        // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
        AdPageManager.getAdvertisingImage()
        
    }
    
}


