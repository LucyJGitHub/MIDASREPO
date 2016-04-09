/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE STOPPED CHEQUES REPORT')                     */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*        REC31      STOPPED CHEQUES REPORT                         */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*        LAST AMENDMENT NO. LN0316           DATE 08JUN90          */
/*        PREV AMENDMENT NO. LN0257           DATE 24MAY90          */
/*                       NO. S01117           DATE 16MAR90          */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       LN0316  - PROGRAM TRIES TO DELETE AN OVERRIDE THAT         */
/*                 HAS ALREADY BEEN DELETED                         */
/*       LN0257  - TO ALLOW COB ON REQUEST REPORT TO BE OVERRIDDEN  */
/*                 TO BRANCH LEVEL REQUEST                          */
/*                                                                  */
/*        S01117 - MULTIBRANCHING                                   */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM PARM(&STAT)                                          /*S01117*/
             PGM     PARM(&STAT &RSEQ &RLEV &RENT)                    /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
                DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
                DCL VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
                DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
                DCL VAR(&STAT) TYPE(*CHAR) LEN(1)
                DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                     /*S01117*/
                DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                    /*S01117*/
/**/
                SNDPGMMSG MSG('REC31 - Stopped Cheques Report') TOMSGQ(MRUNQ)
/**/
                IF COND(&STAT *EQ 'I') THEN(CHGJOB SWS(10000000))
                ELSE CMD(CHGJOB SWS(00000000))
/**/
                OVRDBF FILE(TABLE) TOFILE(TABRE2)
/*              IF COND(&STAT *EQ 'I') THEN(DO)         */ /*S01117*/ /*LN0257*/
                IF COND(&STAT *EQ 'I' *OR &STAT *EQ 'O') THEN(DO)     /*LN0257*/
/*                 IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +            */
/*                    THEN(OVRDBF FILE(SSTOP) POSITION(*KEY 1 +               */
/*                    STOPCSDF &RENT)                                 /*S01117*/
                   IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*S01117*/
                      OVRDBF FILE(SSTOP) POSITION(*KEY 1 +
                      STOPCSDF &RENT)                                 /*S01117*/
                      OPNDBF FILE(SSTOP) OPTION(*ALL)                 /*S01117*/
                      MONMSG MSGID(CPF0000) EXEC(DO)                  /*S01117*/
                      DLTOVR FILE(SSTOP)                              /*S01117*/
                      ENDDO                                           /*S01117*/
                      ENDDO                                           /*S01117*/
/***********    CALL PGM(RE0310)                                      /*S01117*/
                   CALL PGM(RE0310)   PARM(&RSEQ &RENT)               /*S01117*/
                   IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*LN0316*/
/*                    THEN(DLTOVR FILE(SSTOP))             /*S01117*/ /*LN0316*/
                           DLTOVR FILE(SSTOP)                         /*LN0316*/
                           MONMSG MSGID(CPF9841)                      /*LN0316*/
                      ENDDO                                           /*LN0316*/
                ENDDO                                                 /*S01117*/
                ELSE  CALL PGM(RE0310)   PARM('     ' 'ALL')          /*S01117*/
                DLTOVR FILE(TABLE)
/**/
                IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                   /*S01117*/
                   RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)            /*S01117*/
                   CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))          /*S01117*/
                   SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)                     /*S01117*/
                   GOTO ENDPGM                                        /*S01117*/
                ENDDO                                                 /*S01117*/
                IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0310') TOMSGQ(MOPERQ)
                ENDDO
/**/
ENDPGM:      RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
