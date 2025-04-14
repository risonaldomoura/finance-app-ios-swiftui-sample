//
//  CharityFlow.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

enum CharityStep {
    case charities
    case amount
    case confirmation
    case success
    case receipt
}

class CharityViewModel: ObservableObject {
    @Published var currentStep: CharityStep = .charities
    @Published var selectedCharity: Charity? = nil
    @Published var amount: String = ""
    @Published var transferFee: String = "$0.00"
    @Published var accountType: String = "Current Account"
    @Published var transactionId: String = "TRX-"+String(Int.random(in: 10000...99999))
    
    let charities: [Charity] = [
        Charity(name: "Heads Foundation", description: "Helping children in need", image: "heart.circle.fill", category: "Education"),
        Charity(name: "Donate for Child Education", description: "Support education for all", image: "graduationcap.circle.fill", category: "Education"),
        Charity(name: "Donate for Cancer Patients", description: "Help cancer treatment", image: "cross.circle.fill", category: "Health"),
        Charity(name: "Save the Planet", description: "Environmental protection", image: "leaf.circle.fill", category: "Environment")
    ]
    
    func goToNextStep() {
        switch currentStep {
        case .charities:
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
        case .charities:
            // Exit flow
            break
        case .amount:
            currentStep = .charities
        case .confirmation:
            currentStep = .amount
        case .success:
            // Cannot go back from success
            break
        case .receipt:
            currentStep = .success
        }
    }
    
    func selectCharity(_ charity: Charity) {
        selectedCharity = charity
    }
    
    func dismissFlow() {
        // Reset and exit flow
        currentStep = .charities
        amount = ""
        selectedCharity = nil
    }
    
    func calculateTotal() -> String {
        if let amountValue = Double(amount.replacingOccurrences(of: "$", with: "")) {
            return "$\(String(format: "%.2f", amountValue))"
        }
        return "$0.00"
    }
}

struct Charity: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let image: String
    let category: String
}

struct CharityView: View {
    @StateObject private var viewModel = CharityViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .charities:
                CharitiesListView(viewModel: viewModel)
            case .amount:
                DonationAmountView(viewModel: viewModel)
            case .confirmation:
                DonationConfirmationView(viewModel: viewModel)
            case .success:
                DonationSuccessView(viewModel: viewModel)
            case .receipt:
                DonationReceiptView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Charity", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            if viewModel.currentStep == .charities {
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

struct CharitiesListView: View {
    @ObservedObject var viewModel: CharityViewModel
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
            
            ScrollView {
                VStack(spacing: 15) {
                    ForEach(viewModel.charities) { charity in
                        Button(action: {
                            viewModel.selectCharity(charity)
                            viewModel.goToNextStep()
                        }) {
                            HStack {
                                Image(systemName: charity.image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 40, height: 40)
                                    .foregroundColor(.white)
                                    .padding(10)
                                    .background(Circle().fill(Color.blue))
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(charity.name)
                                        .font(.headline)
                                        .foregroundColor(.primary)
                                    
                                    Text(charity.description)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                
                                Spacer()
                                
                                Text(charity.category)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(5)
                                    .foregroundColor(.blue)
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

struct DonationAmountView: View {
    @ObservedObject var viewModel: CharityViewModel
    @State private var selectedAmount: String? = nil
    
    let quickAmounts = ["$50", "$100", "$200"]
    
    var body: some View {
        VStack(spacing: 20) {
            // Charity display
            VStack(alignment: .center, spacing: 10) {
                Image(systemName: viewModel.selectedCharity?.image ?? "heart.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                Text(viewModel.selectedCharity?.name ?? "Heads Foundation")
                    .font(.headline)
                
                Text(viewModel.selectedCharity?.description ?? "Helping children in need")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding()
            
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

struct DonationConfirmationView: View {
    @ObservedObject var viewModel: CharityViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Are you sure?")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("We need to confirm your identity, please make sure that you want to donate money.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Charity info
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Charity")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: viewModel.selectedCharity?.image ?? "heart.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.selectedCharity?.name ?? "Heads Foundation")
                                .fontWeight(.medium)
                            
                            Text(viewModel.selectedCharity?.description ?? "Helping children in need")
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
            
            // Account info
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Account")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    HStack {
                        Image(systemName: "creditcard")
                            .resizable()
                            .frame(width: 40, height: 30)
                            .foregroundColor(.blue)
                        
                        VStack(alignment: .leading) {
                            Text(viewModel.accountType)
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
            
            // Donation details
            VStack(alignment: .leading, spacing: 15) {
                Text("Donation Details")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Text("Donation Amount")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.amount.isEmpty ? "$0.00" : "$\(viewModel.amount.replacingOccurrences(of: "$", with: ""))")
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Transaction Fee")
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

struct DonationSuccessView: View {
    @ObservedObject var viewModel: CharityViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Transfer Successful!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Your donation has been transferred successfully.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Success animation
            VStack {
                Text(viewModel.selectedCharity?.name ?? "Heads Foundation")
                    .font(.headline)
                
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
                
                Text("Transaction Status: PAID")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.top, 5)
            }
            
            // Transaction details
            VStack(alignment: .leading, spacing: 15) {
                Text("Transaction Details")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Text("Transaction ID")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.transactionId)
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Date & Time")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("\(Date(), formatter: dateFormatter)")
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
                
                HStack {
                    Text("Amount")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(viewModel.calculateTotal())
                        .fontWeight(.medium)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(10)
            .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 15) {
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
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}

struct DonationReceiptView: View {
    @ObservedObject var viewModel: CharityViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Receipt")
                .font(.title2)
                .fontWeight(.bold)
            
            // Receipt card
            VStack(spacing: 20) {
                // Logo
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                
                Text("Thank You!")
                    .font(.title3)
                    .fontWeight(.semibold)
                
                Text("Your donation helps make a difference")
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Divider()
                
                // Receipt details
                VStack(spacing: 15) {
                    HStack {
                        Text("Charity")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.selectedCharity?.name ?? "Heads Foundation")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Transaction ID")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.transactionId)
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Date & Time")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text("\(Date(), formatter: dateFormatter)")
                            .fontWeight(.medium)
                    }
                    
                    HStack {
                        Text("Amount")
                            .foregroundColor(.gray)
                        
                        Spacer()
                        
                        Text(viewModel.calculateTotal())
                            .fontWeight(.bold)
                    }
                    
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
                
                Divider()
                
                Text("Transaction Status: PAID")
                    .font(.caption)
                    .foregroundColor(.green)
                    .padding(.bottom, 5)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(10)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            Spacer()
            
            HStack(spacing: 15) {
                Button(action: {
                    // Share receipt functionality would go here
                }) {
                    Text("Share Receipt")
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
            .padding(.horizontal)
            .padding(.bottom)
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter
    }
}