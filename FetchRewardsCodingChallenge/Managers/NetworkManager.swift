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
    
    private let baseURL                 = "https://www.themealdb.com/api/json/"
    private let versionComponent        = "v1"
    private let apiKey                  = "1"
    private let categoryComponent       = "categories.php"
    private let filterComponent         = "filter.php"
    private let lookupComponent         = "lookup.php"
    private let mealIDComponent         = "i"
    private let categorySearchComponent = "c"
    
    
    func getAllMealCategories(categoryID: String, completion: @escaping (Result<[Category], FRError>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }
        
        let versionURL  = baseURL.appendingPathComponent(versionComponent)
        let keyURL      = versionURL.appendingPathComponent(apiKey)
        let categoryURL = keyURL.appendingPathComponent(categoryComponent)
        
        let components  = URLComponents(url: categoryURL, resolvingAgainstBaseURL: true)
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
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
                
                var categoryArray: [Category] = []
                for category in topLevelObject.categories {
                    categoryArray.append(category)
                }
                completion(.success(categoryArray))
            } catch {
                print("Error: \(error)")
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
        print(finalURL)
        
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
                let topLevelObject = try decoder.decode(MealSearchResults.self, from: data)
                
                var mealArray: [Meal] = []
                for meal in topLevelObject.meals {
                    mealArray.append(meal)
                }
                completion(.success(mealArray))
            } catch {
                print("Error: \(error)")
                return completion(.failure(.thrownError(error)))
            }
        }
        
        task.resume()
    }
    
    
    func testIngredients(for id: String, completion: @escaping (Result<MealDetail, FRError>) -> Void) {
        guard let baseURL = URL(string: baseURL) else { return completion(.failure(.invalidURL)) }
        
        let versionURL  = baseURL.appendingPathComponent(versionComponent)
        let keyURL      = versionURL.appendingPathComponent(apiKey)
        let lookUpURL   = keyURL.appendingPathComponent(lookupComponent)
        
        let mealIDQuery = URLQueryItem(name: mealIDComponent, value: id)
        var components  = URLComponents(url: lookUpURL, resolvingAgainstBaseURL: true)
        components?.queryItems = [mealIDQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
             
             URLSession.shared.dataTask(with: finalURL) { data, _, error in
                 if let error = error {
                     print(error, error.localizedDescription)
                     return completion(.failure(.noData))
                 }
                 
                 guard let data = data else { return completion(.failure(.noData)) }
                 
                 do {
                     if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: [Any]] {
                         print(json)
                         guard let jsonMeal = json["meals"]?[0] as? [String : Any],
                               let meal = MealDetail.decode(from: jsonMeal) else {
                                   return completion(.failure(.noData))}
                         print("HEY THE MEALS ARE HERE BUDDY: **\(meal)**")
                         return completion(.success(meal))
                     } else {
                         return completion(.failure(.noData))
                     }
                 } catch {
                     print(error, error.localizedDescription)
                     return completion(.failure(.thrownError(error)))
                 }
             }.resume()
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
