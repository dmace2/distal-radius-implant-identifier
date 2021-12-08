//
//  SwiftUIView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 12/7/21.
//

import SwiftUI

struct ClassificationResultsRowView: View {
    var classification: Classification
    var dateString: String
    @State var tapped = false
    
    var image: Image
    
    init(_ row: Classification) {
        self.classification = row
        let dateFormatter = DateFormatter()

        // Set Date/Time Style
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        // Convert Date to String
        dateString = dateFormatter.string(from: row.date) // September 9, 2020 at 12:24 PM
        image = Image(classification.image, scale: 1.0, label: Text(""))
        
    }
    
    
    
    
    
    var body: some View {
        HStack {
            VStack(alignment:.leading) {
                image
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .frame(width: 150, height: 150, alignment: .center)
                    .onTapGesture {
                        tapped.toggle()
                    }
                    .fullScreenCover(isPresented: $tapped) {
                        FullScreenImageView(image: image)
                    }
                Text(dateString).font(.footnote).bold().foregroundColor(Color("AccentLight"))
            }
            Spacer()
            VStack(alignment: .trailing) {
                Text(classification.results[0].company).font(.title).bold().foregroundColor(Color("AccentLight"))
                Text(String(format: "%.2f", classification.results[0].percentage) + "%").font(.title3).bold().foregroundColor(.secondary)
            }
        }
            
    }
}

//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//        ClassificationResultsRowView()
//    }
//}
