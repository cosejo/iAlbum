//
//  XCTestCaseExtension.swift
//  iAlbumTests
//
//  Created by Carlos Osejo on 22/8/22.
//

import XCTest

extension XCTestCase {
    enum TestError: Error {
        case fileNotFound
    }
    
    func getData(fromJSON fileName: String) throws -> Data {
        let bundle = Bundle(for: type(of: self))
        guard let url = bundle.url(forResource: fileName, withExtension: "json") else {
            XCTFail("Missing File: \(fileName).json")
            throw TestError.fileNotFound
        }
        
        do {
            return try Data(contentsOf: url)
        } catch {
            throw error
        }
        
    }
}
