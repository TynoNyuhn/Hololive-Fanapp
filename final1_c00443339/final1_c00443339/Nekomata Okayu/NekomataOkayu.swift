//
//  NekomataOkayu.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/23/21.
//

import SwiftUI
import AVFoundation
import AVKit

struct NekomataOkayu: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    // Currently selected video
    @State var videoName = "OV1"
    // Video Player
    // Preloaded with a specific video file, in this case, the OV1.mp4
    @State var videoPlayer = AVPlayer(url: Bundle.main.url(forResource: "OV1", withExtension: "mp4")!)
    // Random Videos
    @State var videos = ["OkakoroCPMC", "OkayuAlien", "HMC2"]
    // Types of Media
    @State var mediaTypes  = ["BGM", "Music Videos", "Random Videos"]
    // The index of mediaTypes
    @State var mediaChoice = 0
    // Music Videos
    @State var images = ["OV6","OV1","OV2", "KV2", "OV3", "OV4","OV5","OV7","OV8","MV3", "MV1"]
    // Audio Player
    @State var audioPlayer: AVAudioPlayer!
    // Currently selected BGM
    @State var soundFile = "OkayuBGM"
    // BGMs
    @State var BGMs = ["OkayuBGM", "OkayuBGM2"]
    // Muted Bool
    @State var muted: Bool = false
    // Textfield Comment
    @State private var comment: String = ""
    // The result of addComment(), inputComment will be the one entered into the database
    @State private var inputComment: String = ""
    // Textfield Name
    @State private var name: String = ""
    // The result of addName(), inputtedName will be the one entered into the database
    // Default name is "Anonymous"
    @State private var inputtedName: String = "Anonymous"
    // Bool that states whether or not inputComment is empty
    @State private var emptyComment: Bool = false;
    // pageName will be used for the database's character attribute
    @State private var pageName: String = "NekomataOkayu"
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                Text("Nekomata Okayu") // Name
                    .font(.pixelate(size:36))
                    .bold()
                    .foregroundColor(Color.white)
                Picker(selection: $mediaChoice, label:Text("Media Types")) { // Chooses between BGM, Music Videos, and Random Videos
                    ForEach(0..<mediaTypes.count) { index in
                        Text("\(self.mediaTypes[index])")
                    }
                }.pickerStyle(SegmentedPickerStyle())
                // If the BGM tab was chosen, then it will play audio of BGMs
                if (mediaChoice == 0) {
                    // This button shows the thumbnail of the currently selected BGM, it can be pressed to un/mute it.
                    // Upon appearance, it will load the currently selected and, if unmuted, play it
                    // Upon disappearance, it will pause the audio.
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
                    }.onAppear() { // Plays the BGM audio automatically when the image (button) appears
                        loadSounds(soundFile)
                        self.audioPlayer.numberOfLoops = -1 // BGM will loop infinitely
                        if (!muted) {
                            self.audioPlayer.play()
                        }
                    }.onDisappear() { // If the BGM tab is unselected or the user leaves the page, it will pause the audio.
                        self.audioPlayer.pause()
                    }
                    // Shows the thumbnails of available BGMs to play. The user can scroll through the BGMs from left-right.
                    ScrollView(.horizontal, showsIndicators:false) { // Show Thumbnails for BGMs
                        HStack {
                            ForEach(self.BGMs, id: \.self) { image in
                                // Each thumbnail acts as button, upon being pressed, loads the thumbnail's audio, then plays the audio
                                // Automatically unmutes the audio.
                                Button {
                                    self.soundFile = image
                                    self.audioPlayer.stop()
                                    loadSounds(soundFile)
                                    self.audioPlayer.numberOfLoops = -1 //loadSounds resetted the numberOfLoops to 0, so reset it back to -1 (infinity)
                                    self.audioPlayer.play()
                                    self.muted = false
                                    
                                }
                            label: {
                                // Border for the thumbnail/pic of the currently selected BGM
                                if (soundFile == image) {
                                    // If it's not muted, then border will be green (indicates currently playing)
                                    if (!muted) {
                                        Image(image)
                                            .resizable()
                                            .frame(width: 160, height: 90)
                                            .overlay(Rectangle()
                                                        .strokeBorder(Color.green, lineWidth: 5))
                                    }
                                    // Otherwise, border will be red (indicates currently not playing)
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
                // If either the Music Videos or Random Videos tab are selected, then it shows the video players.
                // Similar to the audioPlayer, it will automatically play/mute on appearance/disappearance respectively.
                // Has a gradient border of the character's themes
                if (mediaChoice != 0) {
                    VideoPlayer(player: videoPlayer)
                        .frame(height:220)
                        .overlay(Rectangle()
                                    .strokeBorder(
                                        // For Korone and Okayu, their Gradient's color are the themes of the other character
                                        LinearGradient(gradient: Gradient(colors: [.white, .yellow, .white, .yellow]), startPoint: .leading, endPoint: .trailing),
                                        lineWidth: 5
                                    )
                        ).onAppear { // Automatically plays when the video player appears
                            self.videoPlayer.play()
                        }.onDisappear { // Automatically pauses when the video player disappears
                            self.videoPlayer.pause()
                        }
                }
                // Shows the thumbnails of either Music or Random Videos. The user can scroll through them from left-right.
                ScrollView(.horizontal, showsIndicators:false) {
                    if (mediaChoice == 1) { // Show Thumbnails for Music Videos
                        HStack {
                            ForEach(self.images, id: \.self) { image in
                                // Each thumbnail acts as button, upon being pressed, loads the thumbnail's video, then plays the video
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
                                // Each thumbnail acts as button, upon being pressed, loads the thumbnail's video, then plays the video
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
                // This VStack contains a short synposis on the character as well as links to their Youtube and Twitter
                VStack {
                    Text("A cat raised by a old woman from the onigiri store. She streams just because there is a PC in the old woman’s room.")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.white)
                    Text("Okayu has a laidback and chill personality comparable to that of an actual cat. However, Okayu is still a gamer, therefore she is prone to gamer moments.\nOriginally ashamed of her deep voice, she grew to love and embrace it - now having the most songs from her group\nShe is able to get along with other members easily, but Korone is her closest friend")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.white)
                    Text("Birthday: February 22nd\nDebut Date: April 6, 2019\nFanbase: Onigiryaa")
                        .font(.pixelate(size:18))
                        .padding()
                        .foregroundColor(Color.white)
                    HStack {
                        VStack {
                        Link(destination: URL(string: "https://www.youtube.com/channel/UCvaTdHTWBGv3MKj3KVqJVCw")!) {
                            Image("YouTube")
                                .resizable()
                                .frame(width:70, height: 35)
                                .padding()
                        }
                        }
                        VStack {
                        Link(destination: URL(string: "https://twitter.com/nekomataokayu")!) {
                            Image("Twitter")
                                .resizable()
                                .frame(width:50, height: 35)
                                .padding()
                        }
                        }
                    }
                }
                Divider()
                // Comments Section
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
                    // Sets emptyComment to false (resets it), then calls addComment() and addName()
                    // If inputComment is not empty, then it'll add an entry to the database
                    // Otherwise, doesn't and sets emptyComment to true, which triggers an alert message
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
                // Shows the comments of the specific page
                // The user can scroll through the comments
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
            
        }.background(Color.purple.ignoresSafeArea())
    
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

struct NekomataOkayu_Previews: PreviewProvider {
    static var previews: some View {
        NekomataOkayu()
    }
}
