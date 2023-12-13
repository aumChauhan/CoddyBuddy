//  ValidationService.swift
//  Created by Aum Chauhan on 21/07/23.

import Foundation

class ValidationService {
    /// - Genreates Random User Name From Email Id.
    static func generateUerName(from email: String) -> String? {
        guard let atIndex = email.firstIndex(of: "@") else {
            return nil
        }
        
        let username = String(email.prefix(upTo: atIndex))
        let randomNumber = String(format: "%04d", Int.random(in: 0...9999))
        
        return username + randomNumber
    }
    
    /// - Validates Names (For Authentication Process).
    static func validateName(_ fullName: String) -> Bool {
        let fullNameCharacterSet = CharacterSet(charactersIn: fullName)
        let allowedCharacterSet = CharacterSet.letters.union(.whitespaces)
        
        // Check if the full name contains only allowed characters (letters and whitespaces)
        guard allowedCharacterSet.isSuperset(of: fullNameCharacterSet) else {
            return false
        }
        
        // Check if the full name contains text and not just blank spaces
        let trimmedFullName = fullName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedFullName.isEmpty else {
            return false
        }
        
        // Checks name character count is less than 16
        guard fullName.count < 16 else {
            return false
        }
        
        return true
    }
    
    /// - Validates UserName (For Authentication Process).
    static func isValidUsername(_ username: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789._")
        let usernameCharacterSet = CharacterSet(charactersIn: username)
        
        // Check if the username contains only allowed characters
        guard allowedCharacterSet.isSuperset(of: usernameCharacterSet) else {
            return false
        }
        
        // Check if the username contains text and not just blank spaces
        let trimmedUsername = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUsername.isEmpty else {
            return false
        }
        
        // Check if the username contains only lowercase characters
        guard trimmedUsername == username.lowercased() else {
            return false
        }
        
        // Checks username character count is less than 10
        guard username.count < 14 else {
            return false
        }
        
        return true
    }
    
    /// - Validates TextFields (i.e, TextField Is Not Empty).
    static func validateTextFields(_ text: String) -> Bool {
        let trimmedFullName = text.trimmingCharacters(in: .whitespacesAndNewlines)
        return !trimmedFullName.isEmpty
    }
    
    /// - Validates URL Format (For Creating New Posts And Message).
    static func isValidURL(_ urlString: String) -> Bool {
        if let url = URL(string: urlString) {
            // Check if the URL is a valid HTTP or HTTPS URL
            return url.scheme == "http" || url.scheme == "https"
        } else if urlString.isEmpty {
            return true
        }
        return false
    }
    
    /// - Validates Tags For Creating Posts (Checks It's Unique & Proper Formmated Text).
    static func hasUniqueTag(_ strings: [String]) -> Bool {
        var nonBlankSet = Set<String>()
        
        for string in strings {
            // Check if the string is not empty and contains only letters and numbers
            let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
            let stringCharacterSet = CharacterSet(charactersIn: string)
            
            guard stringCharacterSet.isSubset(of: allowedCharacterSet) else {
                return false
            }
            
            // Check if the non-blank string is already present in the set
            if !string.isEmpty {
                if nonBlankSet.contains(string) {
                    return false
                } else {
                    nonBlankSet.insert(string)
                }
            }
        }
        return true
    }
    
    static func isValidName(_ chatRoomName: String) -> Bool {
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
        let usernameCharacterSet = CharacterSet(charactersIn: chatRoomName)
        
        // Check if the username contains only allowed characters
        guard allowedCharacterSet.isSuperset(of: usernameCharacterSet) else {
            return false
        }
        
        // Check if the username contains text and not just blank spaces
        let trimmedUsername = chatRoomName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedUsername.isEmpty else {
            return false
        }
        
        return true
    }
    /// - Checks Search Text Contains Char.
    static func isValidSearchText(_ text: String) -> Bool {
        return !text.isEmpty && text.trimmingCharacters(in: .whitespacesAndNewlines).count > 0
    }
    
    /// - Converts String To Array
    /// - Example:
    /// ```
    /// let str = "Hello World"
    /// let arr = stringToArray(str)
    ///
    /// print(arr) // -> ["Hello", "World"]
    /// ```
    static func stringToArray(_ input: String) -> [String] {
        let words = input.split(separator: " ")
        return words.map { String($0) }
    }
}
