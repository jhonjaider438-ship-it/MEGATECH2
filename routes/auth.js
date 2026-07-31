import express from 'express';
import { registro, login } from '../controller/auth.js';

const router = express.Router();

// rutas de autenticacion
router.post('/registro', registro);
router.post('/login', login);

export default router