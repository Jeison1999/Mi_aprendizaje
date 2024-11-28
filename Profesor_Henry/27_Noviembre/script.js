async function mostrarInformacion(params) {
  const id = document.getElementById('idInput').value;
  try{
    const response = await fetch (`https://jsonplaceholder.typicode.com/todos/${id}`);
    if (!response.ok){
      throw new Error('Error al obtener la información');
    }
    const data = await response.json();
    document.getElementById('idArticle').innerText = data.id;
    document.getElementById('nombreArticle').innerText = data.userId;
    document.getElementById('apellidoArticle').innerText = data.title;
    document.getElementById('edadArticle').innerText = data.completed;
  }catch(error){
    alert(error.message);
  }
  
}