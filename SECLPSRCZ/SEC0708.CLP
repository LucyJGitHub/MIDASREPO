/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Repurchase Agreement Mismatch Rpt')          */
/*********************************************************************/
/*                                                                   */
/*         Midas     - Securities Trading Module                */
/*                                                                   */
/*       SEC0708 - REPURCHASE AGREEMENT MISMATCH REPORT              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01117             Date 09Jan91              */
/*                      S01179             Date 16Sep88              */
/*                      S01176             DATE 18/08/88             */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       S01117 - MULTIBRANCHING                                     */
/*       S01179 -  RELELASE                                      *  *S01179*/
/*       S01176 - SECURITIES TRADING 3.1 (AUSTRALIA)                *  *S01176*/
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM   PARM(&RSEQ &RLEV &RENT)                            /*S01117*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
 
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
 
/* SEND PGM MESSAGE */
 
/************CHGVAR     VAR(&MEM) VALUE('SEC0708 - Repurchase + */    /*S01176*/
/************             Agreement Mismatch Rpt')              */    /*S01176*/
             CHGVAR     VAR(&MEM) VALUE('SEC0708 - Repo/Pledge +
                          Agreement Collat. Rpt')                     /*S01176*/
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ)
 
/* CLEAR SWITCHES */
 
             CHGJOB     SWS(00000000)
 
/* CALL REPORT PROGRAM */
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)                            /*S01117*/
             OVRDBF     FILE(DEALRP) POSITION(*KEY 1 DEALSDCF &RENT)  /*S01117*/
             OPNDBF     FILE(DEALRP) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(DEALRP)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(DEALRP)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             OVRDBF     FILE(DPMVRP) POSITION(*KEY 1 DPTMVDF &RENT)   /*S01117*/
             OPNDBF     FILE(DPMVRP) OPTION(*ALL)                     /*S01117*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
             DLTOVR     FILE(DPMVRP)                                  /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(DPMVRP)                                 /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
             ENDDO                                                    /*S01117*/
/************   CALL       PGM(SE0990) */                             /*S01176*/
/***************CALL       PGM(SE0991)                        *S01176* *S01117*/
                CALL       PGM(SE0991) PARM(&RSEQ &RENT)              /*S01117*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA */
 
ERROR:       IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/*********      RCVDTAARA  DTAARA(LDA)                      *********  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
/***************CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 44))  * *S01117*/
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))   /*S01117*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM)-
                           TOMSGQ(MOPERQ MRUNQ)
                CHGVAR     VAR(&MEM) VALUE('SEC0708 - Database Error')
                SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
/*END:********ENDPGM                                                 * *S01117*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
