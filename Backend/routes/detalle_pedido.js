import express from "express";
import {obtener,obtenerPorId,obtenerPorPedido,crear,actualizar,eliminar} from "../controller/detalle_pedido.js";
import { verificarToken, verificarRol } from "../middleware/auth.js";


const router = express.Router();

router.get("/",verificarToken,verificarRol('Admin','Empleado'), obtener);
router.get("/obtener/:id",verificarToken,verificarRol('Admin','Empleado'), obtenerPorId);
// Buscar detalles de un pedido específico
router.get("/pedido/:id",verificarToken,verificarRol('Admin','Empleado'), obtenerPorPedido);
router.post("/crear",verificarToken,verificarRol('Admin'), crear);
router.put("/actualizar/:id",verificarToken,verificarRol('Admin'), actualizar);
router.delete("/eliminar/:id",verificarToken,verificarRol('Admin'), eliminar);

export default router;