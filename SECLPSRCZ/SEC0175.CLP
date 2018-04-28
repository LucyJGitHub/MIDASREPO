/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Position Settlements Bulk Maint Control')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC175  - Reverse/Authorize Positions Settlements           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CRE020             Date 20Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CSE025  *CREATE    Date 11Jan01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       CSE025 - Reverse/Authorise Positions Settlements            */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*---------------------------*/
/* Declaration of parameters */
/*---------------------------*/
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CSE003) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1)                                   /*CRE020*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/*------------------------*/
/* Global monitor message */
/*------------------------*/
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*-----------------------*/
/* Job attributs and LDA */
/*-----------------------*/
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/*--------------------------------------------*/
/**  Check if CSE010 enhancement is installed */
/*--------------------------------------------*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE010')
             CHGVAR     VAR(&CSE010) VALUE('N')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSE010) VALUE('Y')
             ENDDO
 
/*---------------------------------------------*/
/**  Check if CSE003 enhancement is installed  */
/*---------------------------------------------*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE003')
             CHGVAR     VAR(&CSE003) VALUE('N')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSE003) VALUE('Y')
             ENDDO
                                                                                          /*CRE020*/
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&SAR)  VALUE('CRE020')                                        /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('N')                                           /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD  *NE '       ' *AND &RTCD  *NE +
                          '*NRF   ') THEN(DO)                                             /*CRE020*/
               GOTO   CMDLBL(ABNOR)                                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             IF COND(&RTCD *EQ '       ') THEN(DO)                                        /*CRE020*/
             CHGVAR     VAR(&CRE020) VALUE('Y')                                           /*CRE020*/
             ENDDO                                                                        /*CRE020*/
 
/*-----------------*/
/* Files overrides */
/*-----------------*/
 
             OVRDBF     FILE(POSETX)   TOFILE(POSET1)   SHARE(*NO)
             OVRDBF     FILE(POSETDZ1) TOFILE(POSETDY1) SHARE(*NO)
             OVRDBF     FILE(POSETDZ2) TOFILE(POSETDY2) SHARE(*NO)
 
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)
                   OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(SEDEVX)   TOFILE(SEDEV)    SHARE(*NO)
                   OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(TRADSX1)  TOFILE(TRADS)    SHARE(*NO)
             ENDDO
 
/** Data area SESDS */
 
             IF         COND((&CSE010 *EQ 'N') *AND (&CSE003 *EQ +
                          'Y')) THEN(DO)
             CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                        DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37))
             CHGDTAARA  DTAARA(SESDS) VALUE(' ')
             CHGDTAARA  DTAARA(SESDS (1 10)) VALUE('SE0175')
             CHGDTAARA  DTAARA(SESDS (13 6)) VALUE('000000')
             ENDDO
 
/*-----------------------------------------------------*/
/* Call Reverse/Authorize Position Settlements program */
/*-----------------------------------------------------*/
 
             CALL       PGM(SE0175)
 
/*---------------------------*/
/* Database error processing */
/*---------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   ROLLBACK
                   SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   CHGVAR VAR(&MEM) VALUE('SEC175 - Job terminated, +
                                           Database in error.')
                   SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 *EQ 'Y') THEN(DO)                                   /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL PGM(REC000881) +
                          PARM(''SE0170'' ''SE'')') INLLIBL(*JOBD) +
                          MSGQ(MOPERQ)                                                    /*CRE020*/
             ENDDO                                                                        /*CRE020*/
             GOTO       CMDLBL(ENDPGM)                                                    /*CRE020*/
                                                                                          /*CRE020*/
/*----------------------*/
/* Abnormal termination */
/*----------------------*/
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             SNDPGMMSG MSG('Transaction failed. Re-input necessary. +
                            Enter to continue.') TOPGMQ(*EXT)
 
/*---------------------------------*/
/*   E N D   P R O C E S S I N G   */
/*---------------------------------*/
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
