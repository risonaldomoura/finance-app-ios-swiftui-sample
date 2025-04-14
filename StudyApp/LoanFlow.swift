//
//  LoanFlow.swift
//  StudyApp
//
//  Created by Trae AI on 13/04/25.
//

import SwiftUI

enum LoanStep {
    case overview
    case loanType
    case paymentDetails
    case summary
    case success
}

class LoanViewModel: ObservableObject {
    @Published var currentStep: LoanStep = .overview
    @Published var selectedLoanType: LoanType? = nil
    @Published var loanAmount: String = ""
    @Published var duration: Int = 6 // Default 6 months
    @Published var interestRate: Double = 4.5 // Default interest rate
    @Published var monthlyPayment: Double = 0.0
    @Published var totalInterest: Double = 0.0
    @Published var dueDate: Date = Calendar.current.date(byAdding: .month, value: 1, to: Date()) ?? Date()
    
    let loanTypes: [LoanType] = [
        LoanType(name: "Home Loan", icon: "house.fill", color: .blue, baseAmount: "$10000.00"),
        LoanType(name: "Business Loan", icon: "briefcase.fill", color: .orange, baseAmount: "$15000.00"),
        LoanType(name: "Education Loan", icon: "book.fill", color: .purple, baseAmount: "$8000.00"),
        LoanType(name: "Car Loan", icon: "car.fill", color: .green, baseAmount: "$6000.00")
    ]
    
    func goToNextStep() {
        switch currentStep {
        case .overview:
            currentStep = .loanType
        case .loanType:
            currentStep = .paymentDetails
        case .paymentDetails:
            currentStep = .summary
        case .summary:
            currentStep = .success
        case .success:
            // Handled by dismissFlow
            break
        }
    }
    
    func goBack() {
        switch currentStep {
        case .overview:
            // Exit flow
            break
        case .loanType:
            currentStep = .overview
        case .paymentDetails:
            currentStep = .loanType
        case .summary:
            currentStep = .paymentDetails
        case .success:
            // Cannot go back from success
            break
        }
    }
    
    func selectLoanType(_ type: LoanType) {
        selectedLoanType = type
        loanAmount = type.baseAmount.replacingOccurrences(of: "$", with: "")
        calculatePayment()
    }
    
    func dismissFlow() {
        // Reset and exit flow
        currentStep = .overview
        loanAmount = ""
        selectedLoanType = nil
    }
    
    func calculatePayment() {
        guard let amount = Double(loanAmount.replacingOccurrences(of: "$", with: "")) else {
            monthlyPayment = 0.0
            totalInterest = 0.0
            return
        }
        
        // Monthly interest rate
        let monthlyRate = interestRate / 100 / 12
        
        // Calculate monthly payment using loan formula
        let monthlyPaymentValue = amount * monthlyRate * pow(1 + monthlyRate, Double(duration)) / (pow(1 + monthlyRate, Double(duration)) - 1)
        
        monthlyPayment = monthlyPaymentValue
        totalInterest = (monthlyPaymentValue * Double(duration)) - amount
    }
    
    func formatCurrency(_ value: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "$"
        return formatter.string(from: NSNumber(value: value)) ?? "$0.00"
    }
    
    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        return formatter.string(from: date)
    }
}

struct LoanType: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
    let baseAmount: String
}

struct LoanView: View {
    @StateObject private var viewModel = LoanViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            switch viewModel.currentStep {
            case .overview:
                LoanOverviewView(viewModel: viewModel)
            case .loanType:
                LoanTypeSelectionView(viewModel: viewModel)
            case .paymentDetails:
                LoanPaymentDetailsView(viewModel: viewModel)
            case .summary:
                LoanSummaryView(viewModel: viewModel)
            case .success:
                LoanSuccessView(viewModel: viewModel)
            }
        }
        .navigationBarTitle("Loan", displayMode: .inline)
        .navigationBarItems(leading: Button(action: {
            if viewModel.currentStep == .overview {
                presentationMode.wrappedValue.dismiss()
            } else {
                viewModel.goBack()
            }
        }) {
            Image(systemName: "chevron.left")
                .foregroundColor(.gray)
                .padding(8)
                .background(Circle().fill(Color.gray.opacity(0.2)))
        })
    }
}

