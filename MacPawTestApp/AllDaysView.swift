//
//  AllDaysView.swift
//  MacPawTestApp
//
//  Created by Vladislav Stolyarov on 27.08.2023.
//

import SwiftUI

struct AllDaysView: View {
    let allEnemyLosses : EnemyLossesModel
    @State private var dayFilter : String = ""
    
    private var dayLossesArray: [DayLosses] {
            let equipmentLosses = allEnemyLosses.equipmentLosses
            let personnelLosses = allEnemyLosses.personnelLosses
            
            var dayLosses = [DayLosses]()
            
            for index in 0..<equipmentLosses.count {
                let currentEquipmentLosses = equipmentLosses[index]
                let currentPersonnelLosses = personnelLosses[index]
                
                let previousEquipmentLosses = index > 0 ? equipmentLosses[index - 1] : nil
                let previousPersonnelLosses = index > 0 ? personnelLosses[index - 1] : nil
                
                dayLosses.append(DayLosses(
                    equipmentLosses: currentEquipmentLosses,
                    personnelLosses: currentPersonnelLosses,
                    previousEquipmentLosses: previousEquipmentLosses,
                    previousPersonnelLosses: previousPersonnelLosses
                ))
            }
            
            if dayFilter.isEmpty {
                return dayLosses
            } else {
                let filteredDayLosses = dayLosses.filter { dayLosses in
                    return dayLosses.equipmentLosses.day.description.contains(dayFilter)
                }
                return filteredDayLosses
            }
        }
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack {
                HStack (spacing: 18){
                    Image(systemName: "magnifyingglass")
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                    TextField(
                        "",
                        text: $dayFilter,
                        prompt: Text("Знайти день...")
                            .foregroundColor(.promtColor)
                            .font(.subheadline)
                    )
                    .foregroundColor(.white)
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 18)
                .background(Color.textFieldColor)
                .cornerRadius(15)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
                ScrollView {
                    LazyVStack(spacing: 0){
                        ForEach(dayLossesArray, id: \.equipmentLosses.date) { dayLosses in
                            NavigationLink(value : dayLosses) {
                                ZStack {
                                    Rectangle()
                                        .stroke(Color.gray, lineWidth: 1)
                                    Text("День \(dayLosses.equipmentLosses.day)")
                                        .font(.title3)
                                        .foregroundColor(.white)
                                        .padding(.vertical, 8)
                                        .padding(.leading, 16)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }
                            }
                        }
                    }
                    .navigationDestination(for: DayLosses.self) { dayLosses in
                        LossesView(dayLosses: dayLosses)
                    }
                }
            }
        }
        .toolbarBackground(Color.backgroundColor, for: .navigationBar)
    }
}

struct AllDaysView_Previews: PreviewProvider {
    static var previews: some View {
        AllDaysView(allEnemyLosses: EnemyLossesModel())
    }
}
