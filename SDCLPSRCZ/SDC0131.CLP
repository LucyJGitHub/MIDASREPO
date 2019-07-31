/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SD Additional Customer Details Prompt')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       SDC0131 - Additional customer Details Report Prompt         */
/*                                                                   */
/*       (c) Finastra International Limited 2008                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CER059             Date 19Jul10              */
/*                      BUG23946           Date 18May09              */
/*                      CER047  *CREATE    Date 19May08              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG23946 - New field should be use correct char §           */
/*                  (Recompile)                                      */
/*       CER047 - German Features LF037-00 Reporting §24c KWG        */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT &RPARM &RACT &RCMD)
/*                                                                   */
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
             DCL        VAR(&SORTS) TYPE(*CHAR) LEN(3)
             DCL        VAR(&WERRF) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                             Finastra International Limited +
                             2008')
             DCL        VAR(&MSGFLE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(45)
             DCLF       FILE(SD0131DF)
/*                                                                   */
/* Global monitor message                                            */
/*                                                                   */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/*                                                                   */
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2008')
/*                                                                   */
/* Set-off Database Error Switches                                   */
/*                                                                   */
             CHGJOB     SWS(XXXXXX00)
/*                                                                   */
/*  Send Header/Trailer Information                                  */
/*                                                                   */
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&DATE)
             RTVJOBA    JOB(&WSID) USER(&USER)
/*                                                                   */
/* Setup default values for the screen                               */
/*                                                                   */
             CHGVAR     VAR(&START) VALUE(*FIRST)
             CHGVAR     VAR(&END) VALUE(*LAST)
             CHGVAR     VAR(&SORT1) VALUE(Y)
             CHGVAR     VAR(&IN94) VALUE('1')
             CHGVAR     VAR(&DDPGM) VALUE('SDC0131')
/*                                                                   */
/* Send prompt screen                                                */
/*                                                                   */
 SEND:       SNDF       RCDFMT(SD0131M1)
             SNDRCVF    RCDFMT(PROMPT)
             CALL       PGM(ZA0250)
 
/*                                                                   */
             IF         COND(&IN03 *EQ '1') THEN(DO)
                CHGVAR     VAR(&RCMD) VALUE('E')
                RETURN
             ENDDO
/*                                                                   */
             CHGVAR     VAR(&IN02) VALUE('0')
             CHGVAR     VAR(&IN05) VALUE('0')
             CHGVAR     VAR(&IN06) VALUE('0')
             CHGVAR     VAR(&IN07) VALUE('0')
             CHGVAR     VAR(&IN08) VALUE('0')
             CHGVAR     VAR(&IN09) VALUE('0')
             CHGVAR     VAR(&MSGFLE) VALUE('SDUSRMSG')
             CHGVAR     VAR(&WERRF) VALUE('N')
/*                                                                   */
/* Validate entries                                                  */
/*                                                                   */
             IF         COND(&START *NE '*FIRST') THEN(DO)
