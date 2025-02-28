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
        위 이벤트에 대한 자연스러운 참여 댓글을 작성해주세요.
        당신의 답변을 복붙해서 바로 댓글에 달아도 문제가 되지 않도록 반드시 댓글만 작성하고, 추가적인 설명이나 안내 문구는 포함하지 마세요.
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
