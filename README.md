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
## Flujos importantes

### 1. Registro y verificación

1. `POST /auth/registro` → crea usuario inactivo + envía código (Brevo).
2. `POST /auth/verify-account` con `{ correo, codigo }` → activa la cuenta.

### 2. Pedido online

1. Cliente autenticado → `POST /pedidos/crear`.
2. Se valida stock, se crea pedido + detalles y se descuenta inventario.
3. Estado inicial: `Por pagar`.
4. Cliente sube comprobante → `POST /compro`.
5. Admin cambia estado a `Por entregar` → se envía correo de confirmación.
6. Admin cambia a `Entregado`.

### 3. Venta en tienda

1. Admin/Empleado → `POST /ventas` con cédula del cliente, id del vendedor y productos.
2. Se valida stock, se registra venta + detalles y se descuenta inventario.

### 4. Stock bajo

Al actualizar un producto, si `stock ≤ 5` se notifica por correo a todos los usuarios con rol `Admin` o `Empleado`.

---

## Notas de seguridad y buenas prácticas

- Nunca expongas el `.env` ni claves de servicio en el repositorio.
- Preferible usar la **service role key** de Supabase solo en el backend (nunca en el frontend).
- Los tokens JWT expiran en 1 hora; el frontend debe manejar el refresh o re-login.
- Las rutas de creación de productos y comprobantes usan multer en memoria; el límite actual es 50 MB.
- Revisa que el preset de Cloudinary esté configurado correctamente (unsigned o firmado según el flujo que uses).

---

## Scripts disponibles

```json
"start": "node index.js",
"dev": "nodemon index.js"
```

---

## Autor / Proyecto

**Megatech2** – Sistema de Gestión de Inventario y Tienda Tecnológica  
Backend API v1.0.0

---

## Licencia

ISC

