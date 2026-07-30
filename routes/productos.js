import express from "express";

import {listarProductos,obtenerProducto,crear,actualizar,eliminar} from "../controller/productos.js";

const router = express.Router();

router.get("/", listarProductos);

router.get("/obtener/:id", obtenerProducto);

router.post("/crear", crear);

router.put("/actualizar/:id", actualizar);

router.delete("/eliminar/:id", eliminar);

export default router;
