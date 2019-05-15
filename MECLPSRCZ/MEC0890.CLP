/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ME Message generation audit report')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     Message Management                            */
/*                                                                   */
/*       MEC0890 - Message Generation Audit Report Control Program   */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CRN001             Date 04Nov05              */
/*                      BUG6604            Date 20Apr05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             DATE 12AUG96              */
/*                      S01408             DATE 26APR96              */
/*                      S01408             DATE 06MAR96              */
/*                      044474             DATE 24NOV93              */
/*                      046121             DATE 15NOV93              */
/*                      043202             DATE 24OCT92              */
/*                      E40242             DATE 19JUN92              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       CRN001 - increase field length to copy to MGJREFPD.         */
/*       BUG6604- Removal of RCLRSC from this program                */
/*       CCB009 - Journal files throughout close of business         */
/*       S01408 - Addition of core hook MEC0890003                   */
/*       S01408 - Addition of core hook MEC0890INT                   */
/*       S01408 - Addition of core hook MEC0890001                   */
/*                Addition of core hook MEC0890002                   */
/*       044474 - Only let ME0890 for new messages not updates       */
/*       046121 - Convert date to date format for the job, as this   */
/*                may differ from the system date format             */
/*       043202 - Use different printer file if Close of Business    */
/*       E40242 - Created to produce message generation audit list   */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&MODID &JTYPE &CJRN &SDATE &STIME)
 
/*                                                           */
/*/COPY WNCPYSRC,MEC0890INT                                  */       /*S01408*/
/*                                                           */
             DCL        VAR(&MODID)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&JTYPE)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&CJRN)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDATE)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&STIME)  TYPE(*CHAR) LEN(6)
             DCL        VAR(&JNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JUSER)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&JNUM)   TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM)    TYPE(*CHAR) LEN(50)
             DCL        VAR(&U7U8)   TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR) LEN(1)                         */ /*043202 CCB020*/
             DCL        VAR(&COBST)  TYPE(*CHAR) LEN(4)                                   /*CCB020*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/*/COPY WNCPYSRC,MEC0890018                                          */
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/*/COPY WNCPYSRC,MEC0890004                                          */
 
/* Global monitor message */
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ERROR)
/*/COPY WNCPYSRC,MEC0890012                                          */
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
/* Retrieve job name/user/number to pass to called program ME0890 */
             RTVJOBA    JOB(&JNAME) USER(&JUSER) NBR(&JNUM)
 
             SNDPGMMSG  MSG('Message Generation audit report +
                          running') TOMSGQ(MRUNQ)
 
/* Set-off Data Base Error Switches */
/* (Variable used instead of switches to avoid resetting the */
/*  value of the switches from previous programs) */
             CHGVAR     VAR(&U7U8) VALUE('NN')
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*043202 CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/*/COPY WNCPYSRC,MEC0890017                                          */
 
/* Clear extract file data from previous run */
             CLRPFM     FILE(MGJREFPD)
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000)
/*/COPY WNCPYSRC,MEC0890005                                          */
 
/* Ensure that the temporary file does not already exist */
             DLTF       FILE(QTEMP/OUTFILE)
             MONMSG  MSGID(CPF0000 RPG0000 MCH0000)
/* */                                                                /*046121*/
/** Ensure that the date is in the format specified for the job,  */ /*046121*/
/** rather than the system date format.                           */ /*046121*/
/* */                                                                /*046121*/
             CVTDAT     DATE(&SDATE) TOVAR(&SDATE) FROMFMT(*SYSVAL) +
                          TOFMT(*JOB) TOSEP(*NONE)                   /*046121*/
 
/*                                                                      CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),            CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/*                                                                      CCB009*/
/*  Change the name of the journal to 'ICJRN' because  all              CCB009*/
/*  files are journaled to it.                                          CCB009*/
/*                                                                      CCB009*/
             CHGVAR     VAR(&CJRN) VALUE('ICJRN')                     /*CCB009*/
             ENDDO                                                    /*CCB009*/
