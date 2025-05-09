import asyncio
import serial
import websockets

# Set up UART on Jetson Nano
ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)

async def read_from_arduino():
    while True:
        arduino = ser.readline().decode('utf-8').strip()
        if arduino:
            print("Arduino says:", arduino)
        await asyncio.sleep(0.1)  # Avoids blocking the event loop

async def handler(websocket, path):
    async for message in websocket:
        #print(f"Received: {message}")

        if message == "C":
            await websocket.close()
            loop.stop()
        elif message == "B":
            ser.write(b"Backward\n")
            print("Sent: Backwards")
        elif message == "F":
            ser.write(b"Forward\n")
            print("Sent: Forward")
        elif message == "R":
            ser.write(b"Right\n")
            print("Sent: Right")
        elif message == "L":
            ser.write(b"Left\n")
            print("Sent: Left")
        elif message == "S":
            ser.write(b"Stop\n")
            print("Sent: Stop")

        elif message == "25":
            ser.write(b"25\n")
            print("Sent: 25")
        elif message == "50":
            ser.write(b"50\n")
            print("Sent: 50")
        elif message == "75":
            ser.write(b"75\n")
            print("Sent: 75")
        elif message == "100":
            ser.write(b"100\n")
            print("Sent: 100")

# Create the WebSocket server with SO_REUSEADDR enabled
async def start_server():
    server = await websockets.serve(handler, "0.0.0.0", 8765, reuse_address=True)
    print("WebSocket server started on ws://0.0.0.0:8765")
    await server.wait_closed()

# Run the event loop
loop = asyncio.get_event_loop()

try:
    # Schedule both the WebSocket server and Arduino reader
    loop.create_task(read_from_arduino())
    loop.run_until_complete(start_server())
    loop.run_forever()
except KeyboardInterrupt:
    print("Shutting down server...")
finally:
    loop.close()

