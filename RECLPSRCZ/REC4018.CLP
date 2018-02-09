/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE T&N Accounts - Account code check')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       REC4018 - Midas Retail Term & Notice Account Code Check     */
/*                                                                   */
/*       Function:  This program reads through SDACD1PD to find out  */
/*       (COB)      which account codes are Term & Notice account    */
/*                  codes. In the process it checks the Period and   */
/*                  Penalty Details file REPRPNPD to see if there are*/
/*                  accounts there which should not be (on account of*/
/*                  account code) or accounts which need to be       */
/*                  created.                                         */
/*                  This component runs in one of four modes:        */
/*                      *CRTDLT, *CREATE, *DELETE, *AUDIT            */
/*                  In *CREATE and *CRTDLT modes it will create any  */
/*                  missing period and penalty details on REPRPNPD.  */
/*                  In *DELETE and *CRTDLT modes it will delete any  */
/*                  period and penalty details if it finds that the  */
/*                  account code is not term and notice. In audit    */
/*                  mode it will simply report without making the    */
/*                  changes. The report is output to RE4018P1.       */
/*                                                                   */
/*       (c) Finastra International Limited 2009                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      231583             Date 18Dec09              */
/*                      CCB009             Date 18Dec09              */
/*                      217717             Date 18Dec09              */
/*                      170465             Date 18Dec09              */
/*                      CRE015 *CREATE     Date 18Dec09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       231583 - Sys incorrectly changed interest rate              */
/*       CCB009 - COB Journaling                                     */
/*       217717 - Allow rates processing with or without             */
/*                 threshold rate.                                   */
/*       170465 - Component GLC2550 on msg wait in COB.              */
/*       CRE015 - Retail Term and Notice Accounts                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &MODE)
/**/
/* Declare variables */
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(7)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          DMLIB   ')
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10) VALUE('  +
                          JLIB    ')
             DCL        VAR(&CMTCTL) TYPE(*CHAR) LEN(1)
/**********  DCL        VAR(&MPHAS)  TYPE(*CHAR)  LEN(1)                               */ /*CCB020*/
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2009')
/*                                                                                        /*CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature***/                       /*CCB009 CCB020*/
/*                                                                                        /*CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                         */ /*CCB009 CCB020*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                        */ /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/* Declare job name, user and number for remove journal changes    */                     /*CCB009*/
/**/                                                                                      /*CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)                               /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)                               /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)                                /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)                                /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                  /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                                 /*CCB009*/
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/**/                                                                                      /*217717*/
/**Determine*phase*of*system**/                                                    /*217717 CCB020*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*217717 CCB020*/
                                                                                          /*217717*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
             IF         COND((&BUSY = 'N') *OR (&BUSY = 'P')) THEN(DO)
                CHGVAR     VAR(&BUSY) VALUE('P')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
                CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
             ENDDO
/**********  ENDDO                                                                     */ /*CCB020*/
/*                                                                                          CCB009*/
/***Check*for*Switchable*feature*CCB009.***/                                       /*CCB009 CCB020*/
/*                                                                                          CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                         */ /*CCB020*/
/**********               'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* Send Message to MRUNQ */
/**/
             SNDPGMMSG  MSG('REC4018 Midas RE Term & Notice +
                          synchronise Accounts and Term and Notice +
                          Files') TOMSGQ(MRUNQ)
/**/
/**Determine phase of system */                                                           /*217717*/
/*********** RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                                      /*217717*/
                                                                                          /*217717*/
/**/
/* Format library Names */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(&SYSID)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
/**Make*sure*nothing*else*is*updating*these*files**/                                      /*CCB020*/
/**...only*in*COB,*so*any*rollback*is*not*problematic**/                                  /*CCB020*/
/**/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*231583 CCB020*/
             ALCOBJ     OBJ((ACCNTAB *FILE *EXCLRD))
             ALCOBJ     OBJ((REPRPNPD *FILE *EXCLRD))
/**********  ENDDO                                                              */ /*231583 CCB020*/
/**/
/***CREATE*JRNRCV*WITH*AUTHORITY**PUBLIC**ALL*IN*CASE*COMP'T*ENDS***/                     /*CCB020*/
/***AND*IS*RESTARTED*BY*A*DIFFERENT*USER*WHO*MAY*REQUIRE*AUTHORITY**/                     /*CCB020*/
/***TO*DELETE*THIS*JOURNAL*RECEIVER**/                                                    /*CCB020*/
/**/
/**LOOP1:**/                                                                              /*CCB020*/
/**/                                                                                      /*CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/               /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
 
/**********  CRTJRNRCV  JRNRCV(&JLIB/JREC401801) THRESHOLD(1919999) +                  */ /*CCB020*/
/**********               TEXT('Temporary journal for T&N pgm +                        */ /*CCB020*/
/**********               REC4018')                                             */ /*170465 CCB020*/
/**********  MONMSG     MSGID(CPF7010) EXEC(DO)                                        */ /*CCB020*/
/**/
/**********  DLTJRN     JRN(&JLIB/JREC4018)                                            */ /*CCB020*/
/**********  MONMSG     MSGID(CPF2105)                                                 */ /*CCB020*/
/**/
/**CANNOT*MONITOR*FOR*CPA*MSGS.*BUT*MUST*ENSURE*JOB*TAKES*DEFAULT****/                    /*CCB020*/
/**REPLY*FOR*MESSAGE*CPA7025,*(DELETE*ISSUED*WITHOUT*FULL*SAVE.)*****/                    /*CCB020*/
/**/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CCB020*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JREC4018*)                                        */ /*CCB020*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CCB020*/
/**********  CHGVAR     VAR(&BUSY) VALUE('N')                                          */ /*CCB020*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)                            */ /*CCB020*/
/**/
/**********  GOTO       CMDLBL(LOOP1)                                                  */ /*CCB020*/
/**/
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
/***CREATE*JOURNAL*WITH*AUTHORITY**PUBLIC**ALL*IN*CASE*COB*ENDS*****/                     /*CCB020*/
/***AND*IS*RESTARTED*BY*A*DIFFERENT*USER*WHO*MAY*REQUIRE*AUTHORITY**/                     /*CCB020*/
/***TO*DELETE*THIS*JOURNAL***/                                                            /*CCB020*/
/**/
/**LOOP2:**/
/**********  CRTJRN     JRN(&JLIB/JREC4018) JRNRCV(&JLIB/JREC401801) +                 */ /*CCB020*/
/**********               MNGRCV(*SYSTEM) TEXT('Journal for T&N pgm +                  */ /*CCB020*/
/**********               REC4018') AUT(*ALL)                                          */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7010 CPF7015) EXEC(DO)                                */ /*CCB020*/
/**********  DLTJRN     JRN(&JLIB/JREC4018)                                            */ /*CCB020*/
/**********  GOTO       CMDLBL(LOOP2)                                                  */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
RETRY:
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
 /**/
