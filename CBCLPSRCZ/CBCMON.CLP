/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas CB Close of business monitor control')          */
/*********************************************************************/
/*                                                                   */
/*  Midas - Close of Business Processing                             */
/*                                                                   */
/*  CBCMON - CLOSE OF BUSINESS MONITOR CL                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CCB021             Date 06Aug12              */
/*       Prev Amend No. CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*                      146520             Date 05Dec06              */
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CSC023             Date 29Jan04              */
/*                      CCB012             Date 31May03              */
/*                      CPK014             Date 14Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      196122             Date 10Aug01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      110242             DATE 07NOV96              */
/*                      102568             DATE 18APR96              */
/*                      101260             DATE 08MAR96              */
/*                      099150             DATE 02FEB96              */
/*                      095122             DATE 26OCT95              */
/*                      091688             DATE 10AUG95              */
/*                      083886             DATE 20FEB95              */
/*                      078097             DATE 25OCT94              */
/*                      S01408             DATE 04MAY95              */
/*                      037613             DATE 11AUG94              */
/*                      S01491             DATE 01OCT94              */
/*                      S01495             DATE 01OCT94              */
/*                      070107             DATE 29APR94              */
/*                      055670             DATE 21FEB93              */
/*                      S01463             DATE 11FEB94              */
/*                      055744             DATE 13DEC93              */
/*                      034909             DATE 06NOV93              */
/*                      E38772             DATE 24APR92              */
/*                      E28730             DATE 20SEP91              */
/*                      LN0911             DATE 25OCT90              */
/*                      LN0420             DATE 25JUN90              */
/*                      LN0001             DATE 26APR90              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CCB021 - COB Restructure - Non Working Day COB              */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       146520 - RCF MONITOR Not working all the time. This fix     */
/*                clears the 'T' in FCDTAQ which forcing FC0100      */
/*                to close down.                                     */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CCB012 - Journaling options for high availability.  Make    */
/*                CBJRN redundant.                                   */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       196122 - Authority for CBJRN change to *LIBCRTAUT           */
/*       CCB009 - Journal files throughout close of business         */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       102568 - RTVJOBD is not an IBM command and has been         */
/*                replaced with an API.                              */
/*       101260 - Use job description user for Scheduler on SBMJOB   */
/*       099150 - Change routing entry for scheduler submit.         */
/*       095122 - In some circumstances the attention key stops      */
/*                working.  There is no good reason for this.  Fix   */
/*                is to remove the "SETATNPGM (*OFF)" line.          */
/*       091688 - Rename the CBC0010 job to COBSCHED for ease        */
/*                of identification.                                 */
/*       083886 - Produce dump if program terminates abnormally.     */
/*       078097 - IF DATA QUEUE CBDTQD IS LOCKED WHEN PGM DOES A     */
/*                QRCVDTAQ, PGM SHOULD RETRY BEFORE TERMINATING.     */
/*       S01408 - Addition of core hook CBCMONMP1                    */
/*       037613 - CHANGE PROGRAM SO THAT MONITOR SCREEN IS REFRESHED */
/*                AT LEAST EVERY 15 SECONDS.                         */
/*       S01491 - Autocall.                                          */
/*       S01495 - COB enhancements.                                  */
/*       070107 - Add new monitor message to CRTJRN for V2.3 of the  */
/*                operating system.                                  */
/*       055670 - Move set-up of DTAARA/CBRUN to CBRUN to prevent    */
/*                errors in complete components count on restart.    */
/*       S01463 - Rename FCC0401 job to RCFMONITOR.                  */
/*       055744 - Do not set scheduler status to 'N' if scheduler is */
/*                still active                                       */
/*                Allocate the data area MONCHK while the monitor is */
/*                running                                            */
/*       034909 - COB screen counter includes the COBBEGIN and       */
/*                COBEND components. These should not be included.   */
/*       E38772 - Start the journalling of RCF files in this program */
/*                and not in FCC0401 as it can cause locking         */
/*                problems with the first COB components if run in   */
/*                FCC0401.                                           */
/*       E28730 - ADD COUNTER TO COB SCREEN                          */
/*       LN0911 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.            */
/*       LN0420 - SUBMIT COB SCHEDULER TO MEODQ TO REMOVE PROBLEM    */
/*                RESTART AFTER MONITOR FAILURE AND ADD              */
/*                INFORMATION MESSAGES ON RESTART                    */
/*       LN0001 - REMOVE READ TO COB ICD FILE TO REMOVE PROBLEM      */
/*                OF OPEN FILE AND  LOCKING                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&ERROR &JOB)
/**/
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERRCB0170) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COBSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCHSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT)  TYPE(*DEC) LEN(2)
             DCL        VAR(&DTQALEN)  TYPE(*DEC) LEN(5) VALUE(16)
             DCL        VAR(&DTQBLEN)  TYPE(*DEC) LEN(5) VALUE(8)
             DCL        VAR(&DTQDLEN)  TYPE(*DEC) LEN(5) VALUE(86)
