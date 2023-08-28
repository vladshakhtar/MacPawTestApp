//
//  LossesView.swift
//  MacPawTestApp
//
//  Created by Vladislav Stolyarov on 27.08.2023.
//

import SwiftUI

struct LossesView: View {
    
    let dayLosses : DayLosses
    
    
    @ViewBuilder
    func lossesGroup(lossAmountLeft: Int, previousLossAmountLeft : Int?, ukrainianLeft: LocalizedStringKey, englishLeft: LocalizedStringKey , lossAmountRight: Int, previousLossAmountRight : Int?, ukrainianRight: LocalizedStringKey, englishRight: LocalizedStringKey) -> some View {
        HStack {
            VStack {
                Group {
                    HStack {
                        Text("\(lossAmountLeft)")
                            .font(.title2)
                            .foregroundColor(.white)
                        if let previousLossAmountLeft {
                            let difference = lossAmountLeft - previousLossAmountLeft
                            Text("+\(difference)")
                                .font(.caption2)
                                .foregroundColor(.orange)
                                .opacity(difference > 0 ? 1 : 0)
                        }
                    }
                    Text(ukrainianLeft)
                        .font(.footnote)
                        .foregroundColor(.orange)
                    Text(englishLeft)
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            }
            
            VStack {
                Group {
                    HStack {
                        Text("\(lossAmountRight)")
                            .font(.title2)
                            .foregroundColor(.white)
                        if let previousLossAmountRight {
                            let difference = lossAmountRight - previousLossAmountRight
                            Text("+\(difference)")
                                .font(.caption2)
                                .foregroundColor(.orange)
                                .opacity(difference > 0 ? 1 : 0)
                        }
                    }
                    Text(ukrainianRight)
                        .font(.footnote)
                        .foregroundColor(.orange)
                    Text(englishRight)
                        .font(.footnote)
                        .foregroundColor(.white)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            Color.backgroundColor.ignoresSafeArea()
            VStack(spacing: 20) {
                Group {
                    Text("\(dayLosses.equipmentLosses.day) ДЕНЬ ВІЙНИ")
                        .font(.title.bold())
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("Протягом 24.02.2022 – \(formatDateString(dayLosses.equipmentLosses.date))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.bottom, -12)
                    Text("ОРІЄНТОВНІ ВТРАТИ ПРОТИВНИКА СКЛАЛИ")
                        .font(.title)
                        .foregroundColor(.orange)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.leading, 16)
                VStack {
                    Group {
                        HStack {
                            Text("~\(dayLosses.personnelLosses.personnel)")
                                .font(.title2)
                                .foregroundColor(.white)
                            if let previousPersonnelLosses = dayLosses.previousPersonnelLosses {
                                let difference = dayLosses.personnelLosses.personnel - previousPersonnelLosses.personnel
                                Text("+\(difference)")
                                    .font(.caption2)
                                    .foregroundColor(.orange)
                                    .opacity(difference > 0 ? 1 : 0)
                            }
                        }
                        Text("особистого складу")
                            .font(.footnote)
                            .foregroundColor(.orange)
                        Text("personnel")
                            .font(.footnote)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 16)
                }
                lossesGroup(lossAmountLeft: dayLosses.equipmentLosses.APC,
                            previousLossAmountLeft: dayLosses.previousEquipmentLosses?.APC,
                            ukrainianLeft: "ББМ", englishLeft: "APV",
                            lossAmountRight: dayLosses.equipmentLosses.tank,
                            previousLossAmountRight: dayLosses.previousEquipmentLosses?.tank,
                            ukrainianRight: "танків", englishRight: "tanks")
                lossesGroup(lossAmountLeft: dayLosses.equipmentLosses.aircraft,
                            previousLossAmountLeft: dayLosses.previousEquipmentLosses?.aircraft,
                            ukrainianLeft: "літаків", englishLeft: "aircraft",
                            lossAmountRight: dayLosses.equipmentLosses.helicopter,
                            previousLossAmountRight: dayLosses.previousEquipmentLosses?.helicopter,
                            ukrainianRight: "гелікоптерів", englishRight: "helicopters")
                lossesGroup(lossAmountLeft: dayLosses.equipmentLosses.fieldArtillery,
                            previousLossAmountLeft: dayLosses.previousEquipmentLosses?.fieldArtillery,
                            ukrainianLeft: "артилерії", englishLeft: "artillery",
                            lossAmountRight: dayLosses.equipmentLosses.MRL,
                            previousLossAmountRight: dayLosses.previousEquipmentLosses?.MRL,
                            ukrainianRight: "РСЗВ", englishRight: "MLRS")
                lossesGroup(lossAmountLeft: dayLosses.equipmentLosses.drone,
                            previousLossAmountLeft: dayLosses.previousEquipmentLosses?.drone,
                            ukrainianLeft: "БПЛА", englishLeft: "UAV",
                            lossAmountRight: dayLosses.equipmentLosses.navalShip,
                            previousLossAmountRight: dayLosses.previousEquipmentLosses?.navalShip,
                            ukrainianRight: "кораблі", englishRight: "warships")
                lossesGroup(lossAmountLeft: dayLosses.equipmentLosses.antiAircraftWarfare,
                            previousLossAmountLeft: dayLosses.previousEquipmentLosses?.antiAircraftWarfare,
                            ukrainianLeft: "засоби ППО", englishLeft: "air defence systems",
                            lossAmountRight: dayLosses.equipmentLosses.vehiclesAndFuelTanks ?? (dayLosses.equipmentLosses.fuelTank ?? 0 + (dayLosses.equipmentLosses.militaryAuto ?? 0)) ,
                            previousLossAmountRight: dayLosses.previousEquipmentLosses?.vehiclesAndFuelTanks ?? (dayLosses.previousEquipmentLosses?.fuelTank ?? 0 + (dayLosses.previousEquipmentLosses?.militaryAuto ?? 0)),
                            ukrainianRight: "автотехніка і цистерни", englishRight: "vehicles & fuel tanks")
                if let cruiseMissiles = dayLosses.equipmentLosses.cruiseMissiles, let specialEquipment = dayLosses.equipmentLosses.specialEquipment {
                    lossesGroup(lossAmountLeft: cruiseMissiles,
                                previousLossAmountLeft: dayLosses.previousEquipmentLosses?.cruiseMissiles,
                                ukrainianLeft: "крилаті ракети", englishLeft: "cruise missiles",
                                lossAmountRight: specialEquipment,
                                previousLossAmountRight: dayLosses.previousEquipmentLosses?.specialEquipment,
                                ukrainianRight: "спеціальна техніка", englishRight: "special equipment")
                } else if let specialEquipment = dayLosses.equipmentLosses.specialEquipment {
                    VStack {
                        Group {
                            HStack {
                                Text("\(specialEquipment)")
                                    .font(.title2)
                                    .foregroundColor(.white)
                                if let previousEquipmentLosses = dayLosses.previousEquipmentLosses {
                                    let difference = (previousEquipmentLosses.specialEquipment ?? specialEquipment) - specialEquipment
                                    Text("+\(difference)")
                                        .font(.caption2)
                                        .foregroundColor(.orange)
                                        .opacity(difference > 0 ? 1 : 0)
                                }
                            }
                            Text("спеціальна техніка")
                                .font(.footnote)
                                .foregroundColor(.orange)
                            Text("special equipment")
                                .font(.footnote)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 16)
                    }
                }
                Spacer()
            }
        }
    }
}

struct LossesView_Previews: PreviewProvider {
    static var previews: some View {
        LossesView(dayLosses: DayLosses(equipmentLosses: Equipment(date: "2023-08-10", day: 533, aircraft: 315, helicopter: 313, tank: 4278, APC: 8303, fieldArtillery: 5028, MRL: 711, militaryAuto: nil, fuelTank: nil, drone: 4179, navalShip: 18, antiAircraftWarfare: 469, specialEquipment: 746, cruiseMissiles: 1377, vehiclesAndFuelTanks: 7495),
                   personnelLosses: Personnel(date: "2023-08-10", day: 533, personnel: 252200, POW: nil),
                   previousEquipmentLosses: Equipment(date: "2023-08-09", day: 532, aircraft: 315, helicopter: 312, tank: 4262, APC: 8290, fieldArtillery: 5013, MRL: 711, militaryAuto: nil, fuelTank: nil, drone: 4175, navalShip: 18, antiAircraftWarfare: 469, specialEquipment: 742, cruiseMissiles: 1377, vehiclesAndFuelTanks: 7479),
                   previousPersonnelLosses: Personnel(date: "2023-08-10", day: 533, personnel: 251620, POW: nil)))
    }
}
