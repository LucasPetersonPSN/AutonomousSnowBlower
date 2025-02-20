import asyncio
import serial
import websockets

# Set up UART on Jetson Nano
ser = serial.Serial("/dev/ttyACM0", 9600, timeout=1)


#This block reads the serial monitor, ie. what the Ardunio is sending to the Jetson
async def read_from_arduino():
    while True:
        arduino = ser.readline().decode('utf-8').strip()
        if arduino:
            print("Arduino says:", arduino)
        await asyncio.sleep(0.1)  # Avoids blocking the event loop


#This block listens for commands sent from the user via websockets.
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

# This block is what starts the websocket server to provide real time communication between the host and client
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

