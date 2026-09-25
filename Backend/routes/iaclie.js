import express from "express";
import { chatearia, obtenerHistorialMega } from "../controller/iaclie.js";
import { verificarRol, verificarToken } from "../middleware/auth.js";

const router = express.Router();

router.post("/",verificarToken,verificarRol('Cliente'), chatearia);
router.get("/historial/:sesionId",verificarToken,verificarRol('Cliente'), obtenerHistorialMega);

export default router;