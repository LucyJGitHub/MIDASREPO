/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CA COB deal number regeneration')               */
 /********************************************************************/
 /*                                                                  */
 /*       Midas - Common Applications                        */
 /*                                                                  */
 /*         CA0070 - DEAL NUMBER REGENERATION - AT END OF DAY.       */
 /*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXX              Date XX/XX/XX             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                         */
/*       228542 - RGZPFM has changed at R5V3                         */
/*********************************************************************/
             PGM
 /** DECLARE VARIABLES TO HOLD NO. OF DEALS                          */
             DCL        VAR(&DEALC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DEALS) TYPE(*DEC) LEN(6 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 /**/
 /** DECLARE VARIABLE TO HOLD TERMINATION PARAMETER                  */
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&A) TYPE(*CHAR) LEN(50)
 /**/
             DCL        VAR(&DBFILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DBKEY) TYPE(*CHAR) LEN(29)
             DCL        VAR(&DBPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBASE) TYPE(*CHAR) LEN(3)
 /**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO ERROR)
 /**/
 /** RETRIEVE NO. OF DEALS FROM DATA AREA                            */
             RTVDTAARA  DTAARA(CASTATAA (1 5)) RTNVAR(&DEALC)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 /**/
 /** ERROR 099 HAS OCCURED                                           */
                CHGVAR     VAR(&A) VALUE('CA0070    CASTAT  099')
                SNDPGMMSG  MSGID(DBM0002) MSGF(DRSMM) MSGDTA(&A) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             CHGVAR     VAR(&DEALS) VALUE(&DEALC)
 /**/
 /** REORGANIZE FILE PF/CADLFAPP (MONMSG FOR EMPTY FILE)             */
/**********  RGZPFM     FILE(CADLFAPP)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('CADLFAPP' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
 /**/
 /** CALL RPG PGM DEAL NUMBER REGENERATION                           */
/*/COPY WNCPYSRC,CA0070001                                           */
             CALL       PGM(CA0050) PARM(&TERM &DEALS)
 /**/
 /** CHECK FOR PROGRAM ERROR                                         */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (171 10)) RTNVAR(&DBPGM)
                RTVDTAARA  DTAARA(*LDA (181 3)) RTNVAR(&DBASE)
 
 /**********    CHGVAR     VAR(&A) VALUE(&DBPGM****&DBASE)           */ /*BG18886*/
                CHGVAR     VAR(&A) VALUE(&DBPGM *CAT &DBASE)            /*BG18886*/
                SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA(&A) +
                             TOMSGQ(MOPERQ)
             ENDDO
 /**/
 /** CHECK FOR DATA BASE ERROR                                       */
             IF         COND(%SWITCH(XXXXXXX1) *OR %SWITCH(XXXXXX1X)) +
                           THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 8)) RTNVAR(&DBFILE)
                RTVDTAARA  DTAARA(*LDA (142 29)) RTNVAR(&DBKEY)
                RTVDTAARA  DTAARA(*LDA (171 10)) RTNVAR(&DBPGM)
                RTVDTAARA  DTAARA(*LDA (181 3)) RTNVAR(&DBASE)
 
/**********     CHGVAR     VAR(&A) VALUE(&DBFILE****&DBKEY****&DBPGM +
                             ***&DBASE)                              */ /*BG18886*/
                CHGVAR     VAR(&A) VALUE(&DBFILE *CAT &DBKEY *CAT &DBPGM +
                             *CAT &DBASE)
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&A) +
                             TOMSGQ(MOPERQ)
 
             ENDDO
             GOTO ENDCLPGM
ERROR:
 /**/
 /** AN ERROR HAS OCCURED IN THIS PROGRAM                            */
             CHGVAR     VAR(&A) VALUE('CA0070    098')
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA(&A) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 CPA0000 MCH0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDCLPGM: ENDPGM
