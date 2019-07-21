//Page1ViewController
//  Page1ViewController.swift
//  NewsApp2
//
//  Created by 船井洋一郎 on 2019/06/08.
//  Copyright © 2019 yoichiro.funai. All rights reserved.
//

import UIKit
import SegementSlide

//UITableViewControllerにすることで、このファイル自身がtableViewになる。パーツを用意しなくて良い
//XML解析を使えるようにするための宣言
class Page1ViewController: UITableViewController,SegementSlideContentScrollViewDelegate,XMLParserDelegate {
    
    
    //XML解析のインスタンスを作成。item,link,pubdate,titleなどを取ってくる解析を行う
    var parser = XMLParser()
    
    //RSSのパース中の要素名
    var currentElementName:String!
    
    //NewsItems型で入れる。tilte,url,pubdateを使えるようにする
    var newsItems = [NewsItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UITableViewControllerの機能を上記で継承しているため宣言しなくても使える
        tableView.backgroundColor = .clear
        
        
        let image = UIImage(named: "italy")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        
        
        //perseするURLを指定
        let urlString:String = "https://headlines.yahoo.co.jp/rss/cyclist-c_spo.xml"
        let url:URL = URL(string: urlString)!
        //パースするURLを指定する(上記のURL)
        parser = XMLParser(contentsOf: url)!
        //parserのでdelegateメソッドを使用する
        parser.delegate = self
        //解析がスタート、XMLdelegateが呼ぶ
        parser.parse()
        
        
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
        
        //cellはLabelとDetailLabelの二つを持っており、これを使えるようにする
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
        cell.backgroundColor = .clear
        //indexPath(title,url)の全部を取ってくる
        let newsItem = self.newsItems[indexPath.row]
        //cellのtextLabelにはtitleを入れる
        cell.textLabel?.text = newsItem.title
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
        cell.textLabel?.textColor = .white
        cell.textLabel?.numberOfLines = 5
        
        cell.detailTextLabel?.text = newsItem.url
        cell.detailTextLabel?.textColor = .white
        
        return cell
        
    }
    
    //解析中に要素の開始タグがあったときに実行されるメソッド、 XMLParserのdelegateメソッドを書いていく
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        
        currentElementName = nil
        //pareseしているときにitem,url,pubdateが入ってくる
        if elementName == "item" {
            //"item"であれば、NewsItem(title,url,pubdate)という初期化したものをnewsItemsという変数に入れる
            self.newsItems.append(NewsItems())
            
        }else {
            
            //"item"が無ければelementName(title,linkなど)を入れる
            currentElementName = elementName
        }
        
    }
    
    // 開始タグと終了タグでくくられたデータがあったときに実行されるメソッド
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
        //何かしらelementNameが入っているのであれば,if文の中に入れる
        if self.newsItems.count > 0 {
            
            let lastItem = self.newsItems[self.newsItems.count - 1]
            
            //currentElementName(現在の要素名を)
            switch self.currentElementName {
                
            case "title":
                //titleを見つければ、中の文字を取ってくる
                lastItem.title = string
            case "link":
                //linkを見つければ、中のurlを取ってくる
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
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Page1ViewControllerでWebViewControllerでを使えるようにする。
        let webViewController:UIViewController = WebViewController()
        
        webViewController.modalTransitionStyle = .partialCurl
        
        let newsItem = newsItems[indexPath.row]
        //urlを飛ばす
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        
        self.present(webViewController, animated: true, completion: nil)
    }
    
    
    
}
