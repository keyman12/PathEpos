import SwiftUI

struct PaymentView: View {
    let cartItems: [CartItem]
    let totalAmount: Double
    let onTransactionComplete: () -> Void
    
    @State private var selectedPaymentMethod: PaymentMethod?
    @State private var cashReceived: String = ""
    @State private var showingCashInput = false
    @State private var showingCardInput = false
    @Environment(\.dismiss) private var dismiss
    
    private let primaryColor = Color(hex: "#3B9F40")
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header - Fixed at top
                VStack(spacing: 16) {
                    HStack {
                        Text("Payment")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(primaryColor)
                        
                        Spacer()
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                
                // Scrollable content area
                ScrollView {
                    VStack(spacing: 24) {
                        // Transaction Summary
                        VStack(spacing: 16) {
                            Text("Transaction Summary")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            VStack(spacing: 8) {
                                ForEach(cartItems) { cartItem in
                                    HStack(alignment: .center) {
                                        Text(cartItem.item.name)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        
                                        Text("\(cartItem.quantity) × €\(String(format: "%.2f", cartItem.item.price))")
                                            .foregroundColor(.secondary)
                                            .frame(maxWidth: .infinity, alignment: .center)
                                        
                                        Text("€\(String(format: "%.2f", cartItem.totalPrice))")
                                            .fontWeight(.semibold)
                                            .frame(maxWidth: .infinity, alignment: .trailing)
                                    }
                                    .padding(.horizontal)
                                }
                                
                                Divider()
                                
                                HStack {
                                    Text("Total:")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                    Spacer()
                                    Text("€\(String(format: "%.2f", totalAmount))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(primaryColor)
                                }
                                .padding(.horizontal)
                            }
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                        
                        // Payment Method Selection
                        VStack(spacing: 16) {
                            Text("Select Payment Method")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            HStack(spacing: 20) {
                                PaymentMethodButton(
                                    method: .cash,
                                    isSelected: selectedPaymentMethod == .cash,
                                    onTap: { selectedPaymentMethod = .cash }
                                )
                                
                                PaymentMethodButton(
                                    method: .card,
                                    isSelected: selectedPaymentMethod == .card,
                                    onTap: { selectedPaymentMethod = .card }
                                )
                            }
                        }
                        
                        // Continue Button
                        Button(action: {
                            if selectedPaymentMethod == .cash {
                                showingCashInput = true
                            } else if selectedPaymentMethod == .card {
                                showingCardInput = true
                            }
                        }) {
                            Text("Continue")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(selectedPaymentMethod != nil ? Color(hex: "#FF5252") : Color.gray)
                                .cornerRadius(12)
                        }
                        .disabled(selectedPaymentMethod == nil)
                        .padding(.horizontal)
                        
                        // Bottom spacing to ensure button is not cut off
                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .background(Color(.systemBackground))
        }
        .sheet(isPresented: $showingCashInput) {
            CashPaymentView(totalAmount: totalAmount, onComplete: {
                onTransactionComplete()
                dismiss()
            })
        }
        .sheet(isPresented: $showingCardInput) {
            CardPaymentView(totalAmount: totalAmount, onComplete: {
                onTransactionComplete()
                dismiss()
            })
        }
        .navigationBarHidden(true)
    }
}

struct PaymentMethodButton: View {
    let method: PaymentMethod
    let isSelected: Bool
    let onTap: () -> Void
    
    private let primaryColor = Color(hex: "#3B9F40")
    
    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 12) {
                Image(systemName: method == .cash ? "banknote.fill" : "creditcard.fill")
                    .font(.system(size: 40))
                    .foregroundColor(isSelected ? .white : primaryColor)
                
                Text(method.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isSelected ? primaryColor : Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? Color.clear : primaryColor, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CashPaymentView: View {
    let totalAmount: Double
    let onComplete: () -> Void
    
    @State private var cashReceived: String = ""
    @Environment(\.dismiss) private var dismiss
    
    private let primaryColor = Color(hex: "#3B9F40")
    
    var changeAmount: Double {
        guard let received = Double(cashReceived) else { return 0 }
        return received - totalAmount
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "banknote.fill")
                        .font(.system(size: 60))
                        .foregroundColor(primaryColor)
                    
                    Text("Cash Payment")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                }
                
                // Amount Due
                VStack(spacing: 8) {
                    Text("Amount Due")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("€\(String(format: "%.2f", totalAmount))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(primaryColor)
                }
                
                // Cash Input
                VStack(spacing: 16) {
                    Text("Amount Received")
                        .font(.title2)
                        .fontWeight(.semibold)
                    
                    TextField("Enter amount", text: $cashReceived)
                        .font(.title)
                        .multilineTextAlignment(.center)
                        .keyboardType(.decimalPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .onChange(of: cashReceived) { newValue in
                            // Only allow numbers and decimal point
                            let filtered = newValue.filter { "0123456789.".contains($0) }
                            if filtered != newValue {
                                cashReceived = filtered
                            }
                        }
                }
                
                // Change Calculation
                if let received = Double(cashReceived), received >= totalAmount {
                    VStack(spacing: 8) {
                        Text("Change Due")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        
                        Text("€\(String(format: "%.2f", changeAmount))")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer()
                
                // Complete Transaction Button
                Button(action: {
                    onComplete()
                }) {
                    Text("Complete Transaction")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Double(cashReceived) ?? 0 >= totalAmount ? primaryColor : Color.gray)
                        .cornerRadius(12)
                }
                .disabled(Double(cashReceived) ?? 0 < totalAmount)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Cash Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct CardPaymentView: View {
    let totalAmount: Double
    let onComplete: () -> Void
    
    @State private var cardNumber: String = ""
    @State private var expiryDate: String = ""
    @State private var cvv: String = ""
    @State private var cardholderName: String = ""
    @State private var isProcessing = false
    @Environment(\.dismiss) private var dismiss
    
    private let primaryColor = Color(hex: "#3B9F40")
    
    var body: some View {
        NavigationView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 16) {
                    Image(systemName: "creditcard.fill")
                        .font(.system(size: 60))
                        .foregroundColor(primaryColor)
                    
                    Text("Card Payment")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryColor)
                }
                
                // Amount Due
                VStack(spacing: 8) {
                    Text("Amount Due")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    
                    Text("€\(String(format: "%.2f", totalAmount))")
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(primaryColor)
                }
                
                // Card Form
                VStack(spacing: 16) {
                    TextField("Card Number", text: $cardNumber)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                    
                    HStack {
                        TextField("MM/YY", text: $expiryDate)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                        
                        TextField("CVV", text: $cvv)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                    }
                    
                    TextField("Cardholder Name", text: $cardholderName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Spacer()
                
                // Process Payment Button
                Button(action: {
                    isProcessing = true
                    // Simulate payment processing
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isProcessing = false
                        onComplete()
                    }
                }) {
                    HStack {
                        if isProcessing {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                .scaleEffect(0.8)
                        }
                        
                        Text(isProcessing ? "Processing..." : "Process Payment")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(primaryColor)
                    .cornerRadius(12)
                }
                .disabled(isProcessing)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("Card Payment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}



#Preview {
    PaymentView(cartItems: [], totalAmount: 0.0) {}
}
