// const productos = [
//   { id: 1, nombre: 'Frappé de Café y Canela', precio: 15000, descripcion:'Un delicioso batido que contiene café fuerte, leche, hielo y leche condensada, que le da un sabor dulce y cremoso. Se espolvorea con canela',imagen: '../../img/cafeLeche.jpeg'},
//   { id: 2, nombre: 'Frappé de Fresas con Crema', precio: 17000, descripcion:'Un delicioso batido que contiene fresas naturales, leche, hielo y un poco de azúcar. Se corona con crema batida y fresas frescas', imagen:'../../img/fresasCrema.jpeg'},
//   { id: 3, nombre: 'Frappé de Café Chips', precio: 17000, descripcion: 'Un delicioso batido que contiene café, leche, hielo y jarabe de chocolate, además de chispas de chocolate y malvaviscos como toppings', imagen: '../../img/ChocolateChips.jpeg' },
//   { id: 4, nombre: 'Frappé de Vainilla Arequipe', precio: 16000, descripcion:'Un delicioso batido de vainilla con crema batida y caramelo.Combina el sabor suave de la vainilla con el toque cremoso de la crema batida y el sirope de caramelo.', imagen: '../../img/vainillaArequipe.jpeg' },
//   { id: 5, nombre: 'Frappé explosión de mango', precio: 18000, descripcion:'Un delicioso batido que contiene mango maduro, leche de coco, hielo y un poco de miel. Se decora con trozos de mango para darle una textura más agradable.', imagen:'../../img/fCoco.jpeg' },
//   { id: 6, nombre: 'Frappé de oreo', precio: 20000, descripcion:'Un delicioso batido que contiene leche, hielo y galletas oreo licuadas, que le dan un sabor único y una consistencia cremosa. Se adorna con crema batida y galletas oreo trituradas.', imagen: '../../img/F_Oreo.jpeg' },
//   { id: 7, nombre: 'Frappé de té verde', precio: 15000, descripcion:'Un delicioso batido que es una opción diferente y refrescante, contiene té verde frío, leche, hielo y un poco de azúcar. Se adorna con hojas de menta para darle un toque aromático y refrescante.', imagen: '../../img/F_Menta.jpeg' },
//   { id: 8, nombre: 'Frappé de piña colada', precio: 20000, descripcion:'Un delicioso batido la cual es una versión sin alcohol de la famosa bebida piña colada, ya que contiene piña natural, leche de coco, hielo y un poco de azúcar. Se decora con trozos de piña.', imagen: '../../img/F_Piña.jpeg' }

// ];

// let carrito = [];

// // Función para renderizar productos
// function renderizarProductos() {
// const contenedorProductos = document.getElementById('productos');

// for (let i = 0; i < productos.length; i++) {
// const producto = productos[i];

// // Crear el contenedor de la tarjeta de producto
// const tarjetaProducto = document.createElement('div');
// tarjetaProducto.className = 'col mb-5';

// // Crear la card de Bootstrap
// const cardBootstrap = document.createElement('div');
// cardBootstrap.className = 'card h-60';


// // Agregar la imagen del producto
// const imagenProducto = document.createElement('img');
// imagenProducto.className = 'card-img-top';
// imagenProducto.src = producto.imagen;
// cardBootstrap.appendChild(imagenProducto);

// // Detalles del producto
// const detallesProducto = document.createElement('div');
// detallesProducto.className = 'card-body p-4';

// // Nombre del producto
// const nombreProducto = document.createElement('h5');
// nombreProducto.className = 'fw-bolder';
// nombreProducto.textContent = producto.nombre
// detallesProducto.appendChild(nombreProducto);


// // Precio del producto
// const precioProducto = document.createElement('div');
// precioProducto.textContent = `Precio: $${producto.precio}`;
// precioProducto.className='fw-bolder'
// detallesProducto.appendChild(precioProducto);


