import subprocess

try:
    command = f'nmcli dev wifi connect "Snowblower" password "password"'
    result = subprocess.run(command, shell=True, capture_output=True, text=True, check=True)
    print(f"Successfully connected to Snowblower")
except subprocess.CalledProcessError as e:
    print(f"Error connecting to Snowblower: {e.stderr}")
