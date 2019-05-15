/*********************************************************************/
/*XBI    OVRDBF FILE(FDMBR) TOFILE(QAFDMBRL)                         */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Clear Historic Extract Files')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0081 - Clear Historic Extract Files                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CRM601  *CREATE    Date 03Oct01              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRM601 - Clear DEH* files if requested                      */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0081INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&REQ) TYPE(*CHAR) LEN(1)
 
             DCLF       FILE(QTEMP/FDMBR)
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0081 - Clear Historic Extract Files') +
                           TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
             RTVDTAARA  DTAARA(DEEXTCTL (100 1)) RTNVAR(&REQ)
 
             IF         COND(&REQ *EQ 'Y') THEN(DO)
 
/*/COPY WNCPYSRC,DEC0081MPS                                          */
 
                DSPFD      FILE(DEHTRANPD) TYPE(*MBRLIST) +
                             OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDMBR)
 
LOOP:           RCVF
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))
 
                CLRPFM     FILE(DEHTRANPD) MBR(&MLNAME)
                CLRPFM     FILE(DEHPOSNPD) MBR(&MLNAME)
                CLRPFM     FILE(DEHEVNTPD) MBR(&MLNAME)
                CLRPFM     FILE(DEHCASHPD) MBR(&MLNAME)
 
                GOTO       CMDLBL(LOOP)
 
             ENDDO
FINISH:
 
/*/COPY WNCPYSRC,DEC0081MPE                                          */
 
             GOTO       CMDLBL(END)
 
ABNOR:
/*/COPY WNCPYSRC,DEC0081ERR                                          */
 
/* Abnormal termination */
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DEC0081 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0081END                                          */
 
             ENDPGM
