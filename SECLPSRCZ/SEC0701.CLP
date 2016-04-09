/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Security Positions Report')                  */
/*******************************************************************/
/*                                                                 */
/*  Midas - Securities Trading Module                      */
/*                                                                 */
/*  SEC0701  - PRODUCE SECURITY POSITIONS REPORT, SENDING          */
/*             INFORMATIONAL AND ERROR MESSAGES TO MSGQS           */
/*             MRUNQ AND MOPERQ WHERE RELEVANT                     */
/*                                                                 */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                 */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. S01408             DATE  08NOV95                */
/*  PREV AMEND NO. S01408             DATE  11APR95                */
/*                 E29170             DATE  07OCT91                */
/*                 S01117             DATE  09JAN91                */
/*                 S01179             DATE  16SEP88                */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*  S01408 - Core Hook added SEC0701001                            */
/*  S01408 - CORE HOOK ADDED SEC0701MPS                            */
/*         - CORE HOOK ADDED SEC0701END                            */
/*  E29170 - Report Control Facility program changes               */
/*  S01117 - MULTIBRANCHING                                        */
/*  S01179 - ABS RELEASE                                           */
/*                                                                 */
/*******************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/************PGM                                                     * *S01117*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01117*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
/* S01179                                                              *S01179*/
/*********   DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
/**/
/************DCL        VAR(&DBLOT) TYPE(*CHAR) LEN(44)              * *S01117*/
             DCL        VAR(&DBLOT) TYPE(*CHAR) LEN(50)               /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/**/
/* Send start message */
/**/
             SNDPGMMSG  MSG('SEC0701 - Security Positions Report') +
                          TOMSGQ(MRUNQ)
/**/
/* Setof all external switches */
/**/
             CHGJOB     SWS(00000000)
/**/
/* Run Security Positions report program */
/**/
 
/*       POSITION FILE TO THE PARTICULAR BRANCH                      * *S01117*/
           IF COND((&RENT *NE '   ') *AND (&RENT *NE 'ALL')) THEN(DO) /*S01117*/
             OVRDBF     FILE(BKPBK) POSITION(*KEY 1 BKPBKF &RENT)     /*S01117*/
/************OPNDBF     FILE(BKPBK) OPTION(*ALL)                /*S01117E29170*/
             OPNDBF     FILE(BKPBK) OPTION(*INP)                      /*E29170*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*S01117*/
               DLTOVR     FILE(BKPBK)                                 /*S01117*/
             ENDDO                                                    /*S01117*/
             CLOF       OPNID(BKPBK)                                  /*S01117*/
             MONMSG     MSGID(CPF0000)                                /*S01117*/
           ENDDO                                                      /*S01117*/
                                                                     /*S01408*/
/*/COPY WNCPYSRC,SEC0701001                                                  */
                                                                     /*S01408*/
 
/************CALL       PGM(SE0800)                                 * *S01117*/
             CALL       PGM(SE0800) PARM(&RSEQ &RENT)                /*S01117*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0701MPS                                          */
                                                                      /*S01408*/
/**/
/* If external switches U7 and U8 on, Recover data from LDA */
/* and send error messages */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********   RCVDTAARA  DTAARA(LDA)                         *********  *S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/************CHGVAR     VAR(&DBLOT) VALUE(%SUBSTRING(&LDA 134 44))   * *S01117*/
             CHGVAR     VAR(&DBLOT) VALUE(%SUBSTRING(&LDA 134 50))    /*S01117*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBLOT) +
                          TOMSGQ(MRUNQ MOPERQ)
             SNDPGMMSG  MSG('SEC0701 - Database error') TOMSGQ(MRUNQ +
                          MOPERQ)
             ENDDO
/**/
/* If external switch U8 on, send Files out of balance message */
/**/
             IF         COND(%SWITCH(XXXXXX01)) THEN(SNDPGMMSG +
                          MSG('SEC0701 - File controls out of +
                          balance') TOMSGQ(MRUNQ MOPERQ))
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC0701END                                          */
                                                                      /*S01408*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
