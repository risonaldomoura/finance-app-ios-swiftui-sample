//
//  FingerprintViews.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct SetFingerprintView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Fingerprint")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Place your finger in fingerprint sensor until scan completes")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.gray)
            
            Spacer()
            
            // Fingerprint icon
            Image(systemName: "touchid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text("Simular Autenticação")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 30)
            }
            
            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                Button(action: {
                    viewModel.goToSignup()
                }) {
                    Text("Sign Up")
                        .font(.footnote)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.bottom, 20)
        }
    }
}

struct FingerprintScanningView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var isScanning = true
    @State private var showSuccess = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text(showSuccess ? "Authentication Successful!" : "Scanning...")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(showSuccess ? .green : .primary)
            
            Text(showSuccess ? "Redirecting to dashboard..." : "Once your scanning is complete, you will be able to login by using fingerprint!")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .foregroundColor(.gray)
            
            Spacer()
            
            // Animated fingerprint icon
            Image(systemName: showSuccess ? "checkmark.circle.fill" : "touchid")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(showSuccess ? .green : .blue)
                .opacity(isScanning ? 0.5 : 1.0)
                .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isScanning)
                .onAppear {
                    isScanning = true
                    
                    // Simular verificação de impressão digital após 2 segundos
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        showSuccess = true
                        isScanning = false
                        
                        // Após mostrar o sucesso, chamar a função de autenticação bem-sucedida
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            viewModel.simulateSuccessfulAuthentication()
                        }
                    }
                }
            
            Spacer()
            
            Button(action: {
                // Return to login screen
                viewModel.goToLogin()
            }) {
                Text("Done")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 30)
            }
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    SetFingerprintView(viewModel: OnboardingViewModel())
}