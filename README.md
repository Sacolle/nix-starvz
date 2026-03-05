# Uso do Starvz em NixOS

O [starvz](https://github.com/schnorr/starvz/tree/master) é uma ferramenta de vialização para aplicações StarPU.
O manual de instalação é [INSTALL.org](https://github.com/schnorr/starvz/blob/master/INSTALL.org)
Há uma serie de outras dependências que precisam ser resolvidas antes do compilação final do `starvz`.
- [x] StarPU (for starpu\_fxt\_tool)
- [x] fxt
- [x] poti 
- [x] PajeNG (for pj\_dump)

Há também o pmtool (optional, for theoretical bounds) (SimGrid, Academic Initiative CPLEX), 
mas se não for necessário mexer nesse, não irei.

Além disso, no contexto do Nix, eu gostaria que todos os scripts que existem no projeto,
sejam eles R ou bash, possam ser executados fora de um dev environment. Para isso tenho que
descobrir como que um projeto Nix sistematicamente envolve scripts de um repo, além de como 
seria a "instalação".

## Resultados Parciais

O pacote em R parece ter sido compilado com sucesso, agora falta a ferramenta de gerar os pdf a 
partir dos traces.

Atualmente estou usando o ambiente de desenvolvimento, mas tenho um bug que o número de workers
no trace é maior que configurado na máquina. Acho que vou adicionar essa opção no próprio flake
do starpu, assim como mudá-lo um pouco. Acho que é benéfico desacoplar o star-fletcher da derivação 
do fletcher, colocando em repos diferentes.

