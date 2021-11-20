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
	func leaderboard(completion: @escaping (Result<[LeaderboardResponse], Error>) -> Void)
    func team(completion: @escaping (Result<TeamResponse, Error>) -> Void)
}

final class NetworkService: NetworkServiceProtocol {
	private let host = "http://home.kuzznya.space/api/v1"
    private let tokenManager: TokenManagerProtocol
	
	enum AppUrl: String {
		case auth, stages, team, leaderboard
		
		func absoluteUrl(host: String) -> String {
			switch self {
            case .auth:
                return host + "/authentication"
            case .stages:
                return host + "/courses/current/stages"
			case .leaderboard:
				return host + "/teams/leaderboard"
            case .team:
                return host + "/teams/current"
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

        guard let token = tokenManager.get() else {
            completion(.failure(AppError.pnhError))
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])

        let request = AF.request(url, headers: headers)
        request.responseDecodable(of: [StagesResponse].self) { res in
            guard let value = res.value else {
                print("🟥 Some network error")
                completion(.failure(AppError.pnhError))
                return
            }

            completion(.success(value))
        }
    }
	
	func leaderboard(completion: @escaping (Result<[LeaderboardResponse], Error>) -> Void) {
		let url = AppUrl.leaderboard.absoluteUrl(host: host)
		
		let header = HTTPHeader(name: "Authorization", value: "Bearer \(tokenManager.get()!)")
		let headers = HTTPHeaders([header])
		
		AF.request(url, headers: headers).responseDecodable(of: [LeaderboardResponse].self) { res in
			guard let value = res.value else { return }

			completion(.success(value))
		}
	}

    func team(completion: @escaping (Result<TeamResponse, Error>) -> Void) {
        let url = AppUrl.team.absoluteUrl(host: host)

        guard let token = tokenManager.get() else {
            completion(.failure(AppError.pnhError))
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])

        let request = AF.request(url, headers: headers)
        request.responseDecodable(of: TeamResponse.self) { res in
            guard let value = res.value else {
                print("🟥 Some network error")
                completion(.failure(AppError.pnhError))
                return
            }

            completion(.success(value))
        }
    }

    func tasks(completion: @escaping (Result<TasksRespnse, Error>) -> Void) {

    }
}

struct TasksRespnse {
//    {
//    "id": 0,
//    "stageId": 0,
//    "name": "string",
//    "description": "string",
//    "index": 0,
//    "blocks": [
//    {
//    "id": 0,
//    "content": "string",
//    "type": "TEXT",
//    "index": 0
//    }
//    ]
//    }

    let id: Int
    let stageId: Int
    let name: String
}

struct TeamResponse: Decodable {
    let id: Int
    let name: String
    let groupId: Int
    let points: Int
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

enum AppError: Error {
    case pnhError
}

struct LeaderboardResponse: Decodable {
	let id: Int
	let name: String
	let groupId: Int
	let points: Int
}