/*                                                                   */
                CHGVAR     VAR(&POSN1) VALUE(%SST(&START 1 1))
                IF         COND((&POSN1 *LT '0') *OR (&POSN1 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8281')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL2)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN2) VALUE(%SST(&START 2 1))
                IF         COND((&POSN2 *LT '0') *OR (&POSN2 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8281')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL2)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN3) VALUE(%SST(&START 3 1))
                IF         COND((&POSN3 *LT '0') *OR (&POSN3 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8281')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL2)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN4) VALUE(%SST(&START 4 1))
                IF         COND((&POSN4 *LT '0') *OR (&POSN4 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8281')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL2)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN5) VALUE(%SST(&START 5 1))
                IF         COND((&POSN5 *LT '0') *OR (&POSN5 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8281')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL2)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN6) VALUE(%SST(&START 6 1))
                IF         COND((&POSN6 *LT '0') *OR (&POSN6 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN02) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8281')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL2)
                ENDDO
/*                                                                   */
             ENDDO
/*                                                                   */
 VAL2:       IF         COND(&END *NE '*LAST') THEN(DO)
/*                                                                   */
                CHGVAR     VAR(&POSN1) VALUE(%SST(&END 1 1))
                IF         COND((&POSN1 *LT '0') *OR (&POSN1 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN05) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8282')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL3)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN2) VALUE(%SST(&END 2 1))
                IF         COND((&POSN2 *LT '0') *OR (&POSN2 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN05) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8282')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL3)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN3) VALUE(%SST(&END 3 1))
                IF         COND((&POSN3 *LT '0') *OR (&POSN3 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN05) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8282')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL3)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN4) VALUE(%SST(&END 4 1))
                IF         COND((&POSN4 *LT '0') *OR (&POSN4 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN05) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8282')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL3)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN5) VALUE(%SST(&END 5 1))
                IF         COND((&POSN5 *LT '0') *OR (&POSN5 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN05) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8282')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL3)
                ENDDO
/*                                                                   */
                CHGVAR     VAR(&POSN6) VALUE(%SST(&END 6 1))
                IF         COND((&POSN6 *LT '0') *OR (&POSN6 +
                             *GT '9')) THEN(DO)
                   CHGVAR     VAR(&IN05) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8282')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                   GOTO       CMDLBL(VAL3)
                ENDDO
/*                                                                   */
             ENDDO
/*                                                                   */
VAL3:        IF         COND(&START *GE &END) THEN(DO)
                IF         COND(&END *NE '*LAST') THEN(DO)
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8283')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
             ENDDO
/*                                                                   */
/* The Subject to 24c Flag can be either 'Y'/'N'/BLANK               */
/*                                                                   */
                IF         COND((&S24C *NE 'Y') *AND (&S24C +
                             *NE 'N') *AND (&S24C *NE ' ')) THEN(DO)
                   CHGVAR     VAR(&IN07) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8286')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
/*                                                                   */
/* The Sort Fields can be either 'Y'/BLANK                           */
/*                                                                   */
                IF         COND((&SORT1 *NE 'Y') *AND (&SORT1 +
                             *NE ' ')) THEN(DO)
                   CHGVAR     VAR(&IN06) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8287')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
/*                                                                   */
                IF         COND((&SORT2 *NE 'Y') *AND (&SORT2 +
                             *NE ' ')) THEN(DO)
                   CHGVAR     VAR(&IN08) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8287')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
/*                                                                   */
                IF         COND((&SORT3 *NE 'Y') *AND (&SORT3 +
                             *NE ' ')) THEN(DO)
                   CHGVAR     VAR(&IN09) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8287')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
/*                                                                   */
/* Only one the sort fields can be selected                          */
/*                                                                   */
                CHGVAR     VAR(&SORTS) VALUE(&SORT1 *CAT +
                           &SORT2 *CAT &SORT3)
                IF         COND(&SORTS *NE 'Y  ' *AND &SORTS +
                           *NE ' Y ' *AND &SORTS *NE '  Y' +
                           *AND &SORTS *NE '   ') THEN(DO)
                   CHGVAR     VAR(&IN06) VALUE('1')
                   CHGVAR     VAR(&IN08) VALUE('1')
                   CHGVAR     VAR(&IN09) VALUE('1')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CHGVAR     VAR(&MSGID) VALUE('USR8284')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
/*                                                                   */
/* One of the sort fields must be selected                           */
/*                                                                   */
                IF         COND(&SORTS *EQ '   ') THEN(DO)
                   CHGVAR     VAR(&IN06) VALUE('1')
                   CHGVAR     VAR(&IN08) VALUE('1')
                   CHGVAR     VAR(&IN09) VALUE('1')
                   CHGVAR     VAR(&MSGID) VALUE('USR8285')
                   CHGVAR     VAR(&MSGDTA) VALUE(' ')
                   CHGVAR     VAR(&WERRF) VALUE('Y')
                   CALL       PGM(ZA0350) PARM(&MSGFLE &MSGID &MSGDTA)
                ENDDO
/*                                                                   */
             IF         COND(&WERRF *EQ 'Y') THEN(DO)
                GOTO       CMDLBL(SEND)
             ENDDO
/*                                                                   */
/*                                                                   */
/*  Database Error Messages will be sent by RCF                      */
/*                                                                   */
             RTVJOBA    JOB(&JOB) SWS(&SWS)
/*                                                                   */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGVAR     VAR(&RPARM) VALUE(&START *CAT &END *CAT +
                             &IDTYPE *CAT &S24C *CAT &SORT1 *CAT +
                             &SORT2 *CAT &SORT3)
             ENDDO
/*                                                                   */
             GOTO       CMDLBL(END)
/*                                                                   */
 ABNOR:
             IF         COND(&IN01 *EQ '1') THEN(SNDPGMMSG +
                          MSG('Additional customer details report +
                          ended abnormally') TOMSGQ(MOPERQ MRUNQ))
/*                                                                   */
             IF         COND(&IN01 *EQ '0') THEN(SNDPGMMSG +
                          MSG('Additional customer details report +
                          ended abnormally') TOMSGQ(MOPERQ MRUNQ))
/*                                                                   */
 END:        ENDPGM
