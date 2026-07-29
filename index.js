import express from 'express';
import dotenv from 'dotenv';
import { conectaDB, supabase } from './config/supabase.js';
import authRoutes from './routes/auth.js';
import { version } from 'node:os';

// cargar las variables de entorno
dotenv.config();
conectaDB(); 

// creamos la aplicacion de express
const app =  express();

// leer el json
app.use(express.json());

// ruta de prueba
app.get('/',(req,res)=>{
    res.json({
        mensaje: 'bienvenido al backend de MEGATECH2',
        estado : 'en ilnea',
        version : '1.0.0'
    });
});

// configuramos el puerto
const PORT = 3000;

// poner a escuchar el servidor
app.listen(PORT, () => {
    console.log(`👍 servidor escuchando en el puerto ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});