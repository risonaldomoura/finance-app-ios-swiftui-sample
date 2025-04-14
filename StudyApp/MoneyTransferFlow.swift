//
//  MoneyTransferFlow.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

enum MoneyTransferStep {
    case contacts
    case amount
    case confirmation
    case success
    case receipt
}

class MoneyTransferViewModel: ObservableObject {
    @Published var currentStep: MoneyTransferStep = .contacts
    @Published var selectedContact: Contact? = nil
    @Published var amount: String = ""
    @Published var transferFee: String = "$0.00"
    @Published var cardType: String = "Debit Card"
    @Published var transactionId: String = "TRX-"+String(Int.random(in: 10000...99999))
    
    let contacts: [Contact] = [
        Contact(name: "Jonathan", phoneNumber: "+1 234 567 890", image: "person.circle.fill", recentAmount: "$45.00"),
        Contact(name: "Emma", phoneNumber: "+1 987 654 321", image: "person.circle.fill", recentAmount: "$32.50"),
        Contact(name: "Michael", phoneNumber: "+1 555 123 456", image: "person.circle.fill", recentAmount: "$78.25"),
        Contact(name: "Sophia", phoneNumber: "+1 444 789 012", image: "person.circle.fill", recentAmount: "$15.75")
    ]
    
    func goToNextStep() {
        switch currentStep {
        case .contacts:
            currentStep = .amount
        case .amount:
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
        case .contacts:
            // Exit flow
            break
        case .amount:
            currentStep = .contacts
        case .confirmation:
            currentStep = .amount
        case .success:
            // Cannot go back from success
            break
        case .receipt:
            currentStep = .success
        }
    }
    
    func selectContact(_ contact: Contact) {
        selectedContact = contact
    }
    
    func dismissFlow() {
        // Reset and exit flow
        currentStep = .contacts
        amount = ""
        selectedContact = nil
    }
    
    func calculateTotal() -> String {
        if let amountValue = Double(amount.replacingOccurrences(of: "$", with: "")) {
            return "$\(String(format: "%.2f", amountValue))"
        }
        return "$0.00"
    }
}

struct Contact: Identifiable {
    let id = UUID()
    let name: String
    let phoneNumber: String
    let image: String
    let recentAmount: String
}