struct LoanOverviewView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Car Loan")
                    .font(.headline)
                
                // Loan progress circle
                ZStack {
                    Circle()
                        .stroke(Color.gray.opacity(0.2), lineWidth: 15)
                        .frame(width: 150, height: 150)
                    
                    Circle()
                        .trim(from: 0, to: 0.5) // 50% progress
                        .stroke(Color.blue, style: StrokeStyle(lineWidth: 15, lineCap: .round))
                        .frame(width: 150, height: 150)
                        .rotationEffect(.degrees(-90))
                    
                    VStack {
                        Text("50%")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                }
                .padding(.vertical)
                
                // Loan amount
                HStack {
                    Text("$6000.76")
                        .font(.title)
                        .fontWeight(.bold)
                }
                
                // Loan stats
                HStack(spacing: 0) {
                    VStack {
                        Text("Total")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("$ 6000.00")
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Paid")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("$ 3000.00")
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.green.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                    
                    VStack {
                        Text("Due")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("$ 3000.00")
                            .font(.subheadline)
                            .padding(10)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(8)
                    }
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
                
                Divider()
                    .padding(.vertical)
                
                // Recommended loans
                Text("Recommended Loan")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    ForEach(viewModel.loanTypes) { loanType in
                        HStack {
                            ZStack {
                                Circle()
                                    .fill(loanType.color.opacity(0.1))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: loanType.icon)
                                    .foregroundColor(loanType.color)
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(loanType.name)
                                    .font(.headline)
                                
                                Text("Amount: \(loanType.baseAmount)")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                viewModel.selectLoanType(loanType)
                                viewModel.currentStep = .paymentDetails
                            }) {
                                Text("Apply")
                                    .font(.caption)
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.blue)
                                    .cornerRadius(12)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
                    }
                }
                .padding(.horizontal)
                
                // Botão Continue removido conforme solicitado
            }
        }
    }
}

