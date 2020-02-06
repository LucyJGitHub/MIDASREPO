/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SD Available cust number rpt prompt')           */
/*********************************************************************/
/*                                                                   */
/*  Midas - Standing Data Module                                     */
/*                                                                   */
/*  SDC1101  - Available Customer Number Report Prompt.              */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG12497            Date 20Nov06              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                         Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*  BG12497 - Conversion Of Customer Number to Alpha                 */
/*  E27499 - New program to allow 1) input of customer number        */
/*           range to report on. 2) type of report to produce.       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
 
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&RPARM) TYPE(*CHAR) LEN(100)
             DCL        VAR(&RACT)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RCMD)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PARAM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSN1) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSN2) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSN3) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSN4) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSN5) TYPE(*CHAR) LEN(1)
             DCL        VAR(&POSN6) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(SDC1101DF)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/* Set-off Database Error Switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/*  SEND HEADER/TRAILER INFORMATION  */
 
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)
             RTVJOBA    JOB(&WSID) USER(&USER)
 
/* Setup default values for the screen */
 
             CHGVAR     VAR(&START) VALUE(*FIRST)
             CHGVAR     VAR(&END) VALUE(*LAST)
             CHGVAR     VAR(&OPTION) VALUE(*ALL)
 
/* Send prompt screen */
 
 SEND:       SNDRCVF
 
             IF         COND(&IN03 *EQ '1') THEN(DO)
                CHGVAR     VAR(&RCMD) VALUE('E')
                RETURN
             ENDDO
 
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN04) VALUE('0')
 
/* Validate entries */
 
             IF         COND(&START *NE '*FIRST') THEN(DO)
 
                CHGVAR     VAR(&POSN1) VALUE(%SST(&START 1 1))
/**********     IF         COND((&POSN1 *LT '0') *OR (&POSN1 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN1 *LT 'A') *OR (&POSN1 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN2) VALUE(%SST(&START 2 1))
/**********     IF         COND((&POSN2 *LT '0') *OR (&POSN2 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN2 *LT 'A') *OR (&POSN2 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN3) VALUE(%SST(&START 3 1))
/**********     IF         COND((&POSN3 *LT '0') *OR (&POSN3 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN3 *LT 'A') *OR (&POSN3 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN4) VALUE(%SST(&START 4 1))
/**********     IF         COND((&POSN4 *LT '0') *OR (&POSN4 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN4 *LT 'A') *OR (&POSN4 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN5) VALUE(%SST(&START 5 1))
/**********     IF         COND((&POSN5 *LT '0') *OR (&POSN5 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN5 *LT 'A') *OR (&POSN5 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN6) VALUE(%SST(&START 6 1))
/**********     IF         COND((&POSN6 *LT '0') *OR (&POSN6 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN6 *LT 'A') *OR (&POSN6 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN02) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
             ENDDO
 
             IF         COND(&END *NE '*LAST') THEN(DO)
 
                CHGVAR     VAR(&POSN1) VALUE(%SST(&END 1 1))
/**********     IF         COND((&POSN1 *LT '0') *OR (&POSN1 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN1 *LT 'A') *OR (&POSN1 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN05) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN2) VALUE(%SST(&END 2 1))
/**********     IF         COND((&POSN2 *LT '0') *OR (&POSN2 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN2 *LT 'A') *OR (&POSN2 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN05) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN3) VALUE(%SST(&END 3 1))
/**********     IF         COND((&POSN3 *LT '0') *OR (&POSN3 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN3 *LT 'A') *OR (&POSN3 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN05) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN4) VALUE(%SST(&END 4 1))
/**********     IF         COND((&POSN4 *LT '0') *OR (&POSN4 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN4 *LT 'A') *OR (&POSN4 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN05) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN5) VALUE(%SST(&END 5 1))
/**********     IF         COND((&POSN5 *LT '0') *OR (&POSN5 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN5 *LT 'A') *OR (&POSN5 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN05) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
                CHGVAR     VAR(&POSN6) VALUE(%SST(&END 6 1))
/**********     IF         COND((&POSN6 *LT '0') *OR (&POSN6 +                       */  /*BG12497*/
/**********                  *GT '9')) THEN(DO)                                      */  /*BG12497*/
                IF         COND((&POSN6 *LT 'A') *OR (&POSN6 +
                             *GT '9')) THEN(DO)                                          /*BG12497*/
                   CHGVAR     VAR(&IN05) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
 
             ENDDO
 
             IF         COND(&START *GE &END) THEN(DO)
                IF         COND(&END *NE '*LAST') THEN(DO)
                   CHGVAR     VAR(&IN04) VALUE('1')
                   GOTO       CMDLBL(SEND)
                ENDDO
             ENDDO
 
/* Seton indicator if the reporting option is *NEXT */
 
             IF         COND(&OPTION *EQ '*NEXT') THEN(CHGVAR +
                          VAR(&IN01) VALUE('1'))
 
/*  Database Error Messages will be sent by RCF */
 
             RTVJOBA    JOB(&JOB) SWS(&SWS)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGVAR     VAR(&RPARM) VALUE(&START *CAT &END *CAT +
                             &OPTION)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             IF         COND(&IN01 *EQ '1') THEN(SNDPGMMSG MSG('Next +
                          available customer numbers report ended +
                          abnormally') TOMSGQ(MOPERQ MRUNQ))
 
             IF         COND(&IN01 *EQ '0') THEN(SNDPGMMSG +
                          MSG('Available customer numbers report +
                          ended abnormally') TOMSGQ(MOPERQ MRUNQ))
 
 END:        ENDPGM