/************DCL        VAR(&WAIT)  TYPE(*DEC) LEN(5) VALUE(-1) */    /*037613*/
             DCL        VAR(&WAIT)  TYPE(*DEC) LEN(5) VALUE(15)       /*037613*/
             DCL        VAR(&MSGA) TYPE(*CHAR) LEN(16) +
                          VALUE('COBBEGIN  00001C')
             DCL        VAR(&MSGB) TYPE(*CHAR) LEN(8) VALUE('STREAM  ')
             DCL        VAR(&MSGD) TYPE(*CHAR) LEN(86)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&DOMNASA)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&NOAS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6) VALUE('  JLIB')
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)                          */ /*S01495 CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(10)           */            /*101260*/ /*CCB021*/
             DCL        VAR(&DTQFCLN) TYPE(*DEC) LEN(5) VALUE(1)      /*146520*/
             DCL        VAR(&MSGDFC) TYPE(*CHAR) LEN(1)               /*146520*/
/* */                                                                 /*102568*/
/* Define variables for API call */                                   /*102568*/
/* */                                                                 /*102568*/
/**********  DCL        VAR(&RTN_BIN) TYPE(*CHAR) LEN(4)                       /*102568*/ /*CCB021*/
/**********  DCL        VAR(&RTN_INFO) TYPE(*CHAR) LEN(512)                    /*102568*/ /*CCB021*/
/**********  DCL        VAR(&ERROR2) TYPE(*CHAR) LEN(512)                      /*102568*/ /*CCB021*/
/**********  DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('JOBD0100')                 */                 /*102568*/ /*CCB021*/
/**********  DCL        VAR(&JOBD) TYPE(*CHAR) LEN(20) +
                          VALUE('MEODD     *LIBL     ')     */                 /*102568*/ /*CCB021*/
/* */                                                                 /*102568*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*S01491*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                  /*S01491*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)             /*S01491*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*S01491*/
             DCL        VAR(&S01491) TYPE(*CHAR) LEN(1) VALUE('N')    /*S01491*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&DOMNAS) TYPE(*DEC) LEN(2)          /*LN0001*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(1 0)         /*078097*/
/*                                                                      CCB009*/
/**Declare*variable*CCB009*-*flag*for*switchable*feature************/              /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)                         */ /*CCB009 CCB020*/
/**********  DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                        */ /*CCB009 CCB020*/
/*********** DCLF       FILE(SDCOBPPD) RCDFMT(SDCOBPD0)          *LN0001*/
/**/
/*/COPY WNCPYSRC,CBH00002                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                      CCB009*/
/***Check*for*Switchable*feature*CCB009.****************************/              /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +                         */ /*CCB020*/
/**********               'CCB009' &AOFMT)                                      */ /*CCB009 CCB020*/
/*/COPY WNCPYSRC,CBH00003                                            */
/**/                                                                  /*S01491*/
/* Determine if SAR S01491 (Autocall) is switched ON */               /*S01491*/
/**/                                                                  /*S01491*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*S01491*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*S01491*/
             CHGVAR     VAR(&SAR) VALUE('S01491')                     /*S01491*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)  /*S01491*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&S01491) VALUE('Y'))                    /*S01491*/
