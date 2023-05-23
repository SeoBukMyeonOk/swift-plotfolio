//
//  EditPlotView.swift
//  plotfolio
//
//  Created by 송영모 on 2023/05/21.
//

import SwiftUI

import ComposableArchitecture

struct EditPlotView: View {
    public let store: StoreOf<EditPlotStore>
    
    @Environment(\.colorScheme) var colorScheme
    @State private var calendarId: UUID = UUID()
    var rating: CGFloat = 2.3
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: .zero) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Title", text: viewStore.binding(
                            get: { $0.plot.title ?? "" },
                            send: { .titleChanged($0) }
                        ))
                        .font(.title3)
                        .fontWeight(.semibold)
                        
                        DatePicker(
                            "",
                            selection: viewStore.binding(get: \.date, send: EditPlotStore.Action.dateChanged),
                            displayedComponents: [.date]
                        )
                        .id(calendarId)
                        .onChange(of: viewStore.date, perform: { _ in
                            calendarId = UUID()
                        })
                        .frame(width: 40)
                        .padding(.horizontal)
                        .padding(.bottom, 50)
                        
                        let stars = HStack(spacing: 0) {
                            ForEach(0..<5, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }
                            .contentShape(Rectangle())
                            .gesture(
                                DragGesture()
                                    .onChanged { val in
                                        var scaledX = val.location.x
                                        scaledX = scaledX < 0 ? 0.0 : scaledX
                                        scaledX = scaledX > 100 ? 100.0 : scaledX
                                        let point = round(scaledX / 100.0 * 5 * 10) / 10
                                        
                                        viewStore.send(.pointChanged(point))
                                    }
                            )
                            .frame(width: 100)
                        HStack {
                            stars.overlay(
                                GeometryReader { g in
                                    let width = viewStore.state.point / CGFloat(5) * g.size.width
                                    ZStack(alignment: .leading) {
                                        Rectangle()
                                            .frame(width: width)
                                            .foregroundColor(.yellow)
                                    }
                                }
                                    .mask(stars)
                            )
                            .foregroundColor(.gray)
                            
                            Text("\(viewStore.state.point, specifier: "%.1f")")
                                .font(.subheadline)
                                .fontWeight(.semibold)
                            
                            Button(action: {
                                viewStore.send(.pointChanged(0), animation: .default)
                            }, label: {
                                Image(systemName: "arrow.counterclockwise")
                                    .imageScale(.small)
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                            })
                        }
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .leading) {
                        ForEach(PlotType.allCases, id: \.self) { type in
                            HStack {
                                Button(
                                    action: {
                                        viewStore.send(.typeChanged(type.int16), animation: .default)
                                    },
                                    label: {
                                        Image(systemName: viewStore.state.type == type.int16 ? "circle.fill" : "circle")
                                            .imageScale(.small)
                                            .font(.footnote)
                                            .foregroundColor(colorScheme == .light ? .black : .white)
                                    })
                                
                                Text("\(type.rawValue)")
                                    .font(.footnote)
                                    .fontWeight(.medium)
                            }
                        }
                    }
                }
                .padding()
                
                Divider()
                    .padding(.horizontal)
                
                VStack {
                    TextEditor(
                        text: viewStore.binding(
                            get: { $0.plot.content ?? "" },
                            send: { .contentChanged($0) }
                        )
                    )
                    .padding()
                    .lineSpacing(5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct EditPlotView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPlotView(store: .init(initialState: .init(plot: PlotCloudManager.shared.newPlot), reducer: EditPlotStore()._printChanges()))
//    }
//}
