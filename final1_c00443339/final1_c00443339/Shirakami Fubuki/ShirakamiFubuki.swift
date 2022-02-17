//
//  ShirakamiFubuki.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/24/21.
//

import SwiftUI
import AVKit
import AVFoundation

struct ShirakamiFubuki: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State var videoName = "SFV1"
    @State var videoPlayer = AVPlayer(url: Bundle.main.url(forResource: "SFV1", withExtension: "mp4")!)
    @State var videos = ["FubukiFox", "FubukiOrder", "FubukiBorgar", "HMC2"]
    @State var videoPosition = 0
    @State var mediaTypes  = ["BGM", "Music Videos", "Random Videos"]
    @State var mediaChoice = 0
    @State var images = ["SFV1", "SFV2", "SFV3", "SFV4", "MV3"]
    @State var audioPlayer: AVAudioPlayer!
    @State var soundFile = "FubukiBGM"
    @State var BGMs = ["FubukiBGM"]
    @State var muted: Bool = false
    @State private var comment: String = ""
    @State private var inputComment: String = ""
    @State private var name: String = ""
    @State private var inputtedName: String = "Anonymous"
    @State private var emptyComment: Bool = false;
    @State private var pageName: String = "ShirakamiFubuki"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Shirakami Fubuki")
                    .font(.pixelate(size:32))
                    .bold()
                    .foregroundColor(Color.white)
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
                                        LinearGradient(gradient: Gradient(colors: [.blue, .white, .black, .red]), startPoint: .leading, endPoint: .trailing),
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
                    
                    Text("A white haired kemomimi (animal-eared) highschool student. Although she is shy and mostly calm, she likes to talk to people. She would be very happy if you pay attention to her.")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.white)
                    Text("Fubuki has a very cheeful and exciting personality. Often singing cute songs and creating short cute videos.\nShe is still a fox and has a predatory side that shows her fierce determination and willpower.\nShe enjoys speedrunning games and challenges such as shiny-hunting")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.white)
                    Text("Birthday: October 5th\nDebut Date: June 1, 2018\nFanbase: Sukon-bu")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.white)
                    HStack {
                        VStack {
                        Link(destination: URL(string: "https://www.youtube.com/channel/UCdn5BQ06XqgXoAxIhbqw5Rg")!) {
                            Image("YouTube")
                                .resizable()
                                .frame(width:70, height: 35)
                                .padding()
                        }
                        }
                        VStack {
                        Link(destination: URL(string: "https://twitter.com/shirakamifubuki")!) {
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

struct ShirakamiFubuki_Previews: PreviewProvider {
    static var previews: some View {
        ShirakamiFubuki()
    }
}
