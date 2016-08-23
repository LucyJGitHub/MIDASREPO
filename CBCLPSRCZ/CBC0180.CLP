/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Place prev job attributes in data area')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       CBC0180 - Place previous job run info in data area CB0180DA */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. 197065             Date 21Aug01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009  *CREATE    Date 01Jun00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       197065 - End PGM if I/C                                     */
/*       CCB009 - Journal files throughout close of business.        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOB &JOBSEQ)
 
/*/COPY WNCPYSRC,CBC0180INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PHAS) TYPE(*CHAR) LEN(1)                                     /*197065*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&PJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PUSR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PNUM) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,CBC0180MPS                                          */
 
/* If this is not a batch job then end program */
 
             IF         COND(&JOBTYPE *NE '0') THEN(GOTO CMDLBL(END))
 
/* If system is in I/C then end program */                                                /*197065*/
                                                                                          /*197065*/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PHAS)                                 /*197065*/
             IF         COND(&PHAS *EQ 'A') THEN(GOTO CMDLBL(END))                        /*197065*/
                                                                                          /*197065*/
/* Call program CB0180 to retrieve attributes of previous job */
 
             CALL       PGM(CB0180) PARM(&JOB &JOBSEQ &PJOB &PUSR +
                          &PNUM)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/* Create data area CB0180DA in QTEMP. */
 
             CRTDTAARA  DTAARA(QTEMP/CB0180DA) TYPE(*CHAR) LEN(26)
             MONMSG     MSGID(CPF1023)
 
/* Place details of previous component job in data area CB0180DA */
 
             CHGVAR     VAR(&CB0180DA) VALUE(&PJOB *CAT &PUSR *CAT +
                          &PNUM)
             CHGDTAARA  DTAARA(QTEMP/CB0180DA) VALUE(&CB0180DA)
 
/*/COPY WNCPYSRC,CBC0180MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,CBC0180ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CBC0180 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,CBC0180END                                          */
 
             RETURN
 
             ENDPGM
