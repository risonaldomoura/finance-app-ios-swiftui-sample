//
//  CardSettingsView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct CardSettingsView: View {
    @State private var isLockCardEnabled = false
    @State private var isDeactivateCardEnabled = false
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                HStack {
                    ZStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 40, height: 40)
                        
                        Image(systemName: "chevron.left")
                            .foregroundColor(.gray)
                    }
                    
                    Text("My Card")
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
                    
                    // Indicator
                    HStack(spacing: 4) {
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 20, height: 4)
                            .cornerRadius(2)
                    }
                    
                    // Card Status and Limit
                    HStack(spacing: 15) {
                        // Credit Limit
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Credit Limit")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            HStack(alignment: .firstTextBaseline, spacing: 2) {
                                Text("$271.00")
                                    .font(.title3)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                
                                Text("USD")
                                    .font(.caption2)
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(8)
                        
                        // Card Status
                        VStack(alignment: .leading, spacing: 5) {
                            Text("Card Status")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text("Active")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundColor(.red)
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.red.opacity(0.1))
                        .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Settings
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Settings")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        // Change PIN
                        Button(action: {
                            viewModel.startPinChangeFlow(onSuccess: {
                                // Handle successful PIN change
                            })
                        }) {
                            HStack {
                                ZStack {
                                    Circle()
                                        .fill(Color.green.opacity(0.1))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "lock.shield")
                                        .foregroundColor(.green)
                                }
                                
                                Text("Change Pin")
                                    .fontWeight(.medium)
                                
                                Spacer()
                                
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            .background(Color.gray.opacity(0.05))
                            .cornerRadius(8)
                            .padding(.horizontal)
                        }
                        
                        // Lock Card
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.red.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "lock")
                                    .foregroundColor(.red)
                            }
                            
                            Text("Lock Card")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isLockCardEnabled)
                                .labelsHidden()
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        // Deactivate Card
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(Color.blue.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "creditcard")
                                    .foregroundColor(.blue)
                            }
                            
                            Text("Deactivate Card")
                                .fontWeight(.medium)
                            
                            Spacer()
                            
                            Toggle("", isOn: $isDeactivateCardEnabled)
                                .labelsHidden()
                                .tint(.blue)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.05))
                        .cornerRadius(8)
                        .padding(.horizontal)
                    }
                    
                    // Save Button
                    Button(action: {}) {
                        Text("Save")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                            .padding(.horizontal)
                    }
                    .padding(.top)
                }
                .padding(.vertical)
            }
            
            // Tab Bar
            HStack(spacing: 0) {
                ForEach(0..<5) { index in
                    VStack {
                        Image(systemName: index == 0 ? "house" : 
                                        index == 1 ? "shield" :
                                        index == 2 ? "creditcard.fill" :
                                        index == 3 ? "chart.bar" : "square.grid.2x2")
                            .foregroundColor(index == 2 ? .blue : .gray)
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
        .background(Color(UIColor.systemBackground))
        .sheet(isPresented: $viewModel.showPinChangeFlow) {
            ZStack {
                switch viewModel.currentStep {
                case .mobileNumber:
                    MobileNumberView(viewModel: viewModel)
                case .otpVerification:
                    OTPVerificationView(viewModel: viewModel)
                case .newPin:
                    NewPinView(viewModel: viewModel)
                default:
                    EmptyView()
                }
            }
            .onDisappear {
                viewModel.dismissPinChangeFlow()
            }
        }
    }
}

#Preview {
    CardSettingsView()
}