import ExcelJS from 'exceljs';
import { obtenerReporteVentas } from '../model/ventas.js';

// ---------- Utilidades ----------

// "2026-10-08" -> Date en hora LOCAL del servidor (evita el corrimiento de un día
// que ocurre con new Date("2026-10-08"), que se interpreta como UTC)
const fechaLocal = (texto, finDelDia) => {
    const dia = String(texto).slice(0, 10);
    return new Date(`${dia}T${finDelDia ? '23:59:59.999' : '00:00:00'}`);
};

// Muestra la fecha tal cual está guardada en la BD (ya viene con el ajuste de -5h)
const textoFecha = (f) => String(f).replace('T', ' ').slice(0, 19);

// Date -> "AAAA-MM-DD" en hora local del servidor
const soloDia = (d) => {
    const mm = String(d.getMonth() + 1).padStart(2, '0');
    const dd = String(d.getDate()).padStart(2, '0');
    return `${d.getFullYear()}-${mm}-${dd}`;
};

// ---------- Lógica del reporte (la comparten el JSON y el Excel) ----------

const construirReporte = async (query) => {
    const { periodo, fecha_inicio, fecha_fin, id_vendedor, id_categoria, id_subcategoria } = query;

    let fechaInicio;
    let fechaFin;
    const ahora = new Date();

    if (periodo === 'hoy') {
        fechaInicio = new Date(); fechaInicio.setHours(0, 0, 0, 0);
        fechaFin = new Date();    fechaFin.setHours(23, 59, 59, 999);

    } else if (periodo === 'semana') {
        fechaInicio = new Date();
        const dia = fechaInicio.getDay();
        fechaInicio.setDate(fechaInicio.getDate() - (dia === 0 ? 6 : dia - 1));
        fechaInicio.setHours(0, 0, 0, 0);
        fechaFin = new Date(); fechaFin.setHours(23, 59, 59, 999);

    } else if (periodo === 'mes') {
        fechaInicio = new Date(ahora.getFullYear(), ahora.getMonth(), 1);
        fechaFin = new Date(ahora.getFullYear(), ahora.getMonth() + 1, 0);
        fechaFin.setHours(23, 59, 59, 999);

    } else if (fecha_inicio && fecha_fin) {
        fechaInicio = fechaLocal(fecha_inicio, false);
        fechaFin = fechaLocal(fecha_fin, true);
        if (isNaN(fechaInicio) || isNaN(fechaFin)) {
            return { status: 400, body: { error: 'Las fechas no tienen un formato válido (AAAA-MM-DD).' } };
        }

    } else {
        return { status: 400, body: { error: 'Debe indicar un periodo o un rango de fechas.' } };
    }

    const { data, error } = await obtenerReporteVentas(fechaInicio.toISOString(), fechaFin.toISOString());
    if (error) return { status: 500, body: { error: error.message } };

    let ventas = data || [];

    if (id_vendedor) {
        ventas = ventas.filter(v => String(v.id_vendedor) === String(id_vendedor));
    }

    const filtraDetalle = Boolean(id_categoria || id_subcategoria);

    if (id_categoria) {
        ventas = ventas
            .map(v => ({
                ...v,
                detalle_venta: v.detalle_venta.filter(
                    d => String(d.productos?.subcategorias?.categorias?.id) === String(id_categoria)
                )
            }))
            .filter(v => v.detalle_venta.length > 0);
    }

    if (id_subcategoria) {
        ventas = ventas
            .map(v => ({
                ...v,
                detalle_venta: v.detalle_venta.filter(
                    d => String(d.productos?.subcategorias?.id) === String(id_subcategoria)
                )
            }))
            .filter(v => v.detalle_venta.length > 0);
    }

    let totalVentas = 0, totalUnidades = 0, totalDetalles = 0;

    ventas.forEach(v => {
        v.detalle_venta.forEach(d => {
            totalUnidades += Number(d.cantidad);
            totalDetalles++;
        });
        if (!filtraDetalle) {
            totalVentas += Number(v.total);
        } else {
            v.detalle_venta.forEach(d => { totalVentas += Number(d.subtotal); });
        }
    });

    return {
        status: 200,
        body: {
            periodo: periodo || 'personalizado',
            fecha_inicio: fechaInicio,
            fecha_fin: fechaFin,
            filtra_detalle: filtraDetalle,
            resumen: {
                cantidad_ventas: ventas.length,
                cantidad_detalles: totalDetalles,
                unidades_vendidas: totalUnidades,
                total_vendido: totalVentas
            },
            ventas
        }
    };
};

// ---------- GET /ventas/reporte  (JSON) ----------

export const reporteVentas = async (req, res) => {
    try {
        const { status, body } = await construirReporte(req.query);
        res.status(status).json(body);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: error.message });
    }
};

// ---------- GET /ventas/reporte/excel  (archivo .xlsx) ----------

const FORMATO_MONEDA = '"$"#,##0';
const AZUL = 'FF0288D1';

const estiloEncabezado = (fila) => {
    fila.font = { bold: true, color: { argb: 'FFFFFFFF' } };
    fila.fill = { type: 'pattern', pattern: 'solid', fgColor: { argb: AZUL } };
    fila.alignment = { vertical: 'middle', horizontal: 'center' };
};

