//
//  GPTService.swift
//  Pricedive
//
//  Created by 신호연 on 2/28/25.
//

import Foundation
import UIKit

class GPTService {
    private var apiKey: String {
        return APIKey.openAI
    }
    private let apiURL = "https://api.openai.com/v1/chat/completions"

    var loadingIndicator: UIActivityIndicatorView?

    func startLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator?.startAnimating()
        }
    }

    func stopLoadingIndicator() {
        DispatchQueue.main.async {
            self.loadingIndicator?.stopAnimating()
        }
    }

    func generateComment(from eventDescription: String, tags: [String], channelId: String, completion: @escaping (Result<String, Error>) -> Void) {
        let prompt = """
        이벤트 내용: \(eventDescription)

        📢 채널 이름: \(channelId)
        🏷️ 관련 태그: \(tags.joined(separator: ", "))

        위 내용은 유튜브 설명란에서 가져온 이벤트 정보입니다.
        하지만, 설명란을 그대로 사용하지 말고 **진짜 참여자가 남길 법한 자연스러운 댓글**을 작성하세요.

        ❌ 하지 말아야 할 것:
        - 설명을 다시 작성하거나 요약하지 마세요.
        - 이벤트 참여 방법, 채널 구독, 팔로우 등의 내용은 포함하지 마세요.
        - "이벤트에 참여하세요!" 같은 문구는 사용하지 마세요.
        - 딱딱한 문어체는 피하세요.
        - **이모지를 너무 많이 사용하지 마세요.** (최대 1~2개만 적절히 사용)

        ✅ 이렇게 작성하세요:
        - **참여자의 시점에서 감정을 담아 자연스럽게 작성하세요.** (예: "와! 이번 이벤트 기대돼요!")
        - **채널 이름을 자연스럽게 활용하세요.** (예: "\(channelId) 이벤트 열어주셔서 감사합니다!")
        - **태그 키워드를 반영하여 관심 있는 사람들이 공감할 수 있도록 작성하세요.**
        - **이모지는 필요할 때만 적절하게 사용하세요.** (예: "완전 기대돼요! 😆" 또는 "이거 정말 탐나네요! 💖")

        🎯 **최종 댓글을 그대로 출력하세요.** 추가 설명 없이, 자연스러운 댓글만 생성해주세요.
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
