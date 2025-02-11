import asyncio
import serial
import websockets

# Set up UART on Jetson Nano
ser = serial.Serial('/dev/ttyTHS1', 9600, timeout=1)

async def handler(websocket, path):
    async for message in websocket:
        print(f"Received: {message}")
        ser.write(message.encode())  # Send command over UART

# Create the WebSocket server with SO_REUSEADDR enabled
async def start_server():
    server = await websockets.serve(handler, "0.0.0.0", 8765)
    print("WebSocket server started on ws://0.0.0.0:8765")
    await server.wait_closed()

# Run the event loop
loop = asyncio.get_event_loop()
try:
    loop.run_until_complete(start_server())
    loop.run_forever()
except KeyboardInterrupt:
    print("Shutting down server...")
finally:
    loop.close()

