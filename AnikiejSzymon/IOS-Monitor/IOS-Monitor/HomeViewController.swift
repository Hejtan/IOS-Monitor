//
//  HomeViewController.swift
//  IOS-Monitor
//
//  Created by stud on 12/12/2024.
//

// gif source: https://gifer.com/en/

import SwiftUI

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        let hostingController = UIHostingController(rootView: HomeView(weather: RequestWeather.requestWeatherData(mode: 1)))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let hostingController = UIHostingController(rootView: HomeView(weather: RequestWeather.requestWeatherData(mode: 1)))
        addChild(hostingController)
        view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
            hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
}

struct FadeInOnScroll: ViewModifier {
    @State private var isVisible = false
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Color(red: 245/255, green: 245/255, blue: 245/255))
            .shadow(radius: 4)
            .cornerRadius(12)
            .opacity(isVisible ? 1 : 0)
            .offset(x: isVisible ? 0 : 50)
            .animation(.easeOut(duration: 0.5), value: isVisible)
            .background(GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        checkVisibility(frame: geometry.frame(in: .global))
                    }
                    .onChange(of: geometry.frame(in: .global)) { frame in
                        checkVisibility(frame: frame)
                    }})
    }
    private func checkVisibility(frame: CGRect) {
        let midY = frame.midY
        let screenHeight = UIScreen.main.bounds.height
        if midY < screenHeight * 0.9 && midY > 0 {
            isVisible = true
        } else {
            isVisible = false
        }
    }
}

struct HomeView: View {
    
    let weather: Dictionary<String, Double>
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if UserDefaults.standard.bool(forKey: "temperature") {
                    TemperatureView(value: weather["temperature"]!)
                }
                if UserDefaults.standard.bool(forKey: "clouds") {
                    CloudsView(value: weather["cloudiness"]!)
                }
                if UserDefaults.standard.bool(forKey: "rain") {
                    RainView(value: weather["precipitation_value"]!, type: weather["precipitation_type"]!)
                }
                if UserDefaults.standard.bool(forKey: "wind") {
                    WindView(speed: weather["wind_speed"]!, direction: weather["wind_direction"]!)
                }
                if UserDefaults.standard.bool(forKey: "pressure") {
                    PressureView(value: weather["pressure"]!)
                }
                if UserDefaults.standard.bool(forKey: "humidity") {
                    HumidityView(value: weather["humidity"]!)
                }
                if UserDefaults.standard.bool(forKey: "visibility") {
                    VisibilityView(value: weather["visibility"]!)
                }
                if UserDefaults.standard.bool(forKey: "pollen") {
                    PollenView(grasses: weather["grasses"]!, ragweed: weather["ragweed"]!, olive: weather["olive"]!, mugwort: weather["mugwort"]!, alder: weather["alder"]!, hazel: weather["hazel"]!, ash: weather["ash"]!, birch: weather["birch"]!, cottonwood: weather["cottonwood"]!, oak: weather["oak"]!, pine: weather["pine"]!)
                }
                if UserDefaults.standard.bool(forKey: "airQuality") {
                    AirQualityView(value: weather["aqi"]!)
                }
            }
        }
        .background(Color(red: 230/255, green: 230/255, blue: 230/255))
    }
}

struct CloudsView: View {
    let value: Double
    var body: some View {
        if value >= 50.0 {
            VStack(spacing: 1) {
                GifImageView("cloudy")
                    .shadow(radius: 5)
                    .frame(maxWidth: .infinity, maxHeight: 200)
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(.bottom, 0)

                VStack(alignment: .center, spacing: 0) {
                    Text("Jest pochmurno! Zachmurzenie wynosi:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.gray)
                    Text("\(String(format: "%.0f", value))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.gray)
                }
            }
            .modifier(FadeInOnScroll())
        }
        else {
            VStack(spacing: 1) {
                GifImageView("clearsky")
                    .shadow(radius: 5)
                    .frame(width: 200, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Jest słonecznie! Zachmurzenie wynosi:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.yellow)
                    Text("\(String(format: "%.0f", value))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.leading)
                        .foregroundStyle(.yellow)
                }
            }
            .modifier(FadeInOnScroll())
        }
    }
}

struct TemperatureView: View {
    let value: Double
    var body: some View {
        if value < 10 {
            HStack(alignment: .center, spacing: 5) {
                Image("thermometer_3")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Jest zimno! Temperatura wynosi:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.blue)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))℃")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.blue)
                        .multilineTextAlignment(.leading)
                }
            }
            .modifier(FadeInOnScroll())
        }
        else if value > 20 {
            HStack(alignment: .center, spacing: 5) {
                Image("thermometer_1")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Jest gorąco! Temperatura wynosi:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))℃")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.red)
                        .multilineTextAlignment(.leading)
                }
            }
            .modifier(FadeInOnScroll())
        }
        else {
            HStack(alignment: .center, spacing: 5) {
                Image("thermometer_2")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 150)
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Jest ciepło! Temperatura wynosi:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))℃")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.orange)
                        .multilineTextAlignment(.leading)
                }
            }
            .modifier(FadeInOnScroll())
        }
    }
}

