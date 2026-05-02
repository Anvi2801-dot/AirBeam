import socket

# This is the same info from your receiver
UDP_IP = "127.0.0.1"
UDP_PORT = 5005
MESSAGE = b"50,50" # The 'b' makes it a byte string

print(f"Sending test data: {MESSAGE} to {UDP_IP}:{UDP_PORT}")

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.sendto(MESSAGE, (UDP_IP, UDP_PORT))

print("Sent! Check if your mouse moved.")