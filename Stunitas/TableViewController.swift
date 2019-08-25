//
//  TableViewController.swift
//  Stunitas
//
//  Created by 이관렬 on 25/08/2019.
//  Copyright © 2019 이관렬. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import SwiftyJSON
import NVActivityIndicatorView

class TableViewController: UITableViewController {

    
    let searchController = UISearchController(searchResultsController: nil)
    let textColor = UIColor(red:0.90, green:0.90, blue:0.90, alpha:1.0)
    let SEARCH_ADDRESS_KEYWORD_KAKAO_URL = "https://dapi.kakao.com/v2/search/image"
    let SEARCH_ADDRESS_KAKAO_APP_KEY = "242f9d5d25de8a8ab0cbd94cc46f9b9e"
    var imgUrlList = [String]()
    var imgSizeList = [CGFloat]()
    override func viewDidLoad() {
        super.viewDidLoad()
        let sc = searchController.searchBar
        sc.placeholder = "검색어 입력"
        sc.tintColor = textColor
        searchController.hidesNavigationBarDuringPresentation = false
        sc.showsCancelButton = false
        searchController.dimsBackgroundDuringPresentation = true
        sc.delegate = self
        sc.searchBarStyle = .minimal
        let hView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 95))
        hView.addSubview(sc)
        self.tableView.tableHeaderView = hView
        //getSearchKeywordImage(keyword: "설현")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imgUrlList.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! TableViewCell
        
        let url = URL(string: imgUrlList[indexPath.row])
        //print("imgUrlList[indexPath.row] \(imgUrlList[indexPath.row])")
        cell.imgView.kf.indicatorType = .activity
        cell.imgView.kf.setImage(with: url)
        //tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print("헤잇 호출")
        return imgSizeList[indexPath.row]
    }
    
    func getSearchKeywordImage(keyword: String) {
        imgSizeList.removeAll()
        imgUrlList.removeAll()
        Alamofire.request(
            self.SEARCH_ADDRESS_KEYWORD_KAKAO_URL,
            method: .get,
            parameters: ["query": keyword],
            encoding: URLEncoding.default,
            headers: ["Content-Type":"text/plain", "Authorization": "KakaoAK " + self.SEARCH_ADDRESS_KAKAO_APP_KEY]
            )
            .responseJSON {
                response in
                if let responseData = response.result.value as? [String: Any] {
                    let json = JSON(responseData)
                    print("\(json)")
                    for (index,object) in json{
                        if index == "documents"{
                            for (_,object2) in object{
                                self.imgUrlList.append(object2["image_url"].stringValue)
                                self.imgSizeList.append(CGFloat(object2["height"].floatValue))
                            }
                        }
                    }
                }
                
                self.tableView.reloadData()
                self.searchController.searchBar.showsCancelButton = false
                self.view.endEditing(true)
        }
    }
    var mTimer : Timer?
}
extension TableViewController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getSearchKeywordImage(keyword: searchBar.text ?? "")
        searchBar.setShowsCancelButton(false, animated: false)
        self.view.endEditing(false)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        print("디드비긴 호출")
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("엔드 호출")
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        /*
        let time = DispatchTime.now() + .seconds(1)
        let keyword = searchBar.text ?? ""
        DispatchQueue.main.asyncAfter(deadline: time) {
            self.runningAfter1Seconds(keyword: keyword)
        }*/
        
        if let timer = mTimer {
            
            if !timer.isValid {
                print("timer.isValid \(timer.isValid)")
                
                mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runningAfter1Seconds), userInfo: nil, repeats: false)
            }
        }else{
            print("nil")
            
            mTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.runningAfter1Seconds), userInfo: nil, repeats: false)
        }
        
        
        
    }
    @objc func runningAfter1Seconds(){
        print("1초뒤 실행 \(searchController.searchBar.text)")
        let keyword = searchController.searchBar.text ?? ""
        getSearchKeywordImage(keyword: keyword)
    }
    
}
