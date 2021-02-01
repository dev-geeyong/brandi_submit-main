//
//  ViewController.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher
import Toast_Swift
class ViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var logoImageView: UIImageView!
    
    var photos: ([Photo]) = []
    var photosData: ([Photo]) = []
    var pageNumber: Int = 0
    var searchBarText: String = ""
    var limit: Int = 30
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let backBarButtonItem = UIBarButtonItem(title: " ", style: .plain, target: nil, action: nil)
        navigationItem.backBarButtonItem = backBarButtonItem
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
        searchBar.delegate = self
        
        let myCustomCollectionViewCell = UINib(nibName: String(describing: CustomCollectionViewCell.self), bundle: nil)
        self.collectionView.register(myCustomCollectionViewCell, forCellWithReuseIdentifier: "CustomCollectionViewCell")
        
        self.collectionView.collectionViewLayout = createCompositionalLayoutForFirst()
        
    }//viewDidLoad
    
}//ViewController

//MARK: - UICollectionViewLayout 설정
extension ViewController{
    fileprivate func createCompositionalLayoutForFirst() -> UICollectionViewLayout {
        print("createCompositionalLayoutForFirst() called")
        
        let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            //            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5) 아이템별 간격 설정
            let groupHeight =  NSCollectionLayoutDimension.fractionalWidth(1/3)
            let grouSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: groupHeight)
            //            let group = NSCollectionLayoutGroup.horizontal(layoutSize: grouSize, subitems: [item, item, item])
            // 3 * N
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: grouSize, subitem: item, count: 3)
            // 그룹으로 섹션 만들기
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        return layout
    }
    
}
//MARK: - UICollectionViewDelegate , UICollectionViewDataSource
extension ViewController: UICollectionViewDelegate{
    
    //상세이미지 화면 이동 및 데이터 전달
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "resultToItems", sender: indexPath)
        
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "resultToItems"{
            let selectedIndexPath = sender as? NSIndexPath
            let imageVC = segue.destination as! ImageViewController
            imageVC.textData = photos[selectedIndexPath!.item].datetime + ", " + photos[selectedIndexPath!.item].displaySiteName
            
            guard let url = URL(string: photos[selectedIndexPath!.item].imageURL) else { return }
            guard let data = try? Data(contentsOf: url) else { return }
            
            let image = UIImage(data: data)
            imageVC.imageView = UIImageView(image: image)
        }
        
    }
}
extension ViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CustomCollectionViewCell", for: indexPath) as! CustomCollectionViewCell
        
        if let url = URL(string: photos[indexPath.item].thumbnailURL){
            cell.ImageView.kf.setImage(with: url) //Kingfisher
            return cell
        }else{
            cell.ImageView.image = UIImage(systemName: "questionmark.diamond")
            return cell
            
        }
    }
    
    
}
//MARK: - AlamofireManager - getDataResult

extension ViewController{
    func  getDataResult (searcTerm: String, pageNumber: Int) {
        logoImageView.isHidden = true
        
        AlamofireManager.shared.getPhotos(searcTerm: searcTerm, pageNumber: "\(pageNumber)" ,completion:  {
            [weak self]
            result in
            
            guard let self = self else {return}
            
            switch result{
            case .success(let fetchdPhotos):
                print("success AlamofireManager", fetchdPhotos.count)
                self.photosData = fetchdPhotos //데이터 저장
                
                if fetchdPhotos.count > 30 { //최초 30개 데이터 fetch
                    print("30 data append")
                    for i in self.limit-30..<self.limit{
                        self.photos.append(self.photosData[i])
                    }
                }else{ // 검색 결과의 이미지 갯수가 30개 이하인 경우 처리
                    for i in 0..<fetchdPhotos.count{
                        self.photos.append(self.photosData[i])
                    }
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    if self.limit == 30{ //새로운 이미지 검색시 스크롤을 맨 위로
                        let indexPath = IndexPath(item: 0, section: 0)
                        self.collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    }
                    
                }
                
            case .failure(let failError):
                print("home get error \(failError.rawValue)")
                self.view.makeToast(failError.rawValue, duration: 3.0, position: .center) //Toast_Swift
                self.collectionView.reloadData ()
                self.logoImageView.isHidden = false
            }
            
        })
        
    }
}

//MARK: - UISearchBarDelegate - searchBarSearchButtonClicked - searchBar(textDidChange)

extension ViewController: UISearchBarDelegate{
    //검색버튼 클릭처리
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text{
            if searchBarText != searchText{
                //검색시 데이터 초기화
                self.photos.removeAll()
                self.photosData.removeAll()
                self.pageNumber = 1
                self.limit = 30
                
                self.searchBarText = searchText
                self.getDataResult(searcTerm: searchText, pageNumber: pageNumber)
                self.view.endEditing(true)
            }
 
            self.view.endEditing(true)
        }
    }
    //문자를 입력 후 1초가 지나면 자동으로 검색처리
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(self.reload(_:)), object: searchBar)
        perform(#selector(self.reload(_:)), with: searchBar, afterDelay: 1)
    }
    
    @objc func reload(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, searchText.trimmingCharacters(in: .whitespaces) != "" else {
            print("nothing to search")
            return
        }
        
        if searchBarText != searchText {
            //검색시 데이터 초기화
            self.photos.removeAll()
            self.photosData.removeAll()
            self.pageNumber = 1
            self.limit = 30
            
            self.searchBarText = searchText
            self.getDataResult (searcTerm: searchText, pageNumber: pageNumber)
            self.view.endEditing(true)
            
        }
        
    }
}

//MARK: - UICollectionViewDelegateFlowLayout - scrollViewDidEndDragging
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    //(최초 30개 데이터 fetch 후 스크롤 시 30개씩 추가 fetch)
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let offsetY = scrollView.contentOffset.y
        let height = scrollView.contentSize.height
        
        if offsetY > height - scrollView.frame.size.height && self.photosData.count >= 30{
            
            self.pageNumber = pageNumber + 1
            self.limit = limit + 30
            getDataResult(searcTerm: searchBarText, pageNumber: self.pageNumber)
        }
    }
    
    
}
