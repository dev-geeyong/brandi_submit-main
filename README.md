# 카카오 '이미지 검색' api 사용 이미지 검색 앱

https://developers.kakao.com/

## 프로젝트 기능

UISearchBar에 문자를 입력 후 1초가 지나면 자동으로 검색이 됩니다.
검색어가 변경되면 목록 리셋 후 다시 데이터를 fetch 합니다.
데이터는 30개씩 페이징 처리합니다. (최초 30개 데이터 fetch 후 스크롤 시 30개씩 추가 fetch)
검색 결과 목록은 UICollectionView를 사용하여 3xN 그리드 모양으로 구성합니다.
검색 결과가 없을 경우 '검색 결과가 없습니다.' 메시지를 화면에 보여줍니다.
검색 결과 목록 중 하나를 탭 하였을 때 전체 화면으로 이미지를 보여줍니다. 
좌우 여백이 0이고, 이미지 비율은 유지하도록 보여줍니다, 이미지가 세로로 길 경우 스크롤 됩니다.
response 데이터에 출처 'display_sitename', 문서 작성 시간 'datetime'이 있을 경우 전체화면 이미지 밑에 표시해 줍니다.

![Mar-01-2021 17-31-05](https://user-images.githubusercontent.com/55137069/109471422-1336ea00-7ab4-11eb-87ad-47ec9ddf86bc.gif)


## 프로젝트 설정

### CocoaPods

이 프로젝트를 실행하기 전, [CocoaPods](https://cocoapods.org) 이 설치되어있어야 합니다.
CocoaPods 은 Cocoa 프로젝트의 의존성 관리 도구입니다. 사용 방법은 웹 사이트에서 확인할 수 있습니다.

터미널 실행 후, 프로젝트의 Podfile이 있는 Root 폴더로 이동하여, 아래 명령어를 실행합니다.

```ruby
pod install
```

## 프로젝트 실행

프로젝트는 하얀색 아이콘인 **brandi.xcworkspace** 파일을 열어서 실행합니다.


## use frameworks!

- Alamofire
- SwiftyJSON
- Kingfisher
- IQKeyboardManagerSwift
- Toast-Swift
- ChameleonFramework
##### 앱 아이콘 사진 출처 https://www.brandi.co.kr/
