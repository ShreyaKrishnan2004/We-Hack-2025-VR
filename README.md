# We-Hack-2025-VR

This Unity project uses live drone footage in a VR environment to assess the health of cell towers. The system combines computer vision, custom shaders, and haptic feedback to help field engineers identify anomalies without physically climbing towers—enhancing safety and reducing cost.

## 🔧 Features

- 🎥 **Drone Video Integration**: Real-time or recorded drone footage displayed in Unity.
- 🕶️ **VR Immersion**: Supports Oculus devices for immersive inspection.
- 🟥 **Computer Vision Overlay**: Bounding boxes identify towers and highlight detected anomalies.
- 🌡️ **Thermal Imaging Shader**: Simulated thermal effect to visualize heat-based anomalies.
- 🤖 **Haptic Feedback**: Vibrational actuators alert users to key regions requiring attention.

---

## 📁 Project Structure

Assets/ ├── Scripts/ │ ├── BoundingBoxOverlay.cs # Draws bounding boxes over detected objects │ ├── VideoPlayerController.cs # Plays and syncs video with overlays │ └── VRInteraction.cs # Manages VR user input ├── Shaders/ │ └── ThermalVision.shader # Custom shader for thermal vision effect ├── Prefabs/ │ └── BoundingBox.prefab # UI element used for bounding boxes ├── Materials/ │ └── ThermalMaterial.mat # Material using the thermal shader ├── Resources/ │ └── bounding_boxes.json # JSON file with annotated detection data
---

## 🚀 Getting Started

### 1. Clone the Project
```bash
git clone https://github.com/yourusername/celltower-vr-inspection.git
