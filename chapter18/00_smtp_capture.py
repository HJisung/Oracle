from email import policy
from email.parser import BytesParser
from socketserver import StreamRequestHandler, TCPServer
from sys import argv


class SmtpCapture(StreamRequestHandler):
    def reply(self, response):
        self.wfile.write(response + b"\r\n")

    def handle(self):
        self.request.settimeout(15)
        self.reply(b"220 oracle-course.local SMTP capture")
        recipients = []
        for line in self.rfile:
            command = line.upper()
            if command.startswith(b"RCPT TO:"):
                recipients.append(line.strip().decode("ascii")[8:].strip(" <>"))
                self.reply(b"250 Recipient accepted")
            elif command.startswith((b"HELO ", b"MAIL FROM:")):
                self.reply(b"250 OK")
            elif command == b"DATA\r\n":
                self.reply(b"354 End data with a period")
                data = bytearray()
                for part in self.rfile:
                    if part == b".\r\n":
                        break
                    data.extend(part[1:] if part.startswith(b"..") else part)
                message = BytesParser(policy=policy.default).parsebytes(data)
                print(f"SMTP recipients: {', '.join(recipients)}", flush=True)
                print(f"Bcc header present: {'Bcc' in message}", flush=True)
                print(f"Subject: {message['Subject']}", flush=True)
                print(f"Body: {message.get_body().get_content().rstrip()}", flush=True)
                for attachment in message.iter_attachments():
                    payload = attachment.get_payload(decode=True)
                    print(
                        f"Attachment: {attachment.get_filename()} / "
                        f"{len(payload)} bytes / {payload[:8].hex()}",
                        flush=True,
                    )
                self.reply(b"250 Message captured locally")
            elif command == b"QUIT\r\n":
                self.reply(b"221 Bye")
                return
            else:
                self.reply(b"502 Command not implemented")


class LocalCaptureServer(TCPServer):
    allow_reuse_address = True


port = int(argv[1]) if len(argv) > 1 else 25252
with LocalCaptureServer(("127.0.0.1", port), SmtpCapture) as server:
    server.timeout = 30
    print(f"Listening on 127.0.0.1:{port} for one local SMTP session", flush=True)
    server.handle_request()
