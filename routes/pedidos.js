import express from "express";
import {obtener,obtenerPorId,crear,actualizar,eliminar} from "../controller/pedidos.js";

const router = express.Router();

router.get("/", obtener);
router.get("/obtener/:id", obtenerPorId);
router.post("/crear", crear);
router.put("/actualizar/:id", actualizar);
router.delete("/eliminar/:id", eliminar);

export default router;