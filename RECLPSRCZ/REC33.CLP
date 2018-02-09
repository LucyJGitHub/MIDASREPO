/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE STANDING ORDERS REPORT')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*        REC33      STANDING ORDERS REPORT                         */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CAP187             Date 21Aug09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                           097964           DATE 19MAR96          */
/*                           LN0257           DATE 24MAY90          */
/*                           S01117           DATE 16MAR90          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                             */
/*       CAP187  -  Document Linkage (Recompile)                     */
/*       097964  - PUT IN MONITOR MESSAGE TO HANDLE ABNORMAL END    */
/*                 OF RE0330 SO THAT JOB WILL NOT BE LEFT ON        */
/*                 MSGW IN MICJOBQ.                                 */
/*       LN0257  - TO ALLOW COB ON REQUEST REPORT TO BE OVERRIDDEN  */
/*                 TO BRANCH LEVEL REQUEST                          */
/*                                                                  */
/*        S01117 - MULTIBRANCHING                                   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM PARM(&STAT &TYPE)                                    /*S01117*/
             PGM PARM(&STAT &TYPE &RSEQ &RLEV &RENT)                  /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
             DCL VAR(&RLEV) TYPE(*CHAR) LEN(1)                        /*S01117*/
             DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
             DCL VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL VAR(&TYPE) TYPE(*CHAR) LEN(1)
             DCL VAR(&SWS) TYPE(*CHAR) LEN(8) VALUE('00000000')
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/**/
                SNDPGMMSG MSG('REC33 - Standing Orders Report') TOMSGQ(MRUNQ)
/**/
                IF COND(&STAT = 'I') THEN(CHGVAR VAR(%SST(&SWS 1 1)) VALUE('1'))
                IF COND(&TYPE = 'T') THEN(CHGVAR VAR(%SST(&SWS 2 1)) VALUE('1'))
                CHGJOB SWS(&SWS)
/**/
                OVRDBF FILE(TABLE) TOFILE(TABRE2) SHARE(*NO)
                OVRDBF FILE(TABLED) TOFILE(TABRE2) SHARE(*NO)
/*           IF     COND((&STAT *EQ 'I')) THEN(DO)      */ /*S01117*/ /*LN0257*/
             IF     COND((&STAT *EQ 'I' *OR &STAT *EQ 'O')) THEN(DO)  /*LN0257*/
/*                 IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +            */
/*                    THEN(OVRDBF FILE(SSTAN) POSITION(*KEY 1 +               */
/*                    STANDSBF &RENT)                                 /*S01117*/
                   IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*S01117*/
                      OVRDBF FILE(SSTAN) POSITION(*KEY 1 +
                      STANDSBF &RENT)                                 /*S01117*/
                      OPNDBF FILE(SSTAN) OPTION(*ALL)                 /*S01117*/
                      MONMSG MSGID(CPF0000) EXEC(DO)                  /*S01117*/
                      DLTOVR FILE(SSTAN)                              /*S01117*/
                      ENDDO                                           /*S01117*/
                      ENDDO                                           /*S01117*/
/***********    CALL PGM(RE0330)                                      /*S01117*/
                   CALL PGM(RE0330)   PARM(&RSEQ &RENT)               /*S01117*/
                   MONMSG MSGID(CPF0000 RPG0000) EXEC(GOTO +
                      CMDLBL(ENDPGM))                                 /*097964*/
                ENDDO                                                 /*S01117*/
/***********    ELSE CALLPGM(RE0330)PARM('     ' 'ALL') */ /*S01117*/ /*097964*/
                ELSE  CMD(DO)                                         /*097964*/
                   CALL PGM(RE0330) PARM('     ' 'ALL')               /*097964*/
                   MONMSG MSGID(CPF0000 RPG0000) EXEC(GOTO +
                      CMDLBL(ENDPGM))                                 /*097964*/
                   ENDDO                                              /*097964*/
/***********    DLTOVR FILE(*ALL) */                                  /*097964*/
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   /*S01117*/
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)            /*S01117*/
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))          /*S01117*/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01117*/
                   GOTO ENDPGM                                        /*S01117*/
                ENDDO                                                 /*S01117*/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0330') TOMSGQ(MOPERQ)
                ENDDO
/**/
ENDPGM:      RCLRSC                                                   /*S01117*/
       DLTOVR FILE(*ALL)                                              /*097964*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
