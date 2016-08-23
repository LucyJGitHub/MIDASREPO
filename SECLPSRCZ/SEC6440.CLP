/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Safe custody fees drop off')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC6440 - Safe Custody Fees Drop Off                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BUG14358           Date 16Jul07              */
/*       Prev Amend No. BG13371            Date 14Feb07              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      236859             Date 10Aug04              */
/*                      228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPM004             DATE 07MAR96              */
/*                      091522  *CREATE    DATE 14AUG95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG14358 - Reverse Fix 236859                               */
/*       BG13371 - File name typo in CLRPFM                          */
/*       236859 - DB Error CB0180, at 01, file CBAUDTL1, key SEC6440 */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CCB009 - Journal files throughout close of business         */
/*       CPM004 - Add monitor for not journaled                      */
/*       091522 - Safe Custody Fees - Private Banking (CSE001)       */
/*                                                                   */
/*********************************************************************/
/**/
             PGM PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RCD) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&DLT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DROP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&S01513) TYPE(*CHAR) LEN(1) VALUE('N')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
/*  Global monitor message  */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/**/
/*  Check for SE drop field if sequence = 00003  */
/**/
             IF         COND(&CSEQ = 00003) THEN(DO)
               RTVDTAARA  DTAARA(SESTAT (81 1)) RTNVAR(&DROP)
               IF         COND(&DROP *NE 'Y') THEN(DO)
                 GOTO       CMDLBL(END)
               ENDDO
             ENDDO
/**/
/*  Set up and send program message  */
/**/
             CHGVAR     VAR(&MEM) VALUE('SEC6440 - Drop Off Safe +
                          Custody Fees')
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/**/
/*  Check if switchable feature S01513 is switched ON  */
/**/
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01513')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
             IF         COND(&RTCD *EQ '      ') THEN(CHGVAR +
                          VAR(&S01513) VALUE('Y'))
/**/
/*  Clear job switches  */
/**/
             CHGJOB SWS(00000000)
/**/
/**  If core feature S01513 is switched ON, end journal the files  */
/**/
             IF         COND(&S01513 = 'Y') THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
                 ENDJRNPF   FILE(SEOCFSPD SESCFAPD) JRN(ICJRN)
                 MONMSG     MSGID(CPF7032)                            /*CPM004*/
             ENDDO                                                    /*CCB009*/
             ENDDO
/**/
/*  COB recovery processing  */
/**/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
/**/
/**********  IF COND(&S01513 *NE 'Y') THEN(DO)              */               /*236859*/ /*BUG14358*/
             CALL          PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**********  ENDDO                                          */               /*236859*/ /*BUG14358*/
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
             CPYF       FROMFILE(SEOCFSPD) TOFILE(&TOLIB/XSEOCFSPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSEOCFSPD))
             CPYF       FROMFILE(SESCFAPD) TOFILE(&TOLIB/XSESCFAPD) +
                         MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XSESCFAPD))
             CHGVAR     VAR(&STAT) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
             ELSE       CMD(DO)
             CPYF       FROMFILE(XSEOCFSPD) TOFILE(SEOCFSPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEOCFSPD))
             CPYF       FROMFILE(XSESCFAPD) TOFILE(SESCFAPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SESCFAPD))                                                /*BG13371*/
/********                 FILE(SESFCAPD))                                                  BG13371*/
             ENDDO
/**/
/*  Drop off fees settlements  */
/**/
             CALL       PGM(SE6441)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*  Reorganize the file only if there is more than 10% of  */
/*  deleted record                                         */
/**/
             RTVMBRD    FILE(SEOCFSPD) NBRCURRCD(&RCD) NBRDLTRCD(&DLT)
             IF         COND(&RCD *NE 0) THEN(DO)
               CHGVAR     VAR(&RCD) VALUE((&DLT / &RCD) * 100)
               IF         COND(&RCD *GE 10) THEN(DO)
/**********      RGZPFM     FILE(*LIBL/SEOCFSPD)                                          /*228542*/
/**********      MONMSG     MSGID(CPF2981)                                                /*228542*/
                 CALL       PGM(SCC000060) PARM('SEOCFSPD' '*FIRST')                      /*228542*/
                 IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                            CMDLBL(ABNOR))                                                /*228542*/
               ENDDO
             ENDDO
/**/
/*  Drop off fees accrued  */
/**/
             CALL       PGM(SE6440)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/*  Reorganize the file only if there is more than 10% of  */
/*  deleted record                                         */
/**/
             RTVMBRD    FILE(SESCFAPD) NBRCURRCD(&RCD) NBRDLTRCD(&DLT)
             IF         COND(&RCD *NE 0) THEN(DO)
               CHGVAR     VAR(&RCD) VALUE((&DLT / &RCD) * 100)
               IF         COND(&RCD *GE 10) THEN(DO)
/**********      RGZPFM     FILE(*LIBL/SESCFAPD)                                          /*228542*/
/**********      MONMSG     MSGID(CPF2981)                                                /*228542*/
                 CALL       PGM(SCC000060) PARM('SESCFAPD' '*FIRST')                      /*228542*/
                 IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                            CMDLBL(ABNOR))                                                /*228542*/
               ENDDO
             ENDDO
/*/COPY WNCPYSRC,SEC6440001                                          */
/**/
/* Reset value of restart flag to 'N' */
/**/
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             DLTF       FILE(XSEOCFSPD)
             MONMSG     MSGID(CPF2105)
             DLTF       FILE(XSESCFAPD)
             MONMSG     MSGID(CPF2105)
/**/
/**  Start journalling the files  */
/**/
             IF         COND(&S01513 = 'Y') THEN(DO)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
               STRJRNPF   FILE(SEOCFSPD SESCFAPD) JRN(ICJRN) +
                            IMAGES(*BOTH) OMTJRNE(*OPNCLO)
             ENDDO                                                    /*CCB009*/
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC6440 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/**  If core feature S01513 is switched ON  */
/**/
             IF         COND(&S01513 = 'Y') THEN(DO)
/**/
/**  Copy the backup files  */
/**/
               CPYF       FROMFILE(XSEOCFSPD) TOFILE(SEOCFSPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(SEOCFSPD))
               MONMSG     MSGID(CPF0000 MCH0000)
               CPYF       FROMFILE(XSESCFAPD) TOFILE(SESCFAPD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                            FILE(SESCFAPD))
               MONMSG     MSGID(CPF0000 MCH0000)
               DLTF       FILE(XSEOCFSPD)
               MONMSG     MSGID(CPF0000)
               DLTF       FILE(XSESCFAPD)
               MONMSG     MSGID(CPF0000)
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/**  Start journalling the files  */
/**/
               STRJRNPF   FILE(SEOCFSPD SESCFAPD) JRN(ICJRN) +
                            IMAGES(*BOTH) OMTJRNE(*OPNCLO)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO                                                    /*CCB009*/
               CHGVAR     VAR(&STAT) VALUE('N')
               MONMSG     MSGID(CPF0000 MCH0000)
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
