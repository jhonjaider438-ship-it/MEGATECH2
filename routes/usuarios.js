import express from 'express';
import { obteneruser, buscarporid, actualizaruser, eliminaruser, obtenerUsuarioPorCedula } from '../controller/usuarios.js';
import { verificarRol, verificarToken } from '../middleware/auth.js';

const router = express.Router();
// ruta para obtener todos los usuarios
router.get('/',verificarToken,verificarRol('Admin'), obteneruser);
// ruta para buscar usuario por id
router.get('/obtener/:id',verificarToken,verificarRol('Admin'), buscarporid);
// buscar usuarios por cedula
router.get('/cedula/:cedula',verificarToken,verificarRol('Admin'),obtenerUsuarioPorCedula);
// ruta para actualizar usuario
router.put('/actualizar/:id',verificarToken,verificarRol('Admin'), actualizaruser);
// ruta para eliminar usuario
router.delete('/eliminar/:id',verificarToken,verificarRol('Admin'), eliminaruser);

export default router;