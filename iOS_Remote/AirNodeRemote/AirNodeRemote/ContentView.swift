import SwiftUI
import CoreMotion
import Network

struct ContentView: View {
    // MARK: - 1. Connection Settings
    let host: String = "192.168.1.6"
    let port: UInt16 = 5005
    
    // MARK: - 2. State & Managers
    @State private var isTouching = false
    @State private var connection: NWConnection?
    let motionManager = CMMotionManager()
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 30) {
                // Status Header
                HStack {
                    Circle()
                        .fill(isTouching ? Color.green : Color.red)
                        .frame(width: 10, height: 10)
                    Text(isTouching ? "LINK ACTIVE" : "LINK IDLE")
                        .font(.system(.caption, design: .monospaced))
                }
                .foregroundColor(.white)
                
                // The "Clutch" Touch Area
                RoundedRectangle(cornerRadius: 40)
                    .strokeBorder(isTouching ? Color.cyan : Color.gray.opacity(0.3), lineWidth: 3)
                    .background(RoundedRectangle(cornerRadius: 40).fill(Color.white.opacity(0.05)))
                    .frame(height: 400)
                    .overlay(
                        Text(isTouching ? "TILTING" : "HOLD TO MOVE")
                            .foregroundColor(isTouching ? .cyan : .gray)
                            .fontWeight(.bold)
                    )
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { _ in
                                if !isTouching { startMotion() }
                                isTouching = true
                            }
                            .onEnded { _ in
                                isTouching = false
                                stopMotion()
                            }
                    )
                
                Text("AirNode v2.1 - Calibration Mode")
                    .font(.footnote)
                    .foregroundColor(.gray)
            }
            .padding(40)
        }
        .onAppear { setupNetwork() }
    }
    
    // MARK: - 3. The Pipe (Networking)
    func setupNetwork() {
        let endpoint = NWEndpoint.hostPort(host: NWEndpoint.Host(host), port: NWEndpoint.Port(integerLiteral: port))
        let params = NWParameters.udp
        params.includePeerToPeer = true
        
        connection = NWConnection(to: endpoint, using: params)
        connection?.start(queue: .global())
    }
    
    func sendData(_ message: String) {
            // STRICT CHECK: Never send if the thumb isn't down
            guard isTouching, let connection = connection else { return }
            
            let data = message.data(using: .utf8)
            connection.send(content: data, completion: .contentProcessed({ _ in }))
        }
        
        func startMotion() {
            if motionManager.isDeviceMotionAvailable {
                motionManager.deviceMotionUpdateInterval = 0.02
                motionManager.startDeviceMotionUpdates(to: .main) { motion, _ in
                    // 1. IMMEDIATE EXIT: If thumb is lifted, stop processing immediately
                    guard let data = motion, self.isTouching else {
                        self.stopMotion()
                        return
                    }
                    
                    // 2. USE ROTATION RATE: For "Pointer" style control
                    let rawX = data.rotationRate.y * 20
                    let rawY = data.rotationRate.x * 20
                    
                    // 3. DEADZONE: Ignore jitter below 0.5
                    let xDelta = abs(rawX) > 0.5 ? rawX : 0
                    let yDelta = abs(rawY) > 0.5 ? rawY : 0
                    
                    if xDelta != 0 || yDelta != 0 {
                        self.sendData("\(xDelta),\(yDelta)")
                    }
                }
            }
        }
    
    func stopMotion() {
        motionManager.stopDeviceMotionUpdates()
    }
}
