//
//  UserDefaults.swift
//  Example
//
//  Created by SAUCHYE on 9/12/24.
//

import Foundation


// 封装UserDefaults的扩展
extension UserDefaults {
//    public static func remove(forKey key: String) {
//        UserDefaults.standard.removeObject(forKey: key)
//    }

    // 存储数组
    func setArray<T: Codable>(_ value: [T], forKey key: String) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(value) {
            self.set(encoded, forKey: key)
        }
    }
    
    // 读取数组
    func array<T: Codable>(_ type: T.Type, forKey key: String) -> [T]? {
        if let retrievedData = self.data(forKey: key) {
            let decoder = JSONDecoder()
            if let decodedArray = try? decoder.decode([T].self, from: retrievedData) {
                return decodedArray
            }
        }
        return nil
    }
}
