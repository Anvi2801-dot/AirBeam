import socket
import pyautogui

# Settings - Disable the "failsafe" so the script doesn't crash 
# if the mouse hits a corner, but be ready to Cmd+C in Terminal!
pyautogui.FAILSAFE = False

# Network Configuration
UDP_IP = "0.0.0.0" # Listen on all available network interfaces
UDP_PORT = 5005

# Create the Socket (The "Ear")
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # SOCK_DGRAM = UDP
sock.bind((UDP_IP, UDP_PORT))

print(f"AirNode Receiver Active...")
print(f"Listening on Port: {UDP_PORT}")
print("To stop this script, press Ctrl+C in this terminal.")

while True:
    # 1. Wait for data from the iPhone
    data, addr = sock.recvfrom(1024) # buffer size is 1024 bytes
    
    try:
        # 2. Decode the message (Expected format: "x_delta,y_delta")
        message = data.decode('utf-8')
        x, y = message.split(',')
        
        # 3. Move the mouse relative to its current position
        # We multiply by a factor if we want it faster, or keep it 1:1
        # Create a multiplier to tune the speed
        sensitivity = 1.5 
        pyautogui.moveRel(float(x) * sensitivity, float(y) * sensitivity)
        
    except Exception as e:
        # If the iPhone sends a weird message, don't crash, just ignore it
        pass