/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DE Merge Historic files for Transfer')          */
/*OVR  : OVRDBF FILE(FDMBR) TOFILE(QAFDMBRL)                        :*/
/*********************************************************************/
/*                                                                   */
/*       Midas - Data Export Module                                  */
/*                                                                   */
/*       DEC0080 - Merge Historic Extract Files for Transfer.        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CDE005             Date 22Aug02              */
/*       Prev Amend No. CDE003             Date 11Dec02              */
/*                      208221             Date 11Dec02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CDE002  *CREATE    Date 29Mar00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CDE005 - Data Export - Reservation ID (Re-compile)          */
/*       CDE003 - Data Export - MCR Limits Phase II (Recompiled)     */
/*       208221 - Don't copy DEH* files into member INT              */
/*       CDE002 - Data Export - CCRM Revenue Analysis                */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DEC0080INT                                          */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(QTEMP/FDMBR)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DEC0080 - Merge Historic Extract Files +
                          for Transfer') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,DEC0080MPS                                          */
 
             CLRPFM     FILE(DEHTRANPD) MBR(INT)
             CLRPFM     FILE(DEHPOSNPD) MBR(INT)
             CLRPFM     FILE(DEHEVNTPD) MBR(INT)
             CLRPFM     FILE(DEHCASHPD) MBR(INT)
             CLRPFM     FILE(DENTRANPD) MBR(INT)
             CLRPFM     FILE(DENPOSNPD) MBR(INT)
             CLRPFM     FILE(DENEVNTPD) MBR(INT)
 
             DSPFD      FILE(DEHTRANPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/FDMBR)
 
LOOP:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(FINISH))
 
             IF         COND(&MLNAME *NE 'INT') THEN(DO)
 
/************CPYF       FROMFILE(DEHTRANPD) TOFILE(DEHTRANPD) +                          * *208221*/
/************             FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD) +                     * *208221*/
/************             INCREL((*IF T#ACTN *EQ 'I'))                                   * *208221*/
/************MONMSG CPF0000                                                              * *208221*/
             CPYF       FROMFILE(DEHTRANPD) TOFILE(DEOTRANPD) +
                          FROMMBR(&MLNAME) TOMBR(&MLNAME) MBROPT(*REPLACE)
             MONMSG CPF0000
             CPYF       FROMFILE(DENTRANPD) TOFILE(DENTRANPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
/************CPYF       FROMFILE(DEHPOSNPD) TOFILE(DEHPOSNPD) +                          * *208221*/
/************             FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)                       * *208221*/
/************MONMSG CPF0000                                                              * *208221*/
             CPYF       FROMFILE(DEHPOSNPD) TOFILE(DEOPOSNPD) +
                          FROMMBR(&MLNAME) TOMBR(&MLNAME) MBROPT(*REPLACE)
             MONMSG CPF0000
             CPYF       FROMFILE(DENPOSNPD) TOFILE(DENPOSNPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
/************CPYF       FROMFILE(DEHEVNTPD) TOFILE(DEHEVNTPD) +                          * *208221*/
/************             FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)                       * *208221*/
/************MONMSG CPF0000                                                              * *208221*/
             CPYF       FROMFILE(DEHEVNTPD) TOFILE(DEOEVNTPD) +
                          FROMMBR(&MLNAME) TOMBR(&MLNAME) MBROPT(*REPLACE)
             MONMSG CPF0000
             CPYF       FROMFILE(DENEVNTPD) TOFILE(DENEVNTPD) +
                          FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)
             MONMSG CPF0000
/************CPYF       FROMFILE(DEHCASHPD) TOFILE(DEHCASHPD) +                          * *208221*/
/************             FROMMBR(&MLNAME) TOMBR(INT) MBROPT(*ADD)                       * *208221*/
/************MONMSG CPF0000                                                              * *208221*/
 
/************CLRPFM     FILE(DEHTRANPD) MBR(&MLNAME)                                     * *208221*/
/************CLRPFM     FILE(DEHPOSNPD) MBR(&MLNAME)                                     * *208221*/
/************CLRPFM     FILE(DEHEVNTPD) MBR(&MLNAME)                                     * *208221*/
/************CLRPFM     FILE(DEHCASHPD) MBR(&MLNAME)                                     * *208221*/
             CLRPFM     FILE(DENTRANPD) MBR(&MLNAME)
             CLRPFM     FILE(DENPOSNPD) MBR(&MLNAME)
             CLRPFM     FILE(DENEVNTPD) MBR(&MLNAME)
 
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
FINISH:
 
/*/COPY WNCPYSRC,DEC0080MPE                                          */
 
            GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DEC0080ERR                                          */
 
/* Abnormal termination */
 
             CHGJOB     SWS(XXXXXX11)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            DEC0080 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ MRUNQ)
                MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,DEC0080END                                          */
 
ENDPGM
