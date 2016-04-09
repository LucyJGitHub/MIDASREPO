/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Drip feed audit report')                     */
/********************************************************************/
/*                                                                  */
/*      Midas - Midas Export Data Module                            */
/*                                                                  */
/*      EDC0090 - Drip Feed Audit Report                            */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01493 *CREATE      DATE 16MAY94            */
/*       PREV AMEND NO. Ennnnn              DATE DDMMMYY            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       S01493 - Midas Export Data Module                          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RTYP &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTYP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/* Clear switches */
 
             CHGJOB     SWS(00000000)
 
/* If program calle din input cycle */
 
             IF         COND(&RTYP *EQ 'I') THEN(DO)
 
/* Create a temporary LDA */
 
               CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                            VALUE(*BLANKS) TEXT('Temporary data area +
                            for ED0090 report pgm')
               MONMSG     MSGID(CPF1023)
               CALL       PGM(ED0090) PARM(&RTYP &RSEQ)
             ENDDO
 
/* If COB report requested */
 
             IF         COND(&RTYP *EQ 'C') THEN(DO)
               SNDPGMMSG  MSG('EDC0090 - Drip Feed Audit Report') +
                          TOMSGQ(MRUNQ) MSGTYPE(*INFO)
               CALL       PGM(ED0090) PARM(&RTYP &RSEQ)
             ENDDO
ERROR:
 
/* For database errors recover data from LDA */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSG('EDC0090 - Drip Feed Audit Report +
                           terminated abnormally') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
