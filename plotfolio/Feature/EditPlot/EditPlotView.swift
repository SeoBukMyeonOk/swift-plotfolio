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
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: .zero) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 10) {
                        TextField("Title", text: viewStore.binding(
                            get: { $0.plot.title ?? "" },
                            send: { .titleChanged($0) }
                        ))
                        
                        Button("23.04.21") {
                            
                        }
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        
                        HStack(spacing: .zero) {
                            Image(systemName: "star")
                            Image(systemName: "star")
                            Image(systemName: "star")
                            Image(systemName: "star")
                            Image(systemName: "star")
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
                                            .foregroundColor(.black)
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
                    .foregroundColor(.black)
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

struct EditPlotView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlotView(store: .init(initialState: .init(plot: PlotCloudManager.shared.newPlot), reducer: EditPlotStore()._printChanges()))
    }
}

