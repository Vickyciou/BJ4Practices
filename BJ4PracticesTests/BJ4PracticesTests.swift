//
//  BJ4PracticesTests.swift
//  BJ4PracticesTests
//
//  Created by Vicky on 2024/6/18.
//

import XCTest
@testable import BJ4Practices
import SwiftyJSON

final class BJ4PracticesTests: XCTestCase {

    func test_decodeObject_success() {
        // Arrange
        guard let data = readLocalJSONFile(filename: "aaa", bundle: Bundle(for: type(of: self))) else { return XCTFail() }

        // Action
        guard let decodedObject = parseJSON(data: data, type: PushLogPostModel.self) else { return XCTFail() }

        // Assert
        XCTAssertEqual(decodedObject.searchInfo?.filter?["NonStop"], true)
        XCTAssertEqual(decodedObject.searchInfo?.filter?["MaxPrice"], 300)
        XCTAssertEqual(decodedObject.searchInfo?.filter?["d"], "123")
    }
    
    func test_encodeObject_success() {
        // Arrange
        guard let data = readLocalJSONFile(filename: "aaa", bundle: Bundle(for: type(of: self))) else { return XCTFail() }
        guard let decodedObject = parseJSON(data: data, type: PushLogPostModel.self) else { return XCTFail() }

        // Action
        let dictionary = decodedObject.dictionary
        guard let searchInfo = dictionary["SearchInfo"] as? [String: Any] else { return XCTFail() }
        guard let filter = searchInfo["Filter"] as? [String: Any] else { return XCTFail() }

        // Assert
        let nonStop = try? XCTUnwrap(filter["NonStop"]) as? Bool
        XCTAssertEqual(nonStop, true)
        
        let maxPrice = try? XCTUnwrap(filter["MaxPrice"]) as? Int
        XCTAssertEqual(maxPrice, 300)
        
        let d = try? XCTUnwrap(filter["d"]) as? String
        XCTAssertEqual(d, "123")
    }
}

func readLocalJSONFile(filename: String, bundle: Bundle) -> Data? {
    guard let url = bundle.url(forResource: filename, withExtension: "json") else {
        print("Failed to locate \(filename).json in bundle.")
        return nil
    }
    
    do {
        let data = try Data(contentsOf: url)
        return data
    } catch {
        print("Failed to load \(filename).json from bundle: \(error.localizedDescription)")
        return nil
    }
}

func parseJSON<T: Decodable>(data: Data, type: T.Type) -> T? {
    let decoder = JSONDecoder()
    do {
        let decodedObject = try decoder.decode(T.self, from: data)
        return decodedObject
    } catch {
        print("Failed to decode JSON: \(error)")
        return nil
    }
}

import Foundation
import SwiftyJSON

// PushLogPostModel
struct PushLogPostModel: BaseJson4 {
    var deviceID: String // 裝置 ID
    var sessionID: String? // 會話 ID
    var deviceInfo: DeviceInfoModel? // 裝置資訊
    var transactionID: String? // 交易 ID
    var prodInfo: ProdInfoModel? // 產品資訊
    var ptype: String? // 頁面類型
    var searchInfo: SearchInfoModel? // 搜尋資訊
    var orderInfo: OrderInfoModel? // 訂單資訊
    var utmSource: String? // 來源
    var utmMedium: String? // 媒介
    var utmCampaign: String? // 廣告活動
    var utmContent: String? // 內容
    var referer: String? // 來源網址

    enum CodingKeys: String, CodingKey {
        case deviceID = "DeviceID"
        case sessionID = "SessionID"
        case deviceInfo = "DeviceInfo"
        case transactionID = "TransactionID"
        case prodInfo = "ProdInfo"
        case ptype = "Ptype"
        case searchInfo = "SearchInfo"
        case orderInfo = "OrderInfo"
        case utmSource = "UtmSource"
        case utmMedium = "UtmMedium"
        case utmCampaign = "UtmCampaign"
        case utmContent = "UtmContent"
        case referer = "Referer"
    }
}

// DeviceInfoModel
struct DeviceInfoModel: BaseJson4 {
    var userAgent: String? // 使用者 Agent
    var osLanguage: String? // 作業系統語言
    var appLanguage: String? // APP 語言
    var screenResolution: String? // 螢幕解析度

    enum CodingKeys: String, CodingKey {
        case userAgent = "UserAgent"
        case osLanguage = "OS_Language"
        case appLanguage = "APP_Language"
        case screenResolution = "ScreeResolution"
    }
}

// ProdInfoModel
struct ProdInfoModel: BaseJson4 {
    var isForeign: Bool? // True(國外) or False(國內)
    var prodType: String? // 產品類型
    var prodPrice: Float? // 產品價格
    var prodName: String? // 產品名稱
    var prodNo: String? // 產品編號
    var prodDetail: ProdDetailModel? // 產品細節
    var discountPrice: Float? // 產品折扣後價格

    enum CodingKeys: String, CodingKey {
        case isForeign = "IsForeign"
        case prodType = "ProdType"
        case prodPrice = "ProdPrice"
        case prodName = "ProdName"
        case prodNo = "ProdNo"
        case prodDetail = "ProdDetail"
        case discountPrice = "DiscountPrice"
    }
}

