/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas TI Environment support functions: routine 10')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC0020 - TI Environment Support Functions: Routine 10      */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CTI001  *CREATE    Date 03OCT97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CTI001 - Requirements clarification for Midas/TI Interface  */
/*                Program created.                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MNEM &USRPRF)
 
/*/COPY WNCPYSRC,TIC0020INT                                          */
 
             DCL        VAR(&MNEM) TYPE(*CHAR) LEN(3)
             DCL        VAR(&USRPRF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,TIC0020MPS                                          */
 
/*/COPY WNCPYSRC,TIC0020MPE                                          */
 
             CHGVAR     VAR(&PREFIX) VALUE(%SST(&MNEM 1 2))
             CHGVAR &DMLIB (&PREFIX *TCAT 'DMLIB')
             RTVOBJD    OBJ(&DMLIB/SDSTAT) OBJTYPE(*DTAARA) +
                          OWNER(&USRPRF)
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,TIC0020ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC0020 ended abnormally - see job log')
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,TIC0020END                                          */
 
             ENDPGM
