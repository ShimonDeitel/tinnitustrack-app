import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: Store
    @EnvironmentObject var purchases: PurchaseManager
    @State private var showAddSheet = false
    @State private var showSettings = false
    @State private var showPaywall = false

    @State private var newRating = 3
    @State private var newNote = ""
    @State private var newTags: Set<String> = []

    private let tagOptions = ["Loud Noise", "Stress", "Caffeine", "Lack of Sleep", "Alcohol", "Sinus/Cold"]

    var body: some View {
        NavigationStack {
            List {
                ForEach(store.entries) { entry in
                    VStack(alignment: .leading, spacing: 6) {
                        HStack {
                            Text(entry.date, style: .date).font(Theme.headlineFont).foregroundStyle(Theme.primary)
                            Spacer()
                            Text("\(entry.rating)/5").font(Theme.headlineFont).foregroundStyle(Theme.accent)
                        }
                        if !entry.tags.isEmpty {
                            Text(entry.tags.joined(separator: ", ")).font(Theme.captionFont).foregroundStyle(Theme.secondary)
                        }
                        if !entry.note.isEmpty {
                            Text(entry.note).font(Theme.captionFont).foregroundStyle(Theme.secondary)
                        }
                    }
                    .listRowBackground(Theme.cardBackground)
                }
                .onDelete(perform: store.delete)
            }
            .scrollContentBackground(.hidden)
            .background(Theme.background.ignoresSafeArea())
            .navigationTitle("Tinnitustrack")

            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        showSettings = true
                    } label: {
                        Image(systemName: "gearshape")
                    }
                    .accessibilityIdentifier("settingsButton")
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if store.isAtLimit && !purchases.isPro {
                            showPaywall = true
                        } else {
                            showAddSheet = true
                        }
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityIdentifier("addEntryButton")
                }
            }
            .sheet(isPresented: $showSettings) { SettingsView() }
            .sheet(isPresented: $showPaywall) { PaywallView() }

            .sheet(isPresented: $showAddSheet) {
                NavigationStack {
                    Form {
                        Stepper("Intensity: \(newRating)", value: $newRating, in: 1...5)
                            .accessibilityIdentifier("ratingStepper")
                        Section("Possible Triggers") {
                            ForEach(tagOptions, id: \.self) { tag in
                                Toggle(tag, isOn: Binding(
                                    get: { newTags.contains(tag) },
                                    set: { isOn in if isOn { newTags.insert(tag) } else { newTags.remove(tag) } }
                                ))
                            }
                        }
                        TextField("Note", text: $newNote)
                            .accessibilityIdentifier("noteField")
                    }
                    .navigationTitle("New Entry")
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { showAddSheet = false }
                        }
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Save") {
                                store.add(Entry(date: Date(), rating: newRating, note: newNote, tags: Array(newTags)))
                                newRating = 3; newNote = ""; newTags = []
                                showAddSheet = false
                            }
                            .accessibilityIdentifier("saveEntryButton")
                        }
                    }
                    .background(
                        Color.clear.contentShape(Rectangle())
                            .onTapGesture { hideKeyboard() }
                    )
                }
            }
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
