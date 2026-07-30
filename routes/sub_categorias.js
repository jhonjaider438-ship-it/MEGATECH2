import express from "express";
import { lista, crear, obtener, actualizar, eliminar } from "../controller/sub_categorias.js";

const router = express.Router();

router.get("/", lista);

router.get("/obtener/:id", obtener);

router.post("/crear", crear);

router.put("/actualizar/:id", actualizar);

router.delete("/eliminar/:id", eliminar);

export default router;