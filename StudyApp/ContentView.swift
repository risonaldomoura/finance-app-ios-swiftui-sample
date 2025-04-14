//
//  ContentView.swift
//  StudyApp
//
//  Created by Risonaldo Moura on 13/04/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
            Text("Risonaldo Moura")
                .bold()
            Button(/*@START_MENU_TOKEN@*/"Button"/*@END_MENU_TOKEN@*/) {
                print("toast")
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
