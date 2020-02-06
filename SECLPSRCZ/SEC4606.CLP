/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Unrealised Profit/Loss Report')              */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                           */
/*                                                                   */
/*       SEC4606  - Unrealised Profit/Loss Report                    */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSE036  *CREATE    Date 22Apr02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSE036 - Unrealised Profit and Loss Report by Trade         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&TOLIB)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
 
 
             CALL       PGM(AOSARDR0) PARM(&RTCD '*VERIFY' 'CSE036')
             IF         COND(&RTCD *NE '       ') THEN(GOTO ENDPGM)
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             CHGVAR    VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR    VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
 
             CHGJOB     SWS(XXXXXX00)
             SNDPGMMSG  MSG('SEC4606 - Unrealised Profit/Loss +
                          Reporting') TOMSGQ(MRUNQ)
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
             IF         COND(&BUSY = 'Y') THEN(DO)
/**  Copy files  */
                CPYF       FROMFILE(XBKPHDD) TOFILE(BKPHDD) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM BKPHDD)
                CHGVAR     VAR(&BUSY) VALUE('N')
                CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
             ENDDO
 
             ELSE       CMD(DO)
 
/** Delete copy files  */
 
                DLTF       FILE(XBKPHDD)
                   MONMSG MSGID(CPF0000)
                CPYF       FROMFILE(BKPHDD) TOFILE(&TOLIB/XBKPHDD) +
                         MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)
                MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM XBKPHDD)
             ENDDO
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
/** Clear output file */
 
             CLRPFM     FILE(SETREXPP)
 
/** Clear SEKEYD/A member  */
 
             CLRPFM     FILE(SEKEYD) MBR(UNPL)
             CLRPFM     FILE(SEKEYA) MBR(UNPL)
 
             CALL       PGM(SE4606)
/**/
/*  Call SE4605 (Report Program)                                              */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                  OVRDBF     FILE(SEKEYD) TOFILE(SEKEYD) MBR(UNPL)
                  OVRDBF     FILE(SEKEYA) TOFILE(SEKEYA) MBR(UNPL)
                  CALL       PGM(SE4605) PARM('B' 'ALL')
                  DLTOVR     FILE(*ALL)
             ENDDO
/**/
/*  Call SE4607  (Report Program)                                           */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CALL       PGM(SE4607)
             ENDDO
/**/
/*  Database Error Handling                                                   */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
             SNDPGMMSG  MSGID(MEM0001) MSGF(GBMIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             SNDPGMMSG  MSG('SEC4606 terminated - Database error') +
                          TOMSGQ(MRUNQ MOPERQ)
             ENDDO
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGVAR     VAR(&BUSY) VALUE('N')
               CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
                DLTF       FILE(XBKPHDD)
                   MONMSG MSGID(CPF0000)
             ENDDO
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
