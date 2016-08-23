/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Risk Participant / Assignment Drop')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0606B - Risk Participant / Assignment Drop               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 120277 *CREATE     Date 24Feb99              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       120277 - Risk participant / Assignments should be dropped   */
/*                if related to facilities which are dropped         */
/*                                                                   */
/*********************************************************************/
             PGM     PARM(&CNAM &CSEQ)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +
                        VALUE('Risk Participant / Assignment Drop ')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
/**/
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ)
/**/
/*  IF INDICATOR = 'NEW' THEN RESTORE LEPARTPD FILE                  */
 
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
             IF         COND(&BUSY = 'Y') THEN(DO)
                 CPYF       FROMFILE(XLEPARTPD) TOFILE(LEPARTPD) +
                        MBROPT(*REPLACE)
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM LEPARTPD)
             ENDDO
 
/*  ELSE SAVE LEPARTPD FILE                                        */
             ELSE DO
                 CPYF       FROMFILE(LEPARTPD) TOFILE(XLEPARTPD) +
                        MBROPT(*REPLACE)
                 MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                        EXEC(CLRPFM XLEPARTPD)
                 CHGVAR     VAR(&BUSY) VALUE('Y')
                 CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO
 
/* RISK PARTICIPANT / ASSIGNMENT DROP                               */
             CALL PGM(LE0462)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**********      RGZPFM     FILE(LEPARTPD)                                                /*228542*/
/**********      MONMSG     MSGID(CPF2981)                                                /*228542*/
                 CALL       PGM(SCC000060) PARM('LEPARTPD' '*FIRST')                      /*228542*/
 
                   CHGVAR     VAR(&BUSY) VALUE('N')
                   CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
 
                 CLRPFM     FILE(LEEPRTPD)
                 GOTO       END
             ENDDO
 
/*  CHECK FOR ERRORS                                                 */
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)
                 SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                     TOMSGQ(MOPERQ)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