// const descripcionProducto = document.createElement('div');
// descripcionProducto.textContent = `${producto.descripcion}`;
// detallesProducto.appendChild(descripcionProducto);

// detallesProducto.className = 'text-center p-3';
// detallesProducto.appendChild(nombreProducto);
// detallesProducto.appendChild(descripcionProducto);
// detallesProducto.appendChild(precioProducto);



// cardBootstrap.appendChild(detallesProducto);

// // Acciones del producto (botón Agregar en este caso)
// const accionesProducto = document.createElement('div');
// accionesProducto.className = 'card-footer p-4 pt-0 border-top-0 bg-transparent text-center mt-3 ';

// const botonViajar = document.createElement('button');
// botonViajar.className = 'btn btn-outline-dark mt-auto text-center';
// botonViajar.textContent = 'Agregar';
// // Asociar la función agregarAlCarrito al evento click del botón Viajar
// botonViajar.onclick = () => agregarAlCarrito(producto.nombre, producto.precio);

// accionesProducto.appendChild(botonViajar);
// cardBootstrap.appendChild(accionesProducto);

// // Agregar la card de Bootstrap al contenedor de productos
// tarjetaProducto.appendChild(cardBootstrap);

// // Agregar el contenedor de la tarjeta de producto al contenedor general
// contenedorProductos.appendChild(tarjetaProducto);

// function cambiarColorLetraYPaddingDetallesProducto() {
// const detallesProducto = document.querySelectorAll('.card-body');

// for (let detalleProducto of detallesProducto) {
//   detalleProducto.style.color = '#000';
//   detalleProducto.style.fontWeight='600';
// }
// }

// }
// }


// // Llamada a la función para renderizar productos

// // Función para agregar productos al carrito
// function agregarAlCarrito(nombre) {
//   const productoEncontrado = productos.find(producto => producto.nombre === nombre);

//   if (productoEncontrado) {
//     const itemExistente = carrito.find(item => item.nombre === nombre);

//     if (itemExistente) {
//       itemExistente.cantidad++;
//     } else {
//       carrito.push({ nombre, precio: productoEncontrado.precio, cantidad: 1 });
//     }

//     actualizarCarrito();
//   } else {
//     console.error(`Producto no encontrado: ${nombre}`);
//   }
// }
// function actualizarCarrito() {
//   const contenedorItemsCarrito = document.getElementById('items-carrito');
//   const totalCarritoElemento = document.getElementById('total-carrito');

//   contenedorItemsCarrito.innerHTML = '';
//   let total = 0;

//   carrito.forEach((item, index) => {
//       const elementoItemCarrito = document.createElement('li');
//       elementoItemCarrito.className = 'item-carrito';

//       const nombreItem = document.createElement('span');
//       nombreItem.textContent = ` ${item.nombre} (Precio: $${item.precio}) Cantidad: ${item.cantidad}`;

//       const controlesItem = document.createElement('div');


//       const botonAumentar = document.createElement('button');
//       botonAumentar.className = 'btn btn-success mx-1 ';
//       botonAumentar.textContent = '+';
//       botonAumentar.onclick = () => aumentarCantidad(index);

//       const botonDisminuir = document.createElement('button');
//       botonDisminuir.className = 'btn btn-warning mx-1';
//       botonDisminuir.textContent = '-';
//       botonDisminuir.onclick = () => disminuirCantidad(index);

//       const botonEliminar = document.createElement('button');
//       botonEliminar.className = 'btn btn-danger mx-1';
//       botonEliminar.textContent = 'Eliminar';
//       botonEliminar.onclick = () => eliminarItem(index);

//       controlesItem.appendChild(botonDisminuir);
//       controlesItem.appendChild(botonAumentar);
//       controlesItem.appendChild(botonEliminar);

//       elementoItemCarrito.appendChild(nombreItem);
//       elementoItemCarrito.appendChild(controlesItem);

