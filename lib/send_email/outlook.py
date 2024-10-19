from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, EmailStr
import smtplib
import os
from email.mime.text import MIMEText
import ssl
import win32com.client as win32

app = FastAPI()

# Esquema de datos para el correo
class EmailSchema(BaseModel):
    to_email: EmailStr
    subject: str
    message: str

# Función para enviar el correo
def send_email(to_email: str, subject: str, message: str):
    try:
        outlook = win32.Dispatch("Outlook.Application")
        mail = outlook.CreateItem(0)
        mail.To = to_email
        mail.Subject = subject
        mail.Body = message
        mail.Send()
        print("Correo enviado exitosamente")
    except Exception as e:
        print(f"Error enviando el correo: {e}")
        raise HTTPException(status_code=500, detail=f"Error enviando el correo: {e}")

# Endpoint para enviar el correo
@app.post("/send-reminder-outlook/")
async def send_reminder(email_data: EmailSchema):
    try:
        # Ejecutar directamente la función de envío de correo
        send_email(email_data.to_email, email_data.subject, email_data.message)
        return {"message": "Correo enviado exitosamente"}
    except Exception as e:
        # Manejar el error si el envío falla
        raise HTTPException(status_code=500, detail=f"No se pudo enviar el correo: {e}")
#curl -X POST "http://localhost:8000/send-reminder-outlook/" -H "Content-Type: application/json" -d "{\"to_email\": \"zlisandro5@gmail.com\", \"subject\": \"Recordatorio de Turno\", \"message\": \"Hola, este es un recordatorio para tu turno de barber\u00eda ma\u00f1ana a las 10 AM.\"}"