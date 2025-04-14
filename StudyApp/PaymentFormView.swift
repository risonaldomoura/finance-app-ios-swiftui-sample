//
//  PaymentFormView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct PaymentFormView: View {
    let paymentName: String
    let paymentLogo: AnyView
    let paymentAmount: String
    let paymentDate: String
    
    @State private var firstName: String = ""
    @State private var lastName: String = ""
    @State private var address: String = ""
    @State private var postalCode: String = ""
    @State private var state: String = ""
    @State private var city: String = ""
    @State private var country: String = ""
    
    @State private var cardHolderName: String = ""
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    
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
                
                Text("\(paymentName) Payment")
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
                    // Payment Info
                    HStack {
                        paymentLogo
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading) {
                            Text(paymentName)
                                .font(.headline)
                            
                            Text("Next Payment: \(paymentDate)")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        
                        Spacer()
                        
                        Text(paymentAmount)
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                    .padding()
                    .background(Color.gray.opacity(0.05))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    // Personal Information
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Add Information")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextField("First Name", text: $firstName)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        TextField("Last Name", text: $lastName)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        TextField("Address", text: $address)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        HStack {
                            TextField("Postal Code", text: $postalCode)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            TextField("State", text: $state)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                        
                        HStack {
                            TextField("City", text: $city)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            TextField("Country", text: $country)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    
                    // Card Details
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Add Account Details")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        TextField("Card Holder Name", text: $cardHolderName)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        TextField("Card Number", text: $cardNumber)
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        
                        HStack {
                            TextField("MM/YY", text: $expiryDate)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            
                            TextField("CVV", text: $cvv)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.horizontal)
                    }
                    
                    Spacer()
                    
                    // Send Button
                    NavigationLink(destination: PaymentConfirmationView(paymentName: paymentName, paymentLogo: paymentLogo, paymentAmount: paymentAmount, paymentDate: paymentDate)) {
                        Text("Send")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
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
    NavigationView {
        PaymentFormView(
            paymentName: "Netflix",
            paymentLogo: AnyView(
                Image(systemName: "play.rectangle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.red)
            ),
            paymentAmount: "$1.00",
            paymentDate: "March 12, 2021"
        )
    }
}