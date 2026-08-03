import express from "express";
import {obtener,obtenerPorId,obtenerPorPedido,crear,actualizar,eliminar} from "../controller/detalle_pedido.js";


const router = express.Router();

router.get("/", obtener);
router.get("/obtener/:id", obtenerPorId);
// Buscar detalles de un pedido específico
router.get("/pedido/:id", obtenerPorPedido);
router.post("/crear", crear);
router.put("/actualizar/:id", actualizar);
router.delete("/eliminar/:id", eliminar);

export default router;