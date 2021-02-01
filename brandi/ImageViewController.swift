//
//  ImageViewController.swift
//  brandi
//
//  Created by dev.geeyong on 2021/01/29.
//

import UIKit
import Kingfisher
import ChameleonFramework

class ImageViewController: UIViewController {

    
    var imageView: UIImageView!
    var scrollView: UIScrollView!
    var textLabel: UILabel!
    var textData: String?
    var imageUrl: String?

    
    override func viewDidLoad() {
 
        super.viewDidLoad()
        if imageView == nil{ //입력받은 주소의 값의 원본 이미지가 깨진 경우처리
            let image: UIImage = UIImage(systemName: "questionmark.diamond")!
            imageView = UIImageView(image: image)

        }
        setupScrollView()
        setZoomScale(for: scrollView.bounds.size)
        scrollView.zoomScale = scrollView.minimumZoomScale //사진이 처음에 보일 때 줌을 초기화(최소)
        recenterImage()
       
    }
    func setupScrollView(){
        
        //scrollView
        scrollView = UIScrollView(frame: view.bounds)
        scrollView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        scrollView.backgroundColor = .white
        scrollView.contentSize = imageView.bounds.size
        scrollView.delegate = self
        scrollView.addSubview(imageView)
        
        view.addSubview(scrollView)
        
        //textLabel
        textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: imageView.frame.maxX, height: 20))
        if let data = textData{
            textLabel.text = data
        }
        textLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        textLabel.adjustsFontSizeToFitWidth = true
        textLabel.minimumScaleFactor = 0.1
        textLabel.numberOfLines = 0
        
        let colur = AverageColorFromImage(imageView.image!) //ChameleonFramework 이미지에 따른 텍스트 컬러 값 자동설정
        self.textLabel.textColor = ContrastColorOf(colur, returnFlat: true)
        imageView.addSubview(textLabel)
        
    }
    func recenterImage(){//이미지 가운데로 조정
        
        let scrollViewsize = scrollView.bounds.size
        let imageViewSize = imageView.frame.size
        let horizontalSpace = imageViewSize.width < scrollViewsize.width ? (scrollViewsize.width - imageViewSize.width) / 2.0 : 0
     
        let verticalSpace = imageViewSize.height < scrollViewsize.height ? (scrollViewsize.height - imageViewSize.height) / 2.0 : 0
        let extra: CGFloat
        if navigationController != nil{
            extra = navigationController!.navigationBar.bounds.size.height
        }else{
            extra = 0
        }
        scrollView.contentInset = UIEdgeInsets(top: verticalSpace-extra, left: horizontalSpace, bottom: verticalSpace, right: horizontalSpace)
        
        if (verticalSpace < 1.0 ){ // 이미지가 세로로 길 경우 스크롤 활성화
            scrollView.isScrollEnabled = true
        }else{
            scrollView.isScrollEnabled = false
        }
        
    }
    func setZoomScale(for scrollViewSize: CGSize){ //이미지의 기본 줌 크기설정
        let imageSize = imageView.bounds.size
        let widthScale = scrollViewSize.width / imageSize.width
        let heightScale = scrollViewSize.height / imageSize.height
        let minimumScale = min(widthScale, heightScale)
        
        scrollView.minimumZoomScale = minimumScale
        scrollView.maximumZoomScale = 3.0
        
    }

}
//MARK: -UIScrollViewDelegate imageview 줌 
extension ImageViewController: UIScrollViewDelegate{
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        recenterImage()
    }
}
