import express from 'express';
import dotenv from 'dotenv';
import { conectaDB, supabase } from './config/supabase.js';
import authRoutes from './routes/auth.js';
import { version } from 'node:os';
import userRoutes from './routes/usuarios.js'
import categoriasRoutes from './routes/categorias.js';
import subcategoriasRoutes from "./routes/sub_categorias.js";
import productosRouter from "./routes/productos.js";

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
//ruta de autenticacion
app.use('/categorias', categoriasRoutes);
app.use('/subcategorias', subcategoriasRoutes);
app.use('/productos', productosRouter); 

// rutas del crud de usuario
app.use('/usuario', userRoutes);

// rutas de el registro y del login
app.use('/auth', authRoutes)

// configuramos el puerto
const PORT = 3000;

// poner a escuchar el servidor
app.listen(PORT, () => {
    console.log(`👍 servidor escuchando en el puerto ${PORT}`);
    console.log(`http://localhost:${PORT}`);
});