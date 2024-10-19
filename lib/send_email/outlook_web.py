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
email_sender = 'fasturno-noreplay@outlook.com'

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
        with smtplib.SMTP('smtp-mail.outlook.com', 587) as server:
            server.set_debuglevel(1)
            server.ehlo()
            server.starttls()
            server.login(email_sender, password)
            server.sendmail(email_sender, [to_email], msg.as_string())
            server.quit()
        
        print("Correo enviado exitosamente")
    except Exception as e:
        print(f"Error enviando el correo: {e}")
        f"Error enviando el correo: {e}"
send_email("zlisandro5@gmail.com","Mensaje de prueba","Hola, este es un mensaje de prueba")
# Endpoint para enviar el correo
@app.post("/send-reminder-email/")
async def send_reminder(email_data: EmailSchema):
    try:
        # Ejecutar directamente la función de envío de correo
        send_email(email_data.to_email, email_data.subject, email_data.message)
        return {"message": "Correo enviado exitosamente"}
    except Exception as e:
        # Manejar el error si el envío falla
        raise HTTPException(status_code=500, detail=f"No se pudo enviar el correo: {e}")
#curl -X POST "http://localhost:8000/send-reminder-email/" -H "Content-Type: application/json" -d "{\"to_email\": \"zlisandro5@gmail.com\", \"subject\": \"Recordatorio de Turno\", \"message\": \"Hola, este es un recordatorio para tu turno de barber\u00eda ma\u00f1ana a las 10 AM.\"}"