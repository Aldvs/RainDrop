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
            Color.black.ignoresSafeArea()
            ExtractedView(isDragging: $isDragging, dragAmount: $dragAmount)
            Circle()
                .fill(Color.yellow)
                .frame(width: 100, height: 100)
            Circle()
                .fill(isDragging ? .red : .yellow)
                .frame(width: 100, height: 100)
                .overlay(
                    Image(systemName: "cloud.sun.rain.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.white)
                )
                .offset(dragAmount)
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
        }
        .animation(.easeInOut(duration: 1), value: isDragging)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.2).edgesIgnoringSafeArea(.all))
    }
}

struct ExtractedView: View {
    @Binding var isDragging: Bool
    @Binding var dragAmount: CGSize
    
    var body: some View {
        Canvas { context, size in
            let circle = context.resolveSymbol(id: "Circle")!
            let secondCircle = context.resolveSymbol(id: "SecondCircle")!

            context.addFilter(.alphaThreshold(min: 0.5, color: isDragging ? .yellow : .red))
            context.addFilter(.blur(radius: 15))

            // Вычисление центральной точки
            let centerX = size.width / 2
            let centerY = size.height / 2

            context.drawLayer { ctx in
                // Отрисовка круга по центру
                ctx.draw(circle, at: CGPoint(x: centerX, y: centerY))
                ctx.draw(secondCircle, at: CGPoint(x: centerX, y: centerY))
            }
        } symbols: {
            Circle()
//                .fill(Color.yellow)
                .frame(width: 100, height: 100)
                .tag("Circle")
            Circle()
//                .fill(isDragging ? Color.yellow : Color.yellow)
                .frame(width: 100, height: 100)
                .offset(dragAmount)
                .tag("SecondCircle")
                .animation(.easeInOut(duration: 0.5), value: isDragging)
            
        }
    }
}

#Preview {
    ContentView()
}
