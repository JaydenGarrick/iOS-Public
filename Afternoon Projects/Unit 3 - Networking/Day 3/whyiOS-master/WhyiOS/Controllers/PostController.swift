//
//  PostController.swift
//  WhyiOS2
//
//  Created by Jayden Garrick on 5/23/18.
//  Copyright © 2018 Jayden Garrick. All rights reserved.
//

import Foundation

class PostController {
    
    // GET function
    static let baseURL = URL(string: "https://whydidyouchooseios.firebaseio.com/reasons")
    
    static func fetchPosts(completion: @escaping (([Post]?) -> Void)) {
        // URL
        guard var url = baseURL else { completion(nil) ; return }
        url.appendPathExtension("json")
        
        print("📡📡📡\(url.absoluteString)📡📡📡")
        
        // Request
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        // DataTask + Decode + Resume
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            // Check for error
            if let error = error {
                print("Error fetching posts: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else { completion(nil) ; return }
            let jsonDecoder = JSONDecoder()
            do {
                let postsDictionary = try jsonDecoder.decode([String:Post].self, from: data)
                
                /// Old way
                //                var posts: [Post] = []
                //
                //                for (_, value) in postsDictionary {
                //                    posts.append(value)
                //                }
                /// Same thing as 🔝, just fancier.
                let posts = postsDictionary.compactMap { $1 }
                
                completion(posts)
                return
            } catch let error {
                print("Error decoding posts: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            }.resume()
    }
    
    // POST
    static func postReason(name: String, reason: String, cohort: String, completion: @escaping ((Bool)->Void)) {
        // URL
        guard var url = baseURL else { completion(false) ; return }
        url.appendPathExtension("json")
        
        // Encode object to Data + Create object
        let post = Post(name: name, reason: reason, cohort: cohort)
        
        
        do {
            let jsonEncoder = JSONEncoder()
            let postData = try jsonEncoder.encode(post)
            
            
            // Request
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = postData
            
            // Datatask
            URLSession.shared.dataTask(with: request) { (_, _, error) in
                if let error = error {
                    print("Error posting Post: \(error.localizedDescription)")
                    completion(false)
                    return
                }
                completion(true)
                return
                }.resume()
        } catch  {
            print("Error encoding post into data: \(error.localizedDescription)")
            completion(false)
            return
        }
    }
    
    func changeTheWorld(){
        //Amazing code goes in here
    }
    
}