/* */
/** Check if the monitor is already active                        */ /*055744*/
/* */
             ALCOBJ     OBJ((MONCHK *DTAARA *EXCL)) WAIT(5)          /*055744*/
             MONMSG     MSGID(CPF1002) EXEC(DO)                      /*055744*/
                 SNDPGMMSG  MSG('CBCMON - COB MONITOR +
                            IS ALREADY ACTIVE') +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*055744*/
                            CHGJOB SWS(XXXXXX11)                     /*055744*/
                            CHGVAR VAR(&ERROR) VALUE('Y')            /*055744*/
                 GOTO       CMDLBL(END)                              /*055744*/
             ENDDO                                                   /*055744*/
/* */
/**/
             SETATNPGM  PGM(CBC0015A)
/**/
/* RESET JOB SWITCHES */
/**/
             CHGJOB     SWS(XXXXXX00)
/**/
/* RECEIVE THE MAXIMUM NUMBER OF ACTIVE STREAMS AVALIABLE */
/* FROM PF/SDCOBPPD */
/**/
/*********** RCVF       RCDFMT(SDCOBPD0)                         *LN0001*/
             CALL       CBCICD PARM(&DOMNAS)                    /*LN0001*/
/**/
             RTVDTAARA  DTAARA(CBSTAT (45 1)) RTNVAR(&COBSTS)
/**/
/* IF THIS IS A RESTART AFTER MACHINE CRASH, CHANGE SCHEDULER ACTIVE */
/* FLAG TO 'N' */
/**/
/************IF COND(&COBSTS *EQ 'Y') THEN(CHGDTAARA DTAARA(+     */ /*055744*/
/************   CBSTAT (17 1)) VALUE('N'))                        */ /*055744*/
/* */
/** If scheduler already active. only restart monitor             */ /*055744*/
/* */
             ALCOBJ     OBJ((CBCHK *DTAARA *EXCL)) WAIT(5)           /*055744*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SCHACT))     /*055744*/
             DLCOBJ     OBJ((CBCHK *DTAARA *EXCL))                   /*055744*/
/* */
             IF COND(&COBSTS *EQ 'Y') THEN(CHGDTAARA DTAARA(+
                CBSTAT (17 1)) VALUE('N'))                           /*055744*/
/**/
             RTVDTAARA  DTAARA(CBSTAT (17 1)) RTNVAR(&SCHSTS)
/**/
/* IF THE SCHEDULER ISN'T ACTIVE THEN DO */
/**/
             IF COND(&SCHSTS *NE 'Y') THEN(DO)
                 RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
                 CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBCMONMP1                                           */
                                                                      /*S01408*/
/**********      CRTJRNRCV  JRNRCV(&JLIB/CBRCV000) */                                     /*CCB012*/
/**********      MONMSG     MSGID(CPF7010) */                                             /*CCB012*/
/*************   CRTJRN     JRN(&JLIB/CBJRN) JRNRCV(&JLIB/CBRCV000)*/ /*196122*/
/**********      CRTJRN     JRN(&JLIB/CBJRN) JRNRCV(&JLIB/CBRCV000) +                     /*CCB012*/
/**********                   AUT(*LIBCRTAUT)                                  /*196122*/ /*CCB012*/
/**********      MONMSG     MSGID(CPF7010)                                                /*CCB012*/
/**********      MONMSG     MSGID(CPF7015)                                     /*070107*/ /*CCB012*/
/**********      STRJRNPF   FILE(CBCOMSPD) JRN(CBJRN) IMAGES(*BOTH) +                     /*CCB012*/
/**********               OMTJRNE(*OPNCLO)                                                /*CCB012*/
/**********      MONMSG     MSGID(CPF7030)                                                /*CCB012*/
/**********      STRJRNPF   FILE(CBDEPSPD) JRN(CBJRN) IMAGES(*BOTH) +                     /*CCB012*/
/**********               OMTJRNE(*OPNCLO)                                                /*CCB012*/
/**********      MONMSG     MSGID(CPF7030)                                                /*CCB012*/
/**/                                                                  /*S01495*/
/**********    RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)                    */ /*S01495 CCB020*/
/**/                                                                                      /*CCB020*/
/** CBFLAGQT Phase Check  **/                                                             /*CCB020*/
/**/                                                                                      /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
/**/                                                                                      /*CCB020*/
/**********    IF         COND(&MPHAS *EQ 'C') THEN(DO)                         */ /*S01495 CCB020*/
               IF         COND(&COBST *EQ '*YES') THEN(DO)
/**/
/* CHECK TO SEE IF REPORT DISTRIBUTION PROGRAM IS ACTIVE */
/**/
                 ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)
                 MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DISTACT))
/**/
/* IF NOT ACTIVE, SUBMIT REPORT DISTRIBUTION AND DEALLOCATE DTAARA */
/**/
                 DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
                                                                      /*LN0911*/
