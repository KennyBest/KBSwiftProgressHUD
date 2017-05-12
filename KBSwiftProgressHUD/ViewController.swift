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
    lazy var indefiniteAnimationView: KBIndefiniteAnimationView = {
        
        let view = KBIndefiniteAnimationView(frame: CGRect(x: 10, y: 150, width: 100, height: 100))
        view.backgroundColor = .white
        view.radius = 40.0
        view.strokeThickness = 2
        view.strokeColor = UIColor.red
        
        return view
    }()
    
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
        
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(refreshRingView), userInfo: nil, repeats: true)
        timer?.fire()
    }

    @IBAction func clickShowButton(_ sender: Any) {
        self.indefiniteAnimationView = KBIndefiniteAnimationView(frame: CGRect(x: 10, y: 150, width: 100, height: 100))
        self.indefiniteAnimationView.backgroundColor = .white
        self.indefiniteAnimationView.radius = 40.0
        self.indefiniteAnimationView.strokeThickness = 2
        self.indefiniteAnimationView.strokeColor = UIColor.red
        view.addSubview(self.indefiniteAnimationView)
    }
    
   
    @IBAction func clickDismissButton(_ sender: Any) {
        self.indefiniteAnimationView.removeFromSuperview()
    }
    //TODO: 这里有一个问题   判断self.progressRingView?.strokeEnd != CGFloat(1.0) 为什么无效 反而 Float(self.progressRingView!.strokeEnd) != 1.0这样可以
    
    func refreshRingView() -> Void {
    
        guard Float(self.progressRingView!.strokeEnd) != 1.0 else {
            let tmp = Float(self.progressRingView!.strokeEnd)
            print("current strokeEnd is : \(tmp)")
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