struct RainView: View {
    let value: Double
    let type: Double
    var body: some View {
        if type == 0.0 || value < 15.0 {
            HStack(alignment: .center, spacing: 5) {
                VStack(alignment: .center, spacing: 0) {
                    Text("Nie ma żadnych opadów!")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.leading)
                }
            }
            .modifier(FadeInOnScroll())
        }
        else if type == 1.0 {
            HStack(alignment: .center, spacing: 5) {
                GifImageView("rain")
                    .shadow(radius: 5)
                    .frame(width: 100, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Można oczekiwać deszczu! Oczekiwane opady:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.gray)
                        .multilineTextAlignment(.leading)
                }
            }
            .modifier(FadeInOnScroll())
        }
        else {
            HStack(alignment: .center, spacing: 5) {
                GifImageView("snow")
                    .shadow(radius: 5)
                    .frame(width: 100, height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                VStack(alignment: .center, spacing: 0) {
                    Text("Można oczekiwać śniegu! Oczekiwane opady:")
                        .font(.title3)
                        .fontWeight(.semibold)
                        .foregroundStyle(.teal)
                        .multilineTextAlignment(.leading)
                    Text("\(String(format: "%.0f", value))%")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundStyle(.teal)
                        .multilineTextAlignment(.leading)
                }
            }
            .modifier(FadeInOnScroll())
        }
    }
}


struct CompassViewWrapper: UIViewControllerRepresentable {
    let direction: Double
    typealias UIViewControllerType = CompassViewController
    func makeUIViewController(context: Context) -> CompassViewController {
        return CompassViewController(degrees: direction)
    }
    func updateUIViewController(_ uiViewController: CompassViewController, context: Context) {
        
    }
}
struct WindView: View {
    let speed: Double
    let direction: Double
    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            VStack(alignment: .center, spacing: 0) {
                Text("Wiatr wieje z prędkością:")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                Text("\(String(format: "%.0f", speed)) km/h")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
            }
            CompassViewWrapper(direction: direction)
                .frame(width: 100, height: 100)
                
        }
        .modifier(FadeInOnScroll())
    }
}

struct PressureView: View {
    let value: Double
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Ciśnienie wynosi:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            Text("\(String(format: "%.0f", value)) hPa")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
        }
        .modifier(FadeInOnScroll())
    }
}

struct HumidityView: View {
    let value: Double
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Wilgotność wynosi:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.blue)
                .multilineTextAlignment(.leading)
            Text("\(String(format: "%.0f", value))%")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.blue)
                .multilineTextAlignment(.leading)
        }
        .modifier(FadeInOnScroll())
    }
}

struct VisibilityView: View {
    let value: Double
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Widoczność wynosi:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            Text("\(String(format: "%.0f", value)) km")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
        }
        .modifier(FadeInOnScroll())
    }
}

struct PollenView: View {
    let grasses: Double
    let ragweed: Double
    let olive: Double
    let mugwort: Double
    let alder: Double
    let hazel: Double
    let ash: Double
    let birch: Double
    let cottonwood: Double
    let oak: Double
    let pine: Double
    let colortable: Dictionary <Double,  Color> = [
        0: .black,
        1: .green,
        2: .mint,
        3: .yellow,
        4: .orange,
        5: .red,
        6: .purple,
        7: .brown
    ]
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Prognoza pyłków:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(.black)
                .multilineTextAlignment(.leading)
            Text("Trawa: \(String(format: "%.0f", grasses))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[grasses] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Ambrozja: \(String(format: "%.0f", ragweed))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[ragweed] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Oliwka: \(String(format: "%.0f", olive))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[olive] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Bylica: \(String(format: "%.0f", mugwort))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[mugwort] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Leszczyna: \(String(format: "%.0f", hazel))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[hazel] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Jesion: \(String(format: "%.0f", ash))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[ash] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Brzoza: \(String(format: "%.0f", birch))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[birch] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Topola: \(String(format: "%.0f", cottonwood))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[cottonwood] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Dąb: \(String(format: "%.0f", oak))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[oak] ?? .black)
                .multilineTextAlignment(.leading)
            Text("Sosna: \(String(format: "%.0f", pine))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[pine] ?? .black)
                .multilineTextAlignment(.leading)
        }
        .modifier(FadeInOnScroll())
    }
}

struct AirQualityView: View {
    let value: Double
    let colortable: Dictionary <Double,  Color> = [
        0: .black,
        1: .green,
        2: .mint,
        3: .yellow,
        4: .orange,
        5: .red,
        6: .purple,
        7: .brown
    ]
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text("Jakość powietrza wynosi:")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundStyle(colortable[value] ?? .black)
                .multilineTextAlignment(.leading)
            Text("\(String(format: "%.0f", value))")
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(colortable[value] ?? .black)
                .multilineTextAlignment(.leading)
        }
        .modifier(FadeInOnScroll())
    }
    
}
