/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Daily posting by dept report')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC4214 - Daily Posting by Department Report                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG12867           Date 11Dec06              */
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      119039             Date 21Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CRT001  *CREATE    DATE 28Feb95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG12867 - Introduce a parameter to be passed to RE4214 such*/
/*                  that records extracted (POSTPD) are properly     */
/*                  selected.                                        */
/*                - Applied fix 241163                               */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       119039 - Set up DPLIB in parameter to allow correct copy.   */
/*       CRT001 - Retail Teller System                               */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)               /*119039*/
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)                  /*119039*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('REC4214 - Daily posting by department +
                          report') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
             CLRPFM     FILE(POSTPH)
             CLRPFM     FILE(POSTPD)
             CLRPFM     FILE(POSTPZ)
/**/
/**********  CALL       PGM(RE4214)                                                     /*BUG12867*/
             CALL       PGM(RE4214) PARM(&RENT)                                         /*BUG12867*/
/**/
/* GOTO ERROR MSG IS U7 & U8 NOT OFF */
             IF         COND(%SWITCH(XXXXXX1X)) THEN(DO)
                        GOTO ERROR
                        ENDDO
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)             /*119039*/
             CHGVAR     VAR(&DPLIB) VALUE(&LID *CAT 'DPLIB')          /*119039*/
/**/
/* SORT PF/POSTPD IN CORRECT SEQUENCE */
/************CPYF       FROMFILE(POSTPD) TOFILE(QTEMP/POSTPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)   ***/       /*119039*/
/************CPYF       FROMFILE(QTEMP/POSTPD) TOFILE(POSTPD) +
                          MBROPT(*REPLACE)                 ***/       /*119039*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)     ***/       /*119039*/
/**********  RGZPFM     FILE(&DPLIB/POSTPD) KEYFILE(*FILE)            /*119039*/          /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                        /*119039*/          /*228542*/
             CALL       PGM(SCC000060) PARM('POSTPD' '*FIRST')                            /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/
             CALL       PGM(RE4216) PARM(&RSEQ &RLEV &RENT)
/**/
/* CLRPFM IF NO ERROR */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CLRPFM     FILE(POSTPH)
             CLRPFM     FILE(POSTPD)
             CLRPFM     FILE(POSTPZ)
             ENDDO
/**/
/* ERROR MESSAGES */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             IF         COND(%SWITCH(XXXXXX10)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDA 168 8))
                SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
 
ABNOR:
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          REC4214 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
/**/
