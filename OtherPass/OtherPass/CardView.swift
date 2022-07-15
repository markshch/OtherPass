//#TODO
///entry handling
///give icon and color
///fix sheet layout 

import SwiftUI
import RealmSwift
import CodeScanner
import AVFoundation
import UIKit

enum MyAppPage {
    case Menu
    case SecondPage
    case ManualPage
}

final class MyAppEnvironmentData: ObservableObject {
    @Published var currentPage : MyAppPage? = .Menu
}


struct NavigationTest: View {

    var body: some View {
        NavigationView {
            MAIN___()
        }
    }
}

struct MAIN___: View {
    @ObservedResults(Group.self) var groups
    
    @State var aisis: Bool = false
    
    var body: some View {
        if let group = groups.first {
            // Pass the Group objects to a view further
            // down the hierarchy
            CardView(gettingNewData: self.$aisis, cards: 3, group: group)
        } else {
            // For this small app, we only want one group in the realm.
            // You can expand this app to support multiple groups.
            // For now, if there is no group, add one here.
            ProgressView().onAppear {
                $groups.append(Group())
            }
        }
    }
}

struct ItemRow: View {
    @ObservedRealmObject var item: Modal
    var body: some View {
        // You can click an item in the list to navigate to an edit details screen.
//        NavigationLink(destination: ItemDetailsView(item: item)) {
            Text(item.title)
//        }
    }
}

enum OpCode {
    case manual, scanning, editing
}

struct CardView: View {
    @EnvironmentObject var env : MyAppEnvironmentData
    @State private var sheetMode: SheetMode = .none
    @State var isPickerPresented: Bool = false
    @Binding var gettingNewData: Bool
    @State public var overlayOpacity: Double = 0.0
    @State static var isGettingNewData = false
    
    
    static let CARD_HEIGHT: CGFloat = 350
    static let CARD_WIDTH: CGFloat = 350
    static let TAB_HEIGHT: CGFloat = 80
    
    let six_array = ["Gym Pass", "Library Pass", "Gym Pass", "McDonalds Rewards", "Employee ID", "Club ID"]
    var title = "Gym pass"
    @State var cardID = 0
    
//    let realm = try! Realm()
    
    @State var selected: Int? = nil
    @State var cards: Int = 0
    @State var username: String = "Name"
    @State var UVVWidth: Double = 200
    @State var PassNameCount = 4
    @State private var secondIsOff = true
    @ObservedRealmObject var group: Group
    @State var barcode: String = ""
//    @State var UVVWidth: Double = 250
    
    @State var code128ButtonColor = Color(.systemGray6)
    @State var code39 = Color(.systemGray6)
    @State var qr = Color(.systemGray6)
    @State var ean8 = Color(.systemGray6)
    @State var ean13 = Color(.systemGray6)
    @State var upca = Color(.systemGray6)
    
    
    
    @State var opCode: OpCode = .manual
    @State var showCancelButton: Bool = false
    
    @State var opImage: Image = Image(systemName: "checkmark.circle.fill")
    
