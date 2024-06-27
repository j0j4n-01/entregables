

// ------------------------------------------------ VENTAS SEMANALES ------------------------------------------------

    const datosVentasSemanales = {
        labels: ["Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "Sábado", "Domingo"],
        datasets: [{
            label: 'Ventas',
            data: [1000, 1500, 1200, 1800, 2000, 2500, 2200],
            backgroundColor: [
                'rgba(255, 99, 132, 0.5)', // Rojo
                'rgba(54, 162, 235, 0.5)', // Azul
                'rgba(255, 205, 86, 0.5)', // Amarillo
                'rgba(75, 192, 192, 0.5)', // Verde
                'rgba(153, 102, 255, 0.5)', // Morado
                'rgba(255, 159, 64, 0.5)', // Naranja
                'rgba(54, 162, 235, 0.5)'  // Repetimos color azul
            ],
            borderColor: [
                'rgba(255, 99, 132, 1)', // Rojo
                'rgba(54, 162, 235, 1)', // Azul
                'rgba(255, 205, 86, 1)', // Amarillo
                'rgba(75, 192, 192, 1)', // Verde
                'rgba(153, 102, 255, 1)', // Morado
                'rgba(255, 159, 64, 1)', // Naranja
                'rgba(54, 162, 235, 1)'  // Repetimos color azul
            ],
            borderWidth: 1
        }]
    };

    const configVentasSemanales = {
        type: 'bar',
        data: datosVentasSemanales,
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Ganancias',
                        font: {
                            size: 16,
                            weight: 'bold',
                            family: 'Arial'
                        }
                    }
                }
            }
        }
    };

    var ventasSemanalesChart = new Chart(
        document.getElementById('graficoVentasSemanales'),
        configVentasSemanales
    );

// ------------------------------------------------ VENTAS ANUALES ------------------------------------------------

    const datosComparativaAnual = {
        labels: ["Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"],
        datasets: [{
            label: 'Ventas 2023',
            data: [1000, 1200, 1300, 1500, 1800, 2000, 2200, 2300, 2100, 1900, 1600, 1400],
            backgroundColor: 'rgba(54, 162, 235, 0.5)',
            borderColor: 'rgba(54, 162, 235, 1)',
            borderWidth: 1
        },
        {
            label: 'Ventas 2024',
            data: [1100, 1300, 1400, 1600, 1900, 2100, 2300, 2400, 2200, 2000, 1700, 1500],
            backgroundColor: 'rgba(255, 99, 132, 0.5)',
            borderColor: 'rgba(255, 99, 132, 1)',
            borderWidth: 1
        }]
    };

    const configComparativaAnual = {
        type: 'bar',
        data: datosComparativaAnual,
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Ganancias',
                        font: {
                            size: 16,
                            weight: 'bold',
                            family: 'Arial'
                        }
                    }
                }
            }

        }
    };

    var comparativaAnualChart = new Chart(
        document.getElementById('graficoComparativoAnual'),
        configComparativaAnual
    );

// ------------------------------------------- TOP PRODUCTOS MÁS VENDIDOS ----------------------------------------------

    const productosMasVendidos = {
        labels: ["Producto A", "Producto B", "Producto C", "Producto D", "Producto E"],
        data: [50, 40, 30, 20, 10]
    };

    const configProductosMasVendidos = {
        type: 'bar',
        data: {
            labels: productosMasVendidos.labels,
            datasets: [{
                label: 'Ventas',
                data: productosMasVendidos.data,
                backgroundColor: 'rgba(54, 162, 235, 0.5)',
                borderColor: 'rgba(54, 162, 235, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Cantidad de productos',
                        font: {
                            size: 16,
                            weight: 'bold',
                            family: 'Arial'
                        }
                    }
                }
            }
        }
    };

    var productosMasVendidosChart = new Chart(
        document.getElementById('graficoProductosMasVendidos'),
        configProductosMasVendidos
    );


// ------------------------------------------- TOP PRODUCTOS MENOS VENDIDOS ----------------------------------------------

    const productosMenosVendidos = {
        labels: ["Producto F", "Producto G", "Producto H", "Producto I", "Producto J"],
        data: [5, 8, 12, 15, 20]
    };

    const configProductosMenosVendidos = {
        type: 'bar',
        data: {
            labels: productosMenosVendidos.labels,
            datasets: [{
                label: 'Ventas',
                data: productosMenosVendidos.data,
                backgroundColor: 'rgba(255, 99, 132, 0.5)',
                borderColor: 'rgba(255, 99, 132, 1)',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Cantidad de productos',
                        font: {
                            size: 16,
                            weight: 'bold',
                            family: 'Arial'
                        }
                    }
                }
            }
        }
    };

    var productosMenosVendidosChart = new Chart(
        document.getElementById('graficoProductosMenosVendidos'),
        configProductosMenosVendidos
    );

// ------------------------------------------- MOSTRAR IMAGENES DE PRODUCTOS ----------------------------------------------

     function mostrarDetallesProductos(productListId, productos) {
        const productList = document.getElementById(productListId);
        productList.innerHTML = '';
        productos.labels.forEach((producto, index) => {
            const listItem = document.createElement('li');
            listItem.classList.add('product-list-item');
            listItem.innerHTML = `
      <img src="https://via.placeholder.com/50" alt="Imagen de ${producto}">
      <span>${producto}</span>
      <span class="ml-auto">${productos.data[index]} ventas</span>
    `;
            productList.appendChild(listItem);
        });
    }

    mostrarDetallesProductos('productosMasVendidosList', productosMasVendidos);

    mostrarDetallesProductos('productosMenosVendidosList', productosMenosVendidos);
