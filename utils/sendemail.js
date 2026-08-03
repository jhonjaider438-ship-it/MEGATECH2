import nodemailer from 'nodemailer';
import dotenv from 'dotenv';

dotenv.config();

const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: process.env.EMAIL_USER,
        pass: process.env.EMAIL_PASS,
    }
});

export const enviarconfirmacionpedido = async (email, nombre, pedidoid, total) => {
    const mailOptions = {
        from: process.env.EMAIL_USER,
        to: email,
        subject: `👍 Pedido confirmado - Heladería Minions #${pedidoid}`,
        html: `
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="UTF-8">
</head>

<body style="margin:0;padding:0;background:#0b1728;font-family:Arial,sans-serif;">

<table width="100%" cellpadding="0" cellspacing="0" style="padding:30px 0;">
<tr>
<td align="center">

<table width="420" cellpadding="0" cellspacing="0"
style="background:#10243f;border-radius:20px;border:2px solid #1da1f2;color:white;overflow:hidden;">

<tr>
<td style="background:#0d1c31;padding:20px;text-align:center;border-bottom:2px solid #1da1f2;">

<h1 style="margin:0;color:#29b6f6;">
Megatech2
</h1>

<p style="margin-top:8px;color:#b9dfff;">
Confirmación de Pedido
</p>

</td>
</tr>

<tr>
<td style="padding:30px;">

<p style="font-size:18px;">
Hola <strong>${nombre || 'Usuario'}</strong>,
</p>

<p style="color:#d8e9ff;line-height:25px;">
¡Gracias por realizar tu compra! Tu pedido ha sido confirmado correctamente.
</p>

<div style="
background:#0d1c31;
border:2px solid #35e27b;
border-radius:15px;
padding:20px;
margin:25px 0;">

<div style="text-align:center;font-size:48px;">🛒</div>

<h2 style="
text-align:center;
color:#35e27b;
margin:10px 0 20px;">
Pedido Confirmado
</h2>

<table width="100%" style="color:white;font-size:16px;">
<tr>
<td><strong>Número de pedido:</strong></td>
<td style="text-align:right;color:#29b6f6;">
#${pedidoid}
</td>
</tr>

<tr>
<td style="padding-top:12px;"><strong>Total:</strong></td>
<td style="padding-top:12px;text-align:right;color:#35e27b;font-size:18px;font-weight:bold;">
$${total.toLocaleString('es-CO')}
</td>
</tr>
</table>

</div>

<div style="
margin-top:20px;
padding:15px;
background:#0b1728;
border-left:5px solid #29b6f6;
border-radius:8px;">

<strong style="color:#29b6f6;">
📦 Próximo paso
</strong>

<p style="margin:8px 0 0;color:#d8e9ff;">
Nuestro equipo procesará tu pedido y pronto nos pondremos en contacto contigo para informarte sobre el estado de la entrega.
</p>

</div>

<p style="margin-top:30px;color:#d8e9ff;">
Gracias por confiar en <strong>Megatech2</strong>.
</p>

</td>
</tr>

<tr>
<td style="
background:#0d1c31;
padding:18px;
text-align:center;
font-size:13px;
color:#9fb8d6;">

Atentamente,<br>
<strong style="color:#29b6f6;">
Equipo de Soporte - Megatech2
</strong>

<br><br>

© 2026 Megatech2 - Sistema de Gestión de Inventario

</td>
</tr>

</table>

</td>
</tr>
</table>

</body>
</html>
`
    };

    try {
        await transporter.sendMail(mailOptions);
        return { success: true, message: 'Correo de confirmación enviado correctamente' };
    } catch (error) {
        console.error('Error enviando el email de confirmación:', error);
        return { success: false, error: error.message };
    }
};