    @State var floatingUser = Modal()
    
    
//    @State var editIndex: Int = -1
//    @State var data: [Modal]
    
//    @State var modal: Modal

    
    var sss: some View {
//        @State var username: String = "a"
        return VStack {
            TextField("name", text: $floatingUser.title) //$group.items[cardID].barcodeText
                .font(.system(size: 28, weight: .semibold, design: .default))
//                .cornerRadius(18)
                .frame(width: UVVWidth, height: 65, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 92).fill(Color(.systemGray6)))
                .multilineTextAlignment(.center)
                .onChange(of: floatingUser.title) { (newValue) in
                }
            
            HStack {
                Text("Icon").font(.system(size: 28, weight: .semibold, design: .default)).padding(.leading, 10.0).padding(.top, 20.0)
                Spacer()
            }
            .padding(.top, 30.0)
            HStack(spacing: 25.0) {
                var imageSize: CGFloat = 40
//                Spacer()
                Button{} label: {Image(systemName: "circle").font(.system(size: imageSize)).foregroundColor(.blue)}
                Button{} label: {Image(systemName: "seal").font(.system(size: imageSize)).foregroundColor(.blue)}
                Button{} label: {Image(systemName: "diamond").font(.system(size: imageSize)).foregroundColor(.blue)}
                Button{} label: {Image(systemName: "rhombus").font(.system(size: imageSize)).foregroundColor(.blue)}
                Button{} label: {Image(systemName: "rectangle.roundedbottom").font(.system(size: imageSize)).foregroundColor(.blue)}
//                Spacer()
            }
            .padding(.top, 15.0)
            HStack {
                Text("Color").font(.system(size: 28, weight: .semibold, design: .default)).padding(.leading, 10.0).padding(.top, 20.0)
                Spacer()
            }
            .padding(.top, 15.0)
            HStack(spacing: 25.0) {
                var imageSize: CGFloat = 40
//                Spacer()
                Image(systemName: "circle.fill").font(.system(size: imageSize)).foregroundColor(.blue)
                Image(systemName: "circle.fill").font(.system(size: imageSize)).foregroundColor(.red)
                Image(systemName: "circle.fill").font(.system(size: imageSize)).foregroundColor(.green)
                Image(systemName: "circle.fill").font(.system(size: imageSize)).foregroundColor(.purple)
                Image(systemName: "circle.fill").font(.system(size: imageSize)).foregroundColor(.pink)
//                Spacer()
            }
            .padding(.top, 15.0)
            
            Text("").frame(height: 100)
            
            
        }
        
        
    }
    
    var aaa: some View {
        VStack {
//            Spacer()
            QrCodeScannerView()
                .found(r: {
                    ret in
                        print(ret)
                    floatingUser.barcodeText = ret
                    withAnimation{
                        opCode = .editing
                        opImage = Image(systemName: "arrow.right.circle.fill")
                    }
                        
                })
                .torchLight(isOn: false)
                .interval(delay: 1.0)
                .frame(width: 375, height: 450, alignment: .center)
                .cornerRadius(45)
            Spacer()
            Button {
                withAnimation{
                    opCode = .manual
                    opImage = Image(systemName: "arrow.right.circle.fill")
                }
            } label: {Text("Enter Manually").frame(minWidth: 80, maxWidth: 200, minHeight: 44)
                    .background(Color.blue).cornerRadius(18).foregroundColor(.white).font(.system(size: 18, weight: .semibold, design: .default))
            }
            Spacer()
        }

    }
    var bbb: some View {
            
    //        @State var username: String = "Name"
    //        @State var UVVWidth: Double = 200
    //        @State var PassNameCount = 4
    //        print(image)
            
            var boxOfColors = [code128ButtonColor, code39, qr, ean8, ean13, upca]
            
            return VStack {
    //            BarCodeView(barcode: "1234567890")
    //                .scaledToFit()
    //                .padding(.top).border(Color.white)
                TextField("Enter barcode", text: $floatingUser.barcodeText)
                    .font(.system(size: 28, weight: .semibold, design: .default))
                //                .cornerRadius(18)
                    .frame(width: UVVWidth + 60, height: 65, alignment: .center)
                    .background(RoundedRectangle(cornerRadius: 92).fill(Color(.systemGray6)))
                    .multilineTextAlignment(.center)
                    .onChange(of: barcode) { [oldEntry = self.barcode] (newEntry) in
                        
                        if newEntry.count > oldEntry.count {
                            if newEntry.count == 9 || newEntry.count == 12 {
                                withAnimation {
                                    UVVWidth += 30
                                }
                            }
                        }
                        else {
                            if newEntry.count == 9 || newEntry.count == 12  {
                                withAnimation {
                                    UVVWidth -= 30
                                }
                            }
                        }
                    }
                
                HStack {
                    Text("Type").font(.system(size: 28, weight: .semibold, design: .default)).padding([.top, .leading], 20.0)
                    Spacer()
                }
                
                HStack(spacing: 25.0) { //Code 128, 39, EAN-8, EAN-13, UPC-A, QR
                    Button {
                        
                        code128ButtonColor = Color.blue
//                        floatingUser.barcodeType = "128"
                        
                        code39 = Color(.systemGray6)
                        qr = Color(.systemGray6)
                        ean8 = Color(.systemGray6)
                        ean13 = Color(.systemGray6)
                        upca = Color(.systemGray6)
                        
                        
                    } label: {Text("code 128").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
                            .background(code128ButtonColor).cornerRadius(12).foregroundColor(code128ButtonColor == Color.blue ? Color.white : Color.blue)
                    }
                    Button {
                        
                        code128ButtonColor = Color(.systemGray6)
                        code39 = Color.blue
//                        floatingUser.barcodeType = "39"
                        
                        qr = Color(.systemGray6)
                        ean8 = Color(.systemGray6)
                        ean13 = Color(.systemGray6)
                        upca = Color(.systemGray6)
                        
                    } label: {Text("code 39").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
                            .background(code39).cornerRadius(12).foregroundColor(code39 == Color.blue ? Color.white : Color.blue)
                    }
                    Button {
                        
                        code128ButtonColor = Color(.systemGray6)
                        code39 = Color(.systemGray6)
                        qr = Color.blue
//                        floatingUser.barcodeType = "qr"
                        
                        ean8 = Color(.systemGray6)
                        ean13 = Color(.systemGray6)
                        upca = Color(.systemGray6)
                        
                    } label: {Text("QR").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
                            .background(qr).cornerRadius(12).foregroundColor(qr == Color.blue ? Color.white : Color.blue)
                    }
                }
                .padding(.top, 10.0)
                HStack(spacing: 25.0) {
                    Button {
                        
                        code128ButtonColor = Color(.systemGray6)
                        code39 = Color(.systemGray6)
                        qr = Color(.systemGray6)
                        ean8 = Color.blue
//                        floatingUser.barcodeType = "ean8"
                        
                        ean13 = Color(.systemGray6)
                        upca = Color(.systemGray6)
                        
                    } label: {Text("EAN-8").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
                            .background(ean8).cornerRadius(12).foregroundColor(ean8 == Color.blue ? Color.white : Color.blue)
                    }
                    Button {
                        withAnimation {
                        code128ButtonColor = Color(.systemGray6)
                        code39 = Color(.systemGray6)
                        qr = Color(.systemGray6)
                        ean8 = Color(.systemGray6)
                        ean13 = Color.blue
//                        floatingUser.barcodeType = "ean13"
                            
                        upca = Color(.systemGray6)
                        }
                        
                    } label: {Text("EAN-13").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
                            .background(ean13).cornerRadius(12).foregroundColor(ean13 == Color.blue ? Color.white : Color.blue)
                    }
                    Button {
                        
                        code128ButtonColor = Color(.systemGray6)
                        code39 = Color(.systemGray6)
                        qr = Color(.systemGray6)
                        ean8 = Color(.systemGray6)
                        ean13 = Color(.systemGray6)
                        upca = Color.blue
//                        floatingUser.barcodeType = "upca"
                        
                    } label: {Text("UPC-A").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
                            .background(upca).cornerRadius(12).foregroundColor(upca == Color.blue ? Color.white : Color.blue)
                    }
                }
                .padding(.top, 5.0)
                
                Text("").frame(width: 0, height: 300)
                
            }
            .padding(.top)
            .toolbar {
                Button("Save") {
                    var item = Modal()
                    item.barcodeText = barcode
                    
//                    $group.items.append(item)
                    self.env.currentPage = .Menu
                }
            }
            Spacer()
        }
            
        
        
    
    var body: some View {
//        let navlink = NavigationLink(destination: PageTwo(),
//                       tag: .SecondPage,
//                       selection: $env.currentPage,
//                       label: { EmptyView() })
//
//        let navlink2 = NavigationLink(destination: PageThree(group: group),
//                       tag: .ManualPage,
//                       selection: $env.currentPage,
//                       label: { EmptyView() })
        
        @ObservedRealmObject var item: Modal
        
        @State var username: String = "a"

        
        func placeOrder() {
//            self.env.currentPage = .SecondPage
//            $group.items.remove(at: 0)
            opCode = .scanning
//            opImage = Image(systemName: "xmark.circle.fill")
            showCancelButton = true
            floatingUser = Modal()
            withAnimation {

                isPickerPresented.toggle()
                overlayOpacity = 0.45
            }
            
        }
        func adjustOrder() {
//            self.env.currentPage = .ManualPage
//            $group.items.append(Modal())
            
            opCode = .manual
            opImage = Image(systemName: "arrow.right.circle.fill")
            floatingUser = Modal()
            withAnimation {

                isPickerPresented.toggle()
                overlayOpacity = 0.45
            }
            showCancelButton = false
            
        }
        
        func cancelOrder() {
                                    withAnimation {
            
                                        isPickerPresented.toggle()
                                        overlayOpacity = 0.45
                                    }
        }
        
        return GeometryReader { _ in
        ZStack {
            Spacer()
            ScrollView(showsIndicators: false) {
//                navlink
//                .frame(width:0, height:0)
//
//                navlink2
//                .frame(width:0, height:0)
                
                Spacer()
                HStack {
                    Spacer()
                    Text("OtherPass")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Spacer()
                    Menu {

                        Button(action: placeOrder) {
                            Label("Scan barcode", systemImage: "camera.fill")
                        }
                        Button(action: adjustOrder) {
                            Label("Enter manually", systemImage: "textformat.123")
                        }
                        Button(action: cancelOrder) {
                            Label("* show picker", systemImage: "circle")
                        }
                    } label : {Image(systemName: "plus.circle.fill")}
                    .tint(.blue)
                    .font(.system(size: 28, weight: .semibold, design: .default))
                    
//                    Button {
////                        self.cards += 1
//                        self.env.currentPage = .SecondPage
//                        withAnimation {
//
////                            isPickerPresented.toggle()
//                            overlayOpacity = 0.45
//                        }
//                    } label : {Image(systemName: "plus.circle.fill")}
//                    .tint(.blue)
//                    .font(.system(size: 28, weight: .semibold, design: .default))
                    Spacer()
                }
                
                var c5555 = ""
                
                ZStack(alignment: .top) {
                    
                    var c444 = ""
                    
                    var sortedP = group.items
                    var ccards = group.items.count as! Int
                    ForEach(group.items) { card2 in
                        
                        let c2 = card2 as! Modal
                        let card_i = sortedP.index(of: c2) as! Int
//                        let card_i = 0
                        


                        Button {
                            withAnimation {
                                self.selected = self.selected == card_i ? nil : card_i
                                self.cardID = self.selected ?? $group.items.count - 1
                                print("aaaa: \(card_i)")
                                if(self.selected == 0) {
                                    secondIsOff = true
                                } else {
                                    secondIsOff = false
                                }
                            }
                            print("A card was tapped. Do something with card_i here")
                            
                        } label: {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 36, style: .continuous)
                                    .fill(Color.white)
                                    .clipped()
                                    .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0.25, y: 0.25)
                                
                                
                                VStack {
                                    HStack {
                                        Spacer()
                                        Spacer()
                                        Image(systemName: "circle").foregroundColor(.blue).font(.system(size: 22, weight:.bold))
                                        Spacer()
                                        Text(c2.title)
                                            .font(.system(size: 22, weight: .semibold, design: .default))
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                        Spacer()
                                    }
                                    Spacer()
//                                    Image(uiImage: UIImage(named: "gggg")!) ///BARCODE
                                    BarCodeView(barcode: c2.barcodeText)
                                        .scaledToFit()
                                        .padding()
//                                        .border(Color.red)
//                                        .frame(width: 10, height: 10)
//                                    Image(uiImage: (UIImage(barcode: c2.barcodeText) ?? UIImage(barcode: "120202"))!)
                                    Text(c2.barcodeText).offset(x: .zero, y: -40).font(.system(.body, design: .monospaced)).padding([.trailing,.leading], 2)
                                    Spacer()
                                    HStack {
                                        Spacer()
                                        Button {
                                            var v = 1
                                            v = self.selected ?? $group.items.count - 1
                                            print("VVV: \(self.selected)")
                                            $group.items.remove(at: v)
                                            self.selected = nil

                                        } label: {Text("Delete pass").tint(.red)}.padding(.bottom, 30)
                        //                    .font(.system(size: 16, weight: .semibold, design: .default))
                                            .buttonStyle(.borderless)
                                            .disabled(card_i == 1 ? secondIsOff : false)
                                        Spacer()
                                    }
                                    
                                }
                                .frame(height: Self.CARD_HEIGHT - 60, alignment: .top)
                            }
                            
                        }
                        .buttonStyle(NoAnim())
                        .frame(width: Self.CARD_WIDTH, height: Self.CARD_HEIGHT, alignment: .top)
                        .offset(x: .zero, y: CGFloat(card_i) * Self.TAB_HEIGHT + ((selected ?? ccards + 1) < card_i ? Self.CARD_HEIGHT - Self.TAB_HEIGHT / 2 : 0))
                    }
                    .id(cards)
                }
                .frame(height: Self.CARD_HEIGHT + Self.TAB_HEIGHT * CGFloat(group.items.count as! Int), alignment: .top)
                .padding()
            }.navigationBarHidden(true)
                
                .overlay(Color.black.opacity(overlayOpacity))
                .customBottomSheet(isPresented: $isPickerPresented, opacityReference: $overlayOpacity, img: $opImage, opCode: $opCode, showCancelButton: $showCancelButton, floatingUser: $floatingUser, group: group) {
                    
                    return VStack{
                        ZStack {
                            ff().opacity(opCode != .editing ? 1.0 : 0.0)
                            sss.opacity(opCode == .editing ? 1.0 : 0.0)
                        }
                            
                    }
                    
                    
                    }
            Spacer()
        }
        
        }.ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    func ff() -> some View {
        switch(opCode) {
        case .scanning: return AnyView(aaa)
        case .manual: return AnyView(bbb)
        case .editing: return AnyView(sss)
        }
    }
    
    
    var card: some View {
        var index: Int = -1
        return ZStack {
            RoundedRectangle(cornerRadius: 36, style: .continuous)
                .fill(Color.white)
                .clipped()
                .shadow(color: Color.black.opacity(0.15), radius: 4, x: 0.25, y: 0.25)
            
            
            self.cardLayout
        }
        
    }
    
    
    
    var cardLayout: some View {
        var index: Int
        return VStack {
            HStack {
                Spacer()
                Spacer()
                Image(systemName: "circle").foregroundColor(.blue).font(.system(size: 22, weight:.bold))
                Spacer()
                Text("c4444")
                    .font(.system(size: 22, weight: .semibold, design: .default))
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            Spacer()
            Image(uiImage: UIImage(named: "gggg")!) ///BARCODE
            Spacer()
            HStack {
                Spacer()
                Button {
//                    withAnimation(.spring()) {
//                        self.cards -= 1
//                    }
                    withAnimation {

                        isPickerPresented.toggle()
                        overlayOpacity = 0.45
                    }
                    
                } label : {Text("Edit pass")}
//                    .font(.system(size: 16, weight: .semibold, design: .default))
                    .buttonStyle(.borderless)
                    
                    .tint(.blue)
                Spacer()
            }
            
        }
        .frame(height: Self.CARD_HEIGHT - 60, alignment: .top)
    }
    
        
}