struct LoanTypeSelectionView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            // Loan type selection
            VStack(alignment: .leading, spacing: 15) {
                Text("Home Loan")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack {
                    Image(systemName: "house.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.blue)
                    
                    Text("Amount: $10000.00/mo")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.blue.opacity(0.1))
                .cornerRadius(12)
                .padding(.horizontal)
            }
            
            // Duration selection
            VStack(alignment: .leading, spacing: 15) {
                Text("Duration")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(spacing: 15) {
                    Button(action: {
                        viewModel.duration = 6
                        viewModel.calculatePayment()
                    }) {
                        Text("6 Months")
                            .foregroundColor(viewModel.duration == 6 ? .white : .blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.duration == 6 ? Color.blue : Color.blue.opacity(0.1))
                            )
                    }
                    
                    Button(action: {
                        viewModel.duration = 8
                        viewModel.calculatePayment()
                    }) {
                        Text("8 Months")
                            .foregroundColor(viewModel.duration == 8 ? .white : .blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.duration == 8 ? Color.blue : Color.blue.opacity(0.1))
                            )
                    }
                    
                    Button(action: {
                        viewModel.duration = 10
                        viewModel.calculatePayment()
                    }) {
                        Text("10 Months")
                            .foregroundColor(viewModel.duration == 10 ? .white : .blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.duration == 10 ? Color.blue : Color.blue.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal)
            }
            
            // Enter information
            VStack(alignment: .leading, spacing: 15) {
                Text("Enter Your Information")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    TextField("Name", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("CNIC", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Mobile", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(.phonePad)
                    
                    HStack {
                        SecureField("Password", text: .constant(""))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Button(action: {}) {
                            Image(systemName: "eye")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "touchid")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct LoanPaymentDetailsView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Payment Plan")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Loan type info
            if let selectedLoanType = viewModel.selectedLoanType {
                VStack(alignment: .leading, spacing: 15) {
                    Text(selectedLoanType.name)
                        .font(.headline)
                        .padding(.horizontal)
                    
                    HStack {
                        Image(systemName: selectedLoanType.icon)
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(selectedLoanType.color)
                        
                        Text("Amount: \(selectedLoanType.baseAmount)/mo")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(selectedLoanType.color.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            
            // Duration selection
            VStack(alignment: .leading, spacing: 15) {
                Text("Duration")
                    .font(.headline)
                    .padding(.horizontal)
                
                HStack(spacing: 15) {
                    Button(action: {
                        viewModel.duration = 6
                        viewModel.calculatePayment()
                    }) {
                        Text("6 Months")
                            .foregroundColor(viewModel.duration == 6 ? .white : .blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.duration == 6 ? Color.blue : Color.blue.opacity(0.1))
                            )
                    }
                    
                    Button(action: {
                        viewModel.duration = 8
                        viewModel.calculatePayment()
                    }) {
                        Text("8 Months")
                            .foregroundColor(viewModel.duration == 8 ? .white : .blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.duration == 8 ? Color.blue : Color.blue.opacity(0.1))
                            )
                    }
                    
                    Button(action: {
                        viewModel.duration = 10
                        viewModel.calculatePayment()
                    }) {
                        Text("10 Months")
                            .foregroundColor(viewModel.duration == 10 ? .white : .blue)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(viewModel.duration == 10 ? Color.blue : Color.blue.opacity(0.1))
                            )
                    }
                }
                .padding(.horizontal)
            }
            
            // Enter information
            VStack(alignment: .leading, spacing: 15) {
                Text("Enter Your Information")
                    .font(.headline)
                    .padding(.horizontal)
                
                VStack(spacing: 15) {
                    TextField("Name", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("CNIC", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                    
                    TextField("Mobile", text: .constant(""))
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .keyboardType(.phonePad)
                    
                    HStack {
                        SecureField("Password", text: .constant(""))
                            .padding()
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                        
                        Button(action: {}) {
                            Image(systemName: "eye")
                                .foregroundColor(.gray)
                        }
                        
                        Button(action: {}) {
                            Image(systemName: "touchid")
                                .foregroundColor(.gray)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct LoanSummaryView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Payment Plan")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Reckoning section
            Text("Reckoning")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            // Payment details
            VStack(spacing: 15) {
                HStack {
                    Text("Loan Amount")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("$12,580.00")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Interest")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("$4800.00")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Due Date")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("Nov 12, 2023")
                        .fontWeight(.medium)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Divider()
                .padding(.vertical)
            
            // Payment breakdown
            Text("Payment Breakdown")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                HStack {
                    Text("Upcoming Payment")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("12 Jan")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Amount")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Text("$80.00")
                        .fontWeight(.medium)
                }
                
                HStack {
                    Text("Auto Payment")
                        .foregroundColor(.gray)
                    
                    Spacer()
                    
                    Toggle("", isOn: .constant(true))
                }
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .cornerRadius(12)
            .padding(.horizontal)
            
            Spacer()
            
            Button(action: {
                viewModel.goToNextStep()
            }) {
                Text("Continue")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

struct LoanSuccessView: View {
    @ObservedObject var viewModel: LoanViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            Text("Congratulations!")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            
            Text("Your loan request is accepted, you will get the loan soon.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
                .padding(.horizontal)
            
            // Success illustration
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .frame(width: 80, height: 80)
                .foregroundColor(.green)
                .padding()
            
            // People illustration
            Image(systemName: "person.2.fill")
                .resizable()
                .frame(width: 120, height: 60)
                .foregroundColor(.blue)
                .padding()
            
            Spacer()
            
            Button(action: {
                viewModel.dismissFlow()
            }) {
                Text("Close")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom)
        }
    }
}

// Extension for NumberFormatter
extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}