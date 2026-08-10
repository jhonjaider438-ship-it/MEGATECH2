import express from 'express'
import { registrarVenta, comprasPorCliente, comprasPorCedula, listarVentas, ventasPorVendedor, ventaPorId, 
    ventasPorCedula, borrarVenta, reporteVentas } from "../controller/ventas.js";
import { verificarToken, verificarRol } from '../middleware/auth.js';

const router = express.Router();

// registrar una venta
router.post("/",verificarToken, verificarRol('Admin', 'Empleado'), registrarVenta);

// Ver todas las ventas
router.get("/",verificarToken,verificarRol("Admin"),listarVentas);

// Ver ventas realizadas por un vendedor
router.get("/vendedor/:id_vendedor",verificarToken,verificarRol("Admin"),ventasPorVendedor);

// ver ventas de un vendedor por cedula
router.get("/vendedor/cedula/:cedula",verificarToken,verificarRol("Admin"),ventasPorCedula);

// Buscar compras por ID del cliente
router.get("/cliente/:id_cliente",verificarToken,verificarRol("Admin"),comprasPorCliente);

// Buscar compras por cédula
router.get("/cedula/:cedula",verificarToken,verificarRol("Admin"),comprasPorCedula);

// verificar reportes contables 
router.get("/reporte",verificarToken,verificarRol("Admin"),reporteVentas);

// Ver una venta específica
router.get("/:id",verificarToken,verificarRol("Admin"),ventaPorId);

// eliminar una venta
router.delete("/:id",verificarToken,verificarRol("Admin"),borrarVenta);

export default router;