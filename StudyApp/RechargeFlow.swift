//
//  RechargeFlow.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct RechargeView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var mobileNumber: String = ""
    @State private var selectedNetwork: String = "AT&T"
    @State private var amount: String = ""
    @State private var showConfirmation = false
    
    let networks = ["AT&T", "T-Mobile", "Verizon"]
    let presetAmounts = ["$50", "$100", "$150"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text("Recharge")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 25) {
                    // Mobile Number Input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Add Mobile Number")
                            .font(.headline)
                        
                        Text("Enter recipient mobile number")
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        TextField("Mobile Number", text: $mobileNumber)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .keyboardType(.numberPad)
                    }
                    .padding(.horizontal)
                    
                    // Network Selection
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Select Network")
                            .font(.headline)
                        
                        HStack(spacing: 10) {
                            ForEach(networks, id: \.self) { network in
                                NetworkButton(network: network, selectedNetwork: $selectedNetwork)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Amount Input
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Enter Amount")
                            .font(.headline)
                        
                        TextField("$250.00", text: $amount)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .keyboardType(.decimalPad)
                        
                        // Preset amounts
                        HStack(spacing: 10) {
                            ForEach(presetAmounts, id: \.self) { preset in
                                Button(action: {
                                    amount = preset.replacingOccurrences(of: "$", with: "")
                                }) {
                                    Text(preset)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // Continue Button
                    Button(action: {
                        showConfirmation = true
                    }) {
                        Text("Continue")
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
            
            // Tab Bar
            HStack(spacing: 0) {
                ForEach(0..<5) { index in
                    VStack {
                        Image(systemName: index == 0 ? "house" : 
                                        index == 1 ? "shield" :
                                        index == 2 ? "creditcard" :
                                        index == 3 ? "chart.bar" : "square.grid.2x2")
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                }
            }
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3)),
                alignment: .top
            )
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showConfirmation) {
            RechargeConfirmationView(
                mobileNumber: mobileNumber,
                network: selectedNetwork,
                amount: amount.isEmpty ? "0.00" : amount
            )
        }
    }
}

struct NetworkButton: View {
    let network: String
    @Binding var selectedNetwork: String
    
    var body: some View {
        Button(action: {
            selectedNetwork = network
        }) {
            VStack {
                ZStack {
                    Circle()
                        .stroke(selectedNetwork == network ? Color.blue : Color.clear, lineWidth: 2)
                        .frame(width: 60, height: 60)
                    
                    Image(systemName: "antenna.radiowaves.left.and.right")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(selectedNetwork == network ? .blue : .gray)
                        .padding(10)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Text(network)
                    .font(.caption)
                    .foregroundColor(selectedNetwork == network ? .blue : .gray)
            }
        }
    }
}

struct RechargeConfirmationView: View {
    @Environment(\.presentationMode) var presentationMode
    let mobileNumber: String
    let network: String
    let amount: String
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text("Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "ellipsis")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Are you sure?")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Please make sure that you want to Recharge your mobile")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Network Logo
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                    
                    // Network and Number
                    VStack(spacing: 5) {
                        Text(network)
                            .font(.headline)
                        
                        Text("+1 (mobileNumber)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Transaction Status
                    HStack {
                        Text("Transaction Status: Pending")
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.orange.opacity(0.2))
                            .foregroundColor(.orange)
                            .cornerRadius(5)
                    }
                    
                    // Amount
                    VStack(spacing: 5) {
                        Text("$\(amount)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("USD")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Details
                    VStack(spacing: 15) {
                        HStack {
                            Text("Network")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(network)
                                .fontWeight(.medium)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Transfer Fee")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("$0.00")
                                .fontWeight(.medium)
                            + Text("USD")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    // Pay Now Button
                    Button(action: {
                        showSuccess = true
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
                    .padding(.top, 20)
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showSuccess) {
            RechargeSuccessView(
                mobileNumber: mobileNumber,
                network: network,
                amount: amount
            )
        }
    }
}

struct RechargeSuccessView: View {
    @Environment(\.presentationMode) var presentationMode
    let mobileNumber: String
    let network: String
    let amount: String
    @State private var showReceipt = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Spacer()
                
                Text("Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Transfer Successful!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Your recharge has been transferred successfully")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Success Animation
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 120, height: 120)
                        
                        Image("success_animation")
                            .resizable()
                            .frame(width: 100, height: 100)
                            .aspectRatio(contentMode: .fit)
                    }
                    
                    // View Receipt Button
                    Button(action: {
                        showReceipt = true
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
                    .padding(.top, 20)
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showReceipt) {
            RechargeReceiptView(
                mobileNumber: mobileNumber,
                network: network,
                amount: amount
            )
        }
    }
}

struct RechargeReceiptView: View {
    @Environment(\.presentationMode) var presentationMode
    let mobileNumber: String
    let network: String
    let amount: String
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                    }
                }
                
                Spacer()
                
                Text("Confirmation")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                Spacer()
                
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "square.and.arrow.up")
                        .foregroundColor(.gray)
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            ScrollView {
                VStack(spacing: 30) {
                    Text("Transfer Successful!")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Your recharge has been transferred successfully")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Network Logo
                    ZStack {
                        Circle()
                            .fill(Color.blue.opacity(0.1))
                            .frame(width: 80, height: 80)
                        
                        Image(systemName: "antenna.radiowaves.left.and.right")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.blue)
                    }
                    
                    // Network and Number
                    VStack(spacing: 5) {
                        Text(network)
                            .font(.headline)
                        
                        Text("+1 (mobileNumber)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    // Transaction Status
                    HStack {
                        Text("Transaction Status: Paid")
                            .font(.caption)
                            .padding(.vertical, 5)
                            .padding(.horizontal, 10)
                            .background(Color.green.opacity(0.2))
                            .foregroundColor(.green)
                            .cornerRadius(5)
                    }
                    
                    // Amount
                    VStack(spacing: 5) {
                        Text("$\(amount)")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("USD")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    
                    // Details
                    VStack(spacing: 15) {
                        HStack {
                            Text("Network")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text(network)
                                .fontWeight(.medium)
                        }
                        
                        Divider()
                        
                        HStack {
                            Text("Transfer Fee")
                                .foregroundColor(.gray)
                            
                            Spacer()
                            
                            Text("$0.00")
                                .fontWeight(.medium)
                            + Text("USD")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(10)
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RechargeView()
}