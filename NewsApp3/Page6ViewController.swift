//Page6ViewController
//  Page1ViewController.swift
//  NewsApp2
//
//  Created by 船井洋一郎 on 2019/06/08.
//  Copyright © 2019 yoichiro.funai. All rights reserved.
//

import UIKit
import SegementSlide


class Page6ViewController: UITableViewController,SegementSlideContentScrollViewDelegate,XMLParserDelegate {
    
    
    var parser = XMLParser()
    
    
    var currentElementName:String!
    
    
    var newsItems = [NewsItems]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.backgroundColor = .clear
        
        
        let image = UIImage(named: "water")
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.tableView.frame.size.width, height: self.tableView.frame.size.height))
        imageView.image = image
        self.tableView.backgroundView = imageView
        
        
        
        let urlString:String = "https://headlines.yahoo.co.jp/rss/asahibc-loc.xml"
        let url:URL = URL(string: urlString)!
        
        parser = XMLParser(contentsOf: url)!
        
        parser.delegate = self
        
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
    
    
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        self.currentElementName = nil
        
    }
    
    
    
    func parserDidEndDocument(_ parser: XMLParser) {
        
        
        self.tableView.reloadData()
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let webViewController:UIViewController = WebViewController()
        
        webViewController.modalTransitionStyle = .partialCurl
        
        let newsItem = newsItems[indexPath.row]
        
        UserDefaults.standard.set(newsItem.url, forKey: "url")
        
        self.present(webViewController, animated: true, completion: nil)
    }
    
    
    
}
