//
//  AdvertView.swift
//  引导页Demo
//
//  Created by 咕咚咕咚 on 2019/12/25.
//  Copyright © 2019 么么直播. All rights reserved.
//

import UIKit



class AdvertView: UIView {
    
    
    var advView = UIImageView()
    
    var skipButton = UIButton()
    
    var imageFilePath : String?
    var timer :Timer!
    var time:Int = 3
    override init(frame:CGRect) {
        
        super.init(frame: frame)
        
        
        //设置广告图片
        advView = UIImageView.init(frame: frame)
        advView.isUserInteractionEnabled = true
        advView.contentMode = UIView.ContentMode.scaleAspectFill
        advView.clipsToBounds = true
        advView.backgroundColor = UIColor.red
        
        
        if (imageFilePath != nil) {
            advView.image = UIImage(contentsOfFile: imageFilePath!)
        }
        
        //给广告图片添加手势
        let  imageTap = UITapGestureRecognizer(target: self, action: #selector(pushAdDetail))
        advView.addGestureRecognizer(imageTap)
        //跳过按钮
        let btnW:CGFloat = 60
        let btnH:CGFloat = 30
        skipButton = UIButton(frame: CGRect(x: kScreenWidth - btnW, y: btnH, width: btnW, height: btnH))
        skipButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        skipButton.setTitle("跳过\(time)", for: .normal)
        skipButton.setTitleColor(UIColor.white, for: .normal)
        skipButton.backgroundColor = UIColor.gray
        skipButton.layer.cornerRadius = 4
        self.addSubview(advView)
        self.addSubview(skipButton)
        // 启用计时器，控制每秒执行一次tickDown方法
        timer = Timer.scheduledTimer(timeInterval: TimeInterval(1), target: self, selector: #selector(tickDown), userInfo: nil, repeats: true)
    }
    //定时器触发的方法
    @objc func tickDown()  {
        
        self.time -= 1
        skipButton.setTitle("跳过\(time)", for: .normal)
        //如果剩余时间小于等于0
        if(self.time <= 0){
            //取消定时器
            self.timer.invalidate()
            dismiss()
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapAction()  {
        dismiss()
    }
    
    //移除广告
    @objc func dismiss()  {
        self.timer.invalidate()
        self.timer = nil
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
        
    }
    //发送通知
    @objc func pushAdDetail()  {
        dismiss()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "pushAd"), object: nil)
    }
    //显示广告视图
    func show()  {
        
        if #available(iOS 13.0, *) {
            let window = UIApplication.shared.windows[0]
            window.addSubview(self)
            
        } else {
            
            let window  = UIApplication.shared.keyWindow
            window?.addSubview(self)
        }
        
    }
    
}