//       contenedorItemsCarrito.appendChild(elementoItemCarrito);
//       total += item.precio * item.cantidad;
//   });

//   totalCarritoElemento.textContent = total;
// }

// // Función para vaciar el carrito
// function vaciarCarrito() {
//   carrito = [];
//   actualizarCarrito();
// }

// // Función para aumentar la cantidad de un producto en el carrito
// function aumentarCantidad(index) {
//   carrito[index].cantidad++;
//   actualizarCarrito();
// }

// // Función para disminuir la cantidad de un producto en el carrito
// function disminuirCantidad(index) {
//   if (carrito[index].cantidad > 1) {
//       carrito[index].cantidad--;
//   } else {
//       eliminarItem(index);
//   }
//   actualizarCarrito();
// }

// // Función para eliminar un producto del carrito
// function eliminarItem(index) {
//   carrito.splice(index, 1);
//   actualizarCarrito();
// }

// // Inicializar la tienda
// renderizarProductos();



// //Formulario de Devolucion Local
// (function() {
//   'use strict';

//   // Form validation
//   var form = document.getElementById('yourFormId'); // Replace with your form's ID
//   form.addEventListener('submit', function(event) {
//     if (!form.checkValidity()) {
//       event.preventDefault();
//       event.stopPropagation();
//     }

//     form.classList.add('was-validated'); // Bootstrap's validation class
//   });

//   // Additional validation checks (optional)
//   var inputNit = document.getElementById('inputNit');
//   inputNit.addEventListener('input', function() {
//     if (!/^[0-9]+$/.test(this.value)) {
//       this.classList.add('is-invalid');
//     } else {
//       this.classList.remove('is-invalid');
//     }
//   });

//   // Similar checks for other input fields (optional)
//   var inputProducto = document.getElementById('inputProducto');
//   // ... (add similar validation logic for product name)
// });
//---------------------------------------------- Asignacion de saldo y créditos-----------------------------------------//

function toggleCreditos() {
    var checkbox = document.getElementById("checkboxCreditos");
    var creditosContainer = document.getElementById("creditosContainer");

    if (checkbox.checked) {
        creditosContainer.style.display = "block";
    } else {
        creditosContainer.style.display = "none";
    }
}

function toggleSaldoParcial() {
    var checkbox = document.getElementById("checkboxSaldosACredito");
    var saldosContainer = document.getElementById("SaldoParcialContainer");

    if (checkbox.checked) {
        saldosContainer.style.display = "block";
    } else {
        saldosContainer.style.display = "none";
    }
}

// -------- saldo no superior al total de compra ----------- NO TERMINADO a falta de tiempo 
// function calculateRemainingSaldo() {

//     let totalbalance=parseFloat(getElementById('totalBalance').value) 
//     let partialvalue=parseFloat(getElementById('partialvalue').value)

//     if (partialvalue>totalbalance) {
//         document.getElementById('partialvalue').value = "";
//         return;
//     }

//     document.getElementById('balanceResult').innerText="El valo de acreditado supera el total de la factura";

//     document.getElementById('remainingDebt').innerText = '$' + remainingDebt.toFixed(2);


// }


// --------------------------------- alerts----------------------------------------
//  ALERTA DE IMPRESION 

	let timerInterval;

	function impresion() {

		// After printing (for both options)
		Swal.fire({
			title: "Imprimiendo Factura", // Change title to "Printing Invoice" or similar
			html: "Espere un momento...", // Change message to "Please wait..." or similar
			timer: 1000, // Adjust timer duration as needed
			timerProgressBar: true,
			didOpen: () => {
				Swal.showLoading();
			},
			willClose: () => {
				clearInterval(timerInterval);
			}
		});
	}

    //  ALERTA DE IMPRESION 

    
	function printInvoice()

	// After printing (for both options)
	{
		Swal.fire({
			icon: "success",
			title: "Saved",
			showConfirmButton: true,
			timer: 1500
		});
	}
