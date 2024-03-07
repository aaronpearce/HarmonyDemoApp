//
//  HarmonyDemoApp.swift
//  HarmonyDemoApp
//
//  Created by Aaron Pearce on 14/02/24.
//

import Harmony
import SwiftUI

@main
struct HarmonyDemoApp: App {

    @Harmony(
        records: [ListItem.self],
        configuration: Configuration(cloudKitContainerIdentifier: "iCloud.com.pearcmedia.HarmonyDemoApp"),
        migrator: Migrator.make()
    ) var harmony

    var body: some Scene {
        WindowGroup {
            ContentView()
                .tint(.accent)
                .environment(\.databaseReader, harmony.reader)
        }
    }

    init() {
        let design = UIFontDescriptor.SystemDesign.serif
        let largeDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .largeTitle).withDesign(design)!.withSymbolicTraits(.traitBold)!
        let largeFont = UIFont(descriptor: largeDescriptor, size: 0)

        let smallDescriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: .headline).withDesign(design)!
        let smallFont = UIFont(descriptor: smallDescriptor, size: 0)

        let appearance = UINavigationBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.largeTitleTextAttributes = [
            .font : largeFont,
        ]
        appearance.titleTextAttributes = [
            .font : smallFont
        ]

        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
    }
}
