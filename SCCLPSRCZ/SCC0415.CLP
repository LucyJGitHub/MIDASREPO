/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC 24x7 file initialisation')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0415 - 24x7 File Initialisation                          */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2002           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CSC011  *CREATE    Date 14Apr02              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC011 - New initialisation program for CSC011 feature.     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SUPPID)
 
/*/COPY WNCPYSRC,SCC0415INT                                          */
 
             DCL        VAR(&MAIN) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPPID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SUPDMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2002')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC0415MPS                                          */
 
/* Set up variables */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&MAIN)
             CHGVAR     VAR(&SUPDMLIB) VALUE(&SUPPID *CAT 'DMLIB')
 
/* Update DTAARA/SC24X7 */
 
             CHGDTAARA  DTAARA(SC24X7 (1 2)) VALUE(&MAIN)
             CHGDTAARA  DTAARA(SC24X7 (3 2)) VALUE(&SUPPID)
 
/* Update DTAARA/SDSTAT in the support system */
 
             CHGDTAARA  DTAARA(&SUPDMLIB/SDSTAT (6 2)) VALUE(&SUPPID)
 
/* Update DTAARA/CGDTA in the support system */
 
             CHGDTAARA  DTAARA(&SUPDMLIB/CGDTA (7 2)) VALUE(&SUPPID)
 
/* Update DTAARA/RPTRG in the support system */
 
             CHGDTAARA  DTAARA(&SUPDMLIB/RPTRG (1 2)) VALUE(&SUPPID)
 
             CHGDTAARA  DTAARA(&SUPDMLIB/RPTRG (21 2)) VALUE(&SUPPID)
 
             CHGDTAARA  DTAARA(&SUPDMLIB/RPTRG (39 2)) VALUE(&SUPPID)
 
             CHGDTAARA  DTAARA(&SUPDMLIB/RPTRG (49 2)) VALUE(&SUPPID)
 
/* Update DTAARA/TIDTA in the support system */
 
             CHGDTAARA  DTAARA(&SUPDMLIB/TIDTA (11 2)) VALUE(&SUPPID)
 
/* Update DTAARA/MPHAS to 'A' */
 
             CHGDTAARA  DTAARA(&SUPDMLIB/MPHAS (1 1)) VALUE('A')
 
/*/COPY WNCPYSRC,SCC0415MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC0415ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - interactive job */
 
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0415END                                          */
 
             ENDPGM