/*                                                                      CCB009*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),****/              /*CCB009 CCB020*/
/*                                                                      CCB009*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                    */ /*CCB009 CCB020*/
/**Journal*the*RCF*files*for*the*distribution*job*FCC0401**/   /*E38772*S01463*/
/**Journal*the*RCF*files*for*the*distribution*job*RCFMONITOR********/              /*S01463 CCB020*/
/**This*processing*has*been*moved*from*FCC0401*to*avoid*************/              /*E38772 CCB020*/
/**locking*problems*between*FCC0401*and*COB*Components**************/              /*E38772 CCB020*/
                                                                      /*E38772*/
/**********      STRJRNPF   FILE(FCSFNOPD) JRN(CBJRN) IMAGES(*BOTH) +                  */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                         /*E38772 CCB020*/
/**********      MONMSG     MSGID(CPF7030)                                         /*E38772 CCB020*/
/**********      STRJRNPF   FILE(MAARCDPD) JRN(CBJRN) IMAGES(*BOTH) +                  */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                         /*E3877/*CCB020*/
/**********      MONMSG     MSGID(CPF7030)                                         /*E38772 CCB020*/
/**********      STRJRNPF   FILE(MAEXPTPD) JRN(CBJRN) IMAGES(*BOTH) +                  */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                         /*E38772 CCB020*/
/**********      MONMSG     MSGID(CPF7030)                                         /*E38772 CCB020*/
/**********      STRJRNPF   FILE(MAMWRKPD) JRN(CBJRN) IMAGES(*BOTH) +                  */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                         /*E38772 CCB020*/
/**********      MONMSG     MSGID(CPF7030)                                         /*E38772 CCB020*/
/**********      STRJRNPF   FILE(MAOWRKPD) JRN(CBJRN) IMAGES(*BOTH) +                  */ /*CCB020*/
/**********               OMTJRNE(*OPNCLO)                                         /*E38772 CCB020*/
/**********      MONMSG     MSGID(CPF7030)                                         /*E38772 CCB020*/
/**********  ENDDO                                                                 /*CCB009 CCB020*/
                                                                      /*E38772*/
/**********      SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) JOB(FCC0401) +
                              JOBD(FCJOBD) JOBQ(FCJOBQ) OUTQ(*JOBD) +
                              INLLIBL(*JOBD) RTGDTA(MBATCH)                 */
/**********      SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) JOB(FCC0401) +
/**********                   JOBD(FCJOBD) JOBQ(FCJOBQ) OUTQ(*JOBD) +
/**********                   INLLIBL(*JOBD) RTGDTA(*JOBD) */         /*S01463*/
             CALL       PGM(QRCVDTAQ) PARM('FCDTAQ    ' '*LIBL     ' +
                          &DTQFCLN &MSGDFC &WAIT)                     /*146520*/
/************    SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +                              /*CPK014*/
/************                 JOB(RCFMONITOR) JOBD(FCJOBD) +                              /*CPK014*/
/************                 JOBQ(FCJOBQ) OUTQ(*JOBD) RTGDTA(*JOBD) +                    /*CPK014*/
/************                 INLLIBL(*JOBD)                          /*S01463*/          /*CPK014*/
                                                                      /*LN0911*/
                 SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
               ENDDO                                                  /*S01495*/
DISTACT:
                 IF COND(&COBSTS *EQ 'N') THEN(DO)
/**/
/* SEND COBBEGIN MESSAGE TO DTAQ/CBDTQA */
/**/
                      CALL QSNDDTAQ PARM('CBDTQA    ' '*LIBL     ' +
                                         &DTQALEN &MSGA)
/**/
/* SEND THE APPROPRIATE NUMBER OF STREAM MESSAGES TO DTAQ/CBDTQB */
/**/
                      CHGVAR     VAR(&CNT) VALUE(0)
DTAQ:                 CHGVAR     VAR(%SST(&MSGB 7 2)) VALUE(&CNT)
                      CALL QSNDDTAQ PARM('CBDTQB    ' '*LIBL     ' +
                                         &DTQBLEN &MSGB)
                      CHGVAR     VAR(&CNT)    VALUE(&CNT + 1)
                      IF         COND(&CNT *LT &DOMNAS) THEN(GOTO DTAQ)
                 ENDDO
/**/
/* IF RESTART AFTER HALT */
/**/
/**********  IF         COND(&COBSTS *EQ 'H') THEN(CALL PGM(CBC0075) +
                          PARM(&DOMNAS))                                LN0420*/
                                                                      /*LN0420*/
             IF         COND(&COBSTS *EQ 'H') THEN(+
             DO)                                                      /*LN0420*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Close of +
                          Business processing restarting after +
                          halt') TOPGMQ(*EXT) MSGTYPE(*STATUS)        /*LN0420*/
             CALL       PGM(CBC0075) PARM(&DOMNAS)                    /*LN0420*/
             ENDDO
