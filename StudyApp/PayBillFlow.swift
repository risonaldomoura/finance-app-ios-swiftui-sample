//
//  PayBillFlow.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

enum PayBillStep {
    case selectBill
    case confirmation
    case success
    case receipt
}

class PayBillViewModel: ObservableObject {
    @Published var currentStep: PayBillStep = .selectBill
    @Published var selectedBillType: BillType? = nil
    @Published var amount: String = "350.00"
    @Published var billNumber: String = "12569874564"
    @Published var dueDate: String = "March 23, 2021"
    @Published var companyName: String = ""
    @Published var referenceNumber: String = ""
    @Published var password: String = ""
    
    func goToNextStep() {
        switch currentStep {
        case .selectBill:
            currentStep = .confirmation
        case .confirmation:
            currentStep = .success
        case .success:
            currentStep = .receipt
        case .receipt:
            // Handled by dismissFlow
            break
        }
    }
    
    func goBack() {
        switch currentStep {
        case .selectBill:
            // Exit flow
            break
        case .confirmation:
            currentStep = .selectBill
        case .success:
            // Cannot go back from success
            break
        case .receipt:
            currentStep = .success
        }
    }
    
    func selectBill(_ type: BillType) {
        selectedBillType = type
    }
    
    func dismissFlow() {
        // Reset and exit flow
        currentStep = .selectBill
    }
}

enum BillType: String, CaseIterable, Identifiable {
    case internet = "Internet Bill"
    case electricity = "Electricity Bill"
    case water = "Water Bill"
    case other = "Other"
    
    var id: String { self.rawValue }
    
    var icon: String {
        switch self {
        case .internet:
            return "wifi"
        case .electricity:
            return "bolt.fill"
        case .water:
            return "drop.fill"
        case .other:
            return "doc.text.fill"
        }
    }
    
    var color: Color {
        switch self {
        case .internet:
            return .blue
        case .electricity:
            return .yellow
        case .water:
            return .blue
        case .other:
            return .gray
        }
    }
}

struct PayBillView: View {
    @StateObject private var viewModel = PayBillViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                switch viewModel.currentStep {
                case .selectBill:
                    PayBillSelectView(viewModel: viewModel)
                case .confirmation:
                    PayBillConfirmationView(viewModel: viewModel)
                case .success:
                    PayBillSuccessView(viewModel: viewModel)
                case .receipt:
                    PayBillReceiptView(viewModel: viewModel)
                }
            }
            .navigationBarTitle("Pay Bill", displayMode: .inline)
            .navigationBarItems(leading: Button(action: {
                if viewModel.currentStep == .selectBill {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    viewModel.goBack()
                }
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.gray)
                    .padding(8)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            })
        }
    }
}

struct PayBillSelectView: View {
    @ObservedObject var viewModel: PayBillViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                Text("Your Bills")
                    .font(.headline)
                    .padding(.horizontal)
                
                ForEach(BillType.allCases) { billType in
                    Button(action: {
                        viewModel.selectBill(billType)
                    }) {
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(billType.color.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: billType.icon)
                                    .foregroundColor(billType.color)
                            }
                            
                            Text(billType.rawValue)
                                .foregroundColor(.primary)
                            
                            Spacer()
                            
                            Circle()
                                .stroke(Color.blue, lineWidth: viewModel.selectedBillType == billType ? 2 : 0)
                                .background(viewModel.selectedBillType == billType ? Circle().fill(Color.blue) : Circle().fill(Color.clear))
                                .frame(width: 20, height: 20)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                
                Text("Fill Details")
                    .font(.headline)
                    .padding(.top)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    TextField("Company Name", text: $viewModel.companyName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Reference Number", text: $viewModel.referenceNumber)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    HStack {
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Button(action: {}) {
                            Image(systemName: "eye")
                                .foregroundColor(.gray)
                        }
                        .padding(.trailing, 8)
                        
                        Button(action: {}) {
                            Image(systemName: "touchid")
                                .foregroundColor(.gray)
                        }
                    }
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("Next")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.vertical)
        }
    }
}

struct PayBillConfirmationView: View {
    @ObservedObject var viewModel: PayBillViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Are you sure?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Please make sure that you want to pay electricity bill")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Bill details card
            VStack(spacing: 15) {
                ZStack {
                    Circle()
                        .fill(Color.black)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "bolt.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                }
                
                Text("Electricity Bill")
                    .font(.headline)
                
                Text("David John")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    Text("Transaction Status: ")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Unpaid")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(4)
                }
                
                HStack {
                    Text("$\(viewModel.amount)")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("USD")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                
                Divider()
                
                HStack {
                    Text("Bill Number")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.billNumber)
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Due Date")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.dueDate)
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text("Pay Now")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

struct PayBillSuccessView: View {
    @ObservedObject var viewModel: PayBillViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Congratulations!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your electricity bill payment has been paid successfully")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Animated coins
            HStack(spacing: -20) {
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .background(Circle().fill(Color.white))
                
                Image(systemName: "dollarsign.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.gray)
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 4)
                    )
                    .background(Circle().fill(Color.white))
            }
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text("View Receipt")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
    }
}

struct PayBillReceiptView: View {
    @ObservedObject var viewModel: PayBillViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Congratulations!")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Your electricity bill payment has been paid successfully")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 40)
                
                // Animated coins
                HStack(spacing: -20) {
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .background(Circle().fill(Color.white))
                    
                    Image(systemName: "dollarsign.circle.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.gray)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 4)
                        )
                        .background(Circle().fill(Color.white))
                }
                
                // Receipt details
                VStack(spacing: 15) {
                    ZStack {
                        Circle()
                            .fill(Color.black)
                            .frame(width: 60, height: 60)
                        
                        Image(systemName: "bolt.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundColor(.white)
                    }
                    
                    Text("Electricity Bill")
                        .font(.headline)
                    
                    HStack {
                        Text("Transaction Status: ")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Text("Paid")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.green.opacity(0.8))
                            .cornerRadius(4)
                    }
                    
                    HStack {
                        Text("$\(viewModel.amount)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("USD")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.top, 4)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Bill Number")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.billNumber)
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Text("Date")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.dueDate)
                            .font(.subheadline)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                Button(action: {
                    viewModel.dismissFlow()
                }) {
                    Text("Done")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding(.horizontal)
                .padding(.bottom, 20)
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    PayBillView()
}