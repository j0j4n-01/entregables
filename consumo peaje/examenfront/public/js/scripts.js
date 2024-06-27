// ------------------------------------------------ ALERTS ----------------------------------------------------

function alertSucces() {
    Swal.fire({
        icon: "success",
        title: "Guardado con éxito",
        timer: 1200,
        showConfirmButton: false
    });
}

function alertError() {
    Swal.fire({
        icon: "error",
        title: "El abono no puede superar la deuda actual",
        timer: 3000
    });
}

function alertErrorPassword() {
    Swal.fire({
        icon: 'error',
        title: 'Error',
        text: 'Las contraseñas no coinciden',
        showConfirmButton: true
    });
}

function alertQuestion() {
    Swal.fire({
        title: "¿Estás seguro?",
        icon: "warning",
        showCancelButton: true,
        confirmButtonColor: "#3085d6",
        cancelButtonColor: "#d33",
        confirmButtonText: "Estoy seguro"
    }).then((result) => {
        if (result.isConfirmed) {
            Swal.fire({
                title: "¡Eliminado!",
                text: "Eliminado con éxito",
                icon: "success",
                timer: 1500
            });
        } else if (result.dismiss) {
            Swal.fire({
                title: "Cancelado",
                text: "El proceso ha sido cancelado",
                icon: "error",
                timer: 3000
            });
        }

    });
}

function alertSuccesClients() {
    Swal.fire({
        icon: "success",
        title: "Estado cambiado con éxito",
        timer: 1200,
        showConfirmButton: false
    });
}
// ------------------------------------------------ FORM VALIDATION ----------------------------------------------------
// Valida los campos en tiempo real
function handleInputChange(event) {
    var input = event.target;

    if (!input.checkValidity()) {
        input.classList.add('is-invalid');
    } else {
        input.classList.remove('is-invalid');
    }
}

document.querySelectorAll('.form-control').forEach(input => {
    input.addEventListener('input', handleInputChange);
});

// Función para manejar el envío del formulario
function handleSubmit(event) {
    event.preventDefault();

    var form = event.target.closest('.form');
    var isValid = true;

    // Validar el resto de los campos
    form.querySelectorAll('.form-control').forEach(input => {
        if (!input.checkValidity()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
        }
    });

    if (isValid) {
        alertSucces();
        setTimeout(function () {
            form.submit();
            resetForm(form);
        }, 1200);
    }
}

document.querySelectorAll(".submit-button")
    .forEach(button => button.addEventListener("click", handleSubmit));

// Función para validar los campos de contraseña y confirmar contraseña
function validatePasswordFields(form) {
    var password = form.querySelector("#password");
    var confirmPassword = form.querySelector("#confirmPassword");

    if (password.value !== confirmPassword.value) {
        password.classList.add('is-invalid');
        confirmPassword.classList.add('is-invalid');
        alertErrorPassword();
        return false;
    } else {
        password.classList.remove('is-invalid');
        confirmPassword.classList.remove('is-invalid');
        return true;
    }
}

// Función para restablacer y validar contraseña
function restorePassword(event) {
    event.preventDefault();

    var form = event.target.closest('.form');
    var isValid = true;

    // Validar campos de contraseña y confirmar contraseña específicamente
    if (!validatePasswordFields(form)) {
        isValid = false;
    }

    // Validar el resto de los campos
    form.querySelectorAll('.form-control').forEach(input => {
        if (!input.checkValidity()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
        }
    });

    if (isValid) {
        Swal.fire({
            position: "center",
            icon: "success",
            title: "Tu contraseña ha sido restablecida",
            showConfirmButton: false,
            timer: 1500,
            backdrop: `
              rgba(0,0,123,0.4)
              url(assets/img/cat.gif)
              left top
              no-repeat
            `
        });

        // Redirigir después de un cierto tiempo (por ejemplo, 2 segundos)
        setTimeout(function () {
            window.location.href = "/";
        }, 2000); // 2000 milisegundos = 2 segundos
    }
}
document.querySelectorAll(".submit-button-Password")
    .forEach(button => button.addEventListener("click", restorePassword));

// Función para validar contraseña de Usuarios
function validatePassword(event) {
    event.preventDefault();

    var form = event.target.closest('.form');
    var isValid = true;

    // Validar campos de contraseña y confirmar contraseña específicamente
    if (!validatePasswordFields(form)) {
        isValid = false;
    }

    // Validar el resto de los campos
    form.querySelectorAll('.form-control').forEach(input => {
        if (!input.checkValidity()) {
            input.classList.add('is-invalid');
            isValid = false;
        } else {
            input.classList.remove('is-invalid');
        }
    });

    if (isValid) {
        alertSucces();
        setTimeout(function () {
            form.submit();
            resetForm(form);
        }, 1200);
    }

 
}

document.querySelectorAll(".submit-button-user")
    .forEach(button => button.addEventListener("click", validatePassword));


// El botón de Enter funciona como un click
document.querySelectorAll('input').forEach(input => {
    input.addEventListener('keypress', function (event) {

        if (event.key === 'Enter') {

            const form = input.closest('form');

            const submitButton = form.querySelector('.submit-button');

            if (submitButton) {
                submitButton.click();
            }
        }
    });
});

// ------------------------------------------------ CREDITS ----------------------------------------------------

function calculateRemainingDebt() {

    var currentDebt = parseFloat(document.getElementById('currentDebt').innerText.replace('$', '').replace(',', ''));
    var payment = parseFloat(document.getElementById('paymentInput').value);

    // Se valida que el abono no sea mayor a la deuda
    if (payment > currentDebt) {
        alertError();
        document.getElementById('paymentInput').value = "";
        return;
    }

    var remainingDebt = currentDebt - payment;

    document.getElementById('remainingDebt').innerText = '$' + remainingDebt.toFixed(2);

}

function showAlert(event) {
    event.preventDefault(); // Evitar el envío automático del formulario

    var form = document.querySelector('.formd');

    if (form.checkValidity()) {
        form.classList.add('was-validated'); // Agregar la clase .was-validated al formulario

        var modal = event.target.closest('.modal');
        bootstrap.Modal.getInstance(modal).hide();

        alertSucces();
        form.reset();
    }
}

// Trae los datos de la tabla y los muestra en la modal
$('#payment').on('show.bs.modal', function (event) {

    var button = $(event.relatedTarget);
    var originalValue = button.data('original-value');
    var currentDebt = button.data('current-debt');
    var modal = $(this);

    modal.find('#originalValue').text('$' + originalValue);
    modal.find('#currentDebt').text('$' + currentDebt);
});


// El botón de abonar solo está disponible si hay una deuda pendiente
function updateAbonarButtonAvailability() {

    const currentDebt1 = parseFloat(document.getElementById('tableCurrentDebt1').textContent);
    const abonarButton1 = document.getElementById('abonarButton1');
    const currentDebt2 = parseFloat(document.getElementById('tableCurrentDebt2').textContent);
    const abonarButton2 = document.getElementById('abonarButton2');

    abonarButton1.disabled = (currentDebt1 === 0);
    abonarButton2.disabled = (currentDebt2 === 0);
}

updateAbonarButtonAvailability();


