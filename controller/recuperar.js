import { codigorecupera, marcarCodigoComoUsado, codigovalido } from "../model/recuperar.js";
import { obtenercorreo, actualizar } from "../model/usuarios.js";
import nodemailer from 'nodemailer';
import bcrypt from "bcryptjs";