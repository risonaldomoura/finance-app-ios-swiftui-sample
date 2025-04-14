//
//  PaymentReceiptView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct PaymentReceiptView: View {
    let paymentName: String
    let paymentAmount: String
    
    @Environment(\.presentationMode) var presentationMode
    
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
                    
                    // Logo e informações
                    VStack(spacing: 15) {
                        // Logo
                        ZStack {
                            Circle()
                                .fill(Color.red.opacity(0.1))
                                .frame(width: 60, height: 60)
                            
                            Text("N")
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding(.vertical, 10)
                        
                        // Nome
                        Text(paymentName)
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        // Número da conta
                        Text("2222****1955")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.top, 20)
                    
                    // Status
                    HStack {
                        Text("Transaction Status: Paid")
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(
                                Capsule()
                                    .fill(Color.green.opacity(0.2))
                            )
                            .foregroundColor(.green)
                    }
                    
                    // Valor
                    VStack(spacing: 5) {
                        Text(paymentAmount)
                            .font(.system(size: 36))
                            .fontWeight(.bold)
                        
                        Text("USD")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    
                    // Detalhes do pagamento
                    VStack(spacing: 20) {
                        VStack(spacing: 15) {
                            // Taxa de transferência
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
                            
                            // Data de vencimento
                            HStack {
                                Text("Due Date")
                                    .foregroundColor(.gray)
                                
                                Spacer()
                                
                                Text("March 21, 2021")
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
                    
                    // Botão de fechar
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Close")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 30)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    PaymentReceiptView(paymentName: "Netflix", paymentAmount: "$1.00")
}