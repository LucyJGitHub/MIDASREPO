/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Standing data authorisation summary rept')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC4710 - Midas SD Standing Data Authorisation Summary Rpt  */
/*                                                                   */
/*                 This new report component calls the Standing      */
/*                 Data Requiring Authorisation Summary program      */
/*                 SD4710 during either Input Cycle or COB.          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSD028             Date 22Aug05              */
/*                      CSD012             Date 15Oct02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CSD028 - KYC (Standing Data Authorisations)                 */
/*       CSD012 - Standing Data Requiring Authorisation              */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&SEQ &LEVEL &ENTITY)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2003')
 
             DCL        VAR(&SEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&LEVEL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ENTITY) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)                                  */ /*CCB020*/
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                                 */ /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSD028*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CSD028*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CSD028*/
             DCL        VAR(&CSD028) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSD028*/
/*/COPY WNCPYSRC,SDH00557                                            */
 
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('SDC4710 - Standing Data Authorisation +
                          Summary Report') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/*  Check if I/C or COB  */
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                   */ /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**********  IF         COND(&MPHAS *EQ 'A') THEN(DO)                                  */ /*CCB020*/
/**********     CHGVAR     VAR(&MODE) VALUE('A')                                       */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/** Check if CSD028 is installed */                                                       /*CSD028*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSD028*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSD028*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN 'CSD028' +
                           &DSSDY)                                                        /*CSD028*/
             IF         COND(&PRTCD *EQ '       ') +
                           THEN(CHGVAR VAR(&CSD028) VALUE('Y'))                           /*CSD028*/
/*/COPY WNCPYSRC,SDH00558                                            */
                                                                                          /*CSD028*/
/* Call program to produce report SD4710P1                           */
             CALL       PGM(SD4710) PARM(&SEQ &LEVEL &ENTITY)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* If CoB then clear authorisation log and all shadow files          */
/**********  IF         COND(&MODE *NE 'A') THEN(DO)                                   */ /*CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
             IF         COND(&CSD028 *EQ 'N') THEN(DO)                                    /*CSD028*/
                CLRPFM     FILE(SDAULGPD)
                CLRPFM     FILE(SDCBSHPD)                                                 /*CSD028*/
                CLRPFM     FILE(SDCDSHPD)                                                 /*CSD028*/
                CLRPFM     FILE(SDPBSHPD)                                                 /*CSD028*/
             ENDDO                                                                        /*CSD028*/
/*/COPY WNCPYSRC,SDH00559                                            */
                CLRPFM     FILE(SDAUFDPD)
                CLRPFM     FILE(CGCDSHPD)
                CLRPFM     FILE(GLACSHPD)
                CLRPFM     FILE(GLBXSHPD)
                CLRPFM     FILE(RECMSHPD)
                CLRPFM     FILE(REIASHPD)
                CLRPFM     FILE(REPWSHPD)
                CLRPFM     FILE(SDANSHPD)
                CLRPFM     FILE(SDBRSHPD)
/**********     CLRPFM     FILE(SDCBSHPD)                                                 /*CSD028*/
/**********     CLRPFM     FILE(SDCDSHPD)                                                 /*CSD028*/
                CLRPFM     FILE(SDCNSHPD)
                CLRPFM     FILE(SDCUSHPD)
                CLRPFM     FILE(SDEXSHPD)
                CLRPFM     FILE(SDHOSHPD)
                CLRPFM     FILE(SDNOSHPD)
/**********     CLRPFM     FILE(SDPBSHPD)                                                 /*CSD028*/
             IF         COND(&CSD028 *EQ 'Y') THEN(CALL PGM(SD4711))                      /*CSD028*/
/*/COPY WNCPYSRC,SDC4710001                                          */
             ENDDO
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SDC4710  ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
