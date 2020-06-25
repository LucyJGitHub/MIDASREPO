/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE CUSTOMER EXCHANGES INPUT TODAY')             */
/********************************************************************/
/*                                                                  */
/*        Midas     - Retail Module                             */
/*                                                                  */
/*     REC35  -  CUSTOMER EXCHANGE INPUT TODAY                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD52452            Date 12Dec18              */
/*       Prev Amend No. DUG503             Date 12Feb18              */
/*                      MD046248           Date 27Oct17              */
/*                      MD031950           Date 17Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      LN0316             Date 28Jun90              */
/*                    S01117             Date 27Mar90               */
/*                    S01098             DATE 26/08/86              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD52452 -  COB Reopen Fails                                */
/*               -  back up the file CUSEXCE_BK to DPLIB instead of */
/*                  DMLIB                                           */
/*               -  Recompile due to changes in cpysrc REC35002     */
/*       DUG431  -  Amendments to 'Events by Value Date' Report     */
/*                  Use REC35002                                    */
/*       MD046248 - Finastra Rebranding                              */
/*       MD031950 - Recompiled due to changed PF/CUSEXZ1.           */
/*       LN0316  - PROGRAM TRIES TO DELETE AN OVERRIDE THAT         */
/*                 HAS ALREADY BEEN DELETED                         */
/*                                                                  */
/*     S01117  -  MULTIBRANCHING                                    */
/*                                                                  */
/*     S01098  -  BLOCK GECEPD                                      */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM PARM(&STAT)                                          /*S01117*/
             PGM PARM(&STAT &RSEQ &RLEV &RENT)                        /*S01117*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5)                        /*S01117*/
             DCL VAR(&RLEV) TYPE(*CHAR) LEN(1)                        /*S01117*/
             DCL VAR(&RENT) TYPE(*CHAR) LEN(3)                        /*S01117*/
             DCL VAR(&STAT) TYPE(*CHAR) LEN(1)
             DCL VAR(&MEM) TYPE(*CHAR) LEN(50)                        /*S01117*/
             DCL VAR(&LDA) TYPE(*CHAR) LEN(256)                       /*S01117*/
/*/COPY WNCPYSRC,REC35001                                            */
             SNDPGMMSG MSG('REC35 - Customer Exchanges Input Today') +
                       TOMSGQ(MRUNQ)
/**/
             IF COND(&STAT = 'I') THEN(CHGJOB SWS('10000000'))
             ELSE CMD(DO)
                CHGJOB SWS('01000000')
                SNDPGMMSG  MSG('        and Generation of Postings') +
                           TOMSGQ(MRUNQ)
             ENDDO
/**/
             CLRPFM FILE(GECEHH)
             CLRPFM FILE(GECEPD)
             CLRPFM FILE(GECEZZ)
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
             OVRDBF FILE(GECEPD) SEQONLY(*YES 250)                    /*S01098*/
/*/COPY WNCPYSRC,REC35002                                            */
             IF COND(&STAT *EQ 'I') THEN(DO)                          /*S01117*/
                   IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                      THEN(DO)                                        /*S01117*/
                      OVRDBF FILE(CEIP) POSITION(*KEY 1 +
                      STOPCSDF &RENT)                                 /*S01117*/
                      OPNDBF FILE(CEIP) OPTION(*ALL)                  /*S01117*/
                      MONMSG MSGID(CPF0000) EXEC(DO)                  /*S01117*/
                      DLTOVR FILE(CEIP)                               /*S01117*/
                      ENDDO                                           /*S01117*/
                      ENDDO                                           /*S01117*/
/**/
/*********** CALL PGM(RE0350)                                         /*S01117*/
                CALL PGM(RE0350)   PARM(&RSEQ &RENT)                  /*S01117*/
                IF COND(&RENT *NE 'ALL' *AND &RENT *NE '   ') +
                   THEN(DO)                                           /*LN0316*/
/*                 THEN(DLTOVR FILE(CEIP))              */ /*S01117*/ /*LN0316*/
                      DLTOVR FILE(CEIP)                               /*LN0316*/
                      MONMSG MSGID(CPF9841)                           /*LN0316*/
                   ENDDO                                              /*LN0316*/
             ENDDO                                                    /*S01117*/
             ELSE  CALL PGM(RE0350)   PARM('     ' 'ALL')             /*S01117*/
/**/
/*/COPY WNCPYSRC,REC35003                                            */
/*           DLTOVR FILE(TABLE)                         */            /*S01098*/
             DLTOVR FILE(TABLE GECEPD)                                /*S01098*/
/**/
             IF COND(%SWITCH(XXXXXX1X)) THEN(DO)                      /*S01117*/
                RTVDTAARA DTAARA(LDA *ALL) RTNVAR(&LDA)               /*S01117*/
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))             /*S01117*/
                SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)                        /*S01117*/
                GOTO ENDPGM                                           /*S01117*/
             ENDDO                                                    /*S01117*/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
             SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0350') TOMSGQ(MOPERQ)
             ENDDO
/**/
ENDPGM:      RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM