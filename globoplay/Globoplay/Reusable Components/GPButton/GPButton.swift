//
//  GPButton.swift
//  Globoplay
//
//  Created by Murilo on 19/12/24.
//

import SwiftUI

enum ButtonType {
    case watch
    case myList
}

struct GPButton: View {
    var type: ButtonType
    var action: () -> Void
    @Binding var isAdded: Bool

    init(type: ButtonType, action: @escaping () -> Void) {
        self.type = type
        self.action = action
        self._isAdded = Binding.constant(false)
    }

    init(type: ButtonType, isAdded: Binding<Bool>, action: @escaping () -> Void) {
        self.type = type
        self._isAdded = isAdded
        self.action = action
    }

    var body: some View {
        Button(action: {
            if type == .myList {
                isAdded.toggle()
            }
            action()
        }) {
            HStack {
                buttonContent
            }
            .frame(height: 50)
            .frame(maxWidth: .infinity)
            .background(buttonBackgroundColor)
            .cornerRadius(5)
            .overlay(RoundedRectangle(cornerRadius: 5).stroke(Color.white, lineWidth: 1))
        }
        .buttonStyle(PlainButtonStyle())
    }

    private var buttonContent: some View {
        Group {
            switch type {
            case .watch:
                Image(systemName: "play.fill")
                    .foregroundColor(.black)
                Text("Assista")
                    .font(Font.title2.bold())
                    .foregroundColor(.black)
            case .myList:
                if isAdded {
                    Image(systemName: "checkmark")
                        .foregroundColor(.white)
                    Text("Adicionado")
                        .font(Font.title2.bold())
                        .foregroundColor(.white)
                } else {
                    Image(systemName: "star.fill")
                        .foregroundColor(.white)
                    Text("Minha lista")
                        .font(Font.title2.bold())
                        .foregroundColor(.white)
                }
            }
        }
    }

    private var buttonBackgroundColor: Color {
        switch type {
        case .watch:
            return Color.white
        case .myList:
            return Color.black
        }
    }
}
