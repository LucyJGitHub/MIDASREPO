/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CG Print TELLER Extract Control')               */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC0520  - Print Process Driver Control                     */
/*                                                                   */
/*       Function:  This program receives requests for prints, by    */
/*                  reading entries from a data queue and triggers   */
/*                  the production of the requested prints.          */
/*                                                                   */
/*                  The program runs continuously as a background    */
/*                  batch job.                                       */
/*                                                                   */
/*  (c) COPYRIGHT FINASTRA INTERNATIONAL LIMITED 1997.               */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCG016 *CREATE     Date 21FEB97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCG016 - Correspondence Manager for Retail Teller System    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTN_CODE &DTQE)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&MKICPY) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          COPYRIGHT FINASTRA +
                          INTERNATIONAL LIMITED 1997')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DATA)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&DTQE)        TYPE(*CHAR) LEN(50)
             DCL        VAR(&ITEM    )    TYPE(*CHAR) LEN(10)
             DCL        VAR(&CUSTOMER)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTN_CODE)    TYPE(*CHAR) LEN(7)
             DCL        VAR(&OUTQ    )    TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQLIB )    TYPE(*CHAR) LEN(10)
/* */
/* Parameters received for RCF                                       */
/* */
             DCL        VAR(&RLVL)        TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ)        TYPE(*CHAR) LEN(5)
             DCL        VAR(&RBCH)        TYPE(*CHAR) LEN(3)
             DCL        VAR(&RARCH)       TYPE(*CHAR) LEN(1)
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/*           Copyright statement definition - at runtime             */
/**/
             CHGVAR     VAR(&MKICPY) VALUE('COPYRIGHT FINASTRA +
                          INTERNATIONAL LIMITED 1997.')
/* */
/* CHGJOB switches */
/* */
             CHGJOB     SWS(XXXXXX00)
/* */
/* Retrieve the Item number and Customer from the Data Queue         */
/* entry.                                                            */
/* */
             CHGVAR     VAR(&ITEM    ) VALUE(%SST(&DTQE 1 10))
             CHGVAR     VAR(&CUSTOMER) VALUE(%SST(&DTQE 11 10))
             CHGVAR     VAR(&RSEQ)     VALUE(%SST(&DTQE 21 5))
             CHGVAR     VAR(&RLVL)     VALUE(%SST(&DTQE 26 1))
             CHGVAR     VAR(&RBCH)     VALUE(%SST(&DTQE 27 3))
             CHGVAR     VAR(&RARCH)    VALUE(%SST(&DTQE 30 1))
             CHGVAR     VAR(&OUTQ    ) VALUE(%SST(&DTQE 31 10))
             CHGVAR     VAR(&OUTQLIB ) VALUE(%SST(&DTQE 41 10))
/* */
/* Add the new member to the Print Process Extract file and override */
/* to it.                                                            */
/* */
             ADDPFM     FILE(CGPGENPD) MBR(TELLER) +
                          TEXT('Correspondence Items to Print')
             MONMSG     MSGID(CPF7306)
             ADDLFM     FILE(CGPGENL2) MBR(TELLER) DTAMBRS((CGPGENPD +
                          (TELLER))) TEXT('Correspondence Items to +
                          Print')
             MONMSG     MSGID(CPF7306)
             OVRDBF     FILE(CGPGENL2) MBR(TELLER)
             OVRDBF     FILE(CGPGENPD) MBR(TELLER)
             OVRDBF     FILE(FCRREQL0) SHARE(*NO)
/* */
/* Set up overrides for printer output queue                         */
/* */
             OVRPRTF    FILE(CG3000P1) OUTQ(&OUTQLIB/&OUTQ) +
                          SECURE(*YES)
/* */
/* Set up overrides for processing                                   */
/* */
             OVRDBF     FILE(CGUDCRL0) SHARE(*NO)
/* */
/* Call the Print Process Driver Program                             */
/* */
             CALL       PGM(CG0510) PARM(&RTN_CODE &ITEM +
                          &CUSTOMER &RSEQ &RLVL &RBCH &RARCH)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/* */
/* Prompt Charge processing                                          */
/* */
             CALL       PGM(CGC5274) PARM('')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
/* On successful completion, clear print request */
/* */
             CLRPFM     FILE(CGPGENPD) MBR(TELLER)
/* */
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program CGC0520 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC0520 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:
             CHGVAR     VAR(&MKICPY) VALUE('(c) Copyright Finastra +
                          International Limited 1997.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
             ENDPGM
