//
//  NetworkManager.swift
//  FetchRewardsCodingChallenge
//
//  Created by River McCaine on 10/18/21.
//

import UIKit

class NetworkManager {
    
    static let shared                   = NetworkManager()
    let cache                           = NSCache<NSString, UIImage>()
    
    private let baseURL                 = Networking.mealDBURL
    private let versionComponent        = Networking.version
    private let apiKey                  = Networking.key
    private let categoryComponent       = Networking.category
    private let filterComponent         = Networking.filter
    private let lookupComponent         = Networking.lookup
    private let mealIDComponent         = Networking.mealID
    private let categorySearchComponent = Networking.search
    
    
    func getAllMealCategories(completion: @escaping (Result<[Category], FRError>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }
        
        let versionURL  = baseURL.appendingPathComponent(versionComponent)
        let keyURL      = versionURL.appendingPathComponent(apiKey)
        let categoryURL = keyURL.appendingPathComponent(categoryComponent)
        
        let components  = URLComponents(url: categoryURL, resolvingAgainstBaseURL: true)
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("Categories URL Endpoint: \(finalURL)")
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToDecode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let topLevelObject = try decoder.decode(CategorySearchResults.self, from: data)
                
                completion(.success(topLevelObject.categories))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }
    
    
    func getAllMeals(meal: String, completion: @escaping (Result<[Meal], FRError>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }
        
        let versionURL  = baseURL.appendingPathComponent(versionComponent)
        let keyURL      = versionURL.appendingPathComponent(apiKey)
        let filterURL   = keyURL.appendingPathComponent(filterComponent)
        
        let mealIDQuery = URLQueryItem(name: categorySearchComponent, value: meal)
        var components  = URLComponents(url: filterURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [mealIDQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("Meals URL Endpoint: \(finalURL)")
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, response, error in
            
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(.failure(.unableToDecode))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                // mealSearchResults
                let topLevelObject = try decoder.decode(MealSearchResults.self, from: data)
                
                
                completion(.success(topLevelObject.meals))
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }
    
    
    func getAllMealDetails(for id: String, completion: @escaping (Result<MealDetail, FRError>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }
        
        let versionURL  = baseURL.appendingPathComponent(versionComponent)
        let keyURL      = versionURL.appendingPathComponent(apiKey)
        let lookUpURL   = keyURL.appendingPathComponent(lookupComponent)
        
        let mealIDQuery = URLQueryItem(name: mealIDComponent, value: id)
        var components  = URLComponents(url: lookUpURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [mealIDQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print("MealDetail URL Endpoint: \(finalURL)")
        
        let task = URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.noData))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {

                if let json = try JSONSerialization.jsonObject(with: data) as? [String: [Any]] {
        
                    guard let jsonMeal = json["meals"]?[0] as? [String : Any],
                          let meal = MealDetail.decode(from: jsonMeal) else {
                              return completion(.failure(.noData))
                          }
                    return completion(.success(meal))
                } else {
                    return completion(.failure(.noData))
                }
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }
        task.resume()
    }
    
    
    func downloadImage(from urlString: String, completion: @escaping (UIImage?) -> Void) {
        let cacheKey = NSString(string: urlString)
        
        if let image = cache.object(forKey: cacheKey) {
            completion(image)
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self,
                  error == nil,
                  let response = response as? HTTPURLResponse, response.statusCode == 200,
                  let data = data,
                  let image = UIImage(data: data) else {
                      completion(nil)
                      return
                  }
            
            self.cache.setObject(image, forKey: cacheKey)
            completion(image)
        }
        task.resume()
    }
} // END OF CLASS
