// WebViewController
//  WebViewController.swift
//  NewsApp2
//
//  Created by 船井洋一郎 on 2019/06/09.
//  Copyright © 2019 yoichiro.funai. All rights reserved.
//

import UIKit
import WebKit


class WebViewController: UIViewController,WKUIDelegate {
    
    //WKWebViewを使うための宣言
    var webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //webViewのframeを作る。画面全体に表示される
        webView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 50)
        self.view.addSubview(webView)
        
        
        let button = UIButton(type: .system)
        
        button.addTarget(self, action: #selector(buttonAction(_ :)), for: .touchUpInside)
        button.setTitle("戻る", for: .normal)
        button.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20.0)
        button.tintColor = UIColor.white
        
        self.view.addSubview(button)
        
        
        
        //urlを取り出す
        let urlString = UserDefaults.standard.object(forKey: "url")
        //URl型に変換する
        let url = URL(string: urlString! as! String)
        //urlをrequestする。URLをネットワーク接続が可能な状態（リクエスト）に変換する
        let request = URLRequest(url: url!)
        //webViewにwebページを表示する
        webView.load(request)
        
        
    }
    
    @objc func buttonAction(_ sender:UIButton) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
    
    
    
}
