//
//  PinChangeViews.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

struct MobileNumberView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var mobileNumber: String = ""
    @State private var countryCode: String = "+1 123"
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    viewModel.dismissPinChangeFlow()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("Mobile Number")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding(12)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            
            // Icon and title
            VStack(spacing: 15) {
                Image(systemName: "iphone.gen3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .padding(20)
                    .background(Circle().fill(Color.blue.opacity(0.1)))
                
                Text("Mobile Number")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("We need to send OTP to authenticate\nyour number to change your pin")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 30)
            
            // Mobile number input
            VStack(alignment: .leading, spacing: 10) {
                Text("Mobile Number")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 0) {
                    // Country code
                    HStack {
                        Image(systemName: "flag")
                            .foregroundColor(.blue)
                            .frame(width: 25, height: 15)
                        
                        Text(countryCode)
                            .foregroundColor(.black)
                        
                        Image(systemName: "chevron.down")
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 12)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(8)
                    
                    // Phone number field
                    TextField("3698 789", text: $mobileNumber)
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 12)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            
            Spacer()
            
            // Next button
            Button(action: {
                viewModel.goToOTPVerification()
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct OTPVerificationView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var otpFields: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedField: Int?
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    viewModel.goToMobileNumber()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.gray)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
                
                Text("OTP Verification")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button(action: {}) {
                    Image(systemName: "xmark")
                        .foregroundColor(.red)
                        .padding(12)
                        .background(Color.red.opacity(0.1))
                        .clipShape(Circle())
                }
            }
            .padding(.horizontal)
            
            // Icon and title
            VStack(spacing: 15) {
                Image(systemName: "iphone.gen3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
                    .padding(20)
                    .background(Circle().fill(Color.blue.opacity(0.1)))
                
                Text("OTP")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Please enter the OTP send to your\nmobile number +1 123 3698 789")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
            }
            .padding(.top, 30)
            
            // OTP input fields
            HStack(spacing: 15) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $otpFields[index])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 50, height: 50)
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .focused($focusedField, equals: index)
                        .onChange(of: otpFields[index]) { newValue in
                            if newValue.count > 1 {
                                otpFields[index] = String(newValue.prefix(1))
                            }
                            
                            if newValue.count == 1 && index < 3 {
                                focusedField = index + 1
                            }
                        }
                }
            }
            .padding(.top, 30)
            
            // Resend OTP
            Button(action: {}) {
                HStack {
                    Text("Don't receive an OTP?")
                        .foregroundColor(.gray)
                    
                    Text("Resend OTP")
                        .fontWeight(.semibold)
                        .foregroundColor(.blue)
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Next button
            Button(action: {
                viewModel.goToNewPin()
            }) {
                Text("Next")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
}

struct NewPinView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var newPin: String = ""
    @State private var confirmPin: String = ""
    @State private var pinsMatch: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // Header with close button
            HStack {
                Button(action: {
                    viewModel.dismissPinChangeFlow()
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding(12)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Spacer()
            }
            .padding(.horizontal)
            
            Text("Enter New Pin")
                .font(.title2)
                .fontWeight(.bold)
            
            // New PIN input
            VStack(alignment: .leading, spacing: 10) {
                Text("Enter New Pin")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    ForEach(0..<4, id: \.self) { index in
                        if index < newPin.count {
                            Text("*")
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        } else {
                            Text("")
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .onTapGesture {
                    // Show number pad for PIN entry
                }
            }
            .padding(.top, 20)
            
            // Confirm PIN input
            VStack(alignment: .leading, spacing: 10) {
                Text("Confirm Pin Code")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack(spacing: 15) {
                    ForEach(0..<4, id: \.self) { index in
                        if index < confirmPin.count {
                            Text("*")
                                .font(.title)
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        } else {
                            Text("")
                                .frame(width: 50, height: 50)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                        }
                    }
                }
                .onTapGesture {
                    // Show number pad for PIN entry
                }
            }
            .padding(.top, 20)
            
            // PIN match indicator
            if !newPin.isEmpty && !confirmPin.isEmpty {
                HStack {
                    Image(systemName: pinsMatch ? "checkmark.circle.fill" : "xmark.circle.fill")
                        .foregroundColor(pinsMatch ? .green : .red)
                    
                    Text(pinsMatch ? "Your PIN codes are the same" : "Your PIN codes don't match")
                        .font(.subheadline)
                        .foregroundColor(pinsMatch ? .green : .red)
                }
                .padding(.top, 10)
            }
            
            // Number pad
            VStack(spacing: 15) {
                ForEach(0..<3) { row in
                    HStack(spacing: 30) {
                        ForEach(1..<4) { col in
                            let number = row * 3 + col
                            Button(action: {
                                enterDigit(number)
                            }) {
                                Text("\(number)")
                                    .font(.title)
                                    .frame(width: 60, height: 60)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                    }
                }
                
                HStack(spacing: 30) {
                    // Empty space for layout
                    Color.clear
                        .frame(width: 60, height: 60)
                    
                    Button(action: {
                        enterDigit(0)
                    }) {
                        Text("0")
                            .font(.title)
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        deleteDigit()
                    }) {
                        Image(systemName: "delete.left")
                            .font(.title2)
                            .frame(width: 60, height: 60)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(Circle())
                    }
                }
            }
            .padding(.top, 20)
            
            Spacer()
            
            // Done button
            Button(action: {
                if pinsMatch && newPin.count == 4 {
                    viewModel.completePinChange()
                }
            }) {
                Text("Done")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(pinsMatch && newPin.count == 4 ? Color.blue : Color.gray)
                    .cornerRadius(8)
            }
            .disabled(!pinsMatch || newPin.count != 4)
            .padding(.horizontal, 20)
            .padding(.bottom, 20)
        }
    }
    
    private func enterDigit(_ digit: Int) {
        if newPin.count < 4 && confirmPin.isEmpty {
            newPin += "\(digit)"
        } else if confirmPin.count < 4 {
            confirmPin += "\(digit)"
            checkPinsMatch()
        }
    }
    
    private func deleteDigit() {
        if !confirmPin.isEmpty {
            confirmPin.removeLast()
            checkPinsMatch()
        } else if !newPin.isEmpty {
            newPin.removeLast()
        }
    }
    
    private func checkPinsMatch() {
        if confirmPin.count == 4 && newPin.count == 4 {
            pinsMatch = newPin == confirmPin
        } else {
            pinsMatch = false
        }
    }
}

#Preview {
    MobileNumberView(viewModel: OnboardingViewModel())
}