// SearchInfoModel
struct SearchInfoModel: BaseJson4 {
    var departure: [String]? // 出發地
    var arrival: [String]? // 目的地
    var startDate: String? // 開始時間
    var endDate: String? // 結束時間
    var days: String? // 旅遊天數，未選傳 null
    var searchKeyword: String? // 搜尋關鍵字，未選傳空字串
    var isEnsureGroup: Bool? // True(有勾成團) or False(未勾成團)
    var isSold: Bool? // True(有勾可報名) or False (未勾可報名)
    var trans: [String]? // 交通方式
    var isDirect: Bool? // True(有勾直飛) or False (未勾直飛)
    var flight: InfoFlightModel? // 航班資訊
    var member: InfoMemberModel? // 乘客資訊
    var checkIn: String? // 入住時間
    var checkOut: String? // 退房時間
    var allotment: Bool? // True(有勾可預定) or False (未勾可預定)
    var noTrans: Bool? // 直飛 True(有勾直飛) or False (未勾直飛)
    var seekLcc: Bool? // 嚴價航空 True(有勾嚴價航空) or False (未勾嚴價航空)
    var directFlight: String? // 單程、來回、多航段
    var filter: [String: JSON]? // 其他進階篩選條件

    enum CodingKeys: String, CodingKey {
        case departure = "Departure"
        case arrival = "Arrival"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case days = "Days"
        case searchKeyword = "SearchKeyword"
        case isEnsureGroup = "IsEnsureGroup"
        case isSold = "IsSold"
        case trans = "Trans"
        case isDirect = "IsDirect"
        case flight = "Flight"
        case member = "Member"
        case checkIn = "CheckIn"
        case checkOut = "CheckOut"
        case allotment = "Allotment"
        case noTrans = "NoTrans"
        case seekLcc = "SeekLcc"
        case directFlight = "DirectFlight"
        case filter = "Filter"
    }
}

// OrderInfoModel
struct OrderInfoModel: BaseJson4 {
    var orderNo: String? // 訂單編號
    var luid: String? // 會員 ID
    var isForeign: Bool? // True(國外) or False(國內)
    var prodPrice: Float? // 產品價格
    var prodName: String? // 產品名稱
    var prodNo: String? // 產品編號
    var prodDetail: ProdDetailModel? // 產品細節
    var departure: [String]? // 出發地
    var arrival: [String]? // 目的地
    var startDate: String? // 開始時間
    var endDate: String? // 結束時間
    var days: Int? // 旅遊天數
    var trans: [String]? // 交通方式
    var isDirect: Bool? // True(直飛) or False (非直飛)
    var flight: InfoFlightModel? // 航班資訊
    var member: InfoMemberModel? // 乘客資訊
    var checkIn: String? // 入住時間
    var checkOut: String? // 退房時間
    var searchKeyword: String? // 搜尋關鍵字，未選傳空字串
    var noTrans: Bool? // 直飛 True(有勾直飛) or False (未勾直飛)
    var seekLcc: Bool? // 嚴價航空 True(有勾嚴價航空) or False (未勾嚴價航空)
    var directFlight: String? // 單程、來回、多航段
    var discountPrice: Float? // 產品折扣後價格
    var etk: EtkModel? // 票券資訊

    enum CodingKeys: String, CodingKey {
        case orderNo = "OrderNo"
        case luid = "LUID"
        case isForeign = "IsForeign"
        case prodPrice = "ProdPrice"
        case prodName = "ProdName"
        case prodNo = "ProdNo"
        case prodDetail = "ProdDetail"
        case departure = "Departure"
        case arrival = "Arrival"
        case startDate = "StartDate"
        case endDate = "EndDate"
        case days = "Days"
        case trans = "Trans"
        case isDirect = "IsDirect"
        case flight = "Flight"
        case member = "Member"
        case checkIn = "CheckIn"
        case checkOut = "CheckOut"
        case searchKeyword = "SearchKeyword"
        case noTrans = "NoTrans"
        case seekLcc = "SeekLcc"
        case directFlight = "DirectFlight"
        case discountPrice = "DiscountPrice"
        case etk = "Etk"
    }
}

// ProdDetailModel
struct ProdDetailModel: BaseJson4 {
    var normGroupID: String? // 標準團名 ID
    var tourID: String? // 行程 ID
    var hotelInfo: [String]? // 飯店名稱
    var roomType: String? // 房型
    var roomPlan: String? // 專案編號
    var roomPrice: Float? // 房價
    var etkPlan: String? // 票券方案
    var etkType: [ProdDetailEtkTypeModel]? // 票種
    var status: Int? // 產品狀態代碼

    enum CodingKeys: String, CodingKey {
        case normGroupID = "NormGroupID"
        case tourID = "TourID"
        case hotelInfo = "HotelInfo"
        case roomType = "RoomType"
        case roomPlan = "RoomPlan"
        case roomPrice = "RoomPrice"
        case etkPlan = "EtkPlan"
        case etkType = "EtkType"
        case status = "Status"
    }
}

// ProdDetailEtkTypeModel
struct ProdDetailEtkTypeModel: BaseJson4 {
    var typeName: String? // 票種名稱
    var typeQty: Int? // 數量

    enum CodingKeys: String, CodingKey {
        case typeName = "TypeName"
        case typeQty = "TypeQty"
    }
}

// InfoFlightModel
struct InfoFlightModel: BaseJson4 {
    var flightClass: String? // 艙等
    var airline: String? // 航空公司代碼

    enum CodingKeys: String, CodingKey {
        case flightClass = "Class"
        case airline = "Airline"
    }
}

// InfoMemberModel
struct InfoMemberModel: BaseJson4 {
    var adultQty: Int? // 成人人數
    var childQty: Int? // 小孩人數
    var rooms: Int? // 房間數量

    enum CodingKeys: String, CodingKey {
        case adultQty = "AdultQty"
        case childQty = "ChildQty"
        case rooms = "Rooms"
    }
}

// EtkModel
struct EtkModel: BaseJson4 {
    var etkPlan: String? // 票券方案
    var etkType: [ProdDetailEtkTypeModel]? // 票種

    enum CodingKeys: String, CodingKey {
        case etkPlan = "EtkPlan"
        case etkType = "EtkType"
    }
}
