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

## Stack tecnológico
