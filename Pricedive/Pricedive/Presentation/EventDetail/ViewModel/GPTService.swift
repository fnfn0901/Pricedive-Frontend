//
//  GPTService.swift
//  Pricedive
//
//  Created by 신호연 on 2/28/25.
//

import Foundation

class GPTService {
    private let apiKey = "REMOVED"
    private let apiURL = "https://api.openai.com/v1/chat/completions"

    func generateComment(from eventDescription: String, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = """
        이벤트 내용: \(eventDescription)

        위 내용은 유튜브 설명란에서 가져온 이벤트 정보입니다. 
        그러나, 설명란을 그대로 사용하거나 요약하지 마세요.

        ❌ 설명을 다시 작성하거나 요약하지 마세요.
        ❌ 이벤트 참여 방법, 채널 구독, 팔로우 등의 내용은 포함하지 마세요.
        ❌ "이벤트에 참여하세요!" 같은 문구는 사용하지 마세요.
        ❌ 따옴표("")나 특수문자는 포함하지 마세요.

        ✅ 이벤트와 관련된 자연스러운 댓글을 작성하세요.
        ✅ 참여자의 시점에서 작성하세요. (예: "이거 너무 기대돼요!" 같은 느낌)
        ✅ 추가 설명 없이 최종 댓글 형태로 제공하세요.
        """

        let parameters: [String: Any] = [
            "model": "gpt-3.5-turbo",
            "messages": [
                ["role": "system", "content": "You are a helpful assistant."],
                ["role": "user", "content": prompt]
            ],
            "max_tokens": 300,
            "stop": ["\n\n"]
        ]

        guard let url = URL(string: apiURL) else {
            completion(.failure(NSError(domain: "GPTService", code: -1, userInfo: [NSLocalizedDescriptionKey: "잘못된 API URL"])))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            completion(.failure(error))
            return
        }

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(NSError(domain: "GPTService", code: -2, userInfo: [NSLocalizedDescriptionKey: "데이터 없음"])))
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                   let choices = json["choices"] as? [[String: Any]],
                   let message = choices.first?["message"] as? [String: Any],
                   let content = message["content"] as? String {
                    completion(.success(content.trimmingCharacters(in: .whitespacesAndNewlines)))
                } else {
                    completion(.failure(NSError(domain: "GPTService", code: -3, userInfo: [NSLocalizedDescriptionKey: "응답 파싱 실패"])))
                }
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
