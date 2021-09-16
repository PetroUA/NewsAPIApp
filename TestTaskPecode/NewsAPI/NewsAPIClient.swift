//
//  NewsAPIClient.swift
//  TestTaskPecode
//
//  Created by Petro on 15.09.2021.
//

import Foundation

class NewsAPI {
    struct NewsRequestParameters {
        let searchKeywords: String?
        let country: Country?
        let category: Category?
        let sources: [Source]?
        let sortBy: SortBy?
        let page: Int?
        let pageSize: Int?
    }
    
    let apiKey: String
    let session: URLSession
    lazy var jsonDecoder = JSONDecoder()
    
    init(apiKey: String, session: URLSession = URLSession.shared) {
        self.apiKey = apiKey
        self.session = session
    }
    
    func getEverything(requestParametrers: NewsRequestParameters, completion: @escaping (Result<NewsResponse, Error>) -> Void) {
        
        let parametersToSend: [String : String?] = [
            "apiKey": apiKey,
            "category": requestParametrers.category?.rawValue,
            "country": requestParametrers.country?.rawValue,
            "q": requestParametrers.searchKeywords,
            "sources": requestParametrers.sources?.map({ $0.id }).joined(separator: ","),
            "sortBy": requestParametrers.sortBy?.rawValue,
            "page": requestParametrers.page.map({"\($0)"}),
            "pageSize": requestParametrers.pageSize.map({"\($0)"})
        ]
        
        sendGetRequest(requestBaseURL: "https://newsapi.org/v2/everything", requestParametrers: parametersToSend, completion: completion)
    }
    
    func getTopHeadlines(requestParametrers: NewsRequestParameters, completion: @escaping (Result<NewsResponse, Error>) -> Void) {
        
        let parametersToSend: [String : String?] = [
            "apiKey": apiKey,
            "category": requestParametrers.category?.rawValue,
            "country": requestParametrers.country?.rawValue,
            "q": requestParametrers.searchKeywords,
            "sources": requestParametrers.sources?.map({ $0.id }).joined(separator: ","),
            "sortBy": requestParametrers.sortBy?.rawValue,
            "page": requestParametrers.page.map({"\($0)"}),
            "pageSize": requestParametrers.pageSize.map({"\($0)"})
        ]
        
        sendGetRequest(requestBaseURL: "https://newsapi.org/v2/everything", requestParametrers: parametersToSend, completion: completion)
    }
    
    func getSources(category: Category?, country: Country?, completion: @escaping (Result<SourcesResponse, Error>) -> Void ) {
        let requestParametrers: [String : String?] = [
            "apiKey": apiKey,
            "category": category?.rawValue,
            "country": country?.rawValue
        ]
        
        sendGetRequest(requestBaseURL: "https://newsapi.org/v2/top-headlines/sources", requestParametrers: requestParametrers, completion: completion)
    }
}

private extension NewsAPI {
    func sendGetRequest<ResponseType: Decodable>(requestBaseURL: String,
                                                 requestParametrers: [String : String?],
                                                 completion: @escaping (Result<ResponseType, Error>) -> Void) {
        var urlComponents = URLComponents(string: requestBaseURL)!
        
        urlComponents.queryItems = requestParametrers.compactMapValues({ $0 })
            .map({ (key, value) in
                URLQueryItem(name: key, value: value)
            })
        
        let request = URLRequest(url: urlComponents.url!)
        //        print("!!!Sending request=\(request)")
        
        let task = session.dataTask(with: request) { [self] (data, response, error) in
            //            print("!!!Received response data=\(data == nil ? "nil" : String(data: data!, encoding: .utf8)) response=\(response) error=\(error)")
            guard let data = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            do {
                let response = try self.jsonDecoder.decode(ResponseType.self, from: data)
                completion(.success(response))
            }
            catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
