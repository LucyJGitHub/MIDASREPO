/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Merge files for transfer')                   */
/*OVR  : OVRDBF FILE(FDMBR) TOFILE(QAFDMBRL)                        :*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0070 - Merge Extract Files for Transfer.                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CDE005             Date 22Aug02              */
/*                      CDE003             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CDE001  *CREATE    Date 18Nov99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CDE005 - Data Export - Reservation ID (Re-compile)          */
/*       CDE003 - Data Export - MCR Limits Phase II (Recompiled)     */
/*       CDE001 - Data Export - CCRM Limits                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0070INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCLF       FILE(QTEMP/FDMBR)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0070 - Merge Projected Extract Files +
                          for Transfer') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0070MPS                                          */
 
             CLRPFM     FILE(DEOLEJPD)
             INZPFM     FILE(DEOLEJPD) TOTRCDS(1)
 
             CLRPFM     FILE(DEPTRANPD) MBR(INT)
             CLRPFM     FILE(DEPPOSNPD) MBR(INT)
             CLRPFM     FILE(DEPEVNTPD) MBR(INT)
             CLRPFM     FILE(DEPCASHPD) MBR(INT)
 
             CLRPFM     FILE(DETTRANPD) MBR(INT)
             CLRPFM     FILE(DETPOSNPD) MBR(INT)
             CLRPFM     FILE(DETEVNTPD) MBR(INT)
             CLRPFM     FILE(DETCASHPD) MBR(INT)
 
             DSPFD      FILE(DEPTRANPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDMBR)
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))
 
             IF         COND(&MLNAME *NE 'INT') THEN(DO)
 
             CPYF       FROMFILE(DEPTRANPD) TOFILE(DEPTRANPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD) +
                          INCREL((*IF T#ACTN *EQ 'I'))
             MONMSG CPF0000
             CPYF       FROMFILE(DEPPOSNPD) TOFILE(DEPPOSNPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
             CPYF       FROMFILE(DEPEVNTPD) TOFILE(DEPEVNTPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
             CPYF       FROMFILE(DEPCASHPD) TOFILE(DEPCASHPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
 
             CLRPFM     FILE(DEPTRANPD) MBR(&MLNAME)
             CLRPFM     FILE(DEPPOSNPD) MBR(&MLNAME)
             CLRPFM     FILE(DEPEVNTPD) MBR(&MLNAME)
             CLRPFM     FILE(DEPCASHPD) MBR(&MLNAME)
 
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
FINISH:
             CPYF       FROMFILE(DEPTRANPD) TOFILE(DETTRANPD) +
                          FROMMBR(INT) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
             CPYF       FROMFILE(DEPPOSNPD) TOFILE(DETPOSNPD) +
                          FROMMBR(INT) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
             CPYF       FROMFILE(DEPEVNTPD) TOFILE(DETEVNTPD) +
                          FROMMBR(INT) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
             CPYF       FROMFILE(DEPCASHPD) TOFILE(DETCASHPD) +
                          FROMMBR(INT) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
 
             CLRPFM     FILE(DEPTRANPD) MBR(INT)
             CLRPFM     FILE(DEPPOSNPD) MBR(INT)
             CLRPFM     FILE(DEPEVNTPD) MBR(INT)
             CLRPFM     FILE(DEPCASHPD) MBR(INT)
 
/*/COPY WNCPYSRC,DEC0070MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0070ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0070 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DEC0070END                                          */
 
ENDPGM
