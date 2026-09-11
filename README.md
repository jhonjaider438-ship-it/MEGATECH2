# MEGATECH2 – Backend

API REST para el sistema de gestión de inventario, ventas y pedidos de **Megatech2** (tienda tecnológica).

Construida con **Node.js + Express**, base de datos **Supabase (PostgreSQL)**, autenticación JWT, subida de imágenes a **Cloudinary** y envío de correos (Brevo / Nodemailer).

---

## Características principales

- **Autenticación y usuarios**
  - Registro con verificación de cuenta por código de 6 dígitos (correo)
  - Login con JWT (expiración 1 h)
  - Roles: `Cliente`, `Empleado`, `Admin`
  - Recuperación de contraseña por código temporal
  - CRUD de usuarios (Admin)

- **Catálogo**
  - Categorías y subcategorías
  - Productos con imagen (Cloudinary), stock y precio
  - Alertas automáticas de stock bajo (≤ 5 unidades) a Admin/Empleado

- **Pedidos (flujo online)**
  - Cliente crea pedido con validación de stock
  - Estados: `Por pagar` → `Por entregar` → `Entregado`
  - Descuento de stock al crear el pedido
  - Correo de confirmación cuando pasa a `Por entregar`
  - Subida de comprobante de pago (imagen) por el cliente

- **Ventas (punto de venta / físico)**
  - Registro de venta por vendedor (Admin/Empleado)
  - Descuento de stock
  - Consultas por cliente, vendedor, cédula
  - Eliminación de venta con devolución de stock
  - Reportes por período (hoy, semana, mes o rango personalizado) con filtros por vendedor, categoría y subcategoría

---

## Instalación

```bash
# Clonar el repositorio
git clone <url-del-repositorio>
cd megatech2

# Instalar dependencias
npm install
```

---

## Variables de entorno

Crea un archivo `.env` en la raíz del proyecto (no se sube a Git):

```env
# Servidor
PORT=3000

# Supabase
SUPABASE_URL=https://xxxx.supabase.co
SUPABASE_KEY=tu_supabase_anon_o_service_key

# JWT
JWT_SECRET=una_clave_secreta_muy_segura

# Cloudinary
CLOUDINARY_CLOUD_NAME=tu_cloud_name
CLOUDINARY_API_KEY=tu_api_key
CLOUDINARY_API_SECRET=tu_api_secret

# Correo (Nodemailer / Gmail)
EMAIL_USER=tu_correo@gmail.com
EMAIL_PASS=tu_app_password

# Brevo (verificación de cuenta)
BREVO_API_KEY=tu_brevo_api_key
EMAIL_FROM_ALCRIS=Megatech2
```

> **Nota:** En el código de comprobantes se usa un upload preset de Cloudinary (`ml_default`). Configúralo como *Unsigned* en el dashboard de Cloudinary si usas ese flujo.

---

## Ejecución

```bash
# Producción
npm start

# Desarrollo (con nodemon)
npm run dev
```

El servidor queda escuchando en:

```
http://localhost:3000
```

Ruta de salud:

```
GET /
→ { "mensaje": "bienvenido al backend de MEGATECH2", "estado": "en ilnea", "version": "1.0.0" }
```

---

## Autenticación

La mayoría de rutas protegidas requieren:

```
Authorization: Bearer <token>
```

El token se obtiene en `POST /auth/login` e incluye `id`, `correo` y `rol`.

Roles usados en el middleware:

- `Cliente`
- `Empleado`
- `Admin`

---

