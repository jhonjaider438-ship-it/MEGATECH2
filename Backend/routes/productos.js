import express from "express";

import {listarProductos,obtenerProducto,crear,actualizar,eliminar,bajoStock} from "../controller/productos.js";
import { verificarToken, verificarRol } from "../middleware/auth.js";
import { cloudinary, upload } from "../config/claudinary.js";

const router = express.Router();

router.get("/", listarProductos);

router.get("/bajo-stock", bajoStock);

router.get("/obtener/:id", obtenerProducto);

router.post(
    "/crear",
    verificarToken,
    verificarRol("Admin"),
    upload.single("file"),
    crear
);

router.put(
    "/actualizar/:id",
    verificarToken,
    verificarRol("Admin"),
    upload.single("file"),
    actualizar
);

router.delete(
    "/eliminar/:id",
    verificarToken,
    verificarRol("Admin"),
    eliminar
);

export default router;
