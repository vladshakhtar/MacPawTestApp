//
//  EnemyLossesModel.swift
//  MacPawTestApp
//
//  Created by Vladislav Stolyarov on 26.08.2023.
//

import Foundation

final class EnemyLossesModel : ObservableObject, Hashable {
    static func == (lhs: EnemyLossesModel, rhs: EnemyLossesModel) -> Bool {
        lhs.equipmentLosses.count == rhs.equipmentLosses.count
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(equipmentLosses[equipmentLosses.count-1])
    }
    
    @Published var equipmentLosses : [Equipment] = []
    @Published var personnelLosses : [Personnel] = []
    
    
    func fetchEnemyLosses(completion: @escaping (Result<Void, Error>) -> Void) {
            let equipmentURL = URL(string: "https://raw.githubusercontent.com/MacPaw/2022-Ukraine-Russia-War-Dataset/main/data/russia_losses_equipment.json")!
            let personnelURL = URL(string: "https://raw.githubusercontent.com/MacPaw/2022-Ukraine-Russia-War-Dataset/main/data/russia_losses_personnel.json")!
            
            let group = DispatchGroup()
            
            var equipmentError: Error?
            var personnelError: Error?
            
            group.enter()
            fetchLosses(from: equipmentURL, ofType: [Equipment].self) { result in
                switch result {
                case .success(let equipmentLosses):
                        DispatchQueue.main.async {
                            self.equipmentLosses = equipmentLosses
                        }
                case .failure(let error):
                    equipmentError = error
                }
                group.leave()
            }
            
            group.enter()
            fetchLosses(from: personnelURL, ofType: [Personnel].self) { result in
                switch result {
                case .success(let personnelLosses):
                        DispatchQueue.main.async {
                            self.personnelLosses = personnelLosses
                        }
                case .failure(let error):
                    personnelError = error
                }
                group.leave()
            }
            
            group.notify(queue: .main) {
                if let error = equipmentError ?? personnelError {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        }
        
        private func fetchLosses<T: Codable>(from url: URL, ofType type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
            let session = URLSession.shared
            
            let task = session.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let data = data else {
                    let error = NSError(domain: "NoDataError", code: -1, userInfo: nil)
                    completion(.failure(error))
                    return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let decodedLosses = try decoder.decode(T.self, from: data)
                    completion(.success(decodedLosses))
                } catch {
                    completion(.failure(error))
                }
            }
            
            task.resume()
        }
    
}


private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()

func formatDateString(_ dateString: String) -> String {
    if let date = dateFormatter.date(from: dateString) {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd.MM.yyyy"
        return outputFormatter.string(from: date)
    }
    return ""
}




struct Equipment : Codable, Hashable {
    let date: String
    let day: Int
    let aircraft: Int
    let helicopter: Int
    let tank: Int
    let APC: Int
    let fieldArtillery: Int
    let MRL: Int
    let militaryAuto: Int?
    let fuelTank: Int?
    let drone: Int
    let navalShip: Int
    let antiAircraftWarfare: Int
    let specialEquipment: Int?
    let cruiseMissiles: Int?
    let vehiclesAndFuelTanks: Int?
    
    enum CodingKeys: String, CodingKey {
        case date, day, aircraft, helicopter, tank, APC, MRL, drone
        case fieldArtillery = "field artillery"
        case militaryAuto = "military auto"
        case fuelTank = "fuel tank"
        case navalShip = "naval ship"
        case antiAircraftWarfare = "anti-aircraft warfare"
        case cruiseMissiles = "cruise missiles"
        case vehiclesAndFuelTanks = "vehicles and fuel tanks"
        case specialEquipment = "special equipment"
    }
}

struct Personnel : Codable, Hashable {
    let date: String
    let day: Int
    let personnel : Int
    let POW : Int?
}

struct DayLosses : Codable, Hashable {
    static func == (lhs: DayLosses, rhs: DayLosses) -> Bool {
        lhs.equipmentLosses == rhs.equipmentLosses && lhs.personnelLosses == rhs.personnelLosses
    }
    
    let equipmentLosses : Equipment
    let personnelLosses : Personnel
    let previousEquipmentLosses : Equipment?
    let previousPersonnelLosses : Personnel?
}
