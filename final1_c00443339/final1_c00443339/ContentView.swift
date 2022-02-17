//
//  ContentView.swift
//  final1_c00443339
//
//  Created by Tony Huynh on 11/23/21.
//
// App Name:        Hololive Fanapp
// Author Name:     Tony Huynh
// Intent/Purpose:  This app serves as a demo of a potential Hololive media app that contains the videos, music, and information of Hololive VTubers.
//
// List of Section 8-11 Techniques Utilized:
// 8j_validation
// 8m_customfonts
// 8n_alertsandactions
// 8o_contextmenu
// 8m_customfonts
// 9b_audioplayer
// 9e_videoplayer
// 10c_gradients
// 10d_borders
//
// Core Data:
// Comments
//
// Description:
// The app allows the user to select between 3 generations (Gamers, Fantasy, Myth). The currently selected generations shows a list of
// characters from that generation. The user can choose to tap anywhere on the character slot to go to their individual page.
// Long pressing the image of every character in the generation brings up a context menu that allows the user to directly pick a generation.
// Upon reaching their personal page, their BGM will automatically start playing. To pause/mute the BGM, tap on the big picture.
// Above the big picture, there is a Picker that the user can press to choose between BGMs, Music Videos and Random Videos.
// Both Videos sections use the same VideoPlayer. The BGM section uses an AudioPlayer
// The AudioPlayer and VideoPlayer will automatically pause if the user either exits the page or selects a section that doesn't use it.
// Some pages will have multiple BGMs and/or Videos, to which the user can scroll through and select by tapping on their image.
// The thumbnail for the videos and BGMs will be shown directly below the big picture/video. Scroll left-right to traverse through them.
// There will be a green border for the currently selected video/BGM. For BGMs only, there will be a red border if it's muted.
// Below the videos/BGMs, there is a short synposis on the character and buttons that link to their YouTube and Twitter.
// At the bottom their page, users can add comments that are specific to that page. A username is optional, but comments must contain something
// If the user attempts to submit an empty comment, an alert will pop up notifying them and nothing will be posted.
// To delete comments, the user must back out to the main page, then select the Comment Editor button. This also shows all comments made.
//
// Some character pages will have colored backgrounds. Gamers and Fantasy use the pixelate font, whereas each member of Myth has their own unique font. (The system font is considered unqiue in this case)
// If the character page has a Christmas-related BGM/Video, then it will select and play it upon entry.

import SwiftUI
import CoreData

struct ContentView: View {
    @State var genImages = ["HololiveGamers", "HololiveFantasy", "HololiveMyth"]
    @State var genImage = "HololiveGamers"
    @State var genPosition = 0
    