/* Extract details of all messages generated by this job */
/************DSPJRN     JRN(&CJRN) FILE((*LIBL/MGOREFPD *ALL)) +  */ /*044474*/
/************             FROMTIME(&SDATE &STIME) ENTTYP(UP PT) + */ /*044474*/
/************             JOB(&JNUM/&JUSER/&JNAME) ENTDTALEN(407)+*/ /*044474*/
/************             OUTPUT(*OUTFILE) OUTFILE(QTEMP/OUTFILE) */ /*044474*/
/*/COPY WNCPYSRC,MEC0890010                                          */
/************DSPJRN     JRN(&CJRN) FILE((*LIBL/MGOREFPD *ALL)) +                          /*CRN001*/
/************                FROMTIME(&SDATE &STIME) ENTTYP(PT) +                         /*CRN001*/
/************                JOB(&JNUM/&JUSER/&JNAME) +                                   /*CRN001*/
/************                OUTPUT(*OUTFILE) OUTFILE(QTEMP/OUTFILE)                      /*CRN001*/
/************                ENTDTALEN(407)              /*044474*/                       /*CRN001*/
             DSPJRN     JRN(&CJRN) FILE((*LIBL/MGOREFPD *ALL)) +
                             FROMTIME(&SDATE &STIME) ENTTYP(PT) +
                             JOB(&JNUM/&JUSER/&JNAME) +
                             OUTPUT(*OUTFILE) OUTFILE(QTEMP/OUTFILE) +
                             ENTDTALEN(557)                                               /*CRN001*/
/*/COPY WNCPYSRC,MEC0890011                                          */
             MONMSG  MSGID(CPF7062)
/*/COPY WNCPYSRC,MEC0890013                                          */
 
/* Copy DSPJRN outfile to message generation extract file */
/* (The data cannot be written directly using the DSPJRN   */
/*  command as the format of MGJREFPD is not the same as  */
/*  the format of the system defined outfile)             */
             CPYF       FROMFILE(QTEMP/OUTFILE) TOFILE(MGJREFPD) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
/*/COPY WNCPYSRC,MEC0890006                                          */
 
/* Over-ride database file MGJREFPD */
             OVRDBF     FILE(MGJREFPD) SHARE(*NO)
 
/* Create Data Queue to enable formatting program ME0800 */
/* to pass formatted messages to print program ME0890    */
             DLTDTAQ    DTAQ(QTEMP/MEDTQPRT)
             MONMSG     MSGID(CPF0000)
             CRTDTAQ    DTAQ(QTEMP/MEDTQPRT) MAXLEN(125)
/**/                                                                 /*043202*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*043202 CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
/*/COPY WNCPYSRC,MEC0890008                                          */
             OVRPRTF    FILE(ME0890P1) TOFILE(ME0890P2)              /*043202*/
             MONMSG     CPF0000                                      /*043202*/
             ENDDO                                                   /*043202*/
/* */                                                                /*S01408*/
/*/COPY WNCPYSRC,MEC0890001                                      */  /*S01408*/
/* */                                                                /*S01408*/
 
/* Call ME0890 to format and print all messages generated      */
/* Parameters are Module ID, job type, Job name/user/number    */
/* and sequence number, level and entity for RCF processing    */
/* */                                                                /*044474*/
             OVRDBF     FILE(MGJREFL0) TOFILE(MGJREFL1)              /*044474*/
/*/COPY WNCPYSRC,MEC0890009                                          */
             CALL       PGM(ME0890) PARM(&MODID &JTYPE &JNAME &JUSER +
                          &JNUM '     ' 'B' 'ALL' &U7U8)
/* */                                                                /*S01408*/
/*/COPY WNCPYSRC,MEC0890002                                      */  /*S01408*/
/* */                                                                /*S01408*/
             DLTOVR     FILE(MGJREFL0)                               /*044474*/
/*/COPY WNCPYSRC,MEC0890019                                          */
/**/                                                                 /*043202*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*043202 CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
/*/COPY WNCPYSRC,MEC0890007                                          */
             DLTOVR     FILE(ME0890P1)                               /*043202*/
             MONMSG     CPF0000                                      /*043202*/
             ENDDO                                                   /*043202*/
/* */                                                                /*S01408*/
/*/COPY WNCPYSRC,MEC0890003                                      */  /*S01408*/
/* */                                                                /*S01408*/
 
/* If database error detected recover data from LDA and send   */
/* message to MOPERQ                                           */
             IF         COND(&U7U8 *EQ 'YY') THEN(DO)
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                 SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOMSGQ(MOPERQ)
                 CHGJOB     SWS(XXXXXX11)
                 GOTO ERROR
             ENDDO
 
/*/COPY WNCPYSRC,MEC0890014                                          */
             GOTO END
 
 ERROR:      CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Message Generation Audit Report ENDED +
                        ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG MSGID(CPF0000 MCH0000)
/*/COPY WNCPYSRC,MEC0890015                                          */
 
/* Close file MGJREFPD */
 END:                                                                                    /*BUG6604*/
/***END:*****   RCLRSC                                                                   /*BUG6604*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,MEC0890016                                          */
 
             ENDPGM