const generarLibro = (reporte) => {
    const wb = new ExcelJS.Workbook();
    wb.creator = 'MEGATECH 2';
    wb.created = new Date();

    // ---- Hoja 1: Resumen ----
    const hojaR = wb.addWorksheet('Resumen');
    hojaR.columns = [{ width: 30 }, { width: 28 }];
    hojaR.addRow(['Reporte de ventas - MEGATECH 2']).font = { bold: true, size: 14 };
    hojaR.addRow([]);
    hojaR.addRow(['Periodo', reporte.periodo]);
    hojaR.addRow(['Desde', soloDia(reporte.fecha_inicio)]);
    hojaR.addRow(['Hasta', soloDia(reporte.fecha_fin)]);
    hojaR.addRow([]);
    hojaR.addRow(['Cantidad de ventas', reporte.resumen.cantidad_ventas]);
    hojaR.addRow(['Líneas de detalle', reporte.resumen.cantidad_detalles]);
    hojaR.addRow(['Unidades vendidas', reporte.resumen.unidades_vendidas]);
    const filaTotal = hojaR.addRow(['Total vendido', reporte.resumen.total_vendido]);
    filaTotal.getCell(2).numFmt = FORMATO_MONEDA;
    filaTotal.font = { bold: true };
    for (let i = 3; i <= 9; i++) hojaR.getRow(i).getCell(1).font = { bold: true };

    // ---- Hoja 2: Detalle de ventas (una fila por producto vendido) ----
    const hoja = wb.addWorksheet('Detalle de ventas');
    hoja.columns = [
        { header: 'ID venta',        key: 'id',        width: 10 },
        { header: 'Fecha',           key: 'fecha',     width: 20 },
        { header: 'Vendedor',        key: 'vendedor',  width: 26 },
        { header: 'Cédula vendedor', key: 'cedula',    width: 18 },
        { header: 'Categoría',       key: 'categoria', width: 20 },
        { header: 'Subcategoría',    key: 'subcat',    width: 22 },
        { header: 'Producto',        key: 'producto',  width: 34 },
        { header: 'Cantidad',        key: 'cantidad',  width: 10 },
        { header: 'Precio unitario', key: 'precio',    width: 16 },
        { header: 'Subtotal',        key: 'subtotal',  width: 16 }
    ];
    estiloEncabezado(hoja.getRow(1));

    const porVendedor = new Map();

    reporte.ventas.forEach(v => {
        const u = v.usuarios || {};
        const nombreVend = `${u.nombre || ''} ${u.apellido || ''}`.trim() || `ID ${v.id_vendedor}`;

        let unidadesVenta = 0;
        let totalVenta = reporte.filtra_detalle ? 0 : Number(v.total);

        v.detalle_venta.forEach(d => {
            hoja.addRow({
                id: v.id,
                fecha: textoFecha(v.fecha),
                vendedor: nombreVend,
                cedula: u.cedula || '',
                categoria: d.productos?.subcategorias?.categorias?.nombre_categoria || '',
                subcat: d.productos?.subcategorias?.nombre || '',
                producto: d.productos?.nombre || `Producto ${d.id_producto}`,
                cantidad: Number(d.cantidad),
                precio: Number(d.precio_unitario),
                subtotal: Number(d.subtotal)
            });
            unidadesVenta += Number(d.cantidad);
            if (reporte.filtra_detalle) totalVenta += Number(d.subtotal);
        });

        const acc = porVendedor.get(nombreVend) || { ventas: 0, unidades: 0, total: 0 };
        acc.ventas += 1;
        acc.unidades += unidadesVenta;
        acc.total += totalVenta;
        porVendedor.set(nombreVend, acc);
    });

    hoja.getColumn('precio').numFmt = FORMATO_MONEDA;
    hoja.getColumn('subtotal').numFmt = FORMATO_MONEDA;
    hoja.views = [{ state: 'frozen', ySplit: 1 }];
    hoja.autoFilter = 'A1:J1';

    const ultima = hoja.rowCount;
    if (ultima > 1) {
        const fila = hoja.addRow({
            producto: 'TOTAL',
            cantidad: { formula: `SUM(H2:H${ultima})` },
            subtotal: { formula: `SUM(J2:J${ultima})` }
        });
        fila.font = { bold: true };
    }

    // ---- Hoja 3: Resumen por vendedor ----
    const hojaV = wb.addWorksheet('Por vendedor');
    hojaV.columns = [
        { header: 'Vendedor',          key: 'vendedor', width: 28 },
        { header: 'Ventas',            key: 'ventas',   width: 10 },
        { header: 'Unidades vendidas', key: 'unidades', width: 18 },
        { header: 'Total vendido',     key: 'total',    width: 18 }
    ];
    estiloEncabezado(hojaV.getRow(1));
    [...porVendedor.entries()]
        .sort((a, b) => b[1].total - a[1].total)
        .forEach(([vendedor, x]) => hojaV.addRow({ vendedor, ...x }));
    hojaV.getColumn('total').numFmt = FORMATO_MONEDA;

    return wb;
};

export const reporteVentasExcel = async (req, res) => {
    try {
        const { status, body } = await construirReporte(req.query);

        if (status !== 200) return res.status(status).json(body);

        const wb = generarLibro(body);
        const nombre = `reporte_ventas_${new Date().toISOString().slice(0, 10)}.xlsx`;

        res.setHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        res.setHeader('Content-Disposition', `attachment; filename="${nombre}"`);

        await wb.xlsx.write(res);
        res.end();
    } catch (error) {
        console.error(error);
        if (!res.headersSent) res.status(500).json({ error: error.message });
    }
};