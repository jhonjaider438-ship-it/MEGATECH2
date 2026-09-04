import express from "express";
import { registrarComprobante, listarComprobantes, comprobantePorPedido } from "../controller/comprobante.js";
import {verificarToken,verificarRol} from "../middleware/auth.js";
import { upload } from "../config/claudinary.js";

const router = express.Router();


// Cliente registra comprobante
router.post(
    "/",
    verificarToken,
    verificarRol("Cliente"),
    upload.single("foto"),
    registrarComprobante
);

// Admin puede ver todos los comprobantes
router.get("/", verificarToken, verificarRol("Admin"), listarComprobantes);

// Admin puede ver comprobante de un pedido
router.get("/pedido/:id_pedido", verificarToken, verificarRol("Admin"), comprobantePorPedido);


export default router;