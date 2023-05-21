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
    @State private var text: String = ""
    @State var name: String = ""
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: .zero) {
                HStack(alignment: .firstTextBaseline) {
                    VStack(alignment: .leading, spacing: 10) {
                        Button("Date") {
                            
                        }
                        .foregroundColor(.black)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        
                        TextField("Title", text: $name)
                            .padding(.bottom)
                        
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
                                    action: {},
                                    label: {
                                        Image(systemName: "circle")
                                            .imageScale(.small)
                                            .font(.footnote)
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
                    TextEditor(text: $text)
                        .padding()
                        .foregroundColor(.black)
                        .lineSpacing(5)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct EditPlotView_Previews: PreviewProvider {
    static var previews: some View {
        EditPlotView(store: .init(initialState: .init(), reducer: EditPlotStore()._printChanges()))
    }
}

