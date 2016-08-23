/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Remove Journal Chgs for MM Files')           */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                    */
/*                                                                   */
/*   FFC1091  -  REMOVE JOURNAL CHANGES FOR MULTI-MEMBER FILES (EOC) */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG7286            Date 23May05              */
/*       Prev Amend No. CSC020             Date 31Mar04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  E21147             DATE 20FEB90                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BUG7286 - Error in SCRTVJEVT command                        */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*   E21147  - REPLACE QCAEXEC CALL WITH QCMDEXC FOR AS400           */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*     CREATION REQUIREMENTS                                         */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MKT &FAIL &FROM &TO &XREC)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &MKT  TYPE(*CHAR)  LEN(2)
             DCL        &ACT  TYPE(*CHAR)  LEN(1)
             DCL        &FAIL TYPE(*CHAR)  LEN(1)
             DCL        &FROM TYPE(*DEC)   LEN(10 0)
             DCL        &TO   TYPE(*DEC)   LEN(10 0)
             DCL        &FROMA TYPE(*CHAR) LEN(10)
             DCL        &TOA  TYPE(*CHAR) LEN(10)
             DCL        &ID   TYPE(*CHAR)  LEN(7) VALUE(CPF7049)
             DCL        &L1   TYPE(*CHAR)  LEN(4)
             DCL        &DATA TYPE(*CHAR)  LEN(100)
             DCL        &RES  TYPE(*DEC)   LEN(9 0)
             DCL        &RESC TYPE(*CHAR)  LEN(9)
             DCL        &MSG  TYPE(*CHAR)  LEN(70)
             DCL        &EXEC TYPE(*CHAR)  LEN(560)
/************DCL        &XREC TYPE(*CHAR)  LEN(3)*******************************************CSC020*/
             DCL        &XREC   TYPE(*CHAR)  LEN(8)                                       /*CSC020*/
/************DCL********&ENDRC TYPE(*CHAR) LEN(8)*******************************************CSC020*/
             DCL        &ENDRC TYPE(*CHAR) LEN(10)
             DCLF       FFMMFD
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        &STRRCV  TYPE(*CHAR)  LEN(10)                                     /*CSC020*/
             DCL        VAR(&STRSEQ) TYPE(*DEC) LEN(10 0)                                /*BUG7286*/
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                                          CSC020*/
/*  Determine journal receiver of next day set up.                                          CSC020*/
/*  (Equivalent to ICRCV001 in previous releases)                                           CSC020*/
/*                                                                                          CSC020*/
/************SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV)                          *CSC020***BUG7286*/
             SCRTVJEVT  EVENT(NDSUJR) RECEIVER(&STRRCV) SEQ(&STRSEQ)                     /*BUG7286*/
/*                                                                                          CSC020*/
/*  If no value returned, then set receiver to first available.                             CSC020*/
/*                                                                                          CSC020*/
             IF         COND(&STRRCV *EQ '          ') THEN(DO)                           /*CSC020*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) TOENT(*FIRST) +
                          RTNRCV(&STRRCV)                                                 /*CSC020*/
             ENDDO                                                                        /*CSC020*/
/**/
/* CONVERT THE NUMERIC VALUES OF FROM AND TO POINTS TO ALPHA VALUES  */
/**/
             CHGVAR     VAR(&FROMA) VALUE(&FROM)
             CHGVAR     VAR(&TOA) VALUE(&TO)
/**/
             OVRDBF     FILE(FFMMFD) MBR(&MKT)
/**/
FILE:        RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO END)
/**/
/* BUILD THE REMOVE JOURNAL CHANGES COMMAND TO REMOVE CHANGES BETWEEN*/
/* THE POINTS PASSED AS PARAMETERS FOR THE RELEVANT FILE             */
/**/
/************CHGVAR     VAR(&ENDRC) VALUE('ICRCV' *CAT &XREC)*******************************CSC020*/
             CHGVAR     VAR(&ENDRC) VALUE('IR' *CAT &XREC)                                /*CSC020*/