    var body: some View {
        NavigationView {
            VStack {
                Image(genImage) // The user can hold the image to bring up the context menu which allows the user to select directly.
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 250)
                    .contextMenu {
                        Button("Hololive Gamers") {
                            self.genPosition = 0
                            self.genImage = genImages[genPosition]
                        }
                        Button("Hololive Fantasy") {
                            self.genPosition = 1
                            self.genImage = genImages[genPosition]
                        }
                        Button("Hololive Myth") {
                            self.genPosition = 2
                            self.genImage = genImages[genPosition]
                        }
                    }
                HStack {
                    HStack {
                        Button { // Selects the previous generation
                            if (genPosition == 0) {
                                self.genPosition = genImages.count-1
                            }
                            else {
                                self.genPosition -= 1
                            }
                            self.genImage = genImages[genPosition]
                        } label: {
                            Text("Previous")
                                .foregroundColor(Color.white)
                        }.frame(width: 90, height:30)
                            .background(Color.gray)
                            .cornerRadius(5)
                    }.frame(width: 150)
                    
                    HStack {
                        Button { // Selects the next generation
                            if (genPosition == genImages.count-1) {
                                self.genPosition = 0
                            }
                            else {
                                self.genPosition += 1
                            }
                            self.genImage = genImages[genPosition]
                        } label: {
                            Text("Next")
                                .foregroundColor(Color.white)
                        }.frame(width: 90,height: 30)
                            .background(Color.green)
                            .cornerRadius(5)
                    }.frame(width:150)
                }
                ScrollView { // The user can scroll through the displayed characters
                    VStack {
                        if (genImage == "HololiveGamers") {
                            NavigationLink(destination: ShirakamiFubuki()) { // Fubuki
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    // Each character has a nearly identical similar layout.
                                    // Go to ShirkamiFubuki page
                                    Image("PFPFubuki") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Shirakami\nFubuki")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.background(Color(red:0.4627, green:0.8392, blue:1.0))
                            }.navigationBarTitle("Hololive Gamers")
                            NavigationLink(destination: InugamiKorone()) { // Korone
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPKorone") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Inugami\nKorone")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Gamers")
                                    .background(Color.yellow)
                            }
                            NavigationLink(destination: NekomataOkayu()) { // Okayu
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPOkayu") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Nekomata\nOkayu")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Gamers")
                                    .background(Color.purple)
                            }
                            NavigationLink(destination: OokamiMio()) { // Mio
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPMio") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Ookami\nMio")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.red)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Gamers")
                                    .background(Color.black)
                            }
                        }
                        else if (genImage == "HololiveFantasy") {
                            NavigationLink(destination: UruhaRushia()) { // Rushia
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPRushia") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Uruha\nRushia")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Fantasy")
                            }
                            NavigationLink(destination: UsadaPekora()) { // Pekora
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPPekora") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Usada\nPekora")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Fantasy")
                            }
                            NavigationLink(destination: HoushouMarine()) { // Marine
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPMarine") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Houshou\nMarine")
                                        .font(.pixelate(size:24))
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Fantasy")
                            }
                        }
                        else if (genImage == "HololiveMyth") {
                            NavigationLink(destination: GawrGura()) { // Gura
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPGura") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Gawr\nGura")
                                        .font(.gura(size:24))
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Myth")
                                    .background(Color(red:0.4627, green:0.8392, blue:1.0))
                            }
                            NavigationLink(destination: AmeliaWatson()) { // Amelia
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPAmelia") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Amelia\nWatson")
                                        .font(.notes(size:24))
                                        .foregroundColor(Color.black)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Myth")
                            }
                            NavigationLink(destination: CalliopeMori()) { // Calli
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPCalli") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Calliope\nMori")
                                        .font(.graveDigger(size:24))
                                        .foregroundColor(Color.white)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Myth")
                                    .background(Color.black)
                            }
                            NavigationLink(destination: InanisNinomae()) { // Ina
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPIna") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Ina'nis\nNinomae")
                                        .font(.aquire(size:24))
                                        .foregroundColor(Color.yellow)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Myth")
                                    .background(Color.purple)
                            }
                            NavigationLink(destination: KiaraTakanashi()) { // Kiara
                                HStack { // Uses an HStack to force the pfp on the left side, name in the middle, and right-arrow to the right
                                    // For documentation on the individual characters page, go to NekomataOkayu.swift
                                    Image("PFPKiara") // Profile Picture
                                        .resizable()
                                        .frame(width: 70, height: 70)
                                    Spacer()
                                    Text("Takanashi\nKiara")
                                        .font(.system(size:24))
                                        .foregroundColor(Color.red)
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 70))
                                }.navigationBarTitle("Hololive Myth")
                                    .background(Color.orange)
                            }
                        }
                        
                    }
                }
                Spacer()
                // This page allows the user to view all comments and delete any comment.
                NavigationLink(destination: ViewAllComments()) {
                    Text("Delete Comments")
                }
                
            } // end of VStack
        } // end of navlink
    } // end of viewbody
}

public let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}

extension Font {
    static func newRocker(size:CGFloat) -> Font {
        .custom("NewRocker", size: size)
    }
    static func gura(size:CGFloat) -> Font {
        .custom("MerryChristmas2021", size: size)
    }
    static func aquire(size:CGFloat) -> Font {
        .custom("Aquire", size: size)
    }
    static func graveDigger(size: CGFloat) -> Font {
        .custom("GravediggerPersonalUse", size: size)
    }
    static func pixelate(size: CGFloat) -> Font {
        .custom("PixelEmulator", size: size)
    }
    static func amelia(size: CGFloat) -> Font {
        .custom("BetterGrade", size: size)
    }
    static func notes(size: CGFloat) -> Font {
        .custom("CuteNotes", size: size)
    }
    static func handwriting(size: CGFloat) -> Font {
        .custom("JaspersHandwriting", size: size)
    }
}
