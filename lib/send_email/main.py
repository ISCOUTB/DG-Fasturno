from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
import smtplib
import os
from email.mime.text import MIMEText
import ssl
from dotenv import load_dotenv

app = FastAPI()
load_dotenv()
# Variables de entorno para el correo
password = os.getenv("PASSWORD")
print(password)
email_sender = ''

# Esquema de datos para el correo
class EmailSchema(BaseModel):
    to_email: EmailStr
    subject: str
    message: str

# Función para enviar el correo
def send_email(to_email: str, subject: str, message: str):
    try:
        # Crear el mensaje de correo
        msg = MIMEText(message)
        msg['Subject'] = subject
        msg['From'] = email_sender
        msg['To'] = to_email
        context = ssl.create_default_context()

        # Usar el servidor SMTP de Gmail
        with smtplib.SMTP_SSL('smtp.gmail.com', 587, context=context) as server:
            server.starttls()
            server.login(email_sender, password)
            server.sendmail(email_sender, [to_email], msg.as_string())
        
        print("Correo enviado exitosamente")
    except Exception as e:
        print(f"Error enviando el correo: {e}")
        raise HTTPException(status_code=500, detail=f"Error enviando el correo: {e}")

# Endpoint para enviar el correo
@app.post("/send-reminder/")
async def send_reminder(email_data: EmailSchema):
    try:
        # Ejecutar directamente la función de envío de correo
        send_email(email_data.to_email, email_data.subject, email_data.message)
        return {"message": "Correo enviado exitosamente"}
    except Exception as e:
        # Manejar el error si el envío falla
        raise HTTPException(status_code=500, detail=f"No se pudo enviar el correo: {e}")
