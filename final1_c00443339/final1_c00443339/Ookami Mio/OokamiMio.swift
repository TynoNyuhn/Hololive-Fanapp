//
//  OokamiMio.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/24/21.
//

import SwiftUI
import AVKit
import AVFoundation

struct OokamiMio: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var videoName = "MV1"
    @State var videoPlayer = AVPlayer(url: Bundle.main.url(forResource: "MV1", withExtension: "mp4")!)
    @State var videos = ["MioDuck", "HMC2"]
    @State var videoPosition = 0
    @State var mediaTypes  = ["BGM", "Music Videos", "Random Videos"]
    @State var mediaChoice = 0
    @State var images = ["MV1", "MV2", "MV3"]
    @State var audioPlayer: AVAudioPlayer!
    @State var soundFile = "MioBGM"
    @State var BGMs = ["MioBGM"]
    @State var muted: Bool = false
    @State private var comment: String = ""
    @State private var inputComment: String = ""
    @State private var name: String = ""
    @State private var inputtedName: String = "Anonymous"
    @State private var emptyComment: Bool = false;
    @State private var pageName: String = "OokamiMio"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Ookami Mio")
                    .font(.pixelate(size:36))
                    .bold()
                    .foregroundColor(Color.red)
                Picker(selection: $mediaChoice, label:Text("Media Types")) {
                    ForEach(0..<mediaTypes.count) { index in
                        Text("\(self.mediaTypes[index])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
                    .background(Color.gray)
                if (mediaChoice == 0) {
                    Button {
                        self.muted = !muted
                        if (muted) {
                            self.audioPlayer.pause()
                        }
                        else {
                            self.audioPlayer.play()
                        }
                    } label: {
                        Image(soundFile)
                            .resizable()
                            .frame(height:220)
                    }.onAppear() {
                        loadSounds(soundFile)
                        self.audioPlayer.numberOfLoops = -1
                        if (!muted) {
                            self.audioPlayer.play()
                        }
                    }.onDisappear() {
                        self.audioPlayer.pause()
                    }
                    ScrollView(.horizontal, showsIndicators:false) { // Show Thumbnails for BGMs
                        HStack {
                            ForEach(self.BGMs, id: \.self) { image in
                                Button {
                                    self.soundFile = image
                                    self.audioPlayer.stop()
                                    loadSounds(soundFile)
                                    self.audioPlayer.numberOfLoops = -1
                                    self.audioPlayer.play()
                                    self.muted = false
                                    
                                }
                            label: {
                                if (soundFile == image) {
                                    if (!muted) {
                                        Image(image)
                                            .resizable()
                                            .frame(width: 160, height: 90)
                                            .overlay(Rectangle()
                                                        .strokeBorder(Color.green, lineWidth: 5))
                                    }
                                    else {
                                        Image(image)
                                            .resizable()
                                            .frame(width: 160, height: 90)
                                            .overlay(Rectangle()
                                                        .strokeBorder(Color.red, lineWidth: 5))
                                    }
                                }
                                else {
                                    Image(image)
                                        .resizable()
                                        .frame(width: 160, height: 90)
                                }
                            }
                            }
                        }
                    }
                }
                
                if (mediaChoice != 0) {
                    VideoPlayer(player: videoPlayer)
                        .frame(height:220)
                        .overlay(Rectangle()
                                    .strokeBorder(
                                        LinearGradient(gradient: Gradient(colors: [.red, .black]), startPoint: .leading, endPoint: .trailing),
                                        lineWidth: 5
                                    )
                        ).onAppear {
                            self.videoPlayer.play()
                        }.onDisappear {
                            self.videoPlayer.pause()
                        }
                }
                ScrollView(.horizontal, showsIndicators:false) { // Show Thumbnails for Music Videos
                    if (mediaChoice == 1) {
                        HStack {
                            ForEach(self.images, id: \.self) { image in
                                Button {
                                    self.videoName = image
                                    self.videoPlayer.pause()
                                    self.videoPlayer = AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mp4")!)
                                    self.videoPlayer.play()
                                }
                            label: {
                                if (videoName == image) {
                                    Image(image)
                                        .resizable()
                                        .frame(width: 160, height: 90)
                                        .overlay(Rectangle()
                                                    .strokeBorder(Color.green, lineWidth: 5))
                                }
                                else {
                                    Image(image)
                                        .resizable()
                                        .frame(width: 160, height: 90)
                                }
                            }
                            }
                        }
                    }
                    if (mediaChoice == 2) { // Show Thumbnails for Random Videos
                        HStack {
                            ForEach(self.videos, id: \.self) { image in
                                Button {
                                    self.videoName = image
                                    self.videoPlayer.pause()
                                    self.videoPlayer = AVPlayer(url: Bundle.main.url(forResource: videoName, withExtension: "mp4")!)
                                    self.videoPlayer.play()
                                }
                            label: {
                                if (videoName == image) {
                                    Image(image)
                                        .resizable()
                                        .frame(width: 160, height: 90)
                                        .overlay(Rectangle()
                                                    .strokeBorder(Color.green, lineWidth: 5))
                                }
                                else {
                                    Image(image)
                                        .resizable()
                                        .frame(width: 160, height: 90)
                                }
                            }
                            }
                        }
                    }
                }
                VStack {
                    
                    Text("A black haired kemomimi girl who appeared on our radar randomly. She often shows up around shrines. She likes gaming.")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.red)
                    Text("Mio has a very motherly and caring personality.\nShe also likes to engage in fortune tellings and destiny")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.red)
                    Text("Birthday: August 20th\nDebut Date: December 7, 2018\nFanbase: Mio-fa")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.red)
                    HStack {
                        VStack {
                        Link(destination: URL(string: "https://www.youtube.com/channel/UCp-5t9SrOQwXMU7iIjQfARg")!) {
                            Image("YouTube")
                                .resizable()
                                .frame(width:70, height: 35)
                                .padding()
                        }
                        }
                        VStack {
                        Link(destination: URL(string: "https://twitter.com/ookamimio")!) {
                            Image("Twitter")
                                .resizable()
                                .frame(width:50, height: 35)
                                .padding()
                        }
                        }
                    }
                }
                Divider()
                Text("Comments")
                    .font(.pixelate(size: 54))
                    .bold()
                    .foregroundColor(Color.red)
                VStack {
                    TextField("Enter Name (Optional):", text: $name)
                        .padding()
                        .frame(width:400, height: 50, alignment: .trailing)
                        .border(Color.gray, width:4)
                        .background(Color.white)
                    TextField("Add an everlasting comment", text: $comment)
                        .padding()
                        .frame(width: 400, height: 50, alignment: .top)
                        .border(Color.gray, width: 4)
                        .background(Color.white)
                    Button {
                        self.emptyComment = false
                        addComment()
                        addName()
                        if (self.inputComment != "") {
                            addItem()
                        }
                        else {
                            self.emptyComment = true
                        }
                    } label: {
                        Text("Add Comment")
                            .font(.pixelate(size: 14))
                            .padding()
                    }.alert(isPresented: $emptyComment) {
                        Alert(title: Text("Empty Comment"), message: Text("You must enter something into the comment field to submit."), dismissButton: .default(Text("OK")))
                    }
                }
                
                ScrollView {
                    ForEach(items.reversed()) { item in
                        if (item.character == self.pageName) {
                            VStack(alignment: .leading) {
                                Text("\(item.userName!)")
                                    .font(.title)
                                Text("\(item.comment!)")
                                Text("\(item.timestamp!, formatter: itemFormatter)")
                                Divider()
                            }.padding()
                        }
                    }.background(Color.gray)
                }.frame(height: 200)
            }
            Spacer()
        }
        
        .onDisappear() {
            self.videoPlayer.pause()
            
        }.background(Color.black.ignoresSafeArea())
    
    }
    
    func addComment() {
        self.inputComment = self.comment
    }
    func addName() {
        if (self.name == "") {
            self.inputtedName = "Anonymous"
        }
        else {
            self.inputtedName = self.name
        }
    }
    
    func loadSounds(_ soundFileName: String) {
        guard let soundURL = Bundle.main.url(forResource: soundFileName, withExtension: "mp3") else {
            fatalError("Unable to find \(soundFileName) in bundle")
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
        } catch {
            print(error.localizedDescription)
        }
    }
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
            newItem.character = self.pageName
            newItem.comment = self.inputComment
            newItem.userName = self.inputtedName
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct OokamiMio_Previews: PreviewProvider {
    static var previews: some View {
        OokamiMio()
    }
}
