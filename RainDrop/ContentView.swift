//
//  ContentView.swift
//  RainDrop
//
//  Created by admin on 23.05.2024.
//

import SwiftUI

struct ContentView: View {
    @State private var isDragging = false
    @State private var dragAmount = CGSize.zero

    var body: some View {
        ZStack {
            // Bottom static yellow circle
            Circle()
                .fill(Color.yellow)
                .frame(width: 100, height: 100)
            
            // Draggable circle with cloud.sun.rain.fill icon
            Circle()
                .fill(isDragging ? Color.red : Color.yellow)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "cloud.sun.rain.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
                .offset(dragAmount)
//                .scaleEffect(isDragging ? 1.2 : 1.0, anchor: isDragging ? .top : .center)
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragAmount = value.translation
                        }
                        .onEnded { _ in
                            isDragging = false
                            withAnimation(.interpolatingSpring(stiffness: 100, damping: 10)) {
                                dragAmount = .zero
                            }
                        }
                )
//                .animation(.easeInOut(duration: 1.0), value: isDragging)
                .animation(.spring(.smooth, blendDuration: 1.0), value: isDragging)
        }
//        .transition(.)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all))
    }
}

#Preview {
    ContentView()
}