/**/
/* IF RESTART AFTER MACHINE CRASH */
/**/
                 IF COND(&COBSTS *EQ 'Y') THEN(DO)
                      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('+
                          Close of Business processing restarting') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*LN0420*/
                      CALL       PGM(CB0090) PARM(&DOMNAS)
                      CALL       PGM(CB0170) PARM('Y' &ERRCB0170)
                      IF         COND(&ERRCB0170 *EQ 'Y') THEN(DO)
                      SNDPGMMSG  MSG('CB0170 - ERROR PROCESSING FOR +
                           SCHEDULER TERMINATED ABNORMALLY') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      GOTO       CMDLBL(ABNOR)
                      ENDDO
                 ENDDO
/**/
/* IF RESTART AFTER PROGRAM FAILURE(S) */
/**/
/*********   IF         COND(&COBSTS *EQ 'R') THEN(CALL PGM(CBC0095) +
                          PARM(&DOMNAS))                              /*LN0420*/
                                                                      /*LN0420*/
             IF         COND(&COBSTS *EQ 'R') THEN(+
             DO)                                                      /*LN0420*/
                      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('+
                          Close of Business processing restarting') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*LN0420*/
             CALL       PGM(CBC0095) PARM(&DOMNAS)                    /*LN0420*/
             ENDDO
                                                                      /*LN0420*/
/**/
/* IF RESTART AFTER SCHEDULER FAILED */
/**/
             IF         COND(&COBSTS *EQ 'S') THEN(CALL PGM(CB0080) +
                          PARM(&DOMNAS))
                      SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('+
                          Close of Business processing restarting') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*LN0420*/
/**/
/* IF U7 AND U8 HAVE BEEN SWITCHED ON - ERROR GOTO END */
/**/
                 IF COND(%SWITCH(XXXXXX11)) THEN(GOTO ABNOR)
 
                 ELSE DO
/**/
/* SUBMIT THE SCHEDULER */
/**/
/**********          SBMJOB     JOB(CBC0010) JOBD(MBATCH) RQSDTA(+
                                'CALL CBC0010') MSGQ(*NONE)           /*LN0420*/
                     SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('+
                        Close of Business Scheduler being started') +
                          TOPGMQ(*EXT) MSGTYPE(*STATUS)               /*LN0420*/
                                                                      /*LN0911*/
/**********          SBMJOB     CMD(CALL PGM(CBC0010)) JOB(CBC0010) +
                          JOBD(MEODD) MSGQ(*NONE)                    */
/**/                                                                  /*S01491*/
/* Initialise COB scheduler flag in ACCOBT to blank */                /*S01491*/
/**/                                                                  /*S01491*/
                     IF         COND(&S01491 *EQ 'Y') THEN(DO)        /*S01491*/
                       CHGDTAARA  DTAARA(ACCOBT (2 1)) VALUE(' ')     /*S01491*/
                     ENDDO                                            /*S01491*/
/**********          SBMJOB     CMD(CALL PGM(CBC0010)) JOB(CBC0010) + /*091688*/
/**********               JOBD(MEODD) MSGQ(*NONE) RTGDTA(*JOBD) */    /*091688*/
/**********          SBMJOB     CMD(CALL PGM(CBC0010)) JOB(COBSCHED) +/*099150*/
/**********               JOBD(MEODD) MSGQ(*NONE) RTGDTA(*JOBD)/*091688*099150*/
/* */                                                                 /*101260*/
/* If user specified on MEODD then use */                             /*101260*/
/* */                                                                 /*101260*/
/* */                                                                 /*102568*/
/* Use API instead of command to be V3R1M0 compliant */               /*102568*/
/* */                                                                 /*102568*/
/************RTVJOBD    JOBD(MEODD) USER(&USER)              *101260*  *102568*/
/**********  CHGVAR     VAR(&RTN_BIN) VALUE(X'00000000')       */              /*102568*/ /*CCB021*/
/**********  CHGVAR     VAR(%SST(&ERROR2 1 4)) VALUE(&RTN_BIN) */              /*102568*/ /*CCB021*/
/**********  CHGVAR     VAR(&RTN_BIN) VALUE(X'00000200')       */              /*102568*/ /*CCB021*/
/* */                                                                 /*102568*/
/**********  CALL       PGM(QWDRJOBD) PARM(&RTN_INFO &RTN_BIN +
                          &FORMAT &JOBD &ERROR2)               */              /*102568*/ /*CCB021*/
/**********  MONMSG     MSGID(CPF0001) EXEC(CHGVAR +
                          VAR(%SST(&RTN_INFO 29 10)) VALUE('*RQD')) */         /*102568*/ /*CCB021*/
/**********  CHGVAR     VAR(&USER) VALUE(%SST(&RTN_INFO 29 10))     */         /*102568*/ /*CCB021*/
/* */                                                                 /*102568*/
/************IF         COND(&USER *EQ '*RQD      ') THEN(DO) /*101260/*110242*/
/*************       SBMJOB     JOB(COBSCHED) JOBD(MEODD) +           /*110242*/
/*************              RTGDTA(MULTILANGUAGE) RQSDTA('CALL +      /*110242*/
/*************              PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +*110242*/
/*************        '' '' '' '' '' '' '' '')') MSGQ(*NONE) /*099150 /*110242*/
/************ENDDO                                         /*101260*/ /*110242*/
/************ELSE       CMD(DO)                            /*101260*/ /*110242*/
/************SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +       /*110242*/
/*************            RTGDTA(MULTILANGUAGE) RQSDTA('CALL +        /*110242*/
/*************            PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' + /*110242*/
/*************      '' '' '' '' '' '' '' '')') MSGQ(*NONE) /*101260*/ /*110242*/
/************ENDDO                                         /*101260*/ /*110242*/
                                                                      /*110242*/
/**********  IF         COND(&USER *EQ '*RQD      ') THEN(DO)  */              /*110242*/ /*CCB021*/
/************   SBMJOB     JOB(COBSCHED) JOBD(MEODD) +                                    /*CPK014*/
/************                RTGDTA(MULTILANGUAGE) RQSDTA('CALL +                         /*CPK014*/
/************                PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +                  /*CPK014*/
/************                '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +                  /*CPK014*/
/************                MSGQ(*NONE)                              /*110242*/          /*CPK014*/
/************   SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +                        /*CSC023*/
/************             RTGDTA(MULTILANGUAGE) RQSDTA('CALL +                            /*CSC023*/
/************             PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +                     /*CSC023*/
/************             '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +                     /*CSC023*/
/************             MSGQ(*NONE)                                          /*CPK014*/ /*CSC023*/
                SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +
                          RTGDTA(MULTILANGUAGE) RQSDTA('CALL +
                          PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +
                          '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +
                          MSGQ(*NONE) OUTQ(*JOBD)                                         /*CSC023*/
/**********  ENDDO               */                                            /*110242*/ /*CCB021*/
/**********  ELSE       CMD(DO)  */                                            /*110242*/ /*CCB021*/
/************   SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +                        /*CSC023*/
/************                RTGDTA(MULTILANGUAGE) RQSDTA('CALL +                         /*CSC023*/
/************                PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +                  /*CSC023*/
/************                '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +                  /*CSC023*/
/************                MSGQ(*NONE)                              /*110242*/          /*CSC023*/
/**********     SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +
                             RTGDTA(MULTILANGUAGE) RQSDTA('CALL +
                             PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +
                             '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +
                             MSGQ(*NONE) OUTQ(*JOBD)                 */        /*CSC023*/ /*CCB021*/
/**********  ENDDO  */                                                         /*110242*/ /*CCB021*/
                                                                      /*LN0911*/
/**/
/* CHANGE CBSTAT POSITION 17 (SCHEDULER ACTIVE) TO 'Y' */
/**/
                     CHGDTAARA  DTAARA(CBSTAT (17 1)) VALUE('Y')
/**/
/* CHANGE DTAARA/CBSTAT TO SHOW COB RUNNING NORMALLY AND NO HALTS */
/* IN OPERATION */
/**/
                     CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')
                     CHGDTAARA  DTAARA(CBSTAT (20 1)) VALUE('N')
/**/
/* IF RESTART AFTER FAILED COMPONENTS DISPLAY CONTROL MENU */
/* VIA CBC0015R RATHER THAN USING ATTENTION KEY PROCESS */
/**/
                     IF         COND(&COBSTS *EQ 'R') THEN(DO)
                      CALL       PGM(CBC0015R)
                     ENDDO
/**/
                 ENDDO
/**/
             ENDDO
/* */
             CHGVAR     VAR(&MSGD) +
                          VALUE('                                     -
                                 REFRESH         ')                   /*037613*/
                                                                      /*037613*/
             GOTO STRMON                                              /*055744*/
/* */
/** Scheduler Active Tag */                                          /*055744*/
/* */
SCHACT:                                                              /*055744*/
             CHGVAR     VAR(&MSGD) +
                          VALUE('                                     -
                                 RESTART         ')                  /*055744*/
             CALL QSNDDTAQ PARM('CBDTQD    ' '*LIBL     ' +
                                         &DTQDLEN &MSGD)             /*055744*/
                 MONMSG     MSGID(CPF9503) EXEC(DO)                   /*078097*/
                   IF         COND(&COUNT *LE 6) THEN(DO)             /*078097*/
                     CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)         /*078097*/
                     DLYJOB     DLY(10)                               /*078097*/
                     GOTO       CMDLBL(LOOP)                          /*078097*/
                   ENDDO                                              /*078097*/
                   ELSE       CMD(DO)                                 /*078097*/
                     GOTO       CMDLBL(ABNOR)                         /*078097*/
                   ENDDO                                              /*078097*/
                 ENDDO                                                /*078097*/
/* */
STRMON:                                                              /*055744*/
             IF         COND(&S01491 *EQ 'Y') THEN(DO)                /*S01491*/
/*  Attach break handling program ACC0010 to QSYSOPR               */
/**/
/*/COPY WNCPYSRC,CBH00004                                            */
             CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK) PGM(ACC0010)
             MONMSG     MSGID(CPF0000)                                /*S01491*/
/*/COPY WNCPYSRC,CBH00005                                            */
/**/
             ALCOBJ     OBJ((AC002 *DTAARA *EXCL)) WAIT(30)           /*S01491*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC2))        /*S01491*/
             DLCOBJ     OBJ((AC002 *DTAARA *EXCL))                    /*S01491*/
/************SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +         /*110242*/
/*************        JOBD(MEODD) RTGDTA(*JOBD) MSGQ(*NONE)/*S01491*/ /*110242*/
/************SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +                             /*CPK014*/
/************             JOBD(MEODD) RTGDTA(*JOBD) INLLIBL(*JOBD) +                      /*CPK014*/
/************             MSGQ(*NONE)                                 /*110242*/          /*CPK014*/
/************SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +                             /*CSC023*/
/************             JOBD(MEODD) USER(*JOBD) RTGDTA(*JOBD) +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                           /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +
                          JOBD(MEODD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
ALC2:        ENDDO                                                    /*S01491*/
/**/
/* IF A RESTART AFTER A MONITOR FAILURE AND */
/* NOTHING WAS ACTIVE DISPLAY MENU TO ALLOW RESTART */
/**/
             RTVDTAARA  DTAARA(CBSTAT (18 2)) RTNVAR(&NOAS)
             IF         COND((&NOAS *EQ '00') *AND (&COBSTS *EQ 'M')) +
                          THEN(DO)
                        CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')
                        CALL       PGM(CBC0015R)
             ENDDO
 
/**********  DLTF       FILE(QTEMP/CBCOUNT)                  /*E28730   055670*/
/**********  MONMSG     MSGID(CPF0000)                       /*E28730   055670*/
/**********  DLTF       FILE(QTEMP/CBFINISH)                 /*E28730   055670*/
/**********  MONMSG     MSGID(CPF0000)                       /*E28730   055670*/
/**********  DLTF       FILE(QTEMP/TOTALP)                   /*E28730   055670*/
/**********  MONMSG     MSGID(CPF0000)                       /*E28730   055670*/
/**********  DLTF       FILE(QTEMP/FINISH)                   /*E28730   055670*/
/**********  MONMSG     MSGID(CPF0000)                       /*E28730   055670*/
                                                             /*E28730   055670*/
/************CPYF       FROMFILE(*LIBL/CBCOMSPD) +                      055670*/
/************                TOFILE(QTEMP/CBCOUNT) CRTFILE(*YES) +      055670*/
/************                INCREL((*IF DHCRQD *EQ 'Y'))E28730 034909  055670*/
/**********  CPYF       FROMFILE(*LIBL/CBCOMSPD) +                      055670*/
/**********                  TOFILE(QTEMP/CBCOUNT) CRTFILE(*YES) +      055670*/
/**********                  INCREL((*IF DHCRQD *EQ 'Y') (*AND DHCOTT + 055670*/
/**********                  *NE 'COBBEGIN') (*AND DHCOTT *NE +         055670*/
/**********                  'COBEND'))                      /*034909   055670*/
/**********  CPYF       FROMFILE(QTEMP/CBCOUNT) +                       055670*/
/**********               TOFILE(QTEMP/CBFINISH) CRTFILE(*YES) +        055670*/
/**********               INCREL((*IF DHCSTS *EQ 'C'))       /*E28730   055670*/
/**********  DSPFD      FILE(QTEMP/CBCOUNT) TYPE(*MBR) +                055670*/
/**********               OUTPUT(*OUTFILE) OUTFILE(QTEMP/TOTALP)E28730  055670*/
/**********  DSPFD      FILE(QTEMP/CBFINISH) TYPE(*MBR) +               055670*/
/**********               OUTPUT(*OUTFILE) OUTFILE(QTEMP/FINISH)E28730  055670*/
/**********                                                  /*E28730   055670*/
/**********  CALL       PGM(CBCOUNT)                         /*E28730   055670*/
                                                             /*E28730   055670*/
/**/
/* RECEIVE MESSAGE FROM DTAQ/CBDTQD */
/**/
LOOP:            CALL QRCVDTAQ PARM('CBDTQD    ' '*LIBL     ' +
                                    &DTQDLEN &MSGD &WAIT)
/**/
/* CALL THE MONITOR */
/**/
                 CHGVAR     VAR(&DOMNASA) VALUE(&DOMNAS)
                 CALL CBMON PARM(&JOB &MSGD &DOMNASA)
/**/                                                                  /*037613*/
/* MOVE DEFAULT MSG OF 'REFRESH' INTO &MSGD IN CASE OF DTAQ TIMEOUT   /*037613*/
/**/                                                                  /*037613*/
                 CHGVAR     VAR(&MSGD) +
                          VALUE('                                     -
                                 REFRESH         ')                   /*037613*/
/**/
/* RETRIEVE DTAARA/CBSTAT TO SEE IF THE SCHEDULER IS ACTIVE */
/**/
                 RTVDTAARA DTAARA(CBSTAT (17 1)) RTNVAR(&SCHSTS)
/**/
/* IF SCHEDULER IS ACTIVE AND NO DB ERRORS GOTO LOOP TAG */
/**/
             IF         COND((&SCHSTS *EQ 'Y') *AND +
                          (%SWITCH(XXXXXX00))) THEN(GOTO CMDLBL(LOOP))
/**/
/**DEACTIVATE*THE*ATTENTION*KEY********************************095122*/
/**/
/************SETATNPGM  PGM(CBC0015A) SET(*OFF)               *095122*/
/**/
/**/
/* IF SCHEDULER HAS ENDED IN ERROR OR ERROR OCCURED IN CBCMON/CBMON */
/* PERFORM USUAL ERROR PROCESSING */
/**/
             RTVDTAARA DTAARA(CBSTAT (17 1)) RTNVAR(&SCHSTS)
            IF COND((&SCHSTS *EQ 'E') *OR (%SWITCH(XXXXXX11))) THEN(DO)
                 IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**/
                     RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                     SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                MSGDTA(&MEM) TOMSGQ(MOPERQ)
                 ENDDO
/**/
ABNOR:           SNDPGMMSG  MSG('CBCMON - COB MONITOR +
                            TERMINATED ABNORMALLY') +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                            CHGJOB SWS(XXXXXX11)
                            CHGVAR VAR(&ERROR) VALUE('Y')
                 MONMSG     MSGID(CPF0000)
/**/
                 DMPCLPGM                                             /*083886*/
/**/                                                                  /*083886*/
/* IF THE MONITOR FAILED THEN SET THE COB STATUS FIELD TO 'M' */
/**/
                 RTVDTAARA DTAARA(CBSTAT (45 1)) RTNVAR(&COBSTS)
                 MONMSG     MSGID(CPF0000)
                 IF COND(&COBSTS *EQ 'N') THEN(DO)
                    CHGDTAARA DTAARA(CBSTAT (45 1)) VALUE('M')
                    MONMSG     MSGID(CPF0000)
                 ENDDO
             ENDDO
/**/
 END:        DLCOBJ     OBJ((MONCHK *DTAARA *EXCL))                  /*055744*/
             MONMSG     MSGID(CPF0000)                               /*055744*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
