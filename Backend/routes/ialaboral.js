import express from "express";
import { chatearia, obtenerHistorialMega } from "../controller/ialaboral.js";
import { verificarRol, verificarToken } from "../middleware/auth.js";

const router = express.Router();

router.post("/",verificarToken,verificarRol('Admin','Empleado'), chatearia);
router.get("/historial/:sesionId",verificarToken,verificarRol('Admin','Empleado'), obtenerHistorialMega);

export default router;