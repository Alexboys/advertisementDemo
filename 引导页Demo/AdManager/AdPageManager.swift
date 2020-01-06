//
//  AdPageManager.swift
//  引导页Demo
//
//  Created by 咕咚咕咚 on 2019/12/25.
//  Copyright © 2019 么么直播. All rights reserved.
//

import UIKit

class AdPageManager: NSObject {
    
    /**
      *  判断文件是否存在
      */
     
     static func isFileExist(withFilePath filePath: String) -> Bool {
         
         let fileManager = FileManager.default
         var isDirectory:ObjCBool = false
         return fileManager.fileExists(atPath: filePath, isDirectory :  &isDirectory)
     }
     
     
     /**
      *  初始化广告页面
      */
     static func getAdvertisingImage() {
         // TODO 请求广告接口
         // 这里原本采用美团的广告接口，现在了一些固定的图片url代替
        let imageArray: [String] = ["http://imgsrc.baidu.com/forum/pic/item/9213b07eca80653846dc8fab97dda144ad348257.jpg",
                                  "http://pic.paopaoche.net/up/2012-2/20122220201612322865.png",
                                  "http://img5.pcpop.com/ArticleImages/picshow/0x0/20110801/2011080114495843125.jpg",
                                  "http://www.mangowed.com/uploads/allimg/130410/1-130410215449417.jpg"]

          

        let imageUrl: String = imageArray[0]
     
         // 获取图片名:43-130P5122Z60-50.jpg
         let stringArr: [Any] = imageUrl.components(separatedBy: "/")
         let imageName: String = (stringArr.last as! String?)!
         // 拼接沙盒路径
         let filePath: String = NSHomeDirectory().appending("/Documents/\(imageName)")
         let isExist: Bool = self.isFileExist(withFilePath: filePath)
         if !isExist {
             // 判断广告是否更新,如果该图片不存在，则删除老图片，下载新图片
             print("图片不存在")
             self.downloadAdImage(withUrl: imageUrl, imageName: imageName)
         }
     }
     
     
     /**
      *  下载新图片
      */
     static func downloadAdImage(withUrl imageUrl: String, imageName: String) {
        
         DispatchQueue.global(qos: .default).async(execute: {() -> Void in
             
             let url =  URL(string: imageUrl)
             let data :Data? = try? Data(contentsOf: url!)
             let filePath: String = NSHomeDirectory().appending("/Documents/\(imageName)")
             let fileManager = FileManager.default
             fileManager.createFile(atPath: filePath, contents: data , attributes: nil)
             self.deletOldImage()
             UserDefaults.standard.set(imageName, forKey: adImageName)
             UserDefaults.standard.synchronize()
             
         })
     }

     /**
      *  删除旧图片
      */
     static func deletOldImage()  {
         
        let imageName = UserDefaults.standard.value(forKey: adImageName)
        if (imageName != nil) {
            let filePath = NSHomeDirectory().appending("/Documents/\(imageName ?? "")")
            print(filePath)
            let fileManager:FileManager = FileManager.default
            try? fileManager.removeItem(atPath: filePath)
            
        }
    }
    
    
    deinit {
        print("执行了")
    }

}
