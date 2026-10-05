let diasSemana = document.querySelectorAll("#previsoes>section");
let diasAmostra = [1, 5];
let tempoSemana = [];
const btanterior = document.querySelector("#voltar");
const btproximo = document.querySelector("#avancar");
const showTempo = async (tempo) => {
    const semana = document.querySelector("#previsoes").querySelectorAll('#container-previsao-img');
    try {
        tempo.forEach((element) => {
            semana.forEach((el) => {
                const diaSemana = el.querySelector("h2").textContent.trim();
                if (element.dia === diaSemana) {
                    const img = el.querySelector("img");
                    const chance = element.chanceDeChuva;
                    if (chance >= 70) {
                        img.src = "./imagens/chuva.jpg";
                    } else if (chance > 30) {
                        img.src = "./imagens/nublado.jpg";
                    } else {
                        img.src = "./imagens/sol.jpg";
                    }
                    el.querySelector("h3").textContent = element.data;
                    const container = el.parentElement.querySelector("#container-previsao-info");
                    container.querySelector('label[for="%chuva"]').textContent = `${chance}%`;
                }
            });
        });
    } catch (e) { console.error(e) }
}
const getTempo = async () => {
    //const latitude =-27,025;
    // const longetude =-48,654;
    const url = "https://api.open-meteo.com/v1/forecast?latitude=-23.55&longitude=-46.63&daily=precipitation_probability_max&timezone=America%2FSao_Paulo";

    const resposta = await fetch(url);
    const dados = await resposta.json();
    const previsao = await dados.daily.time.map((data, i) => ({
        data: data,
        dia: new Date(`${data}T12:00:00`).toLocaleDateString("pt-BR", {
            weekday: "long"
        }),
        chanceDeChuva: dados.daily.precipitation_probability_max[i]
    }));
    showTempo(previsao);
}
const proximo = () => {
    const semana = document.querySelector("#previsoes");
    semana.appendChild(diasSemana[0]);
    diasSemana = document.querySelectorAll("#previsoes>section");
}
const anterior = () => {
    const semana = document.querySelector("#previsoes");
    semana.prepend(diasSemana[diasSemana.length - 1]);
    diasSemana = document.querySelectorAll("#previsoes>section");
}
btanterior.addEventListener("click", anterior);
btproximo.addEventListener("click", proximo);
getTempo();