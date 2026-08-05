import express from "express";
import { lista, crear, obtener, actualizar, eliminar } from "../controller/sub_categorias.js";
import { verificarRol, verificarToken } from "../middleware/auth.js";

const router = express.Router();

router.get("/", lista);

router.get("/obtener/:id", obtener);

router.post("/crear",verificarToken,verificarRol('Admin'), crear);

router.put("/actualizar/:id",verificarToken,verificarRol('Admin'), actualizar);

router.delete("/eliminar/:id",verificarToken,verificarRol('Admin'), eliminar);

export default router;