//
//  DSTextField.swift
//  Sunset
//
//  Created by Faozi Bouybaouene on 9/3/24.
//

import SwiftUI

struct DSTextField: View {
    @EnvironmentObject var viewModel: WelcomeViewModel
    @FocusState var isTextFieldFocused: Bool
    @Binding var valueTextField: String
    @Binding var isFieldValid: Bool?
    var validator: SunsetTextFieldValidator
    var textFieldTitle: String.LocalizationValue
    var isSecure: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 180)
            .stroke(isTextFieldFocused ? .primaryBackgroundLogin : .neutralBorderDefault,
                    lineWidth: 2)
            .fill(.neutralBackgroundDefault)
            .frame(width: 340, height: 50)
            .overlay {
                HStack {
                    if !isSecure {
                        TextField(String(localized:textFieldTitle), text: $valueTextField)
                            .sunsetStyles()
                            .onChange(of: valueTextField, {
                                withAnimation {
                                    switch validator {
                                    case .username:
                                        isFieldValid = DSTextfieldValidators.username(valueTextField)
                                    case .email:
                                        isFieldValid = DSTextfieldValidators.email(valueTextField)
                                    case .password:
                                        isFieldValid = DSTextfieldValidators.password(valueTextField)
                                    }
                                }
                            })
                            .focused($isTextFieldFocused)
                    } else {
                        SecureField(String(localized:textFieldTitle), text: $valueTextField)
                            .sunsetStyles()
                            .onChange(of: valueTextField, {
                                withAnimation {
                                    switch validator {
                                    case .username:
                                        isFieldValid = DSTextfieldValidators.username(valueTextField)
                                    case .email:
                                        isFieldValid = DSTextfieldValidators.email(valueTextField)
                                    case .password:
                                        isFieldValid = DSTextfieldValidators.password(valueTextField)
                                    }
                                }
                            })
                            .focused($isTextFieldFocused)
                    }
                    if let isFieldValid {
                        if !isFieldValid {
                            Image(systemName: "info.circle.fill")
                                .foregroundStyle(.blue)
                                .onTapGesture {
                                    viewModel.populateAlertItemTextfield(validator: validator)
                                    viewModel.textFieldInfoAlertIsPresented = true
                                }
                        }
                        Image(systemName: isFieldValid ? "checkmark.circle" : "xmark.circle")
                            .padding(.trailing, 16)
                            .foregroundStyle(isFieldValid ? .green : .red)
                            .shadow(radius: 1)
                    }
                }
                .alert(viewModel.alertItem?.title ?? Text(""),
                       isPresented: $viewModel.textFieldInfoAlertIsPresented) {
                    //NO ACTIONS NEEDED
                } message: {
                    viewModel.alertItem?.message
                }

            }
    }
}
