--a)
create view 2a(pecod, prcod, quant) as
	select pecodigo, prcodigo, quantidade
	from itens_pedidos

select pr.prcodigo, pr.descricao, sum(coalesce(2a.quant, 0))
from produtos pr
left join 2a on 2a.prcodigo = pr.prcodigo
group by pr.prcodigo

--b)
create view a(clcod, clnome, pecod, prcod, custo) as
	select pe.clcodigo, cl.nome, pe.pecodigo, ip.prcodigo, ip.quantidade*ip.valor
	from pedidos pe
	inner join itens_pedidos ip on ip.pecodigo = pe.pecodigo
	inner join clientes cl 		on cl.clcodigo = pe.clcodigo

create view b(clcod, clnome, QT, MCP, VMP) as
	select a.clcod, a.clnome, count(distinct a.pecod), avg(a.custo), max(custo)
	from a
	group by a.clcod

create view c(pecod, custo) as
	select pecod, sum(custo)
	from a
	group by pecod

create view clientes_vips(clcod, nome, MCP, QT, VMP) as
	select b.clcod, b.nome, b.MCP, b.QT, b,VMP
	from b
	where (b.qt > (select count(pe.pecodigo)/count(cl.clcodigo)
				   from pedidos pe, clientes clcod
				   where pe.clcodigo = cl.clcodigo)
		  )
		  and
		  (b.VMP > (select avg(custo) from c))

--c)
select pe.pecodigo, cl.nome
from pedidos pe
inner join clientes cl on cl.clcodigo = pe.clcodigo
where not exists (select ip.prcodigo
				  from itens_pedidos ip
				  where ip.pecodigo = pe.pecodigo
				  except
				  select pr.prcodigo
				  from produtos pr
				  inner join fornece_produtos fp on fp.prcodigo = pr.prcodigo
				  inner join fornecedores f 	 on f.fcodigo 	= fp.fcodigo
				  where f.cidade = 'Fortaleza'
				  ) 

--d)
create view clrjp(clcod) as
	select clcodigo
	from clientes
	where cidade = 'Rio de Janeiro' or cidade = 'Recife'

create view clprf(clcod, pecod, prcod, fcod, fnome, fcid) as
	select pe.clcodigo, pe.pecodigo, ip.prcodigo, fp.fcodigo, f.nome, f.cidade
	from pedidos pe
	inner join itens_pedidos ip 	on ip.pecodigo = pe.pecodigo
	inner join produtos pr 			on pr.prcodigo = ip.prcodigo
	inner join fornece_produtos fp  on fp.prcodigo = pr.prcodigo
	inner join fornecedores f 		on f.fcodigo   = fp.fcodigo

select cf.fcod, cf.fnome, cf.fcid
from clprf cf
inner join clrjp crp on crp.clcod = cf.clcod
where cf.clcod in (select clcod
				   from clprf
				   group by clcod
				   having count(distinct fcod) = 1
				   )