struct NoAnim: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

struct BarCodeView: UIViewRepresentable {
    let barcode: String
    func makeUIView(context: Context) -> UIImageView {
        UIImageView()
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        uiView.image = UIImage(barcode: barcode)
//        uiView.image = generateBarcode(from: barcode)
    }
}

func generateBarcode(from string: String) -> UIImage? {
    let data = string.data(using: String.Encoding.ascii)

    if let filter = CIFilter(name: "CICode128BarcodeGenerator") {
        filter.setValue(data, forKey: "inputMessage")
        let transform = CGAffineTransform(scaleX: 3, y: 3)

        if let output = filter.outputImage?.transformed(by: transform) {
            let img = UIImage(ciImage: output, scale: 0.25, orientation: .left)
            return img
        }
    }

    return nil
}


//struct PageThree: View {
//
//    @ObservedRealmObject var group: Group
//
//    @EnvironmentObject var env : MyAppEnvironmentData
//
//    @State var barcode: String = ""
//    @State var UVVWidth: Double = 250
//
//    @State var code128ButtonColor = Color(.systemGray6)
//    @State var code39 = Color(.systemGray6)
//    @State var qr = Color(.systemGray6)
//    @State var ean8 = Color(.systemGray6)
//    @State var ean13 = Color(.systemGray6)
//    @State var upca = Color(.systemGray6)
//
//
//
//    var body: some View {
//
////        @State var username: String = "Name"
////        @State var UVVWidth: Double = 200
////        @State var PassNameCount = 4
////        print(image)
//
//        var boxOfColors = [code128ButtonColor, code39, qr, ean8, ean13, upca]
//
//        VStack {
////            BarCodeView(barcode: "1234567890")
////                .scaledToFit()
////                .padding(.top).border(Color.white)
//            TextField("Enter barcode", text: $barcode)
//                .font(.system(size: 28, weight: .semibold, design: .default))
//            //                .cornerRadius(18)
//                .frame(width: UVVWidth + 60, height: 65, alignment: .center)
//                .background(RoundedRectangle(cornerRadius: 92).fill(Color(.systemGray6)))
//                .multilineTextAlignment(.center)
//                .onChange(of: barcode) { [oldEntry = self.barcode] (newEntry) in
//
//                    if newEntry.count > oldEntry.count {
//                        if newEntry.count == 9 || newEntry.count == 12 {
//                            withAnimation {
//                                UVVWidth += 30
//                            }
//                        }
//                    }
//                    else {
//                        if newEntry.count == 9 || newEntry.count == 12  {
//                            withAnimation {
//                                UVVWidth -= 30
//                            }
//                        }
//                    }
//                }
//
//            HStack {
//                Text("Type").font(.system(size: 28, weight: .semibold, design: .default)).padding([.top, .leading], 20.0)
//                Spacer()
//            }
//
//            HStack(spacing: 25.0) { //Code 128, 39, EAN-8, EAN-13, UPC-A, QR
//                Button {
//
//                    code128ButtonColor = Color.blue
//                    code39 = Color(.systemGray6)
//                    qr = Color(.systemGray6)
//                    ean8 = Color(.systemGray6)
//                    ean13 = Color(.systemGray6)
//                    upca = Color(.systemGray6)
//
//
//                } label: {Text("code 128").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
//                        .background(code128ButtonColor).cornerRadius(12).foregroundColor(code128ButtonColor == Color.blue ? Color.white : Color.blue)
//                }
//                Button {
//
//                    code128ButtonColor = Color(.systemGray6)
//                    code39 = Color.blue
//                    qr = Color(.systemGray6)
//                    ean8 = Color(.systemGray6)
//                    ean13 = Color(.systemGray6)
//                    upca = Color(.systemGray6)
//
//                } label: {Text("code 39").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
//                        .background(code39).cornerRadius(12).foregroundColor(code39 == Color.blue ? Color.white : Color.blue)
//                }
//                Button {
//
//                    code128ButtonColor = Color(.systemGray6)
//                    code39 = Color(.systemGray6)
//                    qr = Color.blue
//                    ean8 = Color(.systemGray6)
//                    ean13 = Color(.systemGray6)
//                    upca = Color(.systemGray6)
//
//                } label: {Text("QR").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
//                        .background(qr).cornerRadius(12).foregroundColor(qr == Color.blue ? Color.white : Color.blue)
//                }
//            }
//            .padding(.top, 10.0)
//            HStack(spacing: 25.0) {
//                Button {
//
//                    code128ButtonColor = Color(.systemGray6)
//                    code39 = Color(.systemGray6)
//                    qr = Color(.systemGray6)
//                    ean8 = Color.blue
//                    ean13 = Color(.systemGray6)
//                    upca = Color(.systemGray6)
//
//                } label: {Text("EAN-8").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
//                        .background(ean8).cornerRadius(12).foregroundColor(ean8 == Color.blue ? Color.white : Color.blue)
//                }
//                Button {
//                    withAnimation {
//                    code128ButtonColor = Color(.systemGray6)
//                    code39 = Color(.systemGray6)
//                    qr = Color(.systemGray6)
//                    ean8 = Color(.systemGray6)
//                    ean13 = Color.blue
//                    upca = Color(.systemGray6)
//                    }
//
//                } label: {Text("EAN-13").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
//                        .background(ean13).cornerRadius(12).foregroundColor(ean13 == Color.blue ? Color.white : Color.blue)
//                }
//                Button {
//
//                    code128ButtonColor = Color(.systemGray6)
//                    code39 = Color(.systemGray6)
//                    qr = Color(.systemGray6)
//                    ean8 = Color(.systemGray6)
//                    ean13 = Color(.systemGray6)
//                    upca = Color.blue
//
//                } label: {Text("UPC-A").frame(minWidth: 80, maxWidth: 100, minHeight: 44)
//                        .background(upca).cornerRadius(12).foregroundColor(upca == Color.blue ? Color.white : Color.blue)
//                }
//            }
//            .padding(.top, 5.0)
//
//        }
//        .padding(.top)
//        .toolbar {
//            Button("Save") {
//                var item = Modal()
//                item.barcodeText = barcode
//
//                $group.items.append(item)
//                self.env.currentPage = .Menu
//            }
//        }
//        Spacer()
//    }
//
//
//
//
//}

