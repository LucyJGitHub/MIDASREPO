/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Interest History Purge Print')               */
/*******************************************************************/
/*                                                                 */
/*       Midas     - Dealing Module                            */
/*                                                                 */
/*       PROGRAM     DLC9111 - INTEREST HISTORY PURGE PRINT        */
/*                                                                 */
/*       (c) Finastra International Limited 2001                   */
/*                                                                 */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       PREV AMEND : S01390         DATE : 04AUG92                */
/*                    AUS006         DATE : 18DEC90                */
/*                                                                 */
/*-----------------------------------------------------------------*/
/*                                                                 */
/*       MD046248 - Finastra Rebranding                            */
/*       S01390 - Release 10 Changes for Australianisation         */
/*       AUS006 - AUSTRALIAN PRODUCT - INTEREST HISTORY            */
/*                                                                 */
/*                                                                 */
/*                                                                 */
/*********************************************************************/
 
/************PGM        PARM(&PRDAT)                                 * *S01390*/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM)                /*S01390*/
/************DCL        VAR(&MEM) TYPE(*CHAR) LEN(44)                * *S01390*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01390*/
             DCL        VAR(&PRDAT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01390*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)                 /*S01390*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01390*/
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)              /*S01390*/
 
             CHGVAR     VAR(&PRDAT) VALUE(%SST(&RPARM 1 7))           /*S01390*/
             OVRDBF     FILE(HISTPAA) SHARE(*YES)
 
             OPNQRYF    FILE((HISTPAA)) KEYFLD((BRCC) (CCY) (CASK +
                          *ASCEND) (CNUM) (DLNO) (EDAT) (SQNO))
 
/************CALL       PGM(DL9111) PARM(&PRDAT)                     * *S01390*/
             CALL       PGM(DL9111) PARM(&PRDAT &RSEQ &RENT)          /*S01390*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CLOF       OPNID(HISTPAA)
             DLTOVR     FILE(HISTPAA)
 
 
 
/*   UNSUCCESSFUL COMPLETION - SEND ERROR MESSAGE   */
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/***************RTVDTAARA  DTAARA(LDA (129 44)) RTNVAR(&MEM)         * *S01390*/
                RTVDTAARA  DTAARA(LDA (132 50)) RTNVAR(&MEM)          /*S01390*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MOPERQ)
             ENDDO
             CLRPFM     HISTPAA
             GOTO END
 
 
 ABNOR:      SNDPGMMSG  MSG('DL9111 DID NOT COMPLETE') TOMSGQ(MOPERQ +
                        MRUNQ)
 
/***END:         ENDPGM                                              * *S01390*/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01390*/
