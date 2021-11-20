//
//  NetworkService.swift
//  junction-2021
//
//  Created by k.lukyanov on 19.11.2021.
//
import Alamofire

protocol NetworkServiceProtocol {
	func auth(authModel: AuthModel, complition: @escaping (Result<String, Error>) -> Void)
    func stages(completion: @escaping (Result<[StagesResponse], Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
	private let host = "http://home.kuzznya.space/api/v1"
    private let tokenManager: TokenManagerProtocol
	
	enum AppUrl: String {
		case auth, stages
		
		func absoluteUrl(host: String) -> String {
			switch self {
            case .auth:
                return host + "/authentication"
            case .stages:
                return host + "/courses/current/stages"
			}
		}
	}

    init(tokenManager: TokenManagerProtocol) {
        self.tokenManager = tokenManager
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

    func stages(completion: @escaping (Result<[StagesResponse], Error>) -> Void) {
        let url = AppUrl.stages.absoluteUrl(host: host)

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(tokenManager.get()!)")
        let headers = HTTPHeaders([header])

        let request = AF.request(url, headers: headers)
        request.responseDecodable(of: [StagesResponse].self) { res in
            guard let value = res.value else { return }

            completion(.success(value))
        }
    }

}

struct StagesResponse: Decodable {
    let id: Int
    let name: String
    let description: String
    let status: String
}

struct AuthResponse: Decodable {
	var token: String
	var role: String
}
