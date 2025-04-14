//
//  AuthViews.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isPasswordVisible: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Login to Your Account")
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 15) {
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                HStack {
                    if isPasswordVisible {
                        TextField("Password", text: $password)
                            .autocapitalization(.none)
                    } else {
                        SecureField("Password", text: $password)
                            .autocapitalization(.none)
                    }
                    
                    Button(action: {
                        isPasswordVisible.toggle()
                    }) {
                        Image(systemName: isPasswordVisible ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 30)
            
            Button(action: {
                // Handle login action and go directly to dashboard
                viewModel.simulateSuccessfulAuthentication()
            }) {
                Text("Login")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 30)
            }
            
            HStack {
                Text("Forgot User / Password?")
                    .font(.footnote)
                    .foregroundColor(.blue)
            }
            
            Spacer()
            
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

struct SignupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var cpf: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var agreeToTerms: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Create Your Account")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.top, 40)
            
            VStack(spacing: 15) {
                TextField("Full Name", text: $fullName)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                TextField("CPF", text: $cpf)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    .keyboardType(.numberPad)
                
                HStack {
                    SecureField("Password", text: $password)
                    
                    Button(action: {}) {
                        Image(systemName: "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                HStack {
                    Toggle("", isOn: $agreeToTerms)
                        .labelsHidden()
                    
                    Text("I agree with Terms & Conditions")
                        .font(.footnote)
                }
                .padding(.horizontal)
            }
            .padding(.horizontal, 30)
            
            Button(action: {
                // Handle signup action and go directly to dashboard
                viewModel.simulateSuccessfulAuthentication()
            }) {
                Text("Sign Up")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal, 30)
            }
            
            Spacer()
            
            HStack {
                Text("Don't have an account?")
                    .font(.footnote)
                Button(action: {
                    viewModel.goToLogin()
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

#Preview {
    LoginView(viewModel: OnboardingViewModel())
}