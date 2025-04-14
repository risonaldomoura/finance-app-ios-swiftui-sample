//
//  DashboardView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct DashboardView: View {
    var body: some View {
        NavigationView {
            // Configuração para ocultar a barra de navegação nativa em toda a navegação
            VStack(spacing: 0) {
                // Header
                HStack {
                    HStack {
                        Image(systemName: "person.circle.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .foregroundColor(.gray)
                        
                        Text("Fintech")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "bell.fill")
                            .foregroundColor(.gray)
                        
                        Circle()
                            .fill(Color.red)
                            .frame(width: 8, height: 8)
                            .offset(x: 8, y: -8)
                    }
                }
                .padding(.horizontal)
                .padding(.top)
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Credit Card
                        ZStack(alignment: .leading) {
                            // Card background
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue)
                                .frame(height: 200)
                            
                            // Card content
                            VStack(alignment: .leading, spacing: 8) {
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
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Valid From 10/25")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                    
                                    VStack(alignment: .leading) {
                                        Text("Valid Thru 10/30")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                    }
                                }
                                
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text("Card Holder")
                                            .font(.caption)
                                            .foregroundColor(.white.opacity(0.8))
                                        
                                        Text("Will Jonas")
                                            .foregroundColor(.white)
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 20, height: 20)
                                        
                                        Circle()
                                            .fill(Color.orange)
                                            .frame(width: 20, height: 20)
                                            .offset(x: -10)
                                    }
                                }
                            }
                            .padding()
                            
                            // Chip
                            Image(systemName: "creditcard.and.123")
                                .resizable()
                                .frame(width: 30, height: 20)
                                .foregroundColor(.yellow)
                                .offset(x: 300, y: -60)
                        }
                        .padding(.horizontal)
                        
                        // Quick Actions
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Quick Actions")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            HStack(spacing: 15) {
                                // Money Transfer
                                NavigationLink(destination: MoneyTransferView().navigationBarHidden(true)) {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.green.opacity(0.1))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: "arrow.left.arrow.right.circle")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.green)
                                        }
                                        
                                        Text("Money Transfer")
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 100)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Pay Bill
                                NavigationLink(destination: PayBillView().navigationBarHidden(true)) {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: "doc.text")
                                                .resizable()
                                                .frame(width: 20, height: 24)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Text("Pay Bill")
                                            .font(.caption)
                                    }
                                    .frame(width: 100)
                                }
                                .buttonStyle(PlainButtonStyle())
                                
                                // Bank to Bank
                                NavigationLink(destination: BankFlowView().navigationBarHidden(true)) {
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.gray.opacity(0.1))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: "building.columns")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Text("Bank to Bank")
                                            .font(.caption)
                                            .multilineTextAlignment(.center)
                                    }
                                    .frame(width: 100)
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                            .padding(.horizontal)
                        }
                        
                        // Services
                        VStack(alignment: .leading, spacing: 15) {
                            Text("Services")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 15) {
                                    // Recharge
                                    NavigationLink(destination: RechargeView().navigationBarHidden(true)) {
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.blue.opacity(0.1))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "dollarsign.circle")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            Text("Recharge")
                                                .font(.caption)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // Charity
                                    NavigationLink(destination: CharityView().navigationBarHidden(true)) {
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.blue.opacity(0.1))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "heart.circle")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            Text("Charity")
                                                .font(.caption)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // Loan
                                    NavigationLink(destination: LoanView().navigationBarHidden(true)) {
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 12)
                                                    .fill(Color.blue.opacity(0.1))
                                                    .frame(width: 50, height: 50)
                                                
                                                Image(systemName: "dollarsign.circle")
                                                    .resizable()
                                                    .frame(width: 24, height: 24)
                                                    .foregroundColor(.blue)
                                            }
                                            
                                            Text("Loan")
                                                .font(.caption)
                                        }
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                    
                                    // Gifts
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: "gift")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Text("Gifts")
                                            .font(.caption)
                                    }
                                    
                                    // Insurance
                                    VStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 50, height: 50)
                                            
                                            Image(systemName: "umbrella")
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        Text("Insurance")
                                            .font(.caption)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                        
                        // Schedule Payments
                        VStack(alignment: .leading, spacing: 15) {
                            HStack {
                                Text("Schedule Payments")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Text("View All")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal)
                            
                            VStack(spacing: 15) {
                                // Netflix
                                NavigationLink(destination: ScheduledPaymentDetailView(
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
                                ).navigationBarHidden(true)) {
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.black)
                                                .frame(width: 40, height: 40)
                                            
                                            Text("N")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.red)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Netflix")
                                                .fontWeight(.medium)
                                            
                                            Text("Next Payment: 12/04")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("$1.00")
                                            .fontWeight(.semibold)
                                        + Text("USD")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                                
                                // Paypal
                                NavigationLink(destination: ScheduledPaymentDetailView(
                                    paymentName: "Paypal",
                                    paymentLogo: AnyView(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 60, height: 60)
                                            
                                            Text("P")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                        }
                                    ),
                                    paymentAmount: "$3.50",
                                    paymentDate: "March 14, 2021"
                                ).navigationBarHidden(true)) {
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.blue.opacity(0.1))
                                                .frame(width: 40, height: 40)
                                            
                                            Text("P")
                                                .font(.title2)
                                                .fontWeight(.bold)
                                                .foregroundColor(.blue)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Paypal")
                                                .fontWeight(.medium)
                                            
                                            Text("Next Payment: 14/04")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("$3.50")
                                            .fontWeight(.semibold)
                                        + Text("USD")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                                
                                // Spotify
                                NavigationLink(destination: ScheduledPaymentDetailView(
                                    paymentName: "Spotify",
                                    paymentLogo: AnyView(
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 12)
                                                .fill(Color.green)
                                                .frame(width: 60, height: 60)
                                            
                                            Text("S")
                                                .font(.title)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                        }
                                    ),
                                    paymentAmount: "$10.00",
                                    paymentDate: "March 13, 2021"
                                ).navigationBarHidden(true)) {
                                    HStack {
                                        ZStack {
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(Color.green)
                                                .frame(width: 40, height: 40)
                                            
                                            Image(systemName: "music.note")
                                                .foregroundColor(.white)
                                        }
                                        
                                        VStack(alignment: .leading) {
                                            Text("Spotify")
                                                .fontWeight(.medium)
                                            
                                            Text("Next Payment: 13/04")
                                                .font(.caption)
                                                .foregroundColor(.gray)
                                        }
                                        
                                        Spacer()
                                        
                                        Text("$10.00")
                                            .fontWeight(.semibold)
                                        + Text("USD")
                                            .font(.caption)
                                            .foregroundColor(.gray)
                                    }
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.horizontal)
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .navigationBarHidden(true) // Oculta a barra de navegação na tela principal
            }
            .navigationViewStyle(StackNavigationViewStyle()) // Garante que a navegação funcione corretamente
            .background(Color(UIColor.systemBackground))
        }
    }
}

#Preview { DashboardView() }
