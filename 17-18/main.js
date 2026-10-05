const meuForms=document.querySelector('form')
console.log(meuForms)
meuForms.addEventListener('submit',(event)=>{
    event.preventDefault()
    const dados = Object.fromEntries(new FormData(meuForms).entries());
    console.log(dados);
})