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
    func tasks(stageId: Int, completion: @escaping (Result<TasksResponse, Error>) -> Void)
    func submit(id: Int, isCheckpoint: Bool, values: [String: String], completion: @escaping () -> Void)
    // Battles
    func getActiveBattle(completion: @escaping (Result<Battle, Error>) -> Void)
    func initiateBattle(opponentId: Int, completion: @escaping () -> ())
    // Collabs
    func getActiveCollab(completion: @escaping (Result<Collab, Error>) -> Void)
    func initiateCollab(helperId: Int, completion: @escaping () -> ())
}

final class NetworkService: NetworkServiceProtocol {
	private let host = "https://junction.kuzznya.com/api/v1"
    private let tokenManager: TokenManagerProtocol
	
	enum AppUrl {
        enum SubmitType {
            case checkpoint(Int), task(Int)
        }

		case auth, stages, team, leaderboard, tasks, submit(SubmitType),
             activeBattle, initiateBattle, activeCollab, initiateCollab
		
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
            case .tasks:
                    return host + "/stages/"
            case .submit(let type):
                switch type {
                case .checkpoint(let id):
                    return host + "/checkpoints/\(id)/submissions"
                case .task(let id):
                    return host + "/tasks/\(id)/submissions"
                }
            case .activeBattle:
                return host + "/battles/current"
            case .initiateBattle:
                return host + "/battles/initiate"
            case .activeCollab:
                return host + "/collabs/current"
            case .initiateCollab:
                return host + "/collabs/initiate"
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

    func tasks(stageId: Int, completion: @escaping (Result<TasksResponse, Error>) -> Void) {
        let url = AppUrl.tasks.absoluteUrl(host: host) + String(stageId)

        guard let token = tokenManager.get() else {
            completion(.failure(AppError.pnhError))
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])

        let request = AF.request(url, headers: headers)
        request.responseDecodable(of: TasksResponse.self) { res in
            guard let value = res.value else {
                print("🟥 Some network error")
                completion(.failure(AppError.pnhError))
                return
            }

            completion(.success(value))
        }
    }

    func submit(id: Int, isCheckpoint: Bool, values: [String: String], completion: @escaping () -> Void) {
        let url = AppUrl.submit(isCheckpoint ? .checkpoint(id) : .task(id)).absoluteUrl(host: host)

        guard let token = tokenManager.get() else {
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])

        AF.request(url, method: .post, parameters: values, encoding: JSONEncoding.default, headers: headers).response { res in
            completion()
        }
    }
    
    func getActiveBattle(completion: @escaping (Result<Battle, Error>) -> Void) {
        let url = AppUrl.activeBattle.absoluteUrl(host: host)

        guard let token = tokenManager.get() else {
            completion(.failure(AppError.pnhError))
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])

        let request = AF.request(url, headers: headers)
        request.responseDecodable(of: Battle.self) { res in
            guard let value = res.value else {
                print("🟥 Some network error")
                completion(.failure(AppError.pnhError))
                return
            }

            completion(.success(value))
        }
    }
    
    func getActiveCollab(completion: @escaping (Result<Collab, Error>) -> Void) {
        let url = AppUrl.activeCollab.absoluteUrl(host: host)

        guard let token = tokenManager.get() else {
            completion(.failure(AppError.pnhError))
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])

        let request = AF.request(url, headers: headers)
        request.responseDecodable(of: Collab.self) { res in
            guard let value = res.value else {
                print("🟥 Some network error")
                completion(.failure(AppError.pnhError))
                return
            }

            completion(.success(value))
        }
    }
    
    func initiateBattle(opponentId: Int, completion: @escaping () -> ()) {
        let url = AppUrl.initiateBattle.absoluteUrl(host: host)
            + "?opponentId=\(opponentId)&checkpointId=0"

        guard let token = tokenManager.get() else {
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).response { res in
            completion()
        }
    }
    
    func initiateCollab(helperId: Int, completion: @escaping () -> ()) {
        let url = AppUrl.initiateCollab.absoluteUrl(host: host)
            + "?helperId=\(helperId)"

        guard let token = tokenManager.get() else {
            return
        }

        let header = HTTPHeader(name: "Authorization", value: "Bearer \(token)")
        let headers = HTTPHeaders([header])
        
        AF.request(url, method: .post, encoding: JSONEncoding.default, headers: headers).response { res in
            completion()
        }
    }
}

struct TasksResponse: Decodable {
    struct Block: Decodable {
        let id: Int
        let content: String
        let type: String
        let index: Int
    }

    struct Task: Decodable {
        let id: Int
        let name: String
        let index: Int
        let points: Int?
        let blocks: [Block]
    }

    struct Checkpoint: Decodable {
        let id: Int
        let name: String
        let status: String
        let points: Int?
        let blocks: [Block]
    }

    let tasks: [Task]
    let checkpoint: Checkpoint
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

// Battles / Collabs
struct User: Decodable {
    let id: Int
    let name: String
}

struct Battle: Decodable {
    let id: Int
    let initiator: User
    let defender: User
}

struct Collab: Decodable {
    let id: Int
    let requester: User
    let helper: User
}
