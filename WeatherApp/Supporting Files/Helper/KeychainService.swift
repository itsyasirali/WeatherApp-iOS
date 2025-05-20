//
//  KeychainService.swift
//  Revolutic
//
//  Created by Muhammad Asher Azeem on 5/20/25.
//  Copyright © 2025 Revolutic. All rights reserved.
//

import Foundation
import Security

struct KeychainService {
    
    // MARK: - Constants
    
    private static let service = "weatherByRevolutic"
    private static let account = "e7a024d2f68bc6f17884822fee3eb03d"
    
    // MARK: - Save API Key
    @discardableResult
    static func saveAPIKey(_ apiKey: String) -> Bool {
        guard let data = apiKey.data(using: .utf8) else {
            print("Failed to encode API key.")
            return false
        }
        
        deleteAPIKey()
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        if status == errSecSuccess {
            return true
        } else {
            print("Failed to save API key to Keychain. Status code: \(status)")
            return false
        }
    }
    
    // MARK: - Get API Key
    static func getAPIKey() -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        guard status == errSecSuccess else {
            print("No API key found in Keychain. Status code: \(status)")
            return nil
        }
        
        guard let data = dataTypeRef as? Data,
              let apiKey = String(data: data, encoding: .utf8) else {
            print("Failed to decode API key from Keychain.")
            return nil
        }
        
        return apiKey
    }
    
    // MARK: - Delete API Key
    
    @discardableResult
    static func deleteAPIKey() -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        
        if status == errSecSuccess || status == errSecItemNotFound {
            return true
        } else {
            print("Failed to delete API key from Keychain. Status code: \(status)")
            return false
        }
    }
}
