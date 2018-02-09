/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM DL CUSTOMER FX DEALS ENQUIRY')               */
/*===================================================================*/
/*                                                                   */
/*  Midas - DEALING MODULE.                                  */
/*                                                                   */
/*  EMC0121A -  CUSTOMER FX DEALS ENQUIRY FOR EXPOSURE MANAGEMENT    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXXX             Date DDMmmYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       PROGRAM CREATED TO DISPLAY THE ENQUIRY IN DESCENDING DATE   */
/*       ORDER                                                       */
/*       THIS PROGRAM WAS CREATED FOR FIX E26937                     */
/*                                                                   */
/*===================================================================*/
 
    PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&RETN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CUST) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
 
    /*  Clear DL data area */
 
    CHGDTAARA  DTAARA(QTEMP/DLSDS) VALUE(' ')
    MONMSG     MSGID(CPF1015)  EXEC(+
    DO)
/******CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(161)           */                   /*CGL029*/
       CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)                                /*CGL029*/
    ENDDO
 
    /*  Retrieve Customer number from data area and select FX deals  */
    /*  for use in program DL0121  */
 
    RTVDTAARA  DTAARA(EMSDS (141 6)) RTNVAR(&CUST)
    CHGDTAARA  DTAARA(DLSDS (141 6)) VALUE(&CUST)
/***CHGDTAARA  DTAARA(QTEMP/DLSDS (159 2)) VALUE('FX')               */                   /*CGL029*/
    CHGDTAARA  DTAARA(QTEMP/DLSDS (165 2)) VALUE('FX')                                    /*CGL029*/
 
/*/COPY WNCPYSRC,EMC0121A01                                          */
    CHGJOB     SWS(00000000)
    CALL       PGM(DL0121)
/*/COPY WNCPYSRC,EMC0121A02                                          */
 
    /*  Retrieve return code from DLSDS and place in EMSDS  */
 
/***RTVDTAARA  DTAARA(DLSDS (161 1)) RTNVAR(&RETN)                   */                   /*CGL029*/
/***CHGDTAARA  DTAARA(EMSDS (161 1)) VALUE(&RETN)                    */                   /*CGL029*/
    RTVDTAARA  DTAARA(DLSDS (167 1)) RTNVAR(&RETN)                                        /*CGL029*/
    CHGDTAARA  DTAARA(EMSDS (167 1)) VALUE(&RETN)                                         /*CGL029*/
 
    /*  Error Processing */
 
    RTVJOBA    JOB(&JOB) SWS(&SWS)
    IF         COND((%SUBSTRING(&SWS 7 1) = '1') *OR +
                   (%SUBSTRING(&SWS 8 1) = '1')) THEN( +
    DO)
       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
       CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
       SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM)-
                  TOMSGQ(MOPERQ)
       SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM)-
                  TOPGMQ(*EXT)
    ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
    ENDPGM