struct MoneyTransferView: View {
    @StateObject private var viewModel = MoneyTransferViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .contacts:
                MoneyTransferContactsView(viewModel: viewModel)
            case .amount:
                TransferAmountView(viewModel: viewModel)
            case .confirmation:
                TransferConfirmationView(viewModel: viewModel)
            case .success:
                MoneyTransferSuccessView(viewModel: viewModel)
            case .receipt:
                TransferReceiptView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Money Transfer", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            if viewModel.currentStep == .contacts {
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

struct MoneyTransferContactsView: View {
    @ObservedObject var viewModel: MoneyTransferViewModel
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search", text: $searchText)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // Recent transfers
            Text("Recent transfers")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(viewModel.contacts) { contact in
                        VStack {
                            Button(action: {
                                viewModel.selectContact(contact)
                                viewModel.goToNextStep()
                            }) {
                                Image(systemName: contact.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    .foregroundColor(.white)
                                    .padding(5)
                                    .background(Circle().fill(Color.blue))
                            }
                            
                            Text(contact.name)
                                .font(.caption)
                            
                            Text(contact.recentAmount)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            // Make new transfer
            Text("Make new transfer")
                .font(.headline)
                .padding(.horizontal)
                .padding(.top)
            
            VStack(spacing: 15) {
                TextField("Enter Account Number", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                TextField("Receiver's Mobile Number", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .keyboardType(.phonePad)
                
                TextField("Purpose of payment (Optional)", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                SecureField("Password", text: .constant(""))
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
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
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct TransferAmountView: View {
    @ObservedObject var viewModel: MoneyTransferViewModel
    @State private var selectedAmount: String? = nil
    
    let quickAmounts = ["$50", "$100", "$200"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Card display
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                    .frame(height: 180)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Available Balance")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("$4,228.76")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("•••• •••• •••• 8635")
                        .foregroundColor(.white)
                    
                    Text("Will Jonas")
                        .foregroundColor(.white)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            
            // Amount entry
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter Amount")
                    .font(.headline)
                
                TextField("$25", text: $viewModel.amount)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .keyboardType(.decimalPad)
                    .padding()
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
            }
            .padding(.horizontal)
            
            // Quick Actions
            VStack(alignment: .leading, spacing: 10) {
                Text("Quick Actions")
                    .font(.headline)
                
                HStack(spacing: 15) {
                    ForEach(quickAmounts, id: \.self) { amount in
                        Button(action: {
                            selectedAmount = amount
                            viewModel.amount = amount
                        }) {
                            Text(amount)
                                .foregroundColor(selectedAmount == amount ? .white : .blue)
                                .padding(.horizontal, 20)
                                .padding(.vertical, 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 20)
                                        .fill(selectedAmount == amount ? Color.blue : Color.blue.opacity(0.1))
                                )
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            Spacer()
            
            // Numeric keypad
            VStack(spacing: 15) {
                HStack(spacing: 30) {
                    ForEach(1...3, id: \.self) { number in
                        Button(action: {
                            viewModel.amount += "\(number)"
                        }) {
                            Text("\(number)")
                                .font(.title2)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.gray.opacity(0.1)))
                        }
                    }
                }
                
                HStack(spacing: 30) {
                    ForEach(4...6, id: \.self) { number in
                        Button(action: {
                            viewModel.amount += "\(number)"
                        }) {
                            Text("\(number)")
                                .font(.title2)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.gray.opacity(0.1)))
                        }
                    }
                }
                
                HStack(spacing: 30) {
                    ForEach(7...9, id: \.self) { number in
                        Button(action: {
                            viewModel.amount += "\(number)"
                        }) {
                            Text("\(number)")
                                .font(.title2)
                                .frame(width: 50, height: 50)
                                .background(Circle().fill(Color.gray.opacity(0.1)))
                        }
                    }
                }
                
                HStack(spacing: 30) {
                    Button(action: {
                        viewModel.amount += "."
                    }) {
                        Text(".")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                    }
                    
                    Button(action: {
                        viewModel.amount += "0"
                    }) {
                        Text("0")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                    }
                    
                    Button(action: {
                        if !viewModel.amount.isEmpty {
                            viewModel.amount.removeLast()
                        }
                    }) {
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .frame(width: 50, height: 50)
                            .background(Circle().fill(Color.gray.opacity(0.1)))
                    }
                }
            }
            
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
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct TransferConfirmationView: View {
    @ObservedObject var viewModel: MoneyTransferViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("We need to confirm your identity, please make sure that you want to transfer money.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Recipient info
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Recipient")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.selectedContact?.name ?? "Jonathan")
                                .fontWeight(.medium)
                            
                            Text(viewModel.selectedContact?.phoneNumber ?? "+1 234 567 890")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Card info
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Card")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "creditcard")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.cardType)
                                .fontWeight(.medium)
                            
                            Text("**** **** **** 8635")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding(.horizontal)
            
            // Transfer details
            VStack(alignment: .leading, spacing: 15) {
                Text("Transfer Details")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Text("Transfer Amount")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.amount.isEmpty ? "$0.00" : "$\(viewModel.amount.replacingOccurrences(of: "$", with: ""))")
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Transfer Fee")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.transferFee)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.horizontal)
                
                HStack {
                    Text("Total")
                        .fontWeight(.medium)
                    
                    Spacer()
                    
                    Text(viewModel.calculateTotal())
                        .fontWeight(.bold)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    viewModel.goBack()
                }) {
                    Text("Cancel")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("Send Money")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
}

struct MoneyTransferSuccessView: View {
    @ObservedObject var viewModel: MoneyTransferViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Transfer Successful!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your money has been transferred successfully.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Success animation
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.green)
            
            // Animated faces
            HStack(spacing: 20) {
                Image(systemName: "face.smiling")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                Image(systemName: "face.smiling")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
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
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct TransferReceiptView: View {
    @ObservedObject var viewModel: MoneyTransferViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Transfer Successful!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your money has been transferred successfully.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Recipient info
            HStack {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            }
            
            Text(viewModel.selectedContact?.name ?? "Jonathan")
                .font(.headline)
            
            Text(viewModel.selectedContact?.phoneNumber ?? "+1 234 567 890")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            // Transaction details
            VStack(spacing: 15) {
                Text("Transaction Details")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("Transaction ID")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.transactionId)
                }
                
                HStack {
                    Text("Transfer Amount")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.amount.isEmpty ? "$0.00" : "$\(viewModel.amount.replacingOccurrences(of: "$", with: ""))")
                        .fontWeight(.bold)
                }
                
                HStack {
                    Text("Card Type")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.cardType)
                }
                
                HStack {
                    Text("Transfer Fee")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.transferFee)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
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
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

#Preview {
    MoneyTransferView()
}