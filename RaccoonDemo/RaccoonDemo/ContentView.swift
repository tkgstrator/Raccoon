//
//  ContentView.swift
//  RaccoonDemo
//
//  Created by devonly on 2024/05/03.
//

import SwiftUI
import Raccoon
import SDWebImageSwiftUI

struct ContentView: View {
    @State private var selection: Int = 0
    
    var body: some View {
        TabView(selection: $selection,
                content:  {
            FontView()
                .tag(0)
                .tabItem({
                    Image(systemName: "text.word.spacing")
                })
            ImageView()
                .tag(1)
                .tabItem({
                    Image(systemName: "photo.on.rectangle.angled")
                })
        })
    }
    
    private struct FontView: View {
        @State private var isPresented: Bool = false
        
        var body: some View {
            NavigationView(content: {
                ScrollView(content: {
                    Text("初めて会った日、そう、あのチラズで。彼女は僕に笑いかけてくれた。一輪の花のように。彼女を想うだけで胸が高鳴る。こんな気持ちは初めてだ。今日もいつものように周りを照らしているのだろうか？")
                        .font(.custom(isPresented ? .Splatfont1 : .Splatfont2, size: 14))
                })
                .navigationTitle("FontView")
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing, content: {
                        Toggle(isOn: $isPresented, label: {
                            Text("Style")
                        })
                        .toggleStyle(.switch)
                    })
                })
            })
        }
    }
    
    private struct ImageView: View {
        var body: some View {
            NavigationView(content: {
                ScrollView(content: {
                    LazyVGrid(columns: .init(repeating: .init(.flexible()), count: 4), content: {
                        ForEach(Media.SP3.PNG.allCases, content: { asset in
                            WebImage(url: asset.assetURL)
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .bottom, content: {
                                    Text(asset.assetURL.lastPathComponent)
                                })
                        })
                        ForEach(Media.SP3.SVG.allCases, content: { asset in
                            WebImage(url: asset.assetURL)
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .bottom, content: {
                                    Text(asset.assetURL.lastPathComponent)
                                })
                        })
                        ForEach(Media.SP2.PNG.allCases, content: { asset in
                            WebImage(url: asset.assetURL)
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .bottom, content: {
                                    Text(asset.assetURL.lastPathComponent)
                                })
                        })
                    })
                })
                .navigationTitle("ImageView")
            })
        }
    }
}

#Preview {
    ContentView()
}
