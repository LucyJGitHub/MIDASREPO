/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Depot transfer maintenance')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC0075 - Depots transfers Input/Enquiry                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSE027  *CREATE    Date 01Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CSE027 - Bulk Depot Transfer                                */
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
             DCL        VAR(&CSE010) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CSE003) TYPE(*CHAR) LEN(1)
             DCL        VAR(&S01496) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
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
 
/*--------------------------------------------------*/
/**  Check if Transaction Enhancements is installed */
/*--------------------------------------------------*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE010')
             CHGVAR     VAR(&CSE010) VALUE('N')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSE010) VALUE('Y')
             ENDDO
 
/*--------------------------------------------------*/
/**  Check if CSE003 IS INSTALLED                   */
/*--------------------------------------------------*/
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('CSE003')
             CHGVAR     VAR(&CSE003) VALUE('N')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&CSE003) VALUE('Y')
             ENDDO
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01496')
             CHGVAR     VAR(&S01496) VALUE('N')
/**/
/**  Check if Jyske Enhancements is installed */
/**/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '       ') THEN(DO)
                CHGVAR     VAR(&S01496) VALUE('Y')
             ENDDO
/*-----------------*/
/* Files overrides */
/*-----------------*/
 
             OVRDBF     FILE(DPTMVX) TOFILE(DPTMV) SHARE(*NO)
             OVRDBF     FILE(DPTMVDZ1) TOFILE(DPTMVDY1) SHARE(*NO)
             OVRDBF     FILE(DPTMVDZ2) TOFILE(DPTMVDY2) SHARE(*NO)
             OVRDBF     FILE(CPOSN) SHARE(*NO)
 
             IF         COND(&CSE010 *EQ 'Y') THEN(DO)
                   OVRDBF FILE(SECTYX)   TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(SEDEVX)   TOFILE(SEDEV)    SHARE(*NO)
                   OVRDBF FILE(SECTYZ1)  TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(SECTYZ2)  TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(SECTYZ3)  TOFILE(SECTY)    SHARE(*NO)
                   OVRDBF FILE(TRADSX1)  TOFILE(TRADS)    SHARE(*NO)
             ENDDO
 
             IF         COND(&CSE003 *EQ 'Y') THEN(DO)
                CHKOBJ     OBJ(SESDS) OBJTYPE(*DTAARA)
                MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                             DTAARA(QTEMP/SESDS) TYPE(*CHAR) LEN(37))
             ENDDO
/*-------------------------------------------*/
/* Call Depot transfer Input/Enquery program */
/*-------------------------------------------*/
 
             CALL       PGM(SE0075)
 
/*---------------------------*/
/* Database error processing */
/*---------------------------*/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   ROLLBACK
                   SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                                TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   CHGVAR VAR(&MEM) VALUE('SECU070 - Job terminated, +
                                           Database in error.')
                   SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
/**/
             ELSE DO
/**/
                 SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
/************    SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +                              /*CSC023*/
/************           RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +                            /*CSC023*/
/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CSC023*/
/************    SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                             /*CSC023*/
/************           RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                           /*CSC023*/
/************           INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CSC023*/
                 SBMJOB (SEC0304) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL SEC0304') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
                 SBMJOB (MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                        INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                           /*CSC023*/
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
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
                          Finastra International Limited')
 
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
