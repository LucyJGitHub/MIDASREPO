/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas API List of Todays Transactions component')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - APIs                                                */
/*                                                                   */
/*       APC0001 - List of Transactions sent via APIs                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG13549           Date 14Mar07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAP185             Date 21Apr06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CAP002 *CREATE     Date 06Feb98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG13549 - Reverse MQ Series Interface Changes. Create      */
/*                  another CL for MQ instead.                       */
/*       CAP185 - MQ Series Interface                                */
/*       CAP002 - Conversion of Midas inputs to modular API structure*/
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1)
 
/*           DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                    /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                        /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                        /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                        /*CAP185*/ /*BUG13549*/
/*           DCL        VAR(&CAP185) TYPE(*CHAR) LEN(1)                      /*CAP185*/ /*BUG13549*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*   Set off switches  */
/**/
             CHGJOB     SWS(00000000)
/**/
/*   Retrieve job information  */
/**/
             RTVJOBA       JOB(&JOB)
             CHGVAR     VAR(&TYPE) VALUE(%SST(&RPARM 1 1))
/**/                                                                         /*CAP185*/ /*BUG13549*/
/* Check if CAP185 is enabled */                                             /*CAP185*/ /*BUG13549*/
/**/                                                                         /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&RTCD) VALUE('       ')                            /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                            /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&SARD) VALUE('CAP185')                             /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*         CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)          /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*         CHGVAR     VAR(&CAP185) VALUE('N')                                /*CAP185*/ /*BUG13549*/
/*         IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAP185) VALUE('Y'))                   /*CAP185*/ /*BUG13549*/
/**/
/*   Override to correct view of logging file */
/**/
/*           IF         COND(&CAP185 *NE 'Y') THEN(DO)                      /*CAP185*/ /*BUG13549*/
/*                                                                          /*CAP185*/ /*BUG13549*/
             IF         COND(&TYPE = '1' *OR &TYPE = ' ') THEN(DO)
             OVRDBF     FILE(ZATRNLOG) TOFILE(ZATRNLOGPD) SHARE(*NO)
             ENDDO
             IF         COND(&TYPE = '2') THEN(DO)
             OVRDBF     FILE(ZATRNLOG) TOFILE(ZATRNLOGL1) SHARE(*NO)
             ENDDO
             IF         COND(&TYPE = '3') THEN(DO)
             OVRDBF     FILE(ZATRNLOG) TOFILE(ZATRNLOGL3) SHARE(*NO)
             ENDDO
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           ENDDO                                                           /*CAP185*/ /*BUG13549*/
/**/
/* Call report program     */
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           IF         COND(&CAP185 *EQ 'Y') THEN(DO)                       /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           CLRPFM     FILE(APTLOGPD)                                       /*CAP185*/ /*BUG13549*/
/*           CALL       PGM(AP0011LE) PARM(&RSEQ &RLEV &RENT &RPARM)         /*CAP185*/ /*BUG13549*/
/*           ENDDO                                                           /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
/*           ELSE       CMD(DO)                                              /*CAP185*/ /*BUG13549*/
/*                                                                           /*CAP185*/ /*BUG13549*/
             CALL       PGM(AP0001) PARM(&RSEQ &RLEV &RENT &RPARM)
/*           ENDDO                                                           /*CAP185*/ /*BUG13549*/
/*                                                                   */
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
/**/
             ENDDO
 
             GOTO       CMDLBL(END)
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination  */
/**/
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            APC0001 ended abnormally ') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
