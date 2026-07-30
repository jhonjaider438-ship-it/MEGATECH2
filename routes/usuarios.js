import express from 'express';
import { obteneruser, buscarporid, actualizaruser, eliminaruser } from '../controller/usuarios.js';

const router = express.Router();
// ruta para obtener todos los usuarios
router.get('/', obteneruser);
// ruta para buscar usuario por id
router.get('/obtener/:id', buscarporid);
// ruta para actualizar usuario
router.put('/actualizar/:id', actualizaruser);
// ruta para eliminar usuario
router.delete('/eliminar/:id', eliminaruser);

export default router;