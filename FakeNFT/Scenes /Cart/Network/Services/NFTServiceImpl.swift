//
//  NFTServiceImpl.swift
//  FakeNFT
//
//  Created by Artem Yaroshenko on 02.07.2026.
//

import Foundation

protocol NFTService {
    func fetchNFTs(with ids: [String], completion: @escaping (Result<[NFT], Error>) -> Void)
}

final class NFTServiceImpl: NFTService {
    
    private let decoder = JSONDecoder()
    
    func fetchNFTs(with ids: [String], completion: @escaping (Result<[NFT], any Error>) -> Void) {
        guard !ids.isEmpty else {
            completion(.success([]))
            return
        }
        
        let idsQuery = ids.joined(separator: ",")
        let urlString = "\(RequestConstants.baseURL)/api/v1/nft?ids=\(idsQuery)"
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "NFTService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = HttpMethod.get.rawValue
        request.addValue(RequestConstants.token, forHTTPHeaderField: "X-Practicum-Mobile-Token")
        
        print("FETCH NFTS")
        print("URL: \(request.url?.absoluteString ?? "nil")")
        print("Method: \(request.httpMethod ?? "nil")")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error {
                print("NETWORK ERROR: \(error)")
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP STATUS: \(httpResponse.statusCode)")
            }
            
            guard let data else {
                let err = NSError(domain: "NFTService", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])
                print("ERROR: No data")
                DispatchQueue.main.async { completion(.failure(err)) }
                return
            }
            
            if let raw = String(data: data, encoding: .utf8) {
                print("RAW RESPONSE: \(raw)")
            }
            
            do {
                let nfts = try self.decoder.decode([NFT].self, from: data)
                print("JSON decoded: \(nfts.count) NFT(s)")
                DispatchQueue.main.async { completion(.success(nfts)) }
            } catch {
                print("DECODING ERROR: \(error)")
                DispatchQueue.main.async { completion(.failure(error)) }
            }
        }.resume()
        
        
    }
}
