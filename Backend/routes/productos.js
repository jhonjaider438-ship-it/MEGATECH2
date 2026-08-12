import express from "express";

import {listarProductos,obtenerProducto,crear,actualizar,eliminar} from "../controller/productos.js";
import { verificarToken, verificarRol } from "../middleware/auth.js";

const router = express.Router();

router.get("/", listarProductos);

router.get("/obtener/:id", obtenerProducto);

router.post(
    "/crear",
    verificarToken,
    verificarRol("Admin"),
    crear
);

router.put(
    "/actualizar/:id",
    verificarToken,
    verificarRol("Admin"),
    actualizar
);

router.delete(
    "/eliminar/:id",
    verificarToken,
    verificarRol("Admin"),
    eliminar
);

export default router;
