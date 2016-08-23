/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas HF Del entries by retention period')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - History and Audit Facility Module           */
/*                                                                   */
/*       HFC0210  - DELETE EXPIRED ENTRIES                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 209119             Date 17Oct06              */
/*       Prev Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01379             Date 15Sep92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       209119 - Access the file members one at a time, to ensure   */
/*                that everything is processed accordingly.          */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       S01379 - New program for HAF.                               */
/*                                                                   */
/*********************************************************************/
 
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DAT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DELR) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&HFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RTNMBR) TYPE(*CHAR) LEN(10)                                  /*209119*/
 
             DCLF       FILE(HFFILEPD)
 
/* */
/** GLOBAL MONITOR MESSAGE */
/* */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* */
/* Get library ID and build the HFLIB variable */
/* */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LID)
             CHGVAR     VAR(&HFLIB) VALUE(&LID *CAT 'HFLIB')
 
 
/* */
/* Get the date */
/* */
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&DAT)
 
/* */
/* Read all records from HFFILEPD */
/* */
 RETRY:      RCVF
 
/* */
/* EOF end program */
/* */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(END))
 
/* */
/* If this file not to be processed then read next record */
/* */
             IF         COND((&HEADER *NE '0') *OR (&ENAB *NE 'E')) +
                          THEN(GOTO CMDLBL(RETRY))
 
/* */
/* Override input file top file just read and call HF0210 */
/* to delete entries by retention period */
/* */
/*           OVRDBF     FILE(JOURNAL) TOFILE(&HFLIB/&FFILE)                               /*209119*/
             RTVMBRD    FILE(&HFLIB/&FFILE) MBR(*FIRSTMBR) +
                          RTNMBR(&RTNMBR)                                                 /*209119*/
PROC1:                                                                                    /*209119*/
             OVRDBF     FILE(JOURNAL) TOFILE(&HFLIB/&FFILE) +
                          MBR(&RTNMBR)                                                    /*209119*/
             CALL       PGM(HF0210) PARM(&DAT &RETAIN)
             RTVMBRD    FILE(&HFLIB/&FFILE) MBR(&RTNMBR *NEXT) +
                          RTNMBR(&RTNMBR)                                                 /*209119*/
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(PROC2))                           /*209119*/
             GOTO       CMDLBL(PROC1)                                                     /*209119*/
PROC2:                                                                                    /*209119*/
 
/* */
/* If any records were deleted then reorganise the file */
/* */
/*           RTVMBRD    FILE(&HFLIB/&FFILE) NBRDLTRCD(&DELR)                              /*209119*/
             RTVMBRD    FILE(&HFLIB/&FFILE) MBR(*FIRSTMBR) +
                           RTNMBR(&RTNMBR) NBRDLTRCD(&DELR)                               /*209119*/
 NXTMBR:                                                                                  /*209119*/
             IF         COND(&DELR *NE 0) THEN(DO)
/**********  RGZPFM     FILE(&HFLIB/&FFILE)                                               /*228542*/
/**********  MONMSG     MSGID(CPF0000)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM(&FFILE '*FIRST')                              /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO
             RTVMBRD    FILE(&HFLIB/&FFILE) MBR(&RTNMBR *NEXT) +
                          RTNMBR(&RTNMBR) NBRDLTRCD(&DELR)                                /*209119*/
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(RGZ_OK))                          /*209119*/
             GOTO       CMDLBL(NXTMBR)                                                    /*209119*/
RGZ_OK:                                                                                   /*209119*/
 
/* */
/* Process the next record on file */
/* */
             GOTO       CMDLBL(RETRY)
 
/* */
/** ABNORMAL ERROR PROCESSING                                      */
/* */
 ABNOR:      SNDPGMMSG  MSG('PROGRAM HFC0210 ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
