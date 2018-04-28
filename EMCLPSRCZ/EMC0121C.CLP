/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EM DL CUSTOMER FRA DEALS ENQUIRY')              */
/*===================================================================*/
/*                                                                   */
/*  Midas - DEALING MODULE.                                  */
/*                                                                   */
/*  EMC0121C -  CUSTOMER FRA DEALS ENQUIRY FOR EXPOSURE MANAGEMENT   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGL029             Date 01Sep03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. XXXXXX             Date DDMMMYY              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGL029 - Increase Account Code to 10 digits                 */
/*       PROGRAM CREATED TO DISPLAY THE ENQUIRY IN DESCENDING DATE   */
/*       ORDER                                                       */
/*       THIS PROGRAM WAS CREATED FOR FIX E26937                     */
/*                                                                   */
/*===================================================================*/
/*                                                                   */
/*  C R E A T I O N     P A R A M E T E R S                          */
/*                                                                   */
/*                                                                   */
/*===================================================================*/
 
    PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
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
       CRTDTAARA  DTAARA(QTEMP/DLSDS) TYPE(*CHAR) LEN(167)
    ENDDO
 
    /*  Retrieve Customer number from data area and select FRA deals */
    /*  for use in program DL0121  */
 
    RTVDTAARA  DTAARA(EMSDS (141 6)) RTNVAR(&CUST)
    CHGDTAARA  DTAARA(DLSDS (141 6)) VALUE(&CUST)
/***CHGDTAARA  DTAARA(QTEMP/DLSDS (159 2)) VALUE('FR')               */                   /*CGL029*/
    CHGDTAARA  DTAARA(QTEMP/DLSDS (165 2)) VALUE('FR')                                    /*CGL029*/
 
    CHGJOB     SWS(00000000)
    CALL       PGM(DL0121)
 
    /*  Retrieve return code from DLSDS and place in EMSDS  */
 
/***RTVDTAARA  DTAARA(DLSDS (161 1)) RTNVAR(&RETN)                   */                   /*CGL029*/
/***CHGDTAARA  DTAARA(EMSDS (161 1)) VALUE(&RETN)                    */                   /*CGL029*/
    RTVDTAARA  DTAARA(DLSDS (167 1)) RTNVAR(&RETN)
    CHGDTAARA  DTAARA(EMSDS (167 1)) VALUE(&RETN)
 
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
                          Misys International Banking Systems Ltd.')
 
    ENDPGM
