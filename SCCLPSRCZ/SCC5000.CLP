/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas clustering - exit process control')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC5000 - Midas Clustering - Exit Processing Control        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CSC013  *CREATE    Date 05Nov01              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC013 - Midas Clustering Feature                           */
/*                - New program for this feature.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SUCCESS &ACTCODE &EXPGMDATA &USERINF +
                          &FORMAT)
 
/*/COPY WNCPYSRC,SCC5000INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SUCCESS) TYPE(*CHAR) LEN(9)
             DCL        VAR(&ACTCODE) TYPE(*CHAR) LEN(9)
             DCL        VAR(&EXPGMDATA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&USERINF) TYPE(*CHAR) LEN(9000)
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/*/COPY WNCPYSRC,SCC5000MPS                                          */
 
/* Call the Exit Processing Program */
 
             CALL       PGM(SC005000) PARM(&SUCCESS &ACTCODE +
                          &EXPGMDATA &USERINF &FORMAT)
 
/*/COPY WNCPYSRC,SCC5000MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,SCC5000ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC5000 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC5000END                                          */
 
             ENDPGM
