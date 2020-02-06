/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CA Control deal number regeneration')           */
 /********************************************************************/
 /*                                                                  */
 /*  Midas - Common Applications                             */
 /*                                                                  */
 /*  CA0060 - DEAL NUMBER REGENERATION - BATCH DAY.                  */
 /*                                                                  */
/*       (c) Finastra International Limited 2001                     */
 /*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 02Jun08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      XXXXX              Date XX/xx/XX             */
 /*                                                                  */
 /********************************************************************/
/*       MD046248 - Finastra Rebranding                              */
 /*       BG18886 - Amend non-standard codes.                        */
 /********************************************************************/
 /**/
             PGM
 /** DECLARE VARIABLES TO HOLD NO. OF DEALS                          */
             DCL        VAR(&DEALC) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DEALS) TYPE(*DEC) LEN(6 0)
 /**/
 /** DECLARE VARIABLE TO HOLD TERMINATION PARAMETER                  */
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&A) TYPE(*CHAR) LEN(50)
 /**/
             DCL        VAR(&DBFILE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DBKEY) TYPE(*CHAR) LEN(29)
             DCL        VAR(&DBPGM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DBASE) TYPE(*CHAR) LEN(3)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 /**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO ERROR)
 /**/
 /** RETRIEVE NO. OF DEALS FROM DATA AREA                            */
             RTVDTAARA  DTAARA(CASTATAA (1 5)) RTNVAR(&DEALC)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 /**/
 /** ERROR 099 HAS OCCURED                                           */
                CHGVAR     VAR(&A) VALUE('CA0060    CASTATAA099')
                SNDPGMMSG  MSGID(DBM0002) MSGF(DRSMM) MSGDTA(&A) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ENDCLPGM)
             ENDDO
             CHGVAR     VAR(&DEALS) VALUE(&DEALC)
 /**/
 /** DIVIDE BY 5 FOR THE NUMBER OF DEAL NUMBERS TO CREATE            */
             CHGVAR     VAR(&DEALS) VALUE(&DEALS / 5)
             OVRDBF     FILE(CANDLNLL) WAITRCD(*IMMED)
 /**/
 /** ATTEMPT TO ALLOCATE DEAL NUMBER REGENERATION PROGRAM            */
             ALCOBJ     OBJ((CA0050 *PGM *EXCL)) WAIT(10)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDCLPGM))
 /**/
 /** CALL RPG PGM DEAL NUMBER REGENERATION                           */
/*/COPY WNCPYSRC,CA0060001                                           */
             CALL       PGM(CA0050) PARM(&TERM &DEALS)
 /**/
 /** CHECK FOR PROGRAM ERROR                                         */
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (171 10)) RTNVAR(&DBPGM)
                RTVDTAARA  DTAARA(*LDA (181 3)) RTNVAR(&DBASE)
 
/***************CHGVAR*****VAR(&A)*VALUE(&DBPGM****&DBASE)************/ /*BG18886*/
                CHGVAR     VAR(&A) VALUE(&DBPGM *CAT &DBASE)            /*BG18886*/
                SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA(&A) +
                             TOMSGQ(MOPERQ)
             ENDDO
 /** CHECK FOR DATABASE ERROR                                        */
             IF         COND(%SWITCH(XXXXXXX1) *OR %SWITCH(XXXXXX1X)) +
                          THEN(DO)
 
                RTVDTAARA  DTAARA(*LDA (134 8)) RTNVAR(&DBFILE)
                RTVDTAARA  DTAARA(*LDA (142 29)) RTNVAR(&DBKEY)
                RTVDTAARA  DTAARA(*LDA (171 10)) RTNVAR(&DBPGM)
                RTVDTAARA  DTAARA(*LDA (181 3)) RTNVAR(&DBASE)
 
/***************CHGVAR     VAR(&A) VALUE(&DBFILE****&DBKEY****&DBPGM +
                             ***&DBASE)                              */ /*BG18886*/
                CHGVAR     VAR(&A) VALUE(&DBFILE *CAT &DBKEY *CAT &DBPGM +
                             *CAT &DBASE)                               /*BG18886*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&A) +
                             TOMSGQ(MOPERQ)
 
             ENDDO
             GOTO ENDCLPGM
 /**/
 /** IF ERROR FOUND IN PGM SEND ERROR MESSAGE AND EXIT               */
ERROR:
 /**/
 /** AN ERROR HAS OCCURED IN THIS PROGRAM                            */
             CHGVAR     VAR(&A) VALUE('CA0060    098')
             SNDPGMMSG  MSGID(DBM0004) MSGF(DRSMM) MSGDTA(&A) +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
ENDCLPGM:
             DLCOBJ     OBJ((CA0050 *PGM *EXCL))
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM
