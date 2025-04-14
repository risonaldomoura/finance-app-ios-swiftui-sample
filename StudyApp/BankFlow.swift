//
//  BankFlow.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

enum BankFlowStep {
    case selectBank
    case accountDetails
    case confirmation
    case success
    case receipt
}

class BankFlowViewModel: ObservableObject {
    @Published var currentStep: BankFlowStep = .selectBank
    @Published var selectedBank: Bank? = nil
    @Published var accountNumber: String = ""
    @Published var accountName: String = ""
    @Published var amount: String = ""
    @Published var transferFee: String = "$2.50"
    @Published var transferType: String = "Instant Transfer"
    @Published var transactionId: String = "TRX-"+String(Int.random(in: 10000...99999))
    
    let banks: [Bank] = [
        Bank(name: "Chase Bank", code: "CHASE001", image: "building.columns.fill", color: .blue),
        Bank(name: "Bank of America", code: "BOA002", image: "building.columns.fill", color: .red),
        Bank(name: "Wells Fargo", code: "WF003", image: "building.columns.fill", color: .yellow),
        Bank(name: "Citibank", code: "CITI004", image: "building.columns.fill", color: .green)
    ]
    
    func goToNextStep() {
        switch currentStep {
        case .selectBank:
            currentStep = .accountDetails
        case .accountDetails:
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
        case .selectBank:
            // Exit flow
            break
        case .accountDetails:
            currentStep = .selectBank
        case .confirmation:
            currentStep = .accountDetails
        case .success:
            // Cannot go back from success
            break
        case .receipt:
            currentStep = .success
        }
    }
    
    func selectBank(_ bank: Bank) {
        selectedBank = bank
    }
    
    func dismissFlow() {
        // Reset and exit flow
        currentStep = .selectBank
        accountNumber = ""
        accountName = ""
        amount = ""
        selectedBank = nil
    }
    
    func calculateTotal() -> String {
        if let amountValue = Double(amount.replacingOccurrences(of: "$", with: "")) {
            return "$\(String(format: "%.2f", amountValue))"
        }
        return "$0.00"
    }
}

struct Bank: Identifiable {
    let id = UUID()
    let name: String
    let code: String
    let image: String
    let color: Color
}

struct BankFlowView: View {
    @StateObject private var viewModel = BankFlowViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .selectBank:
                SelectBankView(viewModel: viewModel)
            case .accountDetails:
                AccountDetailsView(viewModel: viewModel)
            case .confirmation:
                BankTransferConfirmationView(viewModel: viewModel)
            case .success:
                BankTransferSuccessView(viewModel: viewModel)
            case .receipt:
                BankTransferReceiptView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Bank to Bank", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            if viewModel.currentStep == .selectBank {
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

struct SelectBankView: View {
    @ObservedObject var viewModel: BankFlowViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search bank", text: $searchText)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Text("Select Bank")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.banks) { bank in
                        Button(action: {
                            viewModel.selectBank(bank)
                            viewModel.goToNextStep()
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(bank.color.opacity(0.1))
                                        .frame(width: 50, height: 50)
                                    
                                    Image(systemName: bank.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(bank.color)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(bank.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text("Code: \(bank.code)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.white)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}

struct AccountDetailsView: View {
    @ObservedObject var viewModel: BankFlowViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let selectedBank = viewModel.selectedBank {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(selectedBank.color.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: selectedBank.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedBank.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedBank.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Code: \(selectedBank.code)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                
                Text("Account Details")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    TextField("Account Number", text: $viewModel.accountNumber)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(.numberPad)
                    
                    TextField("Account Holder Name", text: $viewModel.accountName)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Amount", text: $viewModel.amount)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(.decimalPad)
                }
                .padding(.horizontal)
                
                Text("Transfer Type")
                    .font(.headline)
                    .padding(.horizontal)
                    .padding(.top)
                
                VStack(spacing: 15) {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.blue.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "bolt.fill")
                                .foregroundColor(.blue)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Instant Transfer")
                                .fontWeight(.medium)
                            
                            Text("Fee: $2.50")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .background(Circle().fill(Color.blue))
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    
                    HStack {
                        ZStack {
                            Circle()
                                .fill(Color.green.opacity(0.1))
                                .frame(width: 40, height: 40)
                            
                            Image(systemName: "clock.fill")
                                .foregroundColor(.green)
                        }
                        
                        VStack(alignment: .leading) {
                            Text("Standard Transfer")
                                .fontWeight(.medium)
                            
                            Text("Fee: $0.50 (1-2 business days)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Circle()
                            .stroke(Color.gray, lineWidth: 1)
                            .frame(width: 20, height: 20)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                }
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("Continue")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

struct BankTransferConfirmationView: View {
    @ObservedObject var viewModel: BankFlowViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Confirm Transfer")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Bank info
                if let selectedBank = viewModel.selectedBank {
                    HStack {
                        ZStack {
                            Circle()
                                .fill(selectedBank.color.opacity(0.1))
                                .frame(width: 50, height: 50)
                            
                            Image(systemName: selectedBank.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 24, height: 24)
                                .foregroundColor(selectedBank.color)
                        }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(selectedBank.name)
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            Text("Code: \(selectedBank.code)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    .padding(.horizontal)
                }
                
                // Transfer details
                VStack(spacing: 15) {
                    HStack {
                        Text("Account Number")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.accountNumber)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Text("Account Holder")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.accountName)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Text("Transfer Type")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.transferType)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Text("Transfer Fee")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.transferFee)
                            .fontWeight(.medium)
                    }
                    .padding(.horizontal)
                    
                    Divider()
                    
                    HStack {
                        Text("Amount")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.calculateTotal())
                            .fontWeight(.bold)
                    }
                    .padding(.horizontal)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                Spacer()
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("Confirm Transfer")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

struct BankTransferSuccessView: View {
    @ObservedObject var viewModel: BankFlowViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 100, height: 100)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.green)
            }
            
            Text("Transfer Successful!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your transfer to \(viewModel.selectedBank?.name ?? "") has been processed successfully.")
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Text("Transaction ID: \(viewModel.transactionId)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
            
            HStack(spacing: 20) {
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("View Receipt")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                
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
            }
            .padding()
        }
    }
}

struct BankTransferReceiptView: View {
    @ObservedObject var viewModel: BankFlowViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                Text("Transfer Receipt")
                    .font(.title2)
                    .fontWeight(.bold)
                
                // Receipt card
                VStack(spacing: 15) {
                    Image(systemName: "checkmark.circle.fill")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundColor(.green)
                        .padding(.top)
                    
                    Text("Transfer Completed")
                        .font(.headline)
                    
                    Text(viewModel.calculateTotal())
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    HStack {
                        Text("Date & Time")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("\(Date().formatted(date: .abbreviated, time: .shortened))")
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Transaction ID")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.transactionId)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Bank")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.selectedBank?.name ?? "")
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Account Number")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.accountNumber)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Account Holder")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.accountName)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Transfer Type")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.transferType)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Transfer Fee")
                            .foregroundColor(.gray)
                        Spacer()
                        Text(viewModel.transferFee)
                            .fontWeight(.medium)
                    }
                    
                    Divider()
                    
                    HStack {
                        Text("Status")
                            .foregroundColor(.gray)
                        Spacer()
                        Text("Completed")
                            .fontWeight(.medium)
                            .foregroundColor(.green)
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                .padding(.horizontal)
                
                HStack(spacing: 20) {
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                    
                    Button(action: {}) {
                        HStack {
                            Image(systemName: "printer")
                            Text("Print")
                        }
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                    }
                }
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
                .padding()
            }
        }
    }
}

#Preview {
    BankFlowView()
}