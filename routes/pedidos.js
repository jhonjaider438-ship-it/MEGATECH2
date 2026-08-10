import express from "express";
import {obtener,obtenerPorId,crear,actualizar,eliminar,pedidosPorCedula} from "../controller/pedidos.js";
import { verificarRol, verificarToken } from "../middleware/auth.js";

const router = express.Router();

router.get("/",verificarToken,verificarRol('Admin','Empleado'), obtener);
router.get("/obtener/:id",verificarToken,verificarRol('Admin','Empleado'), obtenerPorId);
router.get("/cedula/:cedula",verificarToken,verificarRol('Admin'),pedidosPorCedula);
router.post("/crear",verificarToken,verificarRol('Cliente'), crear);
router.put("/actualizar/:id",verificarToken,verificarRol('Admin'), actualizar);
router.delete("/eliminar/:id",verificarToken,verificarRol('Admin'), eliminar);

export default router;