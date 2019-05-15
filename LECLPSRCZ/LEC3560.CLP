/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Selection Critria Generation COB - Contrl')  */
/*********************************************************************/
/*                                                                   */
/*       Midas   -  Lending Module                                   */
/*                                                                   */
/*       LEC3560 - Selection Criteria Generation COB - Control.      */
/*                                                                   */
/*                 This COB program controls the generation of       */
/*                 selected facilities. The Facilities Selected      */
/*                 file is cleared then re-built to ensure an        */
/*                 up to date selection of facilities.               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU021  *CREATE    Date 13May98              */
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU021 - EMU LE Facility Currency Conversion                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&QRYSLT) TYPE(*CHAR) LEN(256)
 
             DCL        VAR(&BRCA)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&CNUM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&FACT)   TYPE(*CHAR) LEN(3)
             DCL        VAR(&FCNO)   TYPE(*CHAR) LEN(2)
 
             DCLF       FILE(LEFCONL0)
/*-------------------------------------------------------------------*/
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*-------------------------------------------------------------------*/
/* Check Object, Monitor for CPF9801 - Object not found, Create LDA  */
/*                                                                   */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
/*-------------------------------------------------------------------*/
/* Initialise LDA and Switches                                       */
/*                                                                   */
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
/*-------------------------------------------------------------------*/
/* Clear the Facilities Selected For Conversion file Ready for       */
/* Rebuild.                                                          */
/*                                                                   */
             CLRPFM     FILE(LEFCUPPD)
/*-------------------------------------------------------------------*/
/* Retrieve Facility Currency Conversion Detail Records.             */
/*                                                                   */
 
 NXTREC:     RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(RUN))
/*-------------------------------------------------------------------*/
/* Build Query Selection Criteria                                    */
/*                                                                   */
             CHGVAR     VAR(&BRCA) VALUE(&FCBRCA)
             CHGVAR     VAR(&CNUM) VALUE(&FCCNUM)
             CHGVAR     VAR(&FACT) VALUE(&FCFACT)
             CHGVAR     VAR(&FCNO) VALUE(&FCFCNO)
 
             IF         COND(&BRCA *EQ 'ALL') THEN(DO)
             CHGVAR     VAR(&BRCA) VALUE('   ')
             ENDDO
 
             IF         COND(&CNUM *EQ '000000') THEN(DO)
             CHGVAR     VAR(&CNUM) VALUE('      ')
             ENDDO
 
             IF         COND(&FACT *EQ '000') THEN(DO)
             CHGVAR     VAR(&FACT) VALUE('   ')
             ENDDO
 
             IF         COND(&FCNO *EQ '00') THEN(DO)
             CHGVAR     VAR(&FCNO) VALUE('  ')
             ENDDO
 
             CALL       PGM(LE3530) PARM(&BRCA &CNUM &FCCCY +
                          &FACT &FCNO &QRYSLT)
/*                                                                   */
/* Database error processing                                         */
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/*-------------------------------------------------------------------*/
/* Generate Selected Facilities                                      */
/*                                                                   */
             OVRDBF     FILE(FCLTY1) SHARE(*YES)
             OPNQRYF    FILE((FCLTY1)) OPTION(*INP) QRYSLT(&QRYSLT)
 
             CALL       PGM(LE3540) PARM(&FCREFR)
 
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(FCLTY1)
             MONMSG     MSGID(CPF0000)
/*                                                                   */
/* Database error processing                                         */
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/*-------------------------------------------------------------------*/
/* Next Record                                                       */
/*                                                                   */
             GOTO       CMDLBL(NXTREC)
/*-------------------------------------------------------------------*/
/* Facility Currency Conversion - Control                            */
/*                                                                   */
 
 RUN:        CALL       PGM(LEC3570) PARM(&CNAM &CSEQ)
 
/*                                                                   */
/* Database error processing                                         */
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
/*-------------------------------------------------------------------*/
/* Abnormal End Of Run                                               */
/*                                                                   */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC3560 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
/*-------------------------------------------------------------------*/
/* Close Files                                                       */
/*                                                                   */
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
/*===================================================================*/
