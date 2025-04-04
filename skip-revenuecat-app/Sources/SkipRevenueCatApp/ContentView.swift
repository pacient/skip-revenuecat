import SwiftUI
import SkipRevenueCat

#if !SKIP
import RevenueCatUI
#else
import com.revenuecat.purchases.kmp.ui.revenuecatui.PaywallFooter
import com.revenuecat.purchases.ui.debugview.DebugRevenueCatScreen
import com.revenuecat.purchases.kmp.ui.revenuecatui.PaywallOptions
#endif

public struct ContentView: View {
    @ObservedObject var storeViewModel = Store.shared
    
    @State private var isPresented = false
    @State private var isCustomPaywallPresented = false
    @State private var debugOverlayVisible: Bool = false
    
    public init() {
    }

    public var body: some View {
        #if SKIP
        let options = remember {
            PaywallOptions(dismissRequest: {}) { }
        }
        #endif

        VStack {
            if (Store.shared.subscriptionActive) {
                Text("You're subscribed!")
            } else {
                VStack {
                    Text("You're not subscribed :(")
                    Button("Show Paywall") {
                        isPresented = true
                    }
                    
                    // Have not tested on Android
                    #if os(iOS)
                    Button("Show Custom Paywall") {
                        isCustomPaywallPresented = true
                    }
                    .sheet(isPresented: $isCustomPaywallPresented) {
                        CustomPaywall(isPresented: $isCustomPaywallPresented)
                            .modifier(StoreViewModifier())
                    }
                    #endif
                    
                }
                .sheet(isPresented: $isPresented) {
                    #if !SKIP && os(iOS)
                    CustomPaywallContent()
                        .paywallFooter()
                    #elseif SKIP
                    ComposeView { context in
                        PaywallFooter(options) { _ in
                            CustomPaywallContent()
                                .Compose(context: context.content())
                        }
                    }
                    #endif
                }
            }
            Button("Debug") {
                debugOverlayVisible = true
            }
            #if SKIP
            .sheet(isPresented: $debugOverlayVisible) {
                // Debug view is not available in KMP. Android native library is used
                ComposeView { context in
                    // DebugRevenueCatBottomSheet crashes with an error
                    // rememberModalBottomSheetState is unavailable
                    DebugRevenueCatScreen(
                        onPurchaseCompleted: { _ in  },
                        onPurchaseErrored: { _ in }
                    )
                }
            }
            #elseif !SKIP && os(iOS)
            // Debug view is not available in KMP. iOS native library is used
            .debugRevenueCatOverlay(isPresented: $debugOverlayVisible)
            #endif
        }
    }
}

