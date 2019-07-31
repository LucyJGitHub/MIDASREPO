/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL FRA Zero Rate Fix Control - Run only')       */
/********************************************************************/
/*                                                                  */
/* Midas - FRA/IRS Module                                   */
/*                                                                  */
/* DLC1919A - ZERO RATE FIX CONTROL - RUN ONLY                      */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSW005             Date 01Aug96              */
/*                      S01117             Date 13Aug90              */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*         CSW005 - MG34n and Mg36n message generation              */
/*         S01117 - MULTIBRANCHING CHANGES (RELEASE 10)             */
/*                  New program with DLC1919B - to allow the prompt */
/*                  pgm (DLC1920) to be called with RERUN = Y or N  */
/*                  depending on the menu selection made.           */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT &RPARM &RACT &RCMD)
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&LOOP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CSW005) TYPE(*CHAR) LEN(1)               /*CSW005*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CSW005*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CSW005*/
/**/
/* Monitor for all messages */
             MONMSG     MSGID(CPA0000 MCH0000 RPG0000 CPF0000) +
                          EXEC(GOTO CMDLBL(ERROR))
/**/                                                                  /*CSW005*/
/* Check if CSW005 is existing in SCSARDPD */                         /*CSW005*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CSW005*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CSW005*/
             CHGVAR     VAR(&CSW005) VALUE('N')                       /*CSW005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN 'CSW005' ' ') +
                                                                      /*CSW005*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CSW005) VALUE('Y'))                    /*CSW005*/
/**/
/* If this program has been called then the RERUN option has been taken */
/* from the menu - call DLC1920 with the hard-coded parameter.  &RCMD   */
/* is to receive back any Function keys taken in the prompt program.    */
/**/                                                                  /*CSW005*/
/* This program is amended so that prompt program screen is ignored */
/* if switchable feature CSW005 is on                               */
/**/                                                                  /*CSW005*/
             IF         COND(CSW005 *NE 'Y') THEN(DO)                 /*CSW005*/
             CALL       PGM(DLC1920) PARM(&RERUN &RCMD)
             ENDDO                                                    /*CSW005*/
             CHGVAR     VAR(%SST(&RPARM 1 1)) VALUE(&RERUN)
             GOTO       CMDLBL(END)
/**/
 ERROR:      IF         COND(&LOOP *NE 'Y') THEN(DO)
             CHGVAR     VAR(&LOOP) VALUE(Y)
             SNDPGMMSG  MSGID(FIS0023) MSGF(DRSMM) TOMSGQ(MOPERQ)
             SNDPGMMSG  MSGID(FIS0023) MSGF(DRSMM) TOPGMQ(*EXT)
             ENDDO
/**/
END:         RETURN
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
