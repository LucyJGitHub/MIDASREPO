/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Calculate fixed commission-start task spt')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/*       REC1141 - Calculate Fixed Commission Start Task Split.      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD022062           Date 27Aug13              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CPK015             Date 25Feb02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      179753             Date 05Feb01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CCB003  *Create    Date 05NOV96              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD022062 - EOM COB issues                                   */
/*       CPK015 - Move data queues fom XLIB to DPLIB.                */
/*       179753 - AUTL MIDAS10 should not be hardcoded               */
/*       CCB009 - Journal files throughout close of business         */
/*       CCB003 - COB Performance Enhancements - Task Split          */
/*                Start Task Split                                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/*/COPY WNCPYSRC,REC1141INT                                          */
 
/* Declare file and variables */
 
             DCLF       FILE(CBCMPNLC)
 
             DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10) +
                          VALUE('REC113A   ')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&ANWD) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTAQLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOURNAL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RECEIVER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NAME1) TYPE(*CHAR) LEN(5) VALUE('FIXCM')
             DCL        VAR(&NAME2_C) TYPE(*CHAR) LEN(5) VALUE('00001')
             DCL        VAR(&NAME2_N) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&LOOP) TYPE(*DEC) LEN(3 0) VALUE(1)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*CPK015*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,REC1141MPS                                          */
 
