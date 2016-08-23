/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Update relative period numbers')             */
/********************************************************************/
/*                                                                  */
/*       Midas - General Ledger Module                     */
/*                                                                  */
/*       MCC0190 - UPDATE RELATIVE PERIOD NUMBERS CONTROL           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*   Last Amend No. S01408             Date  11MAY95                */
/*   Prev Amend No. XXXXXX             Date  DDMMMYY                */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*   S01408 - Addition of core hook MCC0190MP1                      */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&CMPNTNAM &SEQNO)
 
             DCL        VAR(&CMPNTNAM) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&SEQNO) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR)  LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR)  LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR)  LEN(2)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                        EXEC(GOTO ABNOR)
 
/* Set off job switches */
             CHGJOB     SWS(00000000)
 
/* Check whether this is a restart */
             CALL       PGM(CB0160) PARM(&CMPNTNAM &SEQNO &BUSY)
 
/* Set up library names */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,MCC0190MP1                                          */
                                                                      /*S01408*/
 
/* If it is a restart then copy period details from back-up file */
             IF         COND(&BUSY *EQ 'Y') THEN(DO)
                  CPYF       FROMFILE(&DPLIB/XGLPERDPD) +
                          TOFILE(*LIBL/GLPERDPD) MBROPT(*REPLACE)
                  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                       CLRPFM FILE(*LIBL/GLPERDPD)
                       ENDDO
                  ENDDO
 
/* If not a restart then copy period details to the back up file */
             ELSE       CMD(DO)
                  DLTF       FILE(&DPLIB/XGLPERDPD)
                  MONMSG     MSGID(CPF0000)
                  CPYF       FROMFILE(*LIBL/GLPERDPD) +
                          TOFILE(&DPLIB/XGLPERDPD) MBROPT(*NONE) +
                          CRTFILE(*YES)
                  MONMSG MSGID(CPF2817) CMPDTA(CPF2869)
                  CALL       PGM(CB0150) PARM(&CMPNTNAM &SEQNO 'Y')
                  ENDDO
 
/* Call program to check if any set codes without a current relative */
/* period number does now have a current period. */
             CALL       PGM(MC0189)
 
/* If U7 or U8 on then perform error handling */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                  CHGVAR     VAR(&MSGDTA) VALUE(%SST(&LDA 134 50))
                  SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                   MSGDTA(&MSGDTA) TOPGMQ(*EXT) TOMSGQ(*LIBL/MOPERQ)
                  ENDDO
 
/* Otherwise continue processing */
             ELSE       CMD(DO)
 
/* Call program to update relative period number */
                  CALL       PGM(MC0190)
 
/* If U7 or U8 on then perform error handling */
                  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                       RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                       CHGVAR     VAR(&MSGDTA) VALUE(%SST(&LDA 134 50))
                       SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                        MSGDTA(&MSGDTA) TOPGMQ(*EXT) +
                        TOMSGQ(*LIBL/MOPERQ)
                        ENDDO
 
/* Otherwise reset status and delete the back-up file */
                  ELSE       CMD(DO)
                       CALL      PGM(CB0150) PARM(&CMPNTNAM &SEQNO 'N')
                       DLTF       FILE(&DPLIB/XGLPERDPD)
                       MONMSG     MSGID(CPF0000)
                       ENDDO
 
                  ENDDO
 
/* Skip global error handling */
             GOTO       CMDLBL(END)
 
/* Global error handling */
 ABNOR:      SNDPGMMSG  MSG('Error occured in program MCC0190 - See +
                          program dump listing') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
