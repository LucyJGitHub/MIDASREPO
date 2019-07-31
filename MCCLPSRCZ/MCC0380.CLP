/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC Rework Prime DR/CR Average Balances')        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounting Module                        */
/*                                                                   */
/*       MCC0380 - Rework Prime DR/CR Average Balances               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 124850             Date 25Sep97              */
/*                      CMC001 *C *CREATE  Date 18Mar96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       124850 - System falling over if files are empty.           */
/*       CMC001 - Management Accounts Enhancement for PCA            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
/**  Declare variables */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PRCG) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')
             DCL        VAR(&RTRN) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)
/*/COPY WNCPYSRC,MCH00010                                            */
/**/
/**  Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDMSG     MSG('MCC0380 - Update Management Account +
                          Average Balances') TOMSGQ(MRUNQ)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local Data Area')
             MONMSG     MSGID(CPF0000)
/**/
/**  Access PCA ICD for Primary Control Group */
/**/
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(AOPCACR0) PARM(&RTCD '*FIRST' &DSFDY)
             CHGVAR     VAR(&PRCG) VALUE(%SST(&DSFDY 15 2))
/**/
/**  Access Historic Balances Control Group File for the */
/**  'DR/CR Average Balances' indicator                  */
/**/
/*/COPY WNCPYSRC,MCH00011                                            */
             CHGVAR     VAR(&RTCD) VALUE(' ')
             CALL       PGM(AOHBCGR0) PARM(&RTCD '*KEY' &PRCG &DSFDY)
/**/
/**  If the 'DR/CR Average Balances' indicator is not 'N' */
/**/
             IF         COND(%SST(&DSFDY 41 1) *NE 'N') THEN(DO)
/**/
/**  If this is a restart, recover original version of the file. */
/**  Otherwise, take a security copy of GLAVBLPD.                */
/**/
                CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
                IF         COND(&BUSY *EQ 'Y') THEN(CPYF +
                             FROMFILE(XGLAVBLPD) TOFILE(GLAVBLPD) +
                             FROMMBR(&PRCG) TOMBR(&PRCG) +
                             MBROPT(*REPLACE))
                ELSE  CMD(DO)
                   CPYF       FROMFILE(GLAVBLPD) TOFILE(XGLAVBLPD) +
                                FROMMBR(&PRCG) TOMBR(&PRCG) +
                                MBROPT(*REPLACE)
                   MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO) /*124850*/
                       CLRPFM FILE(XGLAVBLPD)                         /*124850*/
                   ENDDO                                              /*124850*/
                ENDDO
/**/
/**  Set the component busy flag to 'Y' */
/**/
                CHGVAR     VAR(&BUSY) VALUE('Y')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**/
/**  Call MCC0240 - Rework DR/CR Average Balances */
/**/
                CALL       PGM(MCC0240) PARM(&PRCG &RTRN)
/**/
/**  If return code is blank and U7, U8 are off, set the component */
/**  busy flag to 'N' and delete back-up file                      */
/**/
                IF         COND(&RTRN *EQ ' ' *AND %SWITCH(XXXXXX00)) +
                             THEN(DO)
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
                ENDDO
                ELSE       CMD(DO)
/**/
/**  Otherwise, perform database error processing */
/**/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                TOMSGQ(MOPERQ MRUNQ)
                   GOTO       CMDLBL(ABNOR)
                ENDDO
/**/
             ENDDO
             GOTO       CMDLBL(END)
 /**/
 /**  Abnormal error processing */
 /**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MCC0380 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             DMPCLPGM
 /**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
