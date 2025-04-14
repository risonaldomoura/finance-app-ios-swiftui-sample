//
//  TransferSuccessView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct TransferSuccessView: View {
    let paymentName: String
    let paymentAmount: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showReceipt = false
    
    var body: some View {
        VStack(spacing: 20) {
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
                VStack(spacing: 20) {
                    Text("Transfer Successful!")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.top, 10)
                    
                    Text("Your payment has been transferred successfully")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.gray)
                        .padding(.horizontal, 40)
                    
                    // Animação de sucesso
                    ZStack {
                        // Moedas animadas
                        HStack(spacing: 0) {
                            Image(systemName: "dollarsign.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                                .padding(.trailing, 10)
                            
                            Image(systemName: "dollarsign.circle.fill")
                                .resizable()
                                .frame(width: 70, height: 70)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 20)
                    
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
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.top, 20)
                    
                    Spacer()
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
        .sheet(isPresented: $showReceipt) {
            PaymentReceiptView(paymentName: paymentName, paymentAmount: paymentAmount)
        }
    }
}

#Preview {
    NavigationView {
        TransferSuccessView(paymentName: "Netflix", paymentAmount: "$1.00")
    }
}