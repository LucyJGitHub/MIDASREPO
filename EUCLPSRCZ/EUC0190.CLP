/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas EU Settlement a/c report control')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Retail Utilities                                */
/*                                                                   */
/*       EUC0190 - Retail Settlement A/C Exception Report            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 145427             Date 29Oct98              */
/*                      CEU022  *CREATE    Date 17Jul98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       145427 - Only call EU0190 if retail a/c nos. used.          */
/*       CEU022 - EMU Retail Utilities                               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&PRAM) TYPE(*CHAR) LEN(1) VALUE(' ')   */                     /*CCB020*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*/COPY WNCPYSRC,EUC0190001                                          */
 
             DCLF       FILE(SDRETLPD)                       /*145427*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RCVF       RCDFMT(SDRETLD0)                     /*145427*/
             IF         COND(&BMRANR *EQ 'Y') THEN(DO)       /*145427*/
 
             CHGJOB     SWS(XXXXXX00)
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**********  RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&PRAM)          */                     /*CCB020*/
/**********  MONMSG     MSGID(CPF1023)                             */                     /*CCB020*/
/*/COPY WNCPYSRC,EUC0190002                                          */
 
/*  Run report program */
 
/* Remove the parameter for MPHAS */                                                      /*CCB020*/
/**********  CALL       PGM(EU0190) PARM(&RSEQ &RLEV &RENT &PRAM)  */                     /*CCB020*/
             CALL       PGM(EU0190) PARM(&RSEQ &RLEV &RENT)                               /*CCB020*/
/*/COPY WNCPYSRC,EUC0190003                                          */
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA *ALL) RTNVAR(&LDA)
                  CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                               TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))
 
 ABNOR:      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          EUC0190 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(END))
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDDO                                           /*145427*/
 
             ENDPGM
