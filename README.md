# AirBeam

### A Low-Latency Spatial Controller utilizing iOS CoreMotion & UDP Networking

AirBeam is a professional-grade "Air-Mouse" that bridges the gap between hardware sensors and desktop interaction. Unlike traditional computer vision mice, AirBeam utilizes the internal IMU (Inertial Measurement Unit) of an iPhone to provide 360° spatial control without field-of-view restrictions.

---

## 🚀 Key Features

- **Sensor Fusion** — Combines Gyroscope and Accelerometer data via Apple's `CoreMotion` framework
- **Zero-Drift Logic** — Implements relative attitude anchoring to prevent the "downward slide" common in basic tilt-controls
- **UDP Protocol** — Uses User Datagram Protocol for near-zero latency data transmission, essential for real-time cursor tracking
- **The "Clutch" Mechanism** — A software-defined engagement button that allows for re-centering and precise spatial mapping

---

## 🛠️ Technical Architecture

**Frontend (iOS)** — Built with SwiftUI and `Network.framework`. Processes high-frequency (50Hz) sensor updates and streams coordinate deltas.

**Backend (macOS)** — A Python receiver using `socket` for high-speed packet ingestion and `pyautogui` for hardware-level mouse emulation.

---

## 📦 Project Structure

```
.
├── iOS_Remote/          # SwiftUI Xcode Project
│   └── AirNodeRemote/   # CoreMotion & UDP Logic
├── Mac_Receiver/        # Python Backend
│   └── receiver.py      # UDP Listener & Mouse Controller
└── .gitignore           # Optimized for Swift/Python environments
```

---

## ⚙️ Setup & Installation

### 1. Mac Receiver

```bash
cd Mac_Receiver
pip install pyautogui
python receiver.py
```

### 2. iOS App

1. Open `iOS_Remote/AirNodeRemote.xcodeproj` in Xcode
2. Update the `host` variable in `ContentView.swift` with your Mac's local IP:
   ```bash
   ipconfig getifaddr en0
   ```
3. Deploy to your iPhone (ensure **Developer Mode** is active)

> ⚠️ Both devices must be on the same local network.

---

## 🎯 Use Cases

- **UAV Ground Control** — Interacting with flight software from a distance
- **Professional Presentations** — A spatial clicker with precision cursor control
- **Accessibility** — An alternative input method for users with limited desk mobility
