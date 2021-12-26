//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Emre on 24.12.2021.
//

import Foundation
import Alamofire
import EAAlert

private let baseURL: String = "https://newsapi.org/v2/"

private let sourcesPath = "sources/"
private let topHeadlinesPath = "top-headlines"

public class NetworkManager {

    // MARK: - Shared Manager

    static var shared = NetworkManager()

    var eaAlert: EAAlert?

    private func request<T: Decodable>(of type: T.Type, forPath path: String, method: HTTPMethod = .post, parameters: Parameters? = nil, encoding: ParameterEncoding = URLEncoding.default, headers: HTTPHeaders? = nil, showLoadingView: Bool = false, completion: @escaping (Decodable?) -> Void) {
        var viewLoading: UIView!
        if showLoadingView {
            viewLoading = loadingView()
            if let window = UIApplication.shared.keyWindow {
                window.addSubview(viewLoading)
            }

            eaAlert = EAAlert(message: "Please check your internet connection!")
        }

        var inlineHeaders: HTTPHeaders = [:]
        inlineHeaders["Accept"] = "*/*"
        inlineHeaders["Content-Type"] = "application/x-www-form-urlencoded"

        if let headers = headers {
            for key in headers.dictionary.keys {
                inlineHeaders[key] = headers[key]
            }
        }

        var inlineParameters: Parameters = [:]
        inlineParameters["apiKey"] = "7162e5c4fe814a5eaa39a646923db245"

        if let parameters = parameters {
            for key in parameters.keys {
                inlineParameters[key] = parameters[key] as? String
            }
        }

//        print("\n---------- URL: ----------\n \(baseURL+path)\n--------------------------\n")
//        print("\n------- HEADERS: -------\n \(inlineHeaders)\n--------------------------\n")
//        print("\n----- PARAMETERS: -----\n \(inlineParameters)\n--------------------------\n")

        if let networkReachabilityManager = NetworkReachabilityManager(), networkReachabilityManager.isReachable {
            AF.request(baseURL+path, method: method, parameters: inlineParameters, encoding: encoding, headers: inlineHeaders)
                .validate(statusCode: 200..<500).responseDecodable(of: type) { (response) in
                DispatchQueue.main.async {
                    if let viewLoading = viewLoading {
                        viewLoading.isHidden = true
                    }
                }
                switch response.result {
                case .success(_):
                    guard let responseValue = response.value else { return }
                    completion(responseValue)
//                    print("\n------- RESPONSE: ------\n \(responseValue)\n--------------------------\n")
                case .failure(_):
                    completion(nil)
//                    print("\n-------- ERROR: --------\n \(String(describing: response.error))\n-------------------------\n")
                }
            }
        } else if let eaAlert = eaAlert {
            if let viewLoading = viewLoading {
                viewLoading.isHidden = true
            }
            eaAlert.show()
        }
    }

    func sources(completion: @escaping (Result<SourcesResponse, NetworkError>) -> Void) {
        let parameters = ["language": "en"]
        request(of: SourcesResponse.self, forPath: sourcesPath, method: .get, parameters: parameters, showLoadingView: true) { response in
            if let response = response as? SourcesResponse {
                completion(.success(response))
            } else {
                completion(.failure(NetworkError.objectParseError))
            }
        }
    }

    func topHeadlines(with parameters: Parameters, completion: @escaping (Result<TopHeadlinesResponse, NetworkError>) -> Void) {
        request(of: TopHeadlinesResponse.self, forPath: topHeadlinesPath, method: .get, parameters: parameters, showLoadingView: true) { response in
            if let response = response as? TopHeadlinesResponse {
                completion(.success(response))
            } else {
                completion(.failure(NetworkError.objectParseError))
            }
        }
    }

    func loadingView() -> UIView {
        if let window = UIApplication.shared.keyWindow {
            let superview = UIView(frame: window.bounds)
            superview.backgroundColor = UIColor(white: 1, alpha: 0.5)

            let viewLoading = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
            viewLoading.center = CGPoint(x: window.bounds.width/2, y: window.bounds.height/2)
            viewLoading.backgroundColor = appColor
            let aivLoading = UIActivityIndicatorView(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
            if #available(iOS 13.0, *) {
                aivLoading.style = .large
            }
            aivLoading.startAnimating()
            viewLoading.addSubview(aivLoading)
            viewLoading.layer.cornerRadius = 5
            viewLoading.layer.shadowColor = UIColor.black.cgColor
            viewLoading.layer.shadowOpacity = 0.66
            viewLoading.layer.shadowOffset = CGSize.zero
            viewLoading.layer.shadowRadius = 5
            viewLoading.layer.shadowPath = UIBezierPath(rect: viewLoading.bounds).cgPath
            viewLoading.layer.shouldRasterize = true

            superview.addSubview(viewLoading)

            return superview
        }
        return UIView()
    }

}
