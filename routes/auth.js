import express from 'express';
import { registro, login } from '../controller/auth.js';
import { enviarcorreo, verificode } from '../controller/recuperar.js';

const router = express.Router();

// rutas de autenticacion
router.post('/registro', registro);
router.post('/login', login);

// ruta para recuperar contraseña
router.post('/enviarcodigo', enviarcorreo);
router.post('/verificarcodigo', verificode);

export default router