//
//  ContentView.swift
//  MacPawTestApp
//
//  Created by Vladislav Stolyarov on 21.08.2023.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var enemyLosses = EnemyLossesModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.backgroundColor.ignoresSafeArea()
                VStack {
                    if enemyLosses.equipmentLosses.isEmpty || enemyLosses.personnelLosses.isEmpty {
                        ProgressView("Fetching Data...")
                    } else {
                        LossesView(dayLosses: DayLosses(equipmentLosses: enemyLosses.equipmentLosses[enemyLosses.equipmentLosses.count-1], personnelLosses: enemyLosses.personnelLosses[enemyLosses.personnelLosses.count-1],
                        previousEquipmentLosses: enemyLosses.equipmentLosses[enemyLosses.equipmentLosses.count-2],
                        previousPersonnelLosses: enemyLosses.personnelLosses[enemyLosses.personnelLosses.count-2]))
                    }
                    NavigationLink(value: enemyLosses) {
                        Text("Інформація про всі дні")
                    }
                }
                .padding(.top, 10)
                .navigationDestination(for: EnemyLossesModel.self) { enemyLosses in
                    AllDaysView(allEnemyLosses: enemyLosses)
                }
            }
            .onAppear {
                enemyLosses.fetchEnemyLosses { result in
                    switch result {
                        case .success:
                            print("Data fetched and updated.")
                        case .failure(let error):
                            print("Error: \(error)")
                    }
                }
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension Color {
    static let backgroundColor = Color(red: 60/255, green: 62/255, blue: 70/255)
    static let textFieldColor = Color(red: 35/255, green: 38/255, blue: 43/255)
    static let promtColor = Color(red: 116/255, green: 123/255, blue: 132/255)
}
