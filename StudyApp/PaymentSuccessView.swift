//
//  PaymentSuccessView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct PaymentSuccessView: View {
    let paymentName: String
    let paymentAmount: String
    
    @Environment(\.presentationMode) var presentationMode
    @State private var showReceipt = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Pagamento Realizado!")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Seu pagamento de \(paymentName) foi realizado com sucesso")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal, 40)
            
            Spacer()
            
            // Animação de sucesso
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.1))
                    .frame(width: 120, height: 120)
                
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.green)
            }
            
            Spacer()
            
            // Detalhes do pagamento
            VStack(spacing: 15) {
                Text(paymentName)
                    .font(.headline)
                
                HStack {
                    Text("Status da Transação: ")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    Text("Pago")
                        .font(.caption)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.green.opacity(0.8))
                        .cornerRadius(4)
                }
                
                HStack {
                    Text(paymentAmount)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text("USD")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                
                Divider()
                
                HStack {
                    Text("Data")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text(formattedDate())
                        .font(.subheadline)
                }
                
                HStack {
                    Text("Método de Pagamento")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("Cartão de Crédito")
                        .font(.subheadline)
                }
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            .padding(.horizontal)
            
            VStack(spacing: 15) {
                Button(action: {
                    showReceipt = true
                }) {
                    Text("Ver Recibo")
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Concluído")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal)
            .padding(.bottom, 20)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.gray)
                .padding(8)
                .background(Circle().fill(Color.gray.opacity(0.2)))
        })
        .sheet(isPresented: $showReceipt) {
            PaymentReceiptView(paymentName: paymentName, paymentAmount: paymentAmount)
        }
    }
    
    private func formattedDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: Date())
    }
}

#Preview {
    NavigationView {
        PaymentSuccessView(paymentName: "Netflix", paymentAmount: "$1.00")
    }
}