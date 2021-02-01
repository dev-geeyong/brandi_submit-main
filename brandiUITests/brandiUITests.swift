//
//  brandiUITests.swift
//  brandiUITests
//
//  Created by dev.geeyong on 2021/01/31.
//

import XCTest

class brandiUITests: XCTestCase {
    let app = XCUIApplication()
    
    override func setUp() {
        continueAfterFailure = false
        app.launch() // 앱 실행
    }
    //검색어 입력/결과 테스트
    func test_SearchUserResultAvailable() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("테스트\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCellOfFirst = app.cells.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
    }
    //검색어 결과 스크롤시 데이터 추가 테스트
    func test_CanSearchResultPagination() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("Hello\n") // 2. 검색어 입력 후 키보드 내림
        
        let resultCells = app.cells
        XCTAssertTrue(resultCells.firstMatch.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
        let firstResultsCount = resultCells.count // 첫 번째 페이지 셀의 개수를 저장
        
        let collectionView = app.collectionViews.firstMatch
        XCTAssertTrue(collectionView.exists)
        
        collectionView.swipeUp()// 4. collectionView 상단으로 스크롤 30개를 추가로 보여주는지
        collectionView.swipeUp()
        collectionView.swipeUp()
        XCTAssertNotEqual(firstResultsCount, resultCells.count) // 5. 셀의 개수를 비교하여, 다음 페이지의 데이터가 추가되었는지 확인
    }
    //검색어 결과 아이템 터치시 상세페이지 이동 테스트
    func test_SearchAndEnterDetailView() {
        let searchField = app.searchFields.firstMatch
        XCTAssertTrue(searchField.exists) // 검색창의 TextField가 있는지 확인
        
        searchField.tap() // 1. SearchBar의 TextField를 탭
        searchField.typeText("아이폰 배경화면\n") // 2. 검색어 입력 후 키보드 내림
  
        let resultCellOfFirst = app.cells.element.firstMatch
        XCTAssertTrue(resultCellOfFirst.waitForExistence(timeout: 15.0)) // 3. 검색 결과가 있는지 확인 (최대 15초 동안 대기)
        
        XCTAssertTrue(resultCellOfFirst.isHittable) // 4. 첫 번째 셀 터치가 가능한지 확인
        resultCellOfFirst.tap() // 5. 첫 번째 셀을 터치
        
        let safariViewController = app.otherElements.images.firstMatch
        XCTAssertTrue(safariViewController.waitForExistence(timeout: 15.0)) // 6. 상세 화면으로 이동하는지 확인
    }
    
}
