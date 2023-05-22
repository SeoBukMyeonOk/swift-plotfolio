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
    
    @State private var calendarId: UUID = UUID()
    var rating: CGFloat = 2.3
    var maxRating: Int = 5
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: .zero) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Title", text: viewStore.binding(
                            get: { $0.plot.title ?? "" },
                            send: { .titleChanged($0) }
                        ))
                        
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
                        
                        let stars = HStack(spacing: 0) {
                            ForEach(0..<maxRating, id: \.self) { _ in
                                Image(systemName: "star.fill")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                            }
                        }

                        stars.overlay(
                            GeometryReader { g in
                                let width = rating / CGFloat(maxRating) * g.size.width
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .frame(width: width)
                                        .foregroundColor(.yellow)
                                }
                                let _ = print(g)
                            }
                            .mask(stars)
                        )
                        .foregroundColor(.gray)
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
                                            .foregroundColor(.gray)
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
            .navigationBarItems(
                trailing: HStack(spacing: 20) {
                    Button("Save") {
                        viewStore.send(.saveButtonTapped)
                    }
                }
            )
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

//struct EditPlotView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditPlotView(store: .init(initialState: .init(plot: PlotCloudManager.shared.newPlot), reducer: EditPlotStore()._printChanges()))
//    }
//}
