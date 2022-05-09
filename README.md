# NavPush

A easy way to push view in the SwiftUI

## How to use

1. add `@State var navPush: NavPush?` to the view
2. add `.navPush { navPush = $0 }` to any view element in this view
3. use `navPush?.push { ... } ` to push view
