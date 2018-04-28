/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE T&N Rate Changes at rollover')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail T&N Accounts                                 */
/*                                                                   */
/*       REC4016 - Midas RE T&N Rate Changes at rollover             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2009           */
/*                                                                   */
/*       Last Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. 231583             Date 18Dec09              */
/*                      230355             Date 18Dec09              */
/*                      CCB009             Date 18Dec09              */
/*                      217717             Date 18Dec09              */
/*                      170465             Date 18Dec09              */
/*                      CRE015 *CREATE     Date 18Dec09              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       231583  - Enhancements to running program in input cycle    */
/*                 Note this program should only be run in input     */
/*                 cycle if a catch-up or correction is required or  */
/*                 audit mode.                                       */
/*                 Also added additional report RE4016P to display   */
/*                 rate changes.                                     */
/*       230355  - RECOMPILE OVER CHANGED REPRPNPD.                  */
/*       CCB009  - COB Journaling                                    */
/*       217717  - Allow rates processing with or without            */
/*                 threshold rate.                                   */
/*       170465  - Component GLC2550 on msg wait in COB.             */
/*       CRE015  - Retail Term and Notice Accounts                   */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &MODE &STADATE &ENDDATE)                         /*217717*/
/**/
/* Declare Variables */
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(5)                                     /*217717*/
             DCL        VAR(&STADATE) TYPE(*CHAR) LEN(5)                                  /*217717*/
             DCL        VAR(&ENDDATE) TYPE(*CHAR) LEN(5)                                  /*217717*/
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
                          Misys International Banking Systems Ltd. +
                          2009')
/**/                                                                                      /*CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature***/                       /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
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
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/**/                                                                                      /*217717*/
/* Determine phase of system */                                                           /*217717*/
/**/                                                                                      /*217717*/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)                            */ /*217717 CCB020*/
                                                                                          /*217717*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                     /*CCB020*/
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
             IF         COND((&BUSY = 'N') *OR (&BUSY = 'P')) THEN(DO)
                CHGVAR     VAR(&BUSY) VALUE('P')
                CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
                CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
             ENDDO
/**********  ENDDO                                                                        /*CCB020*/
/**/                                                                                      /*CCB009*/
/***Check*for*switchable*feature*CCB009.***/                                       /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                         */ /*CCB020*/
/**********               'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
 
             CHGJOB     SWS(XXXXXX00)
 
/**/
/* Send message to MRUNQ */
/**/
             SNDPGMMSG  MSG('REC4016 Midas RE Term & Notice  rate +
                          changes at rollover') TOMSGQ(MRUNQ)
/**/
/* Format library names */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SST(&DMLIB 1 2)) VALUE(&SYSID)
             CHGVAR     VAR(%SST(&JLIB 1 2)) VALUE(&SYSID)
 
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                           VALUE(' ')
              MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
              CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
 /* Make sure nothing else is updating these files */
 /* ...Only in COB, so any rollback is not problematic */
/**/
/**********   IF         COND(&MPHAS *NE 'A') THEN(DO)                          */ /*231583 CCB020*/
              ALCOBJ     OBJ((ACCNTAB *FILE *EXCLRD))
              ALCOBJ     OBJ((RERCHHPA *FILE *EXCLRD))
              ALCOBJ     OBJ((RERCH1PD *FILE *EXCLRD))
              ALCOBJ     OBJ((RERCH2PD *FILE *EXCLRD))
              ALCOBJ     OBJ((RERCH3PD *FILE *EXCLRD))
              ALCOBJ     OBJ((REIACA *FILE *EXCLRD))
              ALCOBJ     OBJ((REIACD *FILE *EXCLRD))
              ALCOBJ     OBJ((REIACZ *FILE *EXCLRD))
              ALCOBJ     OBJ((REPRPNPD *FILE *EXCLRD))
/**********   ENDDO                                                             */ /*231583 CCB020*/
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
 
/**********  CRTJRNRCV  JRNRCV(&JLIB/JREC401601) THRESHOLD(1919999) +                  */ /*CCB020*/
/**********               TEXT('Temporary journal for T&N pgm +                        */ /*CCB020*/
/**********               REC4016')                                             */ /*170465 CCB020*/
/**********  MONMSG     MSGID(CPF7010) EXEC(DO)                                        */ /*CCB020*/
 