/**********  STRJRNPF   FILE(RCHGR1 RCHGR2 RCHGR3) +                                   */ /*CCB020*/
/**********               JRN(JREC4018) IMAGES(*BOTH) OMTJRNE(*OPNCLO)                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 /**/
/**********  STRJRNPF   FILE(ACCNTAB) JRN(JREC4018) IMAGES(*BOTH) +                    */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 /**/
/**********  STRJRNPF   FILE(REPRPNPD) JRN(JREC4018) IMAGES(*BOTH) +                   */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 /**/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ELSE       CMD(DO)                                                        */ /*CCB020*/
/**********  STRJRNPF   FILE(RCHGR1 RCHGR2 RCHGR3) JRN(ICJRN) +                        */ /*CCB020*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 /**/
/**********  STRJRNPF   FILE(ACCNTAB) JRN(ICJRN) IMAGES(*BOTH) +                       */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
/**/
/**********  STRJRNPF   FILE(REPRPNPD) JRN(ICJRN) IMAGES(*BOTH) +                      */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
/**/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
             GOTO       CMDLBL(BYPASS)
/**/
JRNFAIL:
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *LE 3) THEN(DO)
             DLYJOB     DLY(60)
             GOTO       CMDLBL(RETRY)
             ENDDO
             ELSE       CMD(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
BYPASS:
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))
/**/
 /* SYCHRONISE ACCNTAB AND REPRPNPD  */
 /* (NOTE: RE4018 CAN BE BYPASSED) */
