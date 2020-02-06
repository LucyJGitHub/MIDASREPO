/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Retail audit letters')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Retail Module                                   */
/*                                                                   */
/*       REC0340 - AUDIT LETTERS                                     */
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
/*       Prev Amend No. 083253             Date 09Mar95              */
/*                      S01413             Date 13Apr93              */
/*                      S01117                  14FEB90              */
/*                      14900                   13SEP88              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       083253 - Pass correct parameters                            */
/*       S01413 - Header Box Standardised                            */
/*       S01117 - Multibranching                                     */
/*       E14900 - Switch U2 should be set ON only if the Commercial  */
/*                Loans Module Exists.                               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/**********  PGM                                                      /*S01117*/
/************PGM    PARM(&RSEQ &RLEV &RENT)                /*S01117*/ /*083253*/
             PGM    PARM(&RSEQ &RLEV &RENT &PARM)                     /*083253*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL    VAR(&RSEQ) TYPE(*CHAR) LEN(5)                     /*S01117*/
             DCL    VAR(&RLEV) TYPE(*CHAR) LEN(1)                     /*S01117*/
             DCL    VAR(&RENT) TYPE(*CHAR) LEN(3)                     /*S01117*/
             DCL    VAR(&PARM) TYPE(*CHAR) LEN(100)                   /*083253*/
             DCL VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL VAR(&MMOD) TYPE(*CHAR) LEN(256)
/*/COPY WNCPYSRC,REH00145                                            */
/**/
             RTVDTAARA  DTAARA(MMOD *ALL) RTNVAR(&MMOD)
             CHGJOB SWS(00000000)
/*/COPY WNCPYSRC,REH00146                                            */
/**/
             CLRPFM FILE(RQSTLHH)
             CLRPFM FILE(RQSTLDD)
             CLRPFM FILE(RQSTLZZ)
/**/
             OVRDBF FILE(TABLE) TOFILE(TABRE2)
/**/
/*********** CALL PGM(RE0340)                                         /*S01117*/
             CALL PGM(RE0340B)   PARM(&RSEQ)                          /*S01117*/
/**/
             IF COND(*NOT %SWITCH(XXXXXX0X)) THEN(GOTO CMDLBL(ERROR1))
             ELSE  CMD(DO)
             CLRPFM FILE(DLAUDHH)
             CLRPFM FILE(DLAUDDD)
             CLRPFM FILE(DLAUDDL)
             CLRPFM FILE(DLAUDDR)
             CLRPFM FILE(DLAUDZZ)
             IF COND(%SST(&MMOD 2 1) *EQ 'Y')  THEN(CHGJOB +
                             SWS(1XXXXXXX))
/**/
/*           IF  COND(%SST(&MMOD 10 1) *EQ 'Y')  THEN(CHGJOB +      */
/*                           SWS(X1XXXXXX))                        */ /*E14900*/
             IF COND(%SST(&MMOD 4 1) *EQ 'Y')  THEN(CHGJOB +
                             SWS(X1XXXXXX))                           /*E14900*/
/**/
             CALL PGM(RE0341)
             ENDDO
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO CMDLBL(ERROR2))
/*********** CALL PGM(RE0342)                                         /*S01117*/
             CALL PGM(RE0342)   PARM(&RSEQ &RENT)                     /*S01117*/
/**/
             DLTOVR FILE(TABLE)                                       /*S01117*/
/**/                                                                  /*S01117*/
/*           E R R O R      M E S S A G E S                          */
/**/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR VAR(&MSG) VALUE('JOB TERMINATED - DATABASE ERROR')
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
               ENDDO
               IF COND(%SWITCH(XXXXXX01)) THEN(DO)
/*                                                                  */
                SNDPGMMSG MSG('FILES OUT OF BALANCE - RE0342') +
                          TOMSGQ(MOPERQ MRUNQ)
/*                                                                  */
               ENDDO
             GOTO CMDLBL(ENDPGM)
             ENDDO
/**/
ERROR2:      IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
               IF COND(%SWITCH(XXXXXX1X)) THEN(DO)
                   CHGVAR VAR(&MSG) VALUE('JOB TERMINATED - DATABASE ERROR')
                   SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
               ENDDO
               IF COND(%SWITCH(XXXXXX01)) THEN(DO)
/*                                                                  */
                SNDPGMMSG MSG('FILE OUT OF BALANCE - RE0341') +
                          TOMSGQ(MOPERQ MRUNQ)
/*                                                                  */
               ENDDO
             GOTO CMDLBL(ENDPGM)
             ENDDO
/**/
ERROR1:      IF COND(*NOT %SWITCH(XXXXXX0X)) THEN(DO)
                CHGVAR VAR(&MSG) VALUE('PROGRAM TERMINATED - DATABASE ERROR')
                SNDPGMMSG MSG(&MSG) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
/*DPGM:      ENDPGM                                                   /*S01117*/
ENDPGM:      RCLRSC                                                   /*S01117*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*S01117*/
