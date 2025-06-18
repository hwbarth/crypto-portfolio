import socket
import json

SOCKET_PATH = '/tmp/sdk.sock'

def send_command(command: dict):
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as client:
        client.connect(SOCKET_PATH)
        client.sendall(json.dumps(command).encode('utf-8'))
        
        # Simple: receive until newline
        data = b""
        while not data.endswith(b'\n'):
            chunk = client.recv(1024)
            if not chunk:
                break
            data += chunk
        return json.loads(data.decode())

if __name__ == "__main__":
    resp = send_command({'action': 'greet', 'name': 'Bob'})
    print('Response:', resp)
