//
//  FAQView.swift
//  DistalRadiusIdentifier
//
//  Created by Dylan Mace on 4/5/22.
//

import SwiftUI

struct FAQView: View {
    var body: some View {
        List {
            DisclosureGroup {
              Text("When you take a photo, it is sent to our proprietary machine learning model, where the image is preprocess and analyzed for markers signifying specific company implants. This model outputs a breakdown dictionary with the associated likelihood of each potential company, with the highest likelihood signifying the predicted company.")
            } label: {
                Text("How does this idenfication process work?").font(.title2).bold()
            }
            DisclosureGroup {
              Text("This is merely a tool to aid in device identification. We encourage you to double check with external sources or examples before operating")
            } label: {
                Text("Can I trust the results?").font(.title2).bold()
            }
            DisclosureGroup {
              Text("All data is kept strictly on device. Requests made to the processing server are only saved for the lifespan of the request, and are de-identified prior to submitting the request.")
            } label: {
                Text("Where is my data stored?").font(.title2).bold()
            }
            DisclosureGroup {
              Text("We are constantly working to add more implants to the classification model and the detail view. If you feel something is missing, please reach out via a review.")
            } label: {
                Text("Why isn’t my implant listed here?").font(.title2).bold()
            }
        }
        .listStyle(.plain)
        .navigationTitle("FAQ")
    }
}

struct FAQView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            FAQView()
        }
    }
}
