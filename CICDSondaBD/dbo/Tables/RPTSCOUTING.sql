CREATE TABLE [dbo].[RPTSCOUTING] (
    [CodigoCliente]     VARCHAR (50)   NULL,
    [NombreCliente]     VARCHAR (8000) NULL,
    [DireccionCliente]  VARCHAR (8000) NULL,
    [ReferenciaCliente] VARCHAR (8000) NULL,
    [TelefonoCliente]   VARCHAR (8000) NULL,
    [Ruta]              VARCHAR (50)   NULL,
    [Operador]          VARCHAR (50)   NULL,
    [Fecha]             DATE           NULL,
    [Hora]              TIME (7)       NULL,
    [Etiqueta]          VARCHAR (8000) NULL,
    [Departamento]      VARCHAR (100)  NOT NULL
);

