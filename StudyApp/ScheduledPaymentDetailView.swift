//
//  ScheduledPaymentDetailView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct ScheduledPaymentDetailView: View {
    let paymentName: String
    let paymentLogo: AnyView
    let paymentAmount: String
    let paymentDate: String
    let paymentStatus: String
    let accountNumber: String
    
    @Environment(\.presentationMode) var presentationMode
    
    init(paymentName: String, paymentLogo: AnyView, paymentAmount: String, paymentDate: String, paymentStatus: String = "Unpaid", accountNumber: String = "2222****1955") {
        self.paymentName = paymentName
        self.paymentLogo = paymentLogo
        self.paymentAmount = paymentAmount
        self.paymentDate = paymentDate
        self.paymentStatus = paymentStatus
        self.accountNumber = accountNumber
    }
    
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
                
                Text("Pay Bill")
                    .font(.title3)
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
                    // Payment Logo and Info
                    VStack(spacing: 15) {
                        // Logo
                        paymentLogo
                            .frame(width: 60, height: 60)
                            .padding(.vertical, 10)
                        
                        // Name
                        Text(paymentName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        // Account Number
                        Text(accountNumber)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Status
                    HStack {
                        Text("Transaction Status: \(paymentStatus)")
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(paymentStatus == "Paid" ? Color.green.opacity(0.2) : Color.red.opacity(0.2))
                            )
                            .foregroundColor(paymentStatus == "Paid" ? .green : .red)
                    }
                    
                    // Amount
                    VStack(spacing: 5) {
                        Text(paymentAmount)
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                        
                        Text("USD")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    
                    // Payment Details
                    VStack(spacing: 20) {
                        Text("Payment Details")
                            .font(.headline)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                        
                        VStack(spacing: 15) {
                            // Transfer Fee
                            HStack {
                                Text("Transfer fee")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("$0.00")
                                    .fontWeight(.medium)
                                + Text("USD")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            Divider()
                                .padding(.horizontal)
                            
                            // Due Date
                            HStack {
                                Text("Due Date")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text(paymentDate)
                                    .fontWeight(.medium)
                            }
                            .padding(.horizontal)
                        }
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Action Buttons
                    VStack(spacing: 15) {
                        NavigationLink(destination: PaymentFormView(paymentName: paymentName, paymentLogo: paymentLogo, paymentAmount: paymentAmount, paymentDate: paymentDate)) {
                            Text("Pay Now")
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
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
            .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: -5)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    // Netflix example
    ScheduledPaymentDetailView(
        paymentName: "Netflix",
        paymentLogo: AnyView(
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.black)
                    .frame(width: 60, height: 60)
                
                Text("N")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.red)
            }
        ),
        paymentAmount: "$1.00",
        paymentDate: "March 12, 2021"
    )
}
