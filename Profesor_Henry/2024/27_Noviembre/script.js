async function mostrarInformacion() {
  const id = document.getElementById('idInput').value;
  try {
    const response = await fetch(`https://jsonplaceholder.typicode.com/todos/${id}`);
    if (!response.ok) {
      throw new Error('Error al obtener la información');
    }
    const data = await response.json();
    document.getElementById("UsedId").innerText = data.userId;
    document.getElementById("ID").innerText = data.id;
    document.getElementById("Title").innerText = data.title;
    document.getElementById("Completed").innerText = data.completed;
  } catch (error) {
    alert(error.message);
  }
}