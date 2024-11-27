fetch('https://jsonplaceholder.typicode.com/todos/1')
      .then(response => response.json())
      .then(json =>{
        console.log(json)
        var a = document.querySelector("body > main > section > section.section1 > article")
        a.innerHTML = json.userId;

        var b = document.querySelector("body > main > section > section.section2 > article")
        b.innerHTML = json.id;

        var c = document.querySelector("body > main > section > section:nth-child(3) > article")
        c.innerHTML = json.title;

        var d = document.querySelector("body > main > section > section:nth-child(4) > article")
        d.innerHTML = json.completed;
        })

