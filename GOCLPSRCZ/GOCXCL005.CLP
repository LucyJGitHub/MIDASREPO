/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Universal transactions upd: end tsk-splt')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCXCL005 - Midas GO Extract Controller Customer Loans      */
/*                   End Task Split                                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGP014  *Create    Date 27Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGP014 - Task split of Extract Controller, Customer Loans   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare variables */
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('GOCXCLTS  ')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOURNAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRIVER) TYPE(*CHAR) LEN(10) +
                          VALUE(XCLNDVPD)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GOCXCL005 - Midas GO Extract Controller +
                          Customer Loans - End Task Split') +
                          TOMSGQ(MRUNQ)
 
/* Determine full DMLIB library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&DMLIB) VALUE(&SYSID *CAT 'DMLIB')
 
/* Determine full JLIB and DTAQLIB library name */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'DPLIB')
 
/* Define journal name */
 
             CHGVAR     VAR(&JOURNAL) VALUE('J' *CAT &CNAME)
 
/* Delete main data queue */
 
             DLYJOB     DLY(10)
 
             DLTDTAQ    DTAQ(&DTAQLIB/GOXCLNSRV)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve first member description */
 
             RTVMBRD    FILE(&DRIVER) RTNMBR(&MEMBER)
 
/* Delete sub-task data queue */
 
 LOOP:       DLTDTAQ    DTAQ(&DTAQLIB/&MEMBER)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Retrieve next member description */
 
             RTVMBRD    FILE(&DRIVER) MBR(&MEMBER *NEXT) +
                          RTNMBR(&MEMBER)
             MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(REMOVE))
 
/* Loop for all members in driving file */
 
             GOTO       CMDLBL(LOOP)
 
 REMOVE:
 
/* Remove all members from driving file and trailer file */
 
             RMVM       FILE(&DRIVER) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
             GOTO       CMDLBL(END)
 
ABNOR:       SNDPGMMSG  MSG('Program GOCXCL005 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
