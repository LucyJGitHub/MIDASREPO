/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Fixed account charges gen -end task split')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC5333 - Fixed Account Charges generation - End Task Split */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CRE083BC           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*       Prev Amend No. CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB003  *Create    Date 23OCT96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CRE083BC - Changes to optimise the existing RE components   */
/*       CCB009 - Journal files throughout close of business         */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                End Task Split                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,REC5333INT                                          */
 
/* Declare file and variables */
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('REC5330   ')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOURNAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECEIVER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECORD) TYPE(*DEC) LEN(10 0)                               /*CRE083BC*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
             DCLF       FILE(TABTBRE)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC5333MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('REC5333 - Fixed Account Charges +
                          Generation - End Task Split') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
/* If Fixed Account Charge Generation Flag is 'Y', then call */
/* programs to update Fixed Account Charges trailer */
 
             RCVF
 
             IF         COND(&FACH = 'Y') THEN(DO)
 
             CLRPFM     FILE(GEFAZZ)
             OVRDBF     FILE(REFACGPA) TOFILE(REFACGPA) MBR(*ALL)
 
             CALL       PGM(RE5338)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             RTVMBRD    FILE(REFACGPA) MBR(FACHG00001) +
                          NBRCURRCD(&RECORD)                                            /*CRE083BC*/
             IF         COND(&RECORD *NE 0) THEN(DO)                                    /*CRE083BC*/
             CALL       PGM(RE5339)
             ENDDO                                                                      /*CRE083BC*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             ENDDO
 
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
 
             DLTDTAQ    DTAQ(&DTAQLIB/FACHGSERVE)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(REFACGPD) RTNMBR(&MEMBER)
 
/* Delete sub-task data queue */
 
 LOOP:       DLTDTAQ    DTAQ(&DTAQLIB/&MEMBER)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(REFACGPD) MBR(&MEMBER *NEXT) +
                          RTNMBR(&MEMBER)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(REMOVE))
 
/* Loop for all members in driving file */
 
             GOTO       CMDLBL(LOOP)
 
/* Remove all members from driving and trailer file */
 
 REMOVE:     RMVM       FILE(REFACGPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(REFACGPA) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
             GOTO       CMDLBL(END)
 
 
 ABNOR:      SNDPGMMSG  MSG('Program REC5333 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,REC5333END                                          */
 
             ENDPGM
