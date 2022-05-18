use exemplo
go

if OBJECT_ID(N'dbo.pedidos',N'U') IS NOT NULL
	drop table pedidos;
go

create table pedidos(
id bigint not null identity primary key,
cliente_nome varchar(25),
cliente_pais varchar(50),
pedido_data date,
pedido_valor decimal(10,2)
)


use exemplo
go
bulk insert pedidos
from 'C:\temp\pedidos.csv'
with (DATAFILETYPE = 'char'
	,FIRSTROW=2
	,FIELDQUOTE = '\'
	,FIELDTERMINATOR=','
	,ROWTERMINATOR='0x0a');


use exemplo
go
bulk insert pedidos
from 'C:\temp\pedidos_comId.csv'
with (DATAFILETYPE = 'char'
	,FIRSTROW=2
	,FIELDQUOTE = '\'
	,FIELDTERMINATOR=','
	,keepidentity
	,ROWTERMINATOR='0x0a');


--select * from pedidos where pedido_data >= '2022-01-01'

SELECT * FROM OPENROWSET (BULK N'C:\temp\pedidos.csv', SINGLE_CLOB) MyFile 

--necessario para utilizar openrowset com driver do access
EXEC sp_configure 'show advanced options', 1;
GO
reconfigure
GO

sp_configure 'Ad Hoc Distributed Queries',1
GO
reconfigure
GO

select
*
from openrowset('MSDASQL'
,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}'
,'select * from C:\temp\pedidos.csv')


select
cliente_nome,cliente_pais,cast(pedido_data as date) pedido_data,pedido_valor/100 pedido_valor
from openrowset('MSDASQL'
,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}'
,'select * from C:\temp\pedidos.csv')



insert into pedidos(cliente_nome,cliente_pais,pedido_data,pedido_valor) 
select
cliente_nome,cliente_pais,cast(pedido_data as date) pedido_data,pedido_valor/100 pedido_valor
from openrowset('MSDASQL'
,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}'
,'select * from C:\temp\pedidos.csv')


select
cliente_nome,cliente_pais,cast(pedido_data as date) pedido_data,pedido_valor/100 pedido_valor
into #pedidos
from openrowset('MSDASQL'
,'Driver={Microsoft Access Text Driver (*.txt, *.csv)}'
,'select * from C:\temp\pedidos.csv')

select * from #pedidos

merge pedidos as destino
using #pedidos as origem on 
	destino.cliente_nome = origem.cliente_nome 
	and destino.cliente_pais = origem.cliente_pais
	and destino.pedido_data = origem.pedido_data
--registro existe nas 2 tabelas
when MATCHED 
	and destino.pedido_valor <> origem.pedido_valor 
	then
	update set
		destino.pedido_data = origem.pedido_data,
		destino.pedido_valor = origem.pedido_valor

-- Registro não existe na origem, apenas no destino. Vamos apagar o dado da origem.
WHEN NOT MATCHED BY SOURCE THEN
    DELETE

-- Registro não existe no destino. Vamos inserir.
WHEN NOT MATCHED BY TARGET THEN
    INSERT (cliente_nome,cliente_pais,pedido_data,pedido_valor)
    VALUES(origem.cliente_nome, origem.cliente_pais, origem.pedido_data, origem.pedido_valor)
OUTPUT $action, 
DELETED.cliente_nome AS DestinoClienteNome, 
DELETED.cliente_pais AS DestinoClientePais, 
DELETED.pedido_data AS DestinoPedidoData, 
INSERTED.cliente_nome AS OrigemClienteNome, 
INSERTED.cliente_pais AS OrigemClientePais, 
INSERTED.pedido_data AS OrigemPedidoData; 

SELECT @@ROWCOUNT;
GO

update #pedidos set pedido_valor = pedido_valor - 10 where pedido_data = '2022-02-15'
delete from #pedidos where cliente_pais = 'China'

drop table #pedidos

select * from pedidos