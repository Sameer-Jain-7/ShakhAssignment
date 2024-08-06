//
//  Extentions.swift
//  AssignmentShakh
//
//  Created by Sameer Jain on 06/08/24.
//

import Foundation

extension ViewController {
    func fetchReelsData() {
        guard let url = Bundle.main.url(forResource: "reels", withExtension: "json") else { return }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let response = try decoder.decode(ReelsResponse.self, from: data)
            self.reels = response.reels.map { $0.arr }
            print(response.reels.first)
            collectionView.reloadData()
        } catch {
            print("Failed to load and parse reels.json: \(error.localizedDescription)")
        }
    }

}
