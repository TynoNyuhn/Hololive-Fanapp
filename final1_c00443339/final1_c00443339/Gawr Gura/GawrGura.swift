//
//  GawrGura.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/24/21.
//

import SwiftUI
import AVKit
import AVFoundation

struct GawrGura: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var videoName = "GC1"
    @State var videoPlayer = AVPlayer(url: Bundle.main.url(forResource: "GC1", withExtension: "mp4")!)
    @State var videos = ["GC1", "AC1","GC2","GC3","GC4","GC5","GC6"]
    @State var videoPosition = 0
    @State var mediaTypes  = ["BGM", "Music Videos", "Random Videos"]
    @State var mediaChoice = 2
    @State var images = ["GV1", "GV2","TKV3", "GV3"]
    @State var audioPlayer: AVAudioPlayer!
    @State var soundFile = "GBGM"
    @State var BGMs = ["GBGM", "GBGM2", "GBGM3"]
    @State var muted: Bool = false
    @State private var comment: String = ""
    @State private var inputComment: String = ""
    @State private var name: String = ""
    @State private var inputtedName: String = "Anonymous"
    @State private var emptyComment: Bool = false;
    @State private var pageName: String = "GawrGura"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Gawr Gura")
                    .font(.gura(size:52))
                    .bold()
                Picker(selection: $mediaChoice, label:Text("Media Types")) {
                    ForEach(0..<mediaTypes.count) { index in
                        Text("\(self.mediaTypes[index])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
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
                                        LinearGradient(gradient: Gradient(colors: [.blue, .white]), startPoint: .leading, endPoint: .trailing),
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
                    
                    Text("A descendant of the Lost City of Atlantis, who swam to Earth while saying, \"It's so boring down there LOLOLOL!\" Gura bought her clothes (and her shark hat) in the human world and she really loves them. In her spare time, she enjoys talking to marine life.")
                        .font(.gura(size:27))
                        .padding()
                    Text("\"a\" - Gawr Gura")
                        .font(.gura(size:27))
                        .padding()
                    Text("Birthday: June 20th\nDebut Date: September 13, 2020\nFanbase: Chumbuds")
                        .font(.gura(size:27))
                        .padding()
                    HStack {
                        VStack {
                        Link(destination: URL(string: "https://www.youtube.com/channel/UCoSrY_IQQVpmIRZ9Xf-y93g")!) {
                            Image("YouTube")
                                .resizable()
                                .frame(width:70, height: 35)
                                .padding()
                        }
                        }
                        VStack {
                        Link(destination: URL(string: "https://twitter.com/gawrgura")!) {
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
                            .foregroundColor(Color.white)
                    }.alert(isPresented: $emptyComment) {
                        Alert(title: Text("Empty Comment"), message: Text("You must enter something into the comment field to submit."), dismissButton: .default(Text("OK")))
                    }
                }
                
                ScrollView {
                    VStack {
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
                        }
                    }
                }.frame(height: 200)
            }
            
            Spacer()
        }
        
        .onDisappear() {
            self.videoPlayer.pause()
            
        }.background(Color(red:0.4627, green:0.8392, blue:1.0).ignoresSafeArea())
    
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

struct GawrGura_Previews: PreviewProvider {
    static var previews: some View {
        GawrGura()
    }
}
