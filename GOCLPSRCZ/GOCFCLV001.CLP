/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GO Bulk Update of GZFCLTLVPD: start tsk-splt')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GOCFCLV001 - Midas GO Bulk update of Facilities Listview    */
/*                    Start Task Split                               */
/*                                                                   */
/*       (c) Misys Banking Systems Ltd. 2009                         */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Last Amend No. CGP015  *CREATE    Date 06Mar09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CGP015 - Task Split of Bulk update of Facilities listview   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare file and variables */
 
             DCLF       FILE(CBCMPNLC)
 
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE(GOFCLVSRV)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DRIVER) TYPE(*CHAR) LEN(10) +
                          VALUE(FCLVDVPD)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAME1) TYPE(*CHAR) LEN(5) VALUE('FCLVD')
             DCL        VAR(&NAME2_C) TYPE(*CHAR) LEN(5)
             DCL        VAR(&NAME2_N) TYPE(*DEC) LEN(5 0) VALUE(01000)
             DCL        VAR(&TSK#) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) VALUE('GOCFCLVTS')
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)
             DCL        VAR(&WKDHSEQ) TYPE(*DEC) LEN(5 0)
 
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('GOCFCLV001 - Midas GO Bulk update of +
                          Facilities Listview - Start Task Split') +
                          TOMSGQ(MRUNQ)
 
/* Determine full JLIB and DTAQLIB library name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'DPLIB')
 
/* Clear index file */
 
             CLRPFM     FILE(FCLVIXPD)
 
/* Remove all members from driving file and trailer file */
 
             RMVM       FILE(&DRIVER) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
/* Create main data queue */
 
             CHKOBJ     OBJ(&DTAQLIB/&SRVDTAQ) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAQ +
                          DTAQ(&DTAQLIB/&SRVDTAQ) MAXLEN(50))
             CALL       PGM(QCLRDTAQ) PARM(&SRVDTAQ '*LIBL')
             MONMSG     MSGID(CPF9801)
 
/* Retrieve number of sub-tasks */
 
 CHAIN:      RCVF
             CHGVAR     VAR(&WKDHSEQ) VALUE(&DHCSEQ)
             IF         COND((&DHCOTT *NE &CNAME) *OR (&WKDHSEQ *NE +
                          &CSEQ)) THEN(DO)
             GOTO       CMDLBL(CHAIN)
             ENDDO
 
/* Create member and data queue(clear if needed) for 1st task                          */
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)
             CHGVAR     VAR(&MEMBER) VALUE(&NAME1 *CAT &CSEQA)
             ADDPFM     FILE(&DRIVER) MBR(&MEMBER)
             CHKOBJ     OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50)
                RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER)
                CHGOBJOWN  OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)
             ENDDO
             CALL       PGM(QCLRDTAQ) PARM(&MEMBER &DTAQLIB)
 
/* Create member and data queue(clear if needed) for 2nd and following tasks           */
             CHGVAR     VAR(&TSK#) VALUE(2)
 LOOP:       IF         COND(&TSK# *GT &DHTSNO) THEN(GOTO CMDLBL(END))
 
/* Create member name based on Seq # and Task # */
             CHGVAR     VAR(&WKDHSEQ) VALUE(&DHCSEQ)
             CHGVAR     VAR(&NAME2_N) VALUE(01000)
             CHGVAR     VAR(&NAME2_N) VALUE((&NAME2_N * &WKDHSEQ) + &WKDHSEQ + &TSK# - 2)
             CHGVAR     VAR(&NAME2_C) VALUE(&NAME2_N)
             CHGVAR     VAR(&MEMBER) VALUE(&NAME1 *CAT &NAME2_C)
             ADDPFM     FILE(&DRIVER) MBR(&MEMBER)
 
/* Create data queue if it doesn't already exist and set authorities. */
             CHKOBJ     OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ)
             MONMSG     MSGID(CPF9801) EXEC(DO)
                CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50)
                RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER)
                CHGOBJOWN  OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)
             ENDDO
             CALL       PGM(QCLRDTAQ) PARM(&MEMBER &DTAQLIB)
 
             CHGVAR     VAR(&TSK#) VALUE(&TSK# + 1)
             GOTO       CMDLBL(LOOP)
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCFCLV001 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
