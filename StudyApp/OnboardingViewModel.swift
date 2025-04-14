//
//  OnboardingViewModel.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

enum OnboardingStep {
    case onboarding1
    case onboarding2
    case login
    case signup
    case setFingerprint
    case fingerprintScanning
    case mobileNumber
    case otpVerification
    case newPin
}

class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .onboarding1
    @Published var showPinChangeFlow: Bool = false
    var onAuthenticationSuccess: () -> Void
    var onPinChangeSuccess: () -> Void = {}
    
    init(onAuthenticationSuccess: @escaping () -> Void = {}) {
        self.onAuthenticationSuccess = onAuthenticationSuccess
    }
    
    func goToNextStep() {
        switch currentStep {
        case .onboarding1:
            currentStep = .onboarding2
        case .onboarding2:
            currentStep = .login
        case .login:
            // Login is handled separately
            break
        case .signup:
            // Signup is handled separately
            break
        case .setFingerprint:
            currentStep = .fingerprintScanning
            // Simular verificação de impressão digital após 2 segundos
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.onAuthenticationSuccess()
            }
        case .fingerprintScanning:
            // Fingerprint scanning is handled separately
            break
        case .mobileNumber:
            currentStep = .otpVerification
        case .otpVerification:
            currentStep = .newPin
        case .newPin:
            // Handled by completePinChange
            break
        }
    }
    
    func goToLogin() {
        currentStep = .login
    }
    
    func goToSignup() {
        currentStep = .signup
    }
    
    func goToSetFingerprint() {
        // Pular a etapa de impressão digital e autenticar diretamente
        simulateSuccessfulAuthentication()
    }
    
    // Função para simular autenticação bem-sucedida
    func simulateSuccessfulAuthentication() {
        onAuthenticationSuccess()
    }
    
    // Pin Change Flow
    func startPinChangeFlow(onSuccess: @escaping () -> Void = {}) {
        self.onPinChangeSuccess = onSuccess
        self.showPinChangeFlow = true
        self.currentStep = .mobileNumber
    }
    
    func dismissPinChangeFlow() {
        self.showPinChangeFlow = false
    }
    
    func goToMobileNumber() {
        currentStep = .mobileNumber
    }
    
    func goToOTPVerification() {
        currentStep = .otpVerification
    }
    
    func goToNewPin() {
        currentStep = .newPin
    }
    
    func completePinChange() {
        // Simulate successful PIN change
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.dismissPinChangeFlow()
            self.onPinChangeSuccess()
        }
    }
}