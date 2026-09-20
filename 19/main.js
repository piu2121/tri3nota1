let diasSemana = document.querySelectorAll("#previsoes>section");
let diasAmostra = [1, 5];
let tempoSemana = [];
const btanterior=document.querySelector("#voltar");
const btproximo=document.querySelector("#avancar");
const showTempo = (tempo) => {
    const semana = document.querySelector("#previsoes");
    semana.forEach((el) => {
        el.document.querySelector('h2').value = tempo;
        const container = el.document.querySelector('#container-previsao-info');
        container.document.querySelector('label[for="%chuva"]').value = tempo.chuva;
        container.document.querySelector('label[for="%UV"]').value = tempo.UV;
        container.document.querySelector('label[for="%polem"]').value = tempo.polem;
    });
}
const getTempo = async () => {
    const resposta = await fetch("", {
        headers: { "Content-Type": "application/json" },
        method: "GET"
    })
    const dados = await resposta.json();
    showTempo(dados);
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
//getTempo();