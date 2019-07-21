//Page2ViewController
//  Page1ViewController.swift
//  NewsApp2
//
//  Created by 船井洋一郎 on 2019/06/08.
//  Copyright © 2019 yoichiro.funai. All rights reserved.
//

import UIKit
import SegementSlide


class Page2ViewController: UITableViewController,SegementSlideContentScrollViewDelegate,XMLParserDelegate {
    
    
    var parser = XMLParser()
    
    
    var currentElementName:String!
    
    var newsItems = [NewsItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
        tableView.backgroundColor = .clear
        
        
        let image = UIImage(named: "ocean")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        
        
        
        let urlString:String = "https://news.yahoo.co.jp/pickup/computer/rss.xml"
        let url:URL = URL(string: urlString)!
        
        parser = XMLParser(contentsOf: url)!
        
        parser.delegate = self
        
        parser.parse()
        
        // Do any additional setup after loading the view.
    }
    
    @objc var scrollView: UIScrollView {
        
        return tableView
        
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return self.view.frame.size.height/5
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        
        return 1
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return newsItems.count
    }
    
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        
        let newsItem = self.newsItems[indexPath.row]
        
        cell.textLabel?.text = newsItem.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 5
        
        cell.detailTextLabel?.text = newsItem.url
        cell.detailTextLabel?.textColor = .white
        
        return cell
        
    }
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = nil
        
        if elementName == "item" {
            
            self.newsItems.append(NewsItems())
            
        }else {
            
            
            currentElementName = elementName
        }
        
    }
    
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        
        if self.newsItems.count > 0 {
            
            let lastItem = self.newsItems[self.newsItems.count - 1]
            
            
            switch self.currentElementName {
                
            case "title":
                
                lastItem.title = string
            case "link":
                
                lastItem.url = string
            case "pubDate":
                lastItem.pubDate = string
                print(lastItem.pubDate as Any)
                
            default:break
                
                
                
            }
            
            
        }
    }
    
    
    //解析中に要素の終了タグがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        //全て取ったら初期値に戻す。画面遷移した時などにデータが残っていたらいけないので初期値にする
        self.currentElementName = nil
        
    }
    
    
    // XML解析終了時に実行されるメソッド
    func parserDidEndDocument(_ parser: XMLParser) {
        
        //上記のメソッド達を呼ぶ
        self.tableView.reloadData()
        
    }
    
    //cellが押されたときに呼ばれる
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //画面遷移した先でしたURLを表示したい、webviewに取得したURLを表示したい
        //Page1ViewControllerでWebViewControllerでを使えるようにする。。インスタンス作成。
        let webViewController:UIViewController = WebViewController()
        
        webViewController.modalTransitionStyle = .partialCurl
        //選択された場所
        let newsItem = newsItems[indexPath.row]
        //urlを飛ばす
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        //画面遷移する
        self.present(webViewController, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