/**/
             CALL       PGM(RE4018) PARM(&MODE)
/**/
/* Reset restart flag and clear SAVF if run succesful */
/**/
ERROR:
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
 
/**/
/* Database Error has occurred */
/**/
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
/**/                                                                                      /*CCB009*/
/**If*Feature*CCB009*is*'on'*(close*of*business*journaling),********/              /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/**********  IF         COND(&CCB009 *EQ '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                         */                     /*CCB009*/
/**/                                                                                      /*CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)                          /*CCB009*/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)
             CHGVAR     VAR(&CB0180DA) VALUE('I/C')
             ENDDO
/**/                                                                                      /*CCB009*/
/* If data area is not blank, calculate the job name, user and no. */                     /*CCB009*/
/* of the previous run of this component.                                                 /*CCB009*/
/**/                                                                                      /*CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)                                  /*CCB009*/
/**/                                                                                      /*CCB009*/
             IF         COND(&CB0180DA *NE 'I/C') THEN(DO)                                /*CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))                       /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))                      /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))                       /*CCB009*/
             ENDDO
/**/                                                                                      /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */                     /*CCB009*/
/*  for the specific job.                                          */                     /*CCB009*/
/**/                                                                                      /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                                               /*CCB009*/
/**/                                                                                      /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                   /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                                              /*CCB009*/
             ENDDO
/**/                                                                                      /*CCB009*/
/*  Retrieve the first journal entry sequence number               */                     /*CCB009*/
/*  for the specific job.                                          */                     /*CCB009*/
/**/                                                                                      /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)                                              /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                   /*CCB009*/
             CHGVAR     VAR(&FINISH) VALUE(0)                                             /*CCB009*/
             ENDDO
/**/                                                                                      /*CCB009*/
/*  Remove journaled changes.                                      */                     /*CCB009*/
/**/                                                                                      /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                        /*CCB009*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*231583 CCB020*/
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB) (RCHGR1) (RCHGR2) +
                          (REPRPNPD)) FROMENT(&START) +
                          TOENT(&FINISH)                                                  /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                            /*CCB009*/
/**********  ENDDO                                                              */ /*231583 CCB020*/
             ENDDO
             ENDDO
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ELSE       CMD(DO)                                                 */ /*CCB009 CCB020*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
/**********  RMVJRNCHG  JRN(JREC4018) FILE((*ALL))                                     */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                                  */ /*CCB009 CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
                   CHGJOB     INQMSGRPY(*RQD)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/* Abnormal termination processing                       */
/**/
 ABNOR:
 /* Rollback the changes */
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**********  ENDDO                                                                     */ /*CCB020*/
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program REC4018 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
 
/**/                                                                                      /*CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/               /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JREC4018)                                       */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  ENDJRNPF   FILE(RCHGR1 RCHGR2 RCHGR3) JRN(ICJRN)                          */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**/
/**********  DLTJRN     JRN(&JLIB/JREC4018)                                            */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JREC4018*)                                        */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
/* Remove job locks */
/**/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*231583 CCB020*/
             DLCOBJ     OBJ((ACCNTAB *FILE *EXCLRD))
             DLCOBJ     OBJ((REPRPNPD *FILE *EXCLRD))
/**********  ENDDO                                                              */ /*231583 CCB020*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2009')
             ENDPGM
