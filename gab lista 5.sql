--q2
select fp.prcodigo, pr.descricao
from fornece_produtos fp
inner join produtos pr on pr.prcodigo = fp.prcodigo
inner join fornecedores f on f.fcodigo = fp.fcodigo
where f.fnome = 'F231' and pr.prcodigo not in (
	select distinct ip.prcodigo
	from itens_pedidos ip
	inner join pedidos pe on pe.pecodigo = ip.pecodigo
	inner join clientes_vips cv on cv.clcodigo = pe.clcodigo
	)
--q3 && q4

create view pesum2(pecod, custo) as
select pecodigo, sum(quantidade*valor)
from itens_pedidos
group by pecodigo
order by pecodigo

create view peclcus1(pecod, clcod, clnom, cus) as
select pe.pecodigo, cl.nome, cl.clcodigo, pes.custo
from pedidos pe
inner join clientes cl on pe.clcodigo = cl.clcodigo
inner join pesum2 pes on pe.pecodigo = pes.pecod

select p1.clnom, p1.clcod, avg(p1.cus)
from peclcus1 p1, peclcus p2
group by p1.clcod, clnom
having avg(p1.cus) > avg(p2.cus)
--q5
create view peclcus2(pecod, clcod, clnom, clcid ,  cus) as
select pe.pecodigo, cl.nome, cl.clcodigo, cl.cidade, pes.custo
from pedidos pe
inner join clientes cl on pe.clcodigo = cl.clcodigo
inner join pesum2 pes on pe.pecodigo = pes.pecod

select clnom, clcod, clcid
from peclcus2
order by cus desc
limit 1
--ou
select clnom, clcod, clcid
from peclcus2
where cus >= all(select cus from peclcus2)

