/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Calculate fixed commission-end task split')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC1135 - Calculate Fixed Commission - End Task Split       */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Last Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB003  *Create    Date 05Nov96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CCB009 - Journal files throughout close of business         */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Task Split                                     */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,REC1135INT                                          */
 
/* Declare file and variables */
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('REC113N   ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOURNAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECEIVER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC1135MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('REC1135 - Calculate Fixed Commission +
                          - End Task Split') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
/* Determine full JLIB and DTAQLIB library name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'XLIB')
 
/* Define journal and receiver name */
 
             CHGVAR     VAR(&JOURNAL) VALUE('J' *CAT &CNAME)
             CHGVAR     VAR(&RECEIVER) VALUE('JR' *CAT &CNAME)
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* Delete journal/receiver */
 
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/&JOURNAL)
             MONMSG     MSGID(CPF7032 CPF9801)
 
             DLTJRN     JRN(&JLIB/&JOURNAL)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Delete journal receiver without any display if not fully saved */
 
             CHGJOB     INQMSGRPY(*DFT)
 
             DLTJRNRCV  JRNRCV(&JLIB/&RECEIVER)
             MONMSG     MSGID(CPF2105 CPF9801)
 
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
 
/* Delete main data queue */
 
             DLTDTAQ    DTAQ(&DTAQLIB/FIXCMSERVE)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(REFIXCPD) RTNMBR(&MEMBER)
 
/* Delete sub-task data queue */
 
 LOOP:       DLTDTAQ    DTAQ(&DTAQLIB/&MEMBER)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(REFIXCPD) MBR(&MEMBER *NEXT) +
                          RTNMBR(&MEMBER)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(REMOVE))
 
/* Loop for all members in driving file */
 
             GOTO       CMDLBL(LOOP)
 
/* Remove all members from driving and trailer file */
 
 REMOVE:     RMVM       FILE(REFIXCPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
             GOTO       CMDLBL(END)
 
 
 ABNOR:      SNDPGMMSG  MSG('Program REC1135 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC1135END                                          */
 
             ENDPGM