/* Send message to MRUNQ */
             SNDPGMMSG  MSG('REC1141 - Calculate Fixed Commission +
                           - Start Task Split') TOMSGQ(MRUNQ)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
/* Determine full JLIB and DTAQLIB library name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
/************CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'XLIB')                        */ /*CPK015*/
             CHGVAR     VAR(&DTAQLIB) VALUE(&SYSID *CAT 'DPLIB')                          /*CPK015*/
 
/* Define journal and receiver name */
 
             CHGVAR     VAR(&JOURNAL) VALUE('J' *CAT &CNAME)
             CHGVAR     VAR(&RECEIVER) VALUE('JR' *CAT &CNAME)
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* Delete journal */
 
             ENDJRNPF   FILE(*ALL) JRN(&JLIB/&JOURNAL)
             MONMSG     MSGID(CPF7032 CPF9801)
 
             DLTJRN     JRN(&JLIB/&JOURNAL)
             MONMSG     MSGID(CPF2105 CPF9801)
 
/* Delete journal receiver without any display if not fully saved */
 
             CHGJOB     INQMSGRPY(*DFT)
 
             DLTJRNRCV  JRNRCV(&JLIB/&RECEIVER)
             MONMSG     MSGID(CPF2105 CPF9801)
 
             CHGJOB     INQMSGRPY(*RQD)
 
/* Create journal/receiver */
 
/**********  CRTJRNRCV  JRNRCV(&JLIB/&RECEIVER) AUT(MIDAS10)          /*179753*/
/**********  CRTJRN     JRN(&JLIB/&JOURNAL) JRNRCV(&JLIB/&RECEIVER) +
                          AUT(MIDAS10)                                /*179753*/
             CRTJRNRCV  JRNRCV(&JLIB/&RECEIVER) AUT(*LIBCRTAUT)       /*179753*/
             CRTJRN     JRN(&JLIB/&JOURNAL) JRNRCV(&JLIB/&RECEIVER) +
                          AUT(*LIBCRTAUT)                             /*179753*/
 
             ENDDO                                                    /*CCB009*/
/* Clear index file */
 
             CLRPFM     FILE(REFXCIPD)
 
/* Remove all members from driving file */
 
             RMVM       FILE(REFIXCPD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
 
/* Create main data queue */
 
/**********  CRTDTAQ    DTAQ(&DTAQLIB/FIXCMSERVE) MAXLEN(50) +
                          AUT(MIDAS10)                                /*179753*/
/************CRTDTAQ    DTAQ(&DTAQLIB/FIXCMSERVE) MAXLEN(50) +                         */ /*CPK015*/
/************             AUT(*LIBCRTAUT)                                      /*179753*/ /*CPK015*/
/************MONMSG     MSGID(CPF9870) EXEC(DO)                                        */ /*CPK015*/
/************CALL       PGM(QCLRDTAQ) PARM(FIXCMSERVE &DTAQLIB)                        */ /*CPK015*/
/************ENDDO                                                                     */ /*CPK015*/
             CALL       PGM(QCLRDTAQ) PARM(FIXCMSERVE '*LIBL')                            /*CPK015*/
 
             IF         COND(&CSEQ *EQ 2) THEN(CHGVAR VAR(&ANWD) +
                          VALUE('Y'))
 
/* Retrieve number of sub-tasks */
 
 CHAIN:      RCVF
             IF         COND(&DHCOTT *NE &CNAME) THEN(DO)
             GOTO       CMDLBL(CHAIN)
             ENDDO
 
/* If ANWD run then ensure that ANWD component is accessed*/
 
             IF         COND(&ANWD *EQ 'Y') THEN(DO)
             IF         COND(&DHCSEQ *NE '00002') THEN(DO)
             GOTO       CMDLBL(CHAIN)
             ENDDO
             ENDDO
 
/* Start loop which adds new members to driving file */
 
             CHGVAR     VAR(&NAME2_C) VALUE(&DHCSEQ)
 LOOP:       IF         COND(&LOOP *GT &DHTSNO) THEN(GOTO +
                          CMDLBL(START))
 
             CHGVAR     VAR(&MEMBER) VALUE(&NAME1 *CAT &NAME2_C)
             ADDPFM     FILE(REFIXCPD) MBR(&MEMBER)
/**********  CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50) AUT(MIDAS10)/*179753*/
/************CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50) +                            */ /*CPK015*/
/************             AUT(*LIBCRTAUT)                                      /*179753*/ /*CPK015*/
/************MONMSG     MSGID(CPF9870) EXEC(DO)                                        */ /*CPK015*/
/************CALL       PGM(QCLRDTAQ) PARM(&MEMBER &DTAQLIB)                           */ /*CPK015*/
/************ENDDO                                                                     */ /*CPK015*/
 
/* Create data queue if it doesn't already exist and set authorities. */                  /*CPK015*/
             CHKOBJ     OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ)                              /*CPK015*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*CPK015*/
                CRTDTAQ    DTAQ(&DTAQLIB/&MEMBER) MAXLEN(50)                              /*CPK015*/
                RTVOBJD    OBJ(&DTAQLIB) OBJTYPE(*LIB) OWNER(&OWNER)                      /*CPK015*/
                CHGOBJOWN  OBJ(&DTAQLIB/&MEMBER) OBJTYPE(*DTAQ) +
                             NEWOWN(&OWNER)                                               /*CPK015*/
             ENDDO                                                                        /*CPK015*/
             CALL       PGM(QCLRDTAQ) PARM(&MEMBER &DTAQLIB)                              /*CPK015*/
 
             IF         COND(&LOOP = 1) THEN(DO)
             IF         COND(&DHCSEQ = '00001') THEN(DO)
             CHGVAR     VAR(&NAME2_N) VALUE(01000)
             ENDDO
             ELSE       CMD(DO)
/**********  CHGVAR     VAR(&NAME2_N) VALUE(02001)                 */                   /*MD022062*/
             CHGVAR     VAR(&NAME2_N) VALUE(02000)                                      /*MD022062*/
             ENDDO
             ENDDO
 
             CHGVAR     VAR(&LOOP) VALUE(&LOOP + 1)
             CHGVAR     VAR(&NAME2_N) VALUE(&NAME2_N + 1)
             CHGVAR     VAR(&NAME2_C) VALUE(&NAME2_N)
             GOTO       CMDLBL(LOOP)
 
/* Start journalling driving/update files */
 
 START:      STRJRNPF   FILE(REFIXCPD REHISPD RECOMD REFXCIPD) +
                          JRN(&JLIB/&JOURNAL) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*CCB009*/
 
             GOTO       CMDLBL(END)
 
 
 ABNOR:      SNDPGMMSG  MSG('Program REC1141 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,REC1141END                                          */
 
             ENDPGM
