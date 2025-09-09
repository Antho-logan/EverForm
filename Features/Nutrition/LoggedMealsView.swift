import SwiftUI

struct LoggedMealsView: View {
  @EnvironmentObject var journalStore: JournalStore
  @Environment(\.dismiss) private var dismiss
  @State private var scope: Scope = .day

  enum Scope: String, CaseIterable, Identifiable { case day = "Day", week = "Week", month = "Month"; var id: String { rawValue } }

  private var window: (start: Date, end: Date) {
    let cal = Calendar.current
    let now = Date()
    switch scope {
    case .day:
      return (cal.startOfDay(for: now), cal.date(byAdding: .day, value: 1, to: cal.startOfDay(for: now))!)
    case .week:
      let start = cal.date(from: cal.dateComponents([.yearForWeekOfYear, .weekOfYear], from: now))!
      return (start, cal.date(byAdding: .day, value: 7, to: start)!)
    case .month:
      let start = cal.date(from: cal.dateComponents([.year, .month], from: now))!
      return (start, cal.date(byAdding: .month, value: 1, to: start)!)
    }
  }

  // Adapt to your real entry type & fields
  private var meals: [JournalMealEntry] {
    journalStore.meals.filter { e in
      e.date >= window.start && e.date < window.end
    }.sorted(by: { $0.date > $1.date })
  }

  private var totals: (cal: Int, p: Int, c: Int, f: Int) {
    meals.reduce((0,0,0,0)) { acc, e in
      (acc.0 + max(0,e.totalCalories), 
       acc.1 + max(0,Int(e.totalProtein)), 
       acc.2 + max(0,Int(e.totalCarbs)), 
       acc.3 + max(0,Int(e.totalFat)))
    }
  }

  var body: some View {
    NavigationStack {
      List {
        Section {
          HStack {
            Picker("Scope", selection: $scope) {
              ForEach(Scope.allCases) { s in Text(s.rawValue).tag(s) }
            }
            .pickerStyle(.segmented)
          }
        }
        Section("Totals") {
          HStack(spacing: 16) {
            TotalTag("Calories", "\(totals.cal) kcal")
            TotalTag("Protein", "\(totals.p) g")
            TotalTag("Carbs",   "\(totals.c) g")
            TotalTag("Fat",     "\(totals.f) g")
          }
          .listRowBackground(Color.clear)
        }

        Section("Meals") {
          if meals.isEmpty {
            Text("No meals in this period.")
              .foregroundStyle(.secondary)
              .frame(maxWidth: .infinity, alignment: .center)
              .padding(.vertical, 24)
          } else {
            ForEach(meals) { e in
              VStack(alignment: .leading, spacing: 6) {
                HStack {
                  Text(e.mealType.rawValue)
                    .font(.headline)
                  Spacer()
                  Text("\(e.totalCalories) kcal")
                    .font(.headline)
                }
                HStack(spacing: 12) {
                  Text("P \(Int(e.totalProtein))g")
                  Text("C \(Int(e.totalCarbs))g")
                  Text("F \(Int(e.totalFat))g")
                }
                .font(.caption)
                .foregroundStyle(.secondary)

                if !e.items.isEmpty {
                  Text(e.items.map { $0.name }.joined(separator: ", "))
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                }
              }
            }
            .onDelete { idx in
              for i in idx {
                let entry = meals[i]
                journalStore.removeMeal(entry) // use real delete API
              }
            }
          }
        }
      }
      .listStyle(.insetGrouped)
      .navigationTitle("Logged Meals")
      .toolbar { ToolbarItem(placement: .topBarTrailing) { Button("Done") { dismiss() } } }
      .background(DSColor.appBackground)
      .onAppear { 
        let navStyler = UINavigationBarAppearance()
        navStyler.configureWithOpaqueBackground()
        navStyler.backgroundColor = UIColor(DSColor.appBackground)
        navStyler.shadowColor = .clear
        navStyler.titleTextAttributes = [.foregroundColor: UIColor.label]
        navStyler.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        UINavigationBar.appearance().standardAppearance = navStyler
        UINavigationBar.appearance().scrollEdgeAppearance = navStyler
      }
      .toolbarBackground(.visible, for: .navigationBar)
      .toolbarBackground(DSColor.appBackground, for: .navigationBar)
    }
  }
}

private struct TotalTag: View {
  let title: String, value: String
  init(_ t: String, _ v: String) { title = t; value = v }
  var body: some View {
    VStack(alignment: .leading, spacing: 2) {
      Text(title).font(.caption).foregroundStyle(.secondary)
      Text(value).font(.headline)
    }
    .padding(10)
    .background(RoundedRectangle(cornerRadius: 10).fill(DSColor.card.opacity(0.6)))
  }
}