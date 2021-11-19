//
//  NetworkService.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//
import Alamofire

protocol NetworkServiceProtocol {
	func auth(authModel: AuthModel, complition: @escaping (Result<String, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
	private let host = "http://home.kuzznya.space"
	
	enum AppUrl: String {
		case auth
		
		func absoluteUrl(host: String) -> String {
			switch self {
			case .auth:
				return host + "/authentication"
			}
		}
	}
	
	func auth(authModel: AuthModel, complition: @escaping (Result<String, Error>) -> Void) {
		let url = AppUrl.auth.absoluteUrl(host: self.host)
		AF.request(url, method: .post,
				   parameters: authModel,
				   encoder: JSONParameterEncoder.default).responseDecodable(of: AuthResponse.self) { response in
			switch response.result {
			case .success:
				let statusCode = response.response?.statusCode
				if statusCode == 200 {
					guard let authResponse = response.value else { return }
					complition(.success(authResponse.token))
					return
				}
				// Нужны норамльные ошибки
				print("Invalid login")
				complition(.failure(AFError.explicitlyCancelled))
			case .failure(let error):
				complition(.failure(error))
			}
		}
	}

}

struct AuthResponse: Decodable {
	var token: String
	var role: String
}
