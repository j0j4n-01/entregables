// Obtener las credenciales desde el servidor
async function getCredentials() {
    try {
        const response = await axios.get('/api/credentials');
        return response.data;
    } catch (error) {
        console.error('Error al obtener las credenciales:', error);
        return null;
    }
}

// Función para obtener los datos de la API
async function fetchData() {
    const credentials = await getCredentials();
    if (!credentials) return;

    const apiURL = 'http://jpnet08-001-site1.htempurl.com/SENA/exportacion';
    const { username, password } = credentials;

    try {
        const response = await axios.get(apiURL, {
            auth: {
                username: username,
                password: password
            }
        });
        const data = response.data;

        // Llamar a la función para llenar la tabla con los datos obtenidos
        fillTable(data);
    } catch (error) {
        console.error('Error al obtener los datos de la API:', error);
    }
}

// Función para llenar la tabla con los datos obtenidos
function fillTable(data) {
    const tableBody = document.querySelector('#dataTable tbody');
    tableBody.innerHTML = ''; // Limpiar cualquier contenido existente

    data.forEach(item => {
        const row = document.createElement('tr');

        row.innerHTML = `
            <td>${item.id}</td>
            <td>${item.nombre}</td>
            <td>${item.descripcion}</td>
            <td>${item.estado}</td>
            <td>
                <!-- Aquí puedes agregar botones o enlaces para acciones como editar o eliminar -->
                <button class="btn btn-primary">Editar</button>
                <button class="btn btn-danger">Eliminar</button>
            </td>
        `;

        tableBody.appendChild(row);
    });
}

// Llamar a la función para obtener los datos cuando la página se haya cargado
document.addEventListener('DOMContentLoaded', fetchData);
