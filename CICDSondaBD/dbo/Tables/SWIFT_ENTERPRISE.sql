CREATE TABLE [dbo].[SWIFT_ENTERPRISE] (
    [ENTERPRISE]               INT           IDENTITY (1, 1) NOT NULL,
    [CODE_ENTERPRISE]          NVARCHAR (50) NULL,
    [NAME_ENTERPRISE]          NVARCHAR (50) NULL,
    [CONTACT_NAME]             NVARCHAR (50) NULL,
    [PHONE_CONTACT]            NVARCHAR (50) NULL,
    [PHONE_ENTERPRISE]         NVARCHAR (50) NULL,
    [LAST_UPDATE]              DATETIME      NULL,
    [LAST_UPDATE_BY]           NVARCHAR (50) NULL,
    [NIT]                      VARCHAR (15)  NULL,
    [ADDRESS_ENTERPRISE]       VARCHAR (150) NULL,
    [URL_WS_INTERFACE]         VARCHAR (MAX) NULL,
    [DEFAULT_GPS]              VARCHAR (100) NULL,
    [LOGO_IMG]                 VARCHAR (MAX) NULL,
    [ENTERPRISE_EMAIL_ADDRESS] VARCHAR (250) NULL,
    [PHONE_NUMBER]             VARCHAR (50)  NULL
);


GO
GRANT ALTER
    ON OBJECT::[dbo].[SWIFT_ENTERPRISE] TO [sonda]
    AS [dbo];


GO
GRANT CONTROL
    ON OBJECT::[dbo].[SWIFT_ENTERPRISE] TO [sonda]
    AS [dbo];


GO
GRANT DELETE
    ON OBJECT::[dbo].[SWIFT_ENTERPRISE] TO [sonda]
    AS [dbo];


GO
GRANT INSERT
    ON OBJECT::[dbo].[SWIFT_ENTERPRISE] TO [sonda]
    AS [dbo];


GO
GRANT SELECT
    ON OBJECT::[dbo].[SWIFT_ENTERPRISE] TO [sonda]
    AS [dbo];

