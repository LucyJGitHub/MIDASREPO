/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas dummy default routing entry program')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC0106 - Midas Dummy Default Routing Entry Program.        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 114755             Date 26FEB97              */
/*       Prev Amend No. 099150  *CREATE    Date 26JAN96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       114755 - Program does not actually apply any MLS overrides, */
/*                call MLC0020 rather than QCMD to do this.          */
/*       099150 - New program introduced to standardise entry        */
/*                to the Midas system.                               */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,SCC0106INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')
 
/*/COPY WNCPYSRC,SCC0106MPS                                          */
 
/* Call general default routing entry program via ML overrides */
 
/************CALL       PGM(QCMD)                                     /*114755*/
             CALL       PGM(MLC0020)                                  /*114755*/
 
/*/COPY WNCPYSRC,SCC0106MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/* Abnormal termination */
 
/*/COPY WNCPYSRC,SCC0106ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SCC0106 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,SCC0106END                                          */
 
             ENDPGM
