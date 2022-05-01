CREATE TABLE [acsa].[SWIFT_GOAL_DETAIL] (
    [GOAL_DETAIL_ID]       INT             IDENTITY (1, 1) NOT NULL,
    [GOAL_HEADER_ID]       INT             NOT NULL,
    [SELLER_ID]            INT             NOT NULL,
    [GOAL_BY_SELLER]       DECIMAL (18, 6) NOT NULL,
    [DAILY_GOAL_BY_SELLER] DECIMAL (18, 6) NOT NULL
);

