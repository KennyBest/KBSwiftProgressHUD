//
//  ViewController.swift
//  KBProgressHUD
//
//  Created by llj on 2017/5/10.
//  Copyright © 2017年 llj. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var progressRingView: KBProgressAnimatedView?
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.backgroundColor = .black
        testRingView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clickStartButton(_ sender: Any) {
        
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
        
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(refreshRingView), userInfo: nil, repeats: true)
        timer?.fire()
        
    }

    //TODO- 这里有一个问题   判断self.progressRingView?.strokeEnd != CGFloat(1.0) 为什么无效
    func refreshRingView() -> Void {
    
        guard self.progressRingView?.strokeEnd != CGFloat(1.0) else {
            self.timer?.invalidate()
            self.timer = nil
            CATransaction.begin()
            self.progressRingView?.strokeEnd = 0.0
            CATransaction.commit()
            return
        }
        CATransaction.begin()
        self.progressRingView?.strokeEnd += 0.05
        CATransaction.commit()
    }
    
    
    func testRingView() -> Void {
        
        let frame = CGRect(x: 10, y: 20, width: 100, height: 100)
        
        let backgroundRingView = KBProgressAnimatedView.init(frame: frame)
        backgroundRingView.radius = 40
        backgroundRingView.strokeColor = .lightGray
        backgroundRingView.strokeThickness = 2.0
        backgroundRingView.strokeEnd = 1.0
        self.view.addSubview(backgroundRingView)
        
        let ringView = KBProgressAnimatedView.init(frame: frame)
        ringView.radius = 40
        ringView.strokeThickness = 2.0
        ringView.strokeColor = .red
        ringView.strokeEnd = 0.0
        self.view.addSubview(ringView)
        progressRingView = ringView
        
    }
    
}

