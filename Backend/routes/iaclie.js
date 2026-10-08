import express from "express";
import { chatearia, obtenerHistorialMega } from "../controller/iaclie.js";

const router = express.Router();

router.post("/", chatearia);
router.get("/historial/:sesionId", obtenerHistorialMega);

export default router;
