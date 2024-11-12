import SwiftUI
import Combine

struct ContentView: View {
    @State var store = TodoStore(todos: [], fileProvider: InMemoryFileProvider())
    @State var newTodoText: String = ""
    @FocusState var isFocused: Bool
    let fileProvider: any FileProvider

    var body: some View {
        VStack {
            HStack {
                TextField("New Todo", text: $newTodoText)
                    .focused($isFocused)
                    .textFieldStyle(.roundedBorder)
                    .onSubmit {
                        addTodo()
                    }
                Button("Add") {
                    addTodo()
                }
                .keyboardShortcut(.defaultAction)
            }
            .padding(20)

            TodosList(store: store)
        }
        .background(Color(uiColor: .secondarySystemBackground))
        .task {
            self.store = TodoStore.load(using: fileProvider)
            isFocused = true
        }
    }

    func addTodo() {
        guard !newTodoText.isEmpty else { return }

        withAnimation {
            store.todos.insert(Todo(name: newTodoText), at: 0)
        }

        store.save()
        newTodoText = ""

        isFocused = true
    }
}

struct TodosList: View {
    var store: TodoStore

    var body: some View {
        List(store.todos) { todo in
            Text(todo.name)
                .strikethrough(todo.isComplete)
                .foregroundStyle(todo.isComplete ? Color.secondary : Color.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(18)
                .background(Capsule().fill(Color.white))
                .onTapGesture {
                    withAnimation(.easeOut(duration: 0.2)) {
                        todo.isComplete.toggle()
                        store.save()
                    }
                }
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 2)
                .listRowSeparator(.hidden)
                .swipeActions {
                    Button(role: .destructive) {
                        withAnimation {
                            store.todos.removeAll { $0.id == todo.id }
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }

                }
                .listRowBackground(Color(uiColor: .secondarySystemBackground))
        }
        .listStyle(.plain)
    }
}

#Preview {
    ContentView(fileProvider: InMemoryFileProvider())
}
