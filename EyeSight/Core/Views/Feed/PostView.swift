//
//  PostView.swift
//  EyeSight
//
//  Created by Franklin Zhu on 7/17/23.
//

import SwiftUI

struct PostView: View {
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .cornerRadius(50)
                VStack (alignment: .leading){
                    Text("franklinzhu")
                        .font(.caption)
                        .fontWeight(.bold)
                    Text("New York City")
                        .font(.caption2)
                        .fontWeight(.light)
                }
                Spacer()
                Image(systemName: "person.3.sequence")
            }
            .padding(.top, 10)
            .padding(.horizontal, 8)
            
            Rectangle()
                .fill(Color.gray)
                .aspectRatio(4/5, contentMode: .fit)
                .frame(width: .infinity)
                .cornerRadius(10)
                .padding(.bottom, 16)
            
        }
        
        
    }
}

struct PostView_Previews: PreviewProvider {
    static var previews: some View {
        PostView()
    }
}