/************CHGVAR     VAR(&EXEC) VALUE('RMVJRNCHG JRN(ICJRN) +
                          FILE(' *CAT &FMMF *TCAT ') +
                            RCVRNG(('|| &ENDRC |<')  +
                                  (ICRCV001))   +
                          FROMENT(' || &FROMA |< ') TOENT(' || +
                          &TOA |< ')')******************************************************CSC020*/
             CHGVAR     VAR(&EXEC) VALUE('RMVJRNCHG JRN(ICJRN) +
                          FILE(' *CAT &FMMF *TCAT ') RCVRNG((' *CAT +
                          &ENDRC *TCAT ') (' *CAT &STRRCV *TCAT +
                          '))   FROMENT(' *CAT &FROMA *TCAT ') +
                          TOENT(' *CAT &TOA *TCAT ')')                                    /*CSC020*/
/**/
/* IF THE FAIL VARIABLE IS 'F' SOME CHANGES WILL HAVE BEEN REMOVED   */
/* ALREADY, THIS HAS TO BE MONITORED FOR.                            */
/**/
             IF         COND(&FAIL *EQ F) THEN(DO)
/**/
/* EXECUTE THE REMOVE JOURNAL CHANGES VIA THE QCMDEXC COMMAND         **E21147*/
/**/
/****LOOP*   CALL       PGM(QCAEXEC) PARM(&EXEC 560)                  **E21147*/
LOOP:        CALL       PGM(QCMDEXC) PARM(&EXEC 560)                  /*E21147*/
             MONMSG     MSGID(CPF7049) EXEC(DO)
/**/
/* SET UP NEW FROM POINT IF CHANGES HAVE PREVIOUSLY BEEN REMOVED     */
/**/
                 RCVMSG     MSGTYPE(*ANY) MSGDTA(&DATA) MSGID(&ID)
                 CHGVAR     &L1 %SUBSTRING(&DATA 51 4)
                 CALL       FF0491  PARM(&L1 &RES)
                 CHGVAR     &RES VALUE(&RES - 1)
/**/
/* ONLY CONTINUE TO REMOVE CHANGES IF TO POINT HASN'T BEEN REACHED   */
/**/
                 IF         COND(&RES *GE &TO) THEN(DO)
                     CHGVAR    VAR(&RESC) VALUE(&RES)
                     CHGVAR    VAR(&MSG) VALUE('0' *CAT &RESC)
/********************CHGVAR    VAR(&EXEC) VALUE('RMVJRNCHG JRN(ICJRN) +
                                FILE(' *CAT &FMMF *TCAT ') +
                            RCVRNG(('|| &ENDRC |<')  +
                                  (ICRCV001))   +
                                FROMENT(' || &MSG |< ') +
                                TOENT(' || &TOA |< ')')*************************************CSC020*/
             CHGVAR     VAR(&EXEC) VALUE('RMVJRNCHG JRN(ICJRN) +
                          FILE(' *CAT &FMMF *TCAT ') RCVRNG((' *CAT +
                          &ENDRC *TCAT ') (' *CAT &STRRCV *TCAT +
                          '))   FROMENT(' *CAT &MSG *TCAT ') +
                          TOENT(' *CAT &TOA *TCAT ')')                                    /*CSC020*/
                     GOTO      LOOP
                 ENDDO
/**/
             ENDDO
/**/
             ENDDO
/**/
/* IF THE FAIL VARIABLE ISN'T 'F' NO CHANGES SHOULD HAVE BEEN REMOVED*/
/* ALREADY SO IT IS AN ERROR IF THIS HAS OCCURRED                    */
/**/
             IF         COND(&FAIL *NE F) THEN(DO)
/**/
/* EXECUTE THE REMOVE JOURNAL CHANGES VIA THE QCMDEXC COMMAND         **E21147*/
/**/
/*********** CALL       PGM(QCAEXEC) PARM(&EXEC 560)                  **E21147*/
             CALL       PGM(QCMDEXC) PARM(&EXEC 560)                  /*E21147*/
             ENDDO
/**/
             GOTO       FILE
/**/
 ABNOR:      SNDPGMMSG  MSG('FFC1091 - Remove Journal Changes of +
                          multi member files ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* CALL FF0472 TO RESET END OF CENTRE STATUS INDICATOR               */
/**/
             CALL       FF0472 PARM('F' &MKT)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/* CALL FF0473 TO WRITE A MESSAGE TO THE END OF CENTRE MESSAGES FILE */
/**/
             CHGVAR     VAR(&ACT) VALUE('I')
             CHGVAR     VAR(&MSG) VALUE('End of Centre Recovery +
                         or Reopen terminated abnormally')
             CALL       FF0473 PARM(&MKT &ACT &MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB    SWS(XXXXXX1X)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
END:         ENDPGM
