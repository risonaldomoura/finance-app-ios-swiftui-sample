//
//  OnboardingView.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct OnboardingView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        switch viewModel.currentStep {
        case .onboarding1:
            OnboardingScreen1(viewModel: viewModel)
        case .onboarding2:
            OnboardingScreen2(viewModel: viewModel)
        case .login:
            LoginView(viewModel: viewModel)
        case .signup:
            SignupView(viewModel: viewModel)
        case .setFingerprint:
            SetFingerprintView(viewModel: viewModel)
        case .fingerprintScanning:
            FingerprintScanningView(viewModel: viewModel)
        case .mobileNumber:
            MobileNumberView(viewModel: viewModel)
        case .otpVerification:
            OTPVerificationView(viewModel: viewModel)
        case .newPin:
            NewPinView(viewModel: viewModel)
        }
    }
}

struct OnboardingScreen1: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                // Credit card background
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blue)
                    .frame(width: 280, height: 170)
                    .shadow(radius: 10)
                    .rotationEffect(.degrees(-15))
                
                // Credit card details
                VStack(alignment: .leading) {
                    HStack {
                        Text("1234 5678 9012 3456")
                            .font(.system(size: 16))
                            .foregroundColor(.white)
                        Spacer()
                        Image(systemName: "wave.3.right")
                            .foregroundColor(.white)
                    }
                    Spacer()
                    Text("CARD HOLDER")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.7))
                    Text("YOUR NAME")
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                }
                .padding(20)
                .frame(width: 280, height: 170)
                .rotationEffect(.degrees(-15))
            }
            
            Spacer()
            
            Text("Manage Your Payments with")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("mobile banking")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            
            Text("A convenient way to manage your money securely from your mobile device.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 8)
            
            Spacer()
            
            HStack {
                // Progress indicator
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
                
                Spacer()
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("Skip")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

struct OnboardingScreen2: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack {
            Spacer()
            
            ZStack {
                // Blue background shape
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 280, height: 170)
                    .cornerRadius(16)
                    .rotationEffect(.degrees(15))
                    .offset(y: -20)
                
                // Credit card
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.white)
                    .frame(width: 280, height: 170)
                    .shadow(radius: 10)
                    .rotationEffect(.degrees(-5))
                    .offset(y: 20)
                
                // Credit card details on white card
                VStack(alignment: .leading) {
                    HStack {
                        Text("1234 5678 9012 3456")
                            .font(.system(size: 16))
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "wave.3.right")
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("CARD HOLDER")
                        .font(.system(size: 10))
                        .foregroundColor(.black.opacity(0.7))
                    Text("YOUR NAME")
                        .font(.system(size: 14))
                        .foregroundColor(.black)
                }
                .padding(20)
                .frame(width: 280, height: 170)
                .rotationEffect(.degrees(-5))
                .offset(y: 20)
            }
            
            Spacer()
            
            Text("A loan for every dream with")
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
            
            Text("mobile banking")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
            
            Text("A loan facility that provides you financial assistance whenever you need.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 8)
            
            Spacer()
            
            HStack {
                // Progress indicator
                Circle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 10, height: 10)
                Circle()
                    .fill(Color.blue)
                    .frame(width: 10, height: 10)
                
                Spacer()
                
                Button(action: {
                    viewModel.goToNextStep()
                }) {
                    Text("Skip")
                        .foregroundColor(.gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(20)
                }
            }
            .padding(.horizontal, 40)
            .padding(.bottom, 40)
        }
    }
}

#Preview {
    OnboardingView(viewModel: OnboardingViewModel())
}