/**********  DLTJRN     JRN(&JLIB/JREC4016)                                            */ /*CCB020*/
/**********  MONMSG     MSGID(CPF2105)                                                 */ /*CCB020*/
/**/
/**CANNOT*MONITOR*FOR*CPA*MSGS.*BUT*MUST*ENSURE*JOB*TAKES*DEFAULT****/                    /*CCB020*/
/**REPLY*FOR*MESSAGE*CPA7025,*(DELETE*ISSUED*WITHOUT*FULL*SAVE.)*****/                    /*CCB020*/
/**/
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CCB020*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JREC4016*)                                        */ /*CCB020*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CCB020*/
/**********  CHGVAR     VAR(&BUSY) VALUE('N')                                          */ /*CCB020*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)                            */ /*CCB020*/
 
/**********  GOTO       CMDLBL(LOOP1)                                                  */ /*CCB020*/
 
/**********  ENDDO                                                                     */ /*CCB020*/
/**/
/***CREATE*JOURNAL*WITH*AUTHORITY**PUBLIC**ALL*IN*CASE*COB*ENDS*****/                     /*CCB020*/
/***AND*IS*RESTARTED*BY*A*DIFFERENT*USER*WHO*MAY*REQUIRE*AUTHORITY**/                     /*CCB020*/
/***TO*DELETE*THIS*JOURNAL***/                                                            /*CCB020*/
/**/
/**LOOP2:**/                                                                              /*CCB020*/
/**********  CRTJRN     JRN(&JLIB/JREC4016) JRNRCV(&JLIB/JREC401601) +                 */ /*CCB020*/
/**********               MNGRCV(*SYSTEM) TEXT('Journal for T&N pgm +                  */ /*CCB020*/
/**********               REC4016') AUT(*ALL)                                          */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7010 CPF7015) EXEC(DO)                                */ /*CCB020*/
/**********  DLTJRN     JRN(&JLIB/JREC4016)                                            */ /*CCB020*/
/**********  GOTO       CMDLBL(LOOP2)                                                  */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**********  ENDDO                                                                     */ /*CCB020*/
 
RETRY:
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
 
/**********  STRJRNPF   FILE(RCHGR1 RCHGR2 RCHGR3) +                                   */ /*CCB020*/
/**********               JRN(JREC4016) IMAGES(*BOTH) OMTJRNE(*OPNCLO)                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(ACCNTAB) JRN(JREC4016) IMAGES(*BOTH) +                    */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(REIACA REIACD REIACZ) JRN(JREC4016) +                     */ /*CCB020*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(REPRPNPD) JRN(JREC4016) IMAGES(*BOTH) +                   */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(RERCHHPA RERCH1PD RERCH2PD RERCH3PD) +                    */ /*CCB020*/
/**********               JRN(JREC4016) IMAGES(*BOTH) OMTJRNE(*OPNCLO)                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ELSE       CMD(DO)                                                        */ /*CCB020*/
/**********  STRJRNPF   FILE(RCHGR1 RCHGR2 RCHGR3) JRN(ICJRN) +                        */ /*CCB020*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(ACCNTAB) JRN(ICJRN) IMAGES(*BOTH) +                       */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(REIACA REIACD REIACZ) JRN(ICJRN) +                        */ /*CCB020*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                               */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(REPRPNPD) JRN(ICJRN) IMAGES(*BOTH) +                      */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                             */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  STRJRNPF   FILE(RERCHHPA RERCH1PD RERCH2PD RERCH3PD) +                    */ /*CCB020*/
/**********               JRN(ICJRN) IMAGES(*BOTH) OMTJRNE(*OPNCLO)                    */ /*CCB020*/
/**********  MONMSG     MSGID(CPF7030)                                                 */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(JRNFAIL))                      */ /*CCB020*/
 
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
             GOTO       CMDLBL(BYPASS)
 
JRNFAIL:
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             IF         COND(&COUNT *LE 3) THEN(DO)
             DLYJOB     DLY(60)
             GOTO       CMDLBL(RETRY)
             ENDDO
             ELSE       CMD(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
BYPASS:
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
             MONMSG     MSGID(CPF8351) EXEC(CHGVAR VAR(&CMTCTL) +
                          VALUE('Y'))
/**/
/* CLEAR AUDIT FILE */
/**/
             CLRPFM REPPA1PD
             CLRPFM REPPA2PD
             CALL       PGM(RE4016) PARM(&STADATE &ENDDATE ' ' +
                          &MODE)                                                          /*217717*/
/**/
/* Reset restart flag and clear SAVF if run succesful */
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/                                                                                      /*231583*/
/* Run a report of the output. (Note if this report program fails, can bypass)*/          /*231583*/
/**/                                                                                      /*231583*/
             CALL       PGM(RE4016P) PARM('AUTO')                                         /*231583*/
             IF COND(*NOT %SWITCH(XXXXXX00)) THEN(GOTO ABNOR)                             /*231583*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*231583 CCB020*/
                 ALCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
                 RTVDTAARA  DTAARA(RESTAT) RTNVAR(&RESTAT)
                 IF         COND(%SWITCH(XX1XXXXX)) THEN(CHGVAR +
                            VAR(%SST(&RESTAT 23 1)) VALUE('Y'))
                 CHGVAR     VAR(&BUSY) VALUE('O')
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
                 CHGDTAARA  DTAARA(RESTAT) VALUE(&RESTAT)
                 DLCOBJ     OBJ((RESTAT *DTAARA *EXCLRD))
/**********   ENDDO                                                             */ /*231583 CCB020*/
              ENDDO
 
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
                          (REIACA) (REIACD) (REIACZ) (REPRPNPD) +
                          (RERCHHPA) (RERCH1PD) (RERCH2PD) +
                          (RERCH3PD)) FROMENT(&START) +
                          TOENT(&FINISH)                                                  /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                            /*CCB009*/
/**********  ENDDO                                                              */ /*231583 CCB020*/
             ENDDO
             ENDDO
/**********  ENDDO                                                              */ /*CCB009 CCB020*/
/**********  ELSE       CMD(DO)                                                 */ /*CCB009 CCB020*/
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
/**********  RMVJRNCHG  JRN(JREC4016) FILE((*ALL))                                     */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                                  */ /*CCB009 CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
                   CHGJOB     INQMSGRPY(*RQD)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
/**/
/* Abnormal termination processing                       */
/**/
 ABNOR:
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                                  */ /*CCB020*/
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
/**********  ENDDO                                                                     */ /*CCB020*/
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Program REC4016 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 END:
/**/
/* Changes should be commited, but rollback just in case there are +
   some uncommitted changes */
/**/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             IF         COND(&CMTCTL *NE 'Y') THEN(DO)
             ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
 
/**/                                                                                      /*CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),***/               /*CCB009 CCB020*/
/**/                                                                                      /*CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**********  ENDJRNPF   FILE(*ALL) JRN(JREC4016)                                       */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  ENDJRNPF   FILE(RCHGR1 RCHGR2 RCHGR3) JRN(ICJRN)                          */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
 
/**********  DLTJRN     JRN(&JLIB/JREC4016)                                            */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
 
/**********  CHGJOB     INQMSGRPY(*DFT)                                                */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  DLTJRNRCV  JRNRCV(&JLIB/JREC4016*)                                        */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  CHGJOB     INQMSGRPY(*RQD)                                                */ /*CCB020*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                                 */ /*CCB020*/
/**********  ENDDO                                                                     */ /*CCB020*/
 
/**********  IF         COND(&MPHAS *NE 'A') THEN(DO)                           */ /*231583 CCB020*/
             DLCOBJ     OBJ((ACCNTAB *FILE *EXCLRD))
             DLCOBJ     OBJ((RERCHHPA *FILE *EXCLRD))
             DLCOBJ     OBJ((RERCH1PD *FILE *EXCLRD))
             DLCOBJ     OBJ((RERCH2PD *FILE *EXCLRD))
             DLCOBJ     OBJ((RERCH3PD *FILE *EXCLRD))
             DLCOBJ     OBJ((REIACA *FILE *EXCLRD))
             DLCOBJ     OBJ((REIACD *FILE *EXCLRD))
             DLCOBJ     OBJ((REIACZ *FILE *EXCLRD))
             DLCOBJ     OBJ((REPRPNPD *FILE *EXCLRD))
/**********  ENDDO                                                              */ /*231583 CCB020*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2009')
             ENDPGM
