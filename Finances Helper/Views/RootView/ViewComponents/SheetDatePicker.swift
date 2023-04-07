//
//  SheetDatePicker.swift
//  Finances Helper
//
//  Created by Bogdan Zykov on 04.04.2023.
//

import SwiftUI

struct SheetDatePicker: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var rootVM: RootViewModel
    @State var slectedDate = Date.now.noon
    var body: some View {
        VStack {
            HStack{
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
                Spacer()
            }
            CustomDatePickerView(selectedDate: $slectedDate)
                .padding(.top)
            Spacer()
        }
        .padding()
//        .onChange(of: slectedDate) { newValue in
//            rootVM.timeFilter = .select(newValue)
//            dismiss()
//        }
    }
}

struct SheetDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        SheetDatePicker(rootVM: RootViewModel(context: dev.viewContext))
    }
}