struct MyButtonStyle: ButtonStyle {

  func makeBody(configuration: Self.Configuration) -> some View {
    configuration.label
      .padding()
      .foregroundColor(.white)
      .background(configuration.isPressed ? Color.blue : Color(.systemGray6))
      .cornerRadius(12.0)
  }

}

//struct PageTwo: View {
//
//    static let CARD_HEIGHT: CGFloat = 350
//    static let CARD_WIDTH: CGFloat = 350
//
//    @EnvironmentObject var env : MyAppEnvironmentData
//
//    var body: some View {
//        VStack {
//            Text("Scanning...")
//            Spacer()
//            QrCodeScannerView()
//                .found(r: {ret in print(ret)})
//                .torchLight(isOn: false)
//                .interval(delay: 1.0)
//                .frame(width: 400, height: 400, alignment: .center)
//                .cornerRadius(45)
//            Spacer()
//            Button {} label: {Text("Enter Manually").frame(minWidth: 80, maxWidth: 200, minHeight: 44)
//                    .background(Color.blue).cornerRadius(18).foregroundColor(.white).font(.system(size: 18, weight: .semibold, design: .default))
//            }
//            Spacer()
//        }
//}
//}



struct BottomSheet<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    @Binding var opacityReference: Double
    let sheetContent: () -> SheetContent
    @Binding var img: Image
    @Binding var opCode: OpCode
    @Binding var showCancelButton: Bool
    @Binding var floatingUser: Modal
    @ObservedRealmObject var group: Group
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    func body(content: Content) -> some View {
        
        ZStack {
            content
        
            if isPresented {
                VStack {
                    Spacer()
                
                    VStack {
                        HStack {
                            Button(action: {
                                
                                withAnimation(.easeInOut) {
                                    self.isPresented = false
                                    opacityReference = 0.0
                                    floatingUser = Modal()
                                }
                            }) {
//                                Image(systemName: "checkmark.circle.fill")
                                Image(systemName: "xmark.circle.fill")
//                                    .resizable()
                                    .padding([.top, .trailing], 8)
//                                    .frame(width: 50, height: 50)
                                    .font(.system(size: 50, weight: .regular))
                                    .tint(Color(.systemGray3))
                            }
//                            .opacity(opCode != .scanning ? 1.0 : 0.0)
                            
                            Spacer()
                            Button(action: {
                                switch(opCode) {
                                case .editing:
                                    $group.items.append(floatingUser)
                                    withAnimation(.easeInOut) {
                                        self.isPresented = false
                                        opacityReference = 0.0
                                    }
                                    floatingUser = Modal()
                
                                case .manual:
                                    img = Image(systemName: "checkmark.circle.fill")
                                    withAnimation {opCode = .editing}
                                case .scanning:
                                    img = Image(systemName: "checkmark.circle.fill")
                                    opCode = .editing
                                }
                            }) {
//                                Image(systemName: "checkmark.circle.fill")
                                img
//                                    .resizable()
                                    .padding([.top, .trailing], 8)
//                                    .frame(width: 50, height: 50)
                                    .font(.system(size: 50, weight: .heavy))
                            }
                            .opacity(opCode == .scanning ? 0.0 : 1.0)
                        }
                    
                        sheetContent()
                    }
                    .padding()
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(45.0)
                    .overlay(
                        RoundedRectangle(cornerRadius: 45.0)
                            .stroke(Color.blue, lineWidth: 4)
                            .opacity(colorScheme == .dark ? 1.0 : 0.0)
                    )
                    
                }
                .zIndex(.infinity)
                .transition(.move(edge: .bottom))
                .edgesIgnoringSafeArea(.bottom)
                
            }
        }
    }
}

extension View {
    func customBottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>, opacityReference: Binding<Double>, img: Binding<Image>, opCode: Binding<OpCode>, showCancelButton: Binding<Bool>, floatingUser: Binding<Modal>, group: Group,
        sheetContent: @escaping () -> SheetContent
    ) -> some View {
        self.modifier(BottomSheet(isPresented: isPresented, opacityReference: opacityReference, sheetContent: sheetContent, img: img, opCode: opCode, showCancelButton: showCancelButton, floatingUser: floatingUser, group: group))
    }
}


extension UIImage {

    convenience init?(barcode: String) {
        let data = barcode.data(using: .ascii)
        guard let filter = CIFilter(name: "CICode128BarcodeGenerator") else { //CIQRCodeGenerator
            return nil
        }

        filter.setValue(data, forKey: "inputMessage")
        guard let ciImage = filter.outputImage else {
            return nil
        }

        self.init(ciImage: ciImage)
    }

}
