/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB COB batch monitoring')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBCMONB - BATCH MONITORING OF COB                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 29Jan04              */
/*       Prev Amend No. CCB012             Date 20May02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 06Nov01              */
/*                      196795             Date 13Aug01              */
/*                      196122             Date 10Aug01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK008             DATE 01JUL97              */
/*                      110242             DATE 07NOV96              */
/*                      S01048             DATE 10JUN96              */
/*                      102568             DATE 18APR96              */
/*                      101260             DATE 08MAR96              */
/*                      099768             DATE 20FEB96              */
/*                      098705             DATE 09FEB96              */
/*                      092291             DATE 09FEB96              */
/*                      099150             DATE 02FEB96              */
/*                      098266             DATE 15JAN96              */
/*                      091688             DATE 10AUG95              */
/*                      091570             DATE 08AUG95              */
/*                      S01408             DATE 07AUG95              */
/*                      S01408             DATE 27JUL95              */
/*                      089645             DATE 26JUN95              */
/*                      S01420 *CREATE     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CCB012 - Use 70 job streams. Change to data areas CBRECV    */
/*                - Change to data areas CBRECV and CBTRAN.          */
/*                - Make CBJRN redundant.                            */
/*       CPK014 - Release 4 packaging:                               */
/*                - DTAARA/CBRECV is now a delivered object.         */
/*                - Submit jobs with user *JOBD                      */
/*       196795 - Use DTAARA CBRECV instead of DTAQ MAINDTQ to avoid */
/*                object lock at V5R1M0.                             */
/*       196122 - Authority for CBJRN change to *LIBCRTAUT           */
/*       CCB009 - Journal files throughout close of business         */
/*       CPK008 - DBA R2 Packaging                                   */
/*              - Size of components run/to run counters changed.    */
/*       110242 - Change defaults for SBMJOB cmd to take *JOBD       */
/*       S01048 - Core hook CBCMONB003 added.                        */
/*                Core hook CBCMONB002 added.                        */
/*                Core hook CBCMONB001 added.                        */
/*       102568 - RTVJOBD is not an IBM command and has been         */
/*                replaced with an API.                              */
/*       101260 - Submit scheduler using job description user        */
/*       099768 - Reverse 098705 as it is incorrect.                 */
/*       098705 - COB Monitor should not lock QSYSOPR as this        */
/*                prevents other users from answering the message.   */
/*       092291 - Create data area LDA                               */
/*       099150 - Change routing entry for scheduler submit.         */
/*       098266 - Batch monitor hangs due to this program being      */
/*                submitted with run priority 50; ensure that        */
/*                scheduler is also submitted with the higher        */
/*                priority.                                          */
/*       091688 - Rename the CBC0010 job to COBSCHED for ease        */
/*                of identification.                                 */
/*              - Rename the CBCMONB job to COBMONITOR for ease      */
/*                of identification.                                 */
/*       091570 - Test end of CoB if scheduler not active.           */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBCMONBINT                                       */
/*                - CBCMONBMPS                                       */
/*                - CBCMONBMPE                                       */
/*                - CBCMONBERR                                       */
/*                - CBCMONBEND                                       */
/*       S01408 - Addition of Core Hook CBCMONBMP1                   */
/*                Addition of Core Hook CBCMONBMP2                   */
/*       089645 - The batch monitor is not presently monitored       */
/*                by the Autocall module.                            */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBCMONBINT                                          */
 
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERRCB0170) TYPE(*CHAR) LEN(1)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COBSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SCHSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&HLTSTS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNT) TYPE(*DEC) LEN(2)
             DCL        VAR(&DTQALEN) TYPE(*DEC) LEN(5) VALUE(16)
             DCL        VAR(&DTQBLEN) TYPE(*DEC) LEN(5) VALUE(8)
             DCL        VAR(&DTQDLEN) TYPE(*DEC) LEN(5) VALUE(86)
             DCL        VAR(&WAIT) TYPE(*DEC) LEN(5) VALUE(5)
             DCL        VAR(&WAIT2)  TYPE(*DEC) LEN(5) VALUE(0)
             DCL        VAR(&MSGA) TYPE(*CHAR) LEN(16) +
                          VALUE('COBBEGIN  00001C')
             DCL        VAR(&MSGB) TYPE(*CHAR) LEN(8) VALUE('STREAM  ')
             DCL        VAR(&MSGD) TYPE(*CHAR) LEN(86)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&DOMNASA) TYPE(*CHAR) LEN(2)
/**********  DCL        VAR(&NOAS) TYPE(*CHAR) LEN(2) **/             /*089645*/
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10) VALUE('  JLIB    ')
             DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&S01491) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)                /*101260*/
/* */                                                                 /*102568*/
/* Define variables for API call */                                   /*102568*/
/* */                                                                 /*102568*/
             DCL        VAR(&RTN_BIN) TYPE(*CHAR) LEN(4)              /*102568*/
             DCL        VAR(&RTN_INFO) TYPE(*CHAR) LEN(512)           /*102568*/
             DCL        VAR(&ERROR2) TYPE(*CHAR) LEN(512)             /*102568*/
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('JOBD0100')                           /*102568*/
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(20) +
                          VALUE('MEODD     *LIBL     ')               /*102568*/
/* */                                                                 /*102568*/
             DCL        VAR(&DOMNAS) TYPE(*DEC) LEN(2)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(1)
/*********** DCL        VAR(&CBTRAN) TYPE(*CHAR) LEN(1024) */                             /*CCB012*/
             DCL        VAR(&CBTRAN) TYPE(*CHAR) LEN(1099)                                /*CCB012*/
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&PROC) TYPE(*CHAR) LEN(7) **/             /*089645*/
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&SEV) TYPE(*CHAR) LEN(2) **/              /*089645*/
/**********  DCL        VAR(&CONT) TYPE(*DEC) LEN(2 0) **/            /*089645*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
 
/*/COPY WNCPYSRC,CBCMONBMPS                                          */
/**/                                                                  /*092291*/
/* Create data area LDA */                                            /*092291*/
/**/                                                                  /*092291*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)        /*092291*/
             MONMSG     MSGID(CPF1023)                                /*092291*/
 
/* Allocate data area MONCHK during the monitor run */
 
             ALCOBJ     OBJ((MONCHK *DTAARA *EXCL)) WAIT(2)
             MONMSG     MSGID(CPF1002) EXEC(DO)
                SNDPGMMSG  MSG('CBCMONB - Cannot allocate MONCHK +
                             *DTAARA') TOMSGQ(MOPERQ)
                               CHGJOB SWS(XXXXXX11)
                GOTO       CMDLBL(ENDP)
             ENDDO
 
             OVRMSGF    MSGF(CBUSRMSG) TOMSGF(GBCBUSRMSG)
 
         /*  CHGJOB     LOG(*SAME *SAME *NOLIST) */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
/************CHGVAR     VAR(&LIB) VALUE(&SYSID *TCAT 'XLIB ')                             /*196795*/
             CHGVAR     VAR(&LIB) VALUE(&SYSID *TCAT 'DPLIB ')                            /*196795*/
 
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)
             CHGDTAARA  DTAARA(CBCTRL (1 10)) VALUE(&JOB)
             CHGDTAARA  DTAARA(CBCTRL (11 10)) VALUE(&USR)
             CHGDTAARA  DTAARA(CBCTRL (21 6)) VALUE(&NBR)
 
             CHGVAR VAR(%SST(&PARM 1 7)) VALUE('END    ')
             CHGVAR VAR(%SST(&PARM 38 2)) VALUE('99')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBCMONBMP1                                          */
                                                                      /*S01408*/
 
/* Determine if SAR S01491 (Autocall) is switched ON */
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')
             CHGVAR     VAR(&SAR) VALUE('S01491')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)
/**********  IF         COND(&RTCD *EQ '       ') THEN(CHGVAR + **/   /*089645*/
/**********               VAR(&S01491) VALUE('Y'))              **/   /*089645*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*089645*/
                CHGVAR     VAR(&S01491) VALUE('Y')                    /*089645*/
/**********     CALL       PGM(AC0007) PARM('CBCMONB   ' 'Y')  /*089645*091688*/
                CALL       PGM(AC0007) PARM('COBMONITOR' 'Y')         /*091688*/
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))                           /*089645*/
             ENDDO                                                    /*089645*/
 
/* Verify if transmit and receive data areas are created */
 
             CHKOBJ     OBJ(&LIB/CBTRAN) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
/************** CRTDTAARA  DTAARA(&LIB/CBTRAN) TYPE(*CHAR) LEN(1024) */                   /*CCB012*/
                CRTDTAARA  DTAARA(&LIB/CBTRAN) TYPE(*CHAR) LEN(1099)                      /*CCB012*/
/***************CHGDTAARA DTAARA(CBTRAN (97 12)) VALUE('000000000000')/*CPK008*/
                CHGDTAARA  DTAARA(CBTRAN (97 2)) VALUE('00')          /*CPK008*/
                CHGDTAARA  DTAARA(CBTRAN (105 4)) VALUE('0000')       /*CPK008*/
/******** CHGDTAARA  DTAARA(CBTRAN (849 8)) VALUE('00000000')                  /*CPK008*/ /*CCB012*/
                CHGDTAARA  DTAARA(CBTRAN (1089 8)) VALUE('00000000')                      /*CCB012*/
/************** CHGDTAARA  DTAARA(CBTRAN (1022 3)) VALUE('000') */                        /*CCB012*/
                CHGDTAARA  DTAARA(CBTRAN (1097 3)) VALUE('000')                           /*CCB012*/
             ENDDO
 
/**********  CHKOBJ     OBJ(&LIB/CBRECV) OBJTYPE(*DTAARA) */                              /*CPK014*/
/**********  MONMSG     MSGID(CPF9801) EXEC(DO) */                                        /*CPK014*/
/**********     CRTDTAARA  DTAARA(&LIB/CBRECV) TYPE(*CHAR) LEN(1024) */                   /*CPK014*/
/***************CHGDTAARA DTAARA(CBRECV (97 12)) VALUE('000000000000')/*CPK008*/
                CHGDTAARA  DTAARA(CBRECV (97 2)) VALUE('00')          /*CPK008*/
                CHGDTAARA  DTAARA(CBRECV (105 4)) VALUE('0000')       /*CPK008*/
/*******  CHGDTAARA  DTAARA(CBRECV (849 8)) VALUE('00000000') /                /*CPK008*/ /*CCB012*/
                CHGDTAARA  DTAARA(CBRECV (1089 8)) VALUE('00000000')                      /*CCB012*/
/*************  CHGDTAARA  DTAARA(CBRECV (1022 3)) VALUE('000') */                        /*CCB012*/
                CHGDTAARA  DTAARA(CBRECV (1097 3)) VALUE('000')                           /*CCB012*/
/**********  ENDDO */                                                                     /*CPK014*/
 
/* Reset job switches */
 
             CHGJOB     SWS(XXXXXX00)
 
/* Receive the maximum number of active streams available */
/* from PF/SDCOBPPD */
 
             CALL       PGM(CBCICD) PARM(&DOMNAS)
 
             RTVDTAARA  DTAARA(CBSTAT (45 1)) RTNVAR(&COBSTS)
 
/* If scheduler already active, only restart monitor */
 
             ALCOBJ     OBJ((CBCHK *DTAARA *EXCL)) WAIT(5)
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(SCHACT))
             DLCOBJ     OBJ((CBCHK *DTAARA *EXCL))
 
             IF         COND(&COBSTS *EQ 'Y') THEN(CHGDTAARA +
                          DTAARA(CBSTAT (17 1)) VALUE('N'))
 
             RTVDTAARA  DTAARA(CBSTAT (17 1)) RTNVAR(&SCHSTS)
 
/* If the scheduler isn't active then do */
 
             IF         COND(&SCHSTS *NE 'Y') THEN(DO)
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
                CHGVAR     VAR(%SUBSTRING(&JLIB 1 2)) VALUE(&SYSID)
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBCMONBMP2                                          */
                                                                      /*S01408*/
/*************  CRTJRNRCV  JRNRCV(&JLIB/CBRCV000)                                         /*CCB012*/
/*************  MONMSG     MSGID(CPF7010)                                                 /*CCB012*/
/*************  CRTJRN     JRN(&JLIB/CBJRN) JRNRCV(&JLIB/CBRCV000) */ /*196122*/
/*************  CRTJRN     JRN(&JLIB/CBJRN) JRNRCV(&JLIB/CBRCV000) +           /*196122*/ /*CCB012*/
/*************               AUT(*LIBCRTAUT)                                   /*196122*/ /*CCB012*/
/*************  MONMSG     MSGID(CPF7010)                                                 /*CCB012*/
/*************  MONMSG     MSGID(CPF7015)                                                 /*CCB012*/
/*************  STRJRNPF   FILE(CBCOMSPD) JRN(CBJRN) IMAGES(*BOTH) +                      /*CCB012*/
/*************               OMTJRNE(*OPNCLO)                                             /*CCB012*/
/*************  MONMSG     MSGID(CPF7030)                                                 /*CCB012*/
/*************  STRJRNPF   FILE(CBDEPSPD) JRN(CBJRN) IMAGES(*BOTH) +                      /*CCB012*/
/*************               OMTJRNE(*OPNCLO)                                             /*CCB012*/
/*************  MONMSG     MSGID(CPF7030)                                                 /*CCB012*/
                RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&MPHAS)
 
                IF         COND(&MPHAS *EQ 'C') THEN(DO)
 
/* Check to see if report distribution program is active */
 
                   ALCOBJ     OBJ((FC0100 *DTAARA *EXCL)) WAIT(5)
                   MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DISTACT))
 
/* If not active, submit report distribution and deallocate DTAARA */
 
                   DLCOBJ     OBJ((FC0100 *DTAARA *EXCL))
 
/*****************************************************************             /*CCB009*/ /*CCB012*/
/**If*Feature*CCB009*is*NOT*'on'*(close*of*business*journaling),**/            /*CCB009*/ /*CCB012*/
/*****************************************************************             /*CCB009*/ /*CCB012*/
/**********  IF         COND(&CCB009 *NE '       ') THEN(DO)                   /*CCB009*/ /*CCB012*/
/**Journal*the*RCF*files*for*the*distribution*job*RCFMONITOR**/                           /*CCB012*/
/**This*processing*has*been*moved*from*FCC0401*to*avoid*******/                           /*CCB012*/
/**locking*problems*between*FCC0401*and*COB*Components********/                           /*CCB012*/
/**********                                                                               /*CCB012*/
/**********        STRJRNPF   FILE(FCSFNOPD) JRN(CBJRN) IMAGES(*BOTH) +                   /*CCB012*/
/**********                     OMTJRNE(*OPNCLO)                                          /*CCB012*/
/**********        MONMSG     MSGID(CPF7030)                                              /*CCB012*/
/**********                                                                               /*CCB012*/
/**********        STRJRNPF   FILE(MAARCDPD) JRN(CBJRN) IMAGES(*BOTH) +                   /*CCB012*/
/**********                     OMTJRNE(*OPNCLO)                                          /*CCB012*/
/**********        MONMSG     MSGID(CPF7030)                                              /*CCB012*/
/**********                                                                               /*CCB012*/
/**********        STRJRNPF   FILE(MAEXPTPD) JRN(CBJRN) IMAGES(*BOTH) +                   /*CCB012*/
/**********                     OMTJRNE(*OPNCLO)                                          /*CCB012*/
/**********        MONMSG     MSGID(CPF7030)                                              /*CCB012*/
/**********                                                                               /*CCB012*/
/**********        STRJRNPF   FILE(MAMWRKPD) JRN(CBJRN) IMAGES(*BOTH) +                   /*CCB012*/
/**********                     OMTJRNE(*OPNCLO)                                          /*CCB012*/
/**********        MONMSG     MSGID(CPF7030)                                              /*CCB012*/
/**********                                                                               /*CCB012*/
/**********        STRJRNPF   FILE(MAOWRKPD) JRN(CBJRN) IMAGES(*BOTH) +                   /*CCB012*/
/**********                     OMTJRNE(*OPNCLO)                                          /*CCB012*/
/**********        MONMSG     MSGID(CPF7030)                                              /*CCB012*/
/**********  ENDDO                                                             /*CCB009*/ /*CCB012*/
 
/************      SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +                            /*CPK014*/
/************                   JOB(RCFMONITOR) JOBD(FCJOBD) +                            /*CPK014*/
/************                   JOBQ(FCJOBQ) OUTQ(*JOBD) +                                /*CPK014*/
/************                   RTGDTA(*JOBD) INLLIBL(*JOBD)                              /*CPK014*/
                   SBMJOB     CMD(CALL PGM(FCC0401) PARM(C)) +
                          JOB(RCFMONITOR) JOBD(FCJOBD) JOBQ(FCJOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD)                                                  /*CPK014*/
 
                ENDDO
 
DISTACT:
                IF         COND(&COBSTS *EQ 'N') THEN(DO)
 
/* Send COBBEGIN message to DTAQ/CBDTQA */
 
                   CALL       PGM(QSNDDTAQ) PARM('CBDTQA    ' +
                                '*LIBL     ' &DTQALEN &MSGA)
 
/* Send the appropriate number of stream messages to DTAQ/CBDTQB */
 
                   CHGVAR     VAR(&CNT) VALUE(0)
DTAQ:              CHGVAR     VAR(%SST(&MSGB 7 2)) VALUE(&CNT)
                   CALL       PGM(QSNDDTAQ) PARM('CBDTQB    ' +
                                '*LIBL     ' &DTQBLEN &MSGB)
                   CHGVAR     VAR(&CNT) VALUE(&CNT + 1)
 
                   IF         COND(&CNT *LT &DOMNAS) THEN( +
                                GOTO CMDLBL(DTAQ))
                ENDDO
 
/* If restart after halt */
 
                IF         COND(&COBSTS *EQ 'H') THEN(DO)
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                                MSGDTA('Close of Business +
                                processing restarting after halt') +
                                TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   CALL       PGM(CBC0075) PARM(&DOMNAS)
                ENDDO
 
/* If restart after machine crash */
 
                IF         COND(&COBSTS *EQ 'Y') THEN(DO)
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                                MSGDTA('Close of Business +
                                processing restarting') +
                                TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   CALL       PGM(CB0090) PARM(&DOMNAS)
                   CALL       PGM(CB0170) PARM('Y' &ERRCB0170)
                   IF         COND(&ERRCB0170 *EQ 'Y') THEN(DO)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBCMONB001                                           /*S01408*/
/*                                                                    /*S01408*/
                      SNDPGMMSG  MSG('CB0170 - Error processing for +
                                   scheduler terminated abnormally') +
                                   TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBCMONB002                                           /*S01408*/
/*                                                                    /*S01408*/
                      GOTO       CMDLBL(ABNOR)
                   ENDDO
                ENDDO
 
/* If restart after program failure(s) */
 
                IF         COND(&COBSTS *EQ 'R') THEN(DO)
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                                MSGDTA('Close of Business +
                                processing restarting') +
                                TOMSGQ(MOPERQ) MSGTYPE(*INFO)
                   CALL       PGM(CBC0095) PARM(&DOMNAS)
                ENDDO
 
/* If restart after scheduler failed */
 
                IF         COND(&COBSTS *EQ 'S') THEN(CALL +
                             PGM(CB0080) PARM(&DOMNAS))
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                                MSGDTA('Close of Business +
                                processing restarting') +
                                TOMSGQ(MOPERQ) MSGTYPE(*INFO)
 
/* If U7 and U8 have been switched on - error and Go to END */
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
 
                ELSE       CMD(DO)
 
/* Submit the scheduler */
 
                   SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                                MSGDTA('Close of Business +
                                Scheduler being started') +
                                TOMSGQ(MOPERQ) MSGTYPE(*INFO)
 
/* Initialise COB scheduler flag in ACCOBT to blank */
 
                   IF         COND(&S01491 *EQ 'Y') THEN(DO)
                      CHGDTAARA  DTAARA(ACCOBT (2 1)) VALUE(' ')
                   ENDDO
 
/**********        SBMJOB     CMD(CALL PGM(CBC0010)) JOB(CBC0010) +   /*091688*/
/**********                     JOBD(MEODD) MSGQ(*NONE) RTGDTA(*JOBD) /*091688*/
/******************SBMJOB     CMD(CALL PGM(CBC0010)) JOB(COBSCHED) +
/******************             JOBD(MEODD) MSGQ(*NONE) +  /*091688*/ /*098266*/
/******************                          RTGDTA(*JOBD) /*091688*/ /*098266*/
/**********        SBMJOB     CMD(CALL PGM(CBC0010)) JOB(COBSCHED) +  /*099150*/
/**********                JOBD(MEODD) MSGQ(*NONE) RTGDTA(QCMD)/*098266*099150*/
/* */                                                                 /*101260*/
/* If user specified on MEODD then use */                             /*101260*/
/* */                                                                 /*101260*/
/* */                                                                 /*102568*/
/* Use API instead of command to be V3R1M0 compliant */               /*102568*/
/* */                                                                 /*102568*/
/************RTVJOBD    JOBD(MEODD) USER(&USER)              *101260*  *102568*/
             CHGVAR     VAR(&RTN_BIN) VALUE(X'00000000')              /*102568*/
             CHGVAR     VAR(%SST(&ERROR2 1 4)) VALUE(&RTN_BIN)        /*102568*/
             CHGVAR     VAR(&RTN_BIN) VALUE(X'00000200')              /*102568*/
/* */                                                                 /*102568*/
             CALL       PGM(QWDRJOBD) PARM(&RTN_INFO &RTN_BIN +
                          &FORMAT &JOBD &ERROR2)                      /*102568*/
             MONMSG     MSGID(CPF0001) EXEC(CHGVAR +
                          VAR(%SST(&RTN_INFO 29 10)) VALUE('*RQD'))   /*102568*/
             CHGVAR     VAR(&USER) VALUE(%SST(&RTN_INFO 29 10))       /*102568*/
/* */                                                                 /*102568*/
/************IF         COND(&USER *EQ '*RQD      ') THEN(DO)/*101260   110242*/
/*************     SBMJOB     JOB(COBSCHED) JOBD(MEODD) +             /*110242*/
/*************                 RTGDTA(MULTILANGUAGE) RQSDTA('CALL +   /*110242*/
/*************            PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' + /*110242*/
/*************        '' '' '' '' '' '' '' '')') MSGQ(*NONE)*/ /*099150 110242*/
/************ENDDO                                             /*101260 110242*/
/************ELSE       CMD(DO)                                /*101260 110242*/
/************SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +       /*110242*/
/*************            RTGDTA(MULTILANGUAGE) RQSDTA('CALL +        /*110242*/
/*************            PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' + /*110242*/
/*************       '' '' '' '' '' '' '' '')') MSGQ(*NONE) */ /*101260 110242*/
/************ENDDO                                             /*101260 110242*/
                                                                      /*110242*/
             IF         COND(&USER *EQ '*RQD      ') THEN(DO)         /*110242*/
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
             ENDDO                                                    /*110242*/
             ELSE       CMD(DO)                                       /*110242*/
/************   SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +                        /*CSC023*/
/************                RTGDTA(MULTILANGUAGE) RQSDTA('CALL +                         /*CSC023*/
/************                PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +                  /*CSC023*/
/************                '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +                  /*CSC023*/
/************                MSGQ(*NONE)                              /*110242*/          /*CSC023*/
                SBMJOB     JOB(COBSCHED) JOBD(MEODD) USER(*JOBD) +
                             RTGDTA(MULTILANGUAGE) RQSDTA('CALL +
                             PGM(MLC0000) PARM(''SCC0107'' ''CBC0010'' +
                             '' '' '' '' '' '' '' '')') INLLIBL(*JOBD) +
                             MSGQ(*NONE) OUTQ(*JOBD)                                      /*CSC023*/
             ENDDO                                                    /*110242*/
 
/* Change CBSTAT position 17 (scheduler active) to 'Y' */
 
                   CHGDTAARA  DTAARA(CBSTAT (17 1)) VALUE('Y')
 
/* Change DTAARA/CBSTAT to show COB running normally and no halts */
/* in operation                                                   */
 
                   CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('N')
                   CHGDTAARA  DTAARA(CBSTAT (20 1)) VALUE('N')
                ENDDO
             ENDDO
 
             CHGVAR     VAR(&MSGD) +
                          VALUE('                                     -
                                 REFRESH         ')
 
             GOTO       CMDLBL(STRMON)
 
/* Scheduler active tag */
SCHACT:
             CHGVAR     VAR(&MSGD) +
                          VALUE('                                     -
                                 RESTART         ')
 
             CALL       PGM(QSNDDTAQ) PARM('CBDTQD    ' '*LIBL     ' +
                          &DTQDLEN &MSGD)
 
STRMON:
             IF         COND(&S01491 *EQ 'Y') THEN(DO)
 
/* Attach break handling program ACC0010 to QSYSOPR */
 
/***************CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK) PGM(ACC0010)    *098705*/
/***************CHGMSGQ    MSGQ(QSYSOPR) PGM(ACC0010)      /*098705*/ /*099768*/
                CHGMSGQ    MSGQ(QSYSOPR) DLVRY(*BREAK) PGM(ACC0010)   /*099768*/
                MONMSG     MSGID(CPF0000)
 
                ALCOBJ     OBJ((AC002 *DTAARA *EXCL)) WAIT(30)
                MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(ALC2))
 
                DLCOBJ     OBJ((AC002 *DTAARA *EXCL))
/***************SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +      /*110242*/
/*************               JOBD(MEODD) RTGDTA(*JOBD) MSGQ(*NONE)    /*110242*/
/************   SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +                          /*CPK014*/
/************              JOBD(MEODD) RTGDTA(*JOBD) INLLIBL(*JOBD) +                     /*CPK014*/
/************              MSGQ(*NONE)                                /*110242*/          /*CPK014*/
/************   SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +                          /*CSC023*/
/************             JOBD(MEODD) USER(*JOBD) RTGDTA(*JOBD) +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(*NONE)                           /*CPK014*/ /*CSC023*/
                SBMJOB     CMD(CALL PGM(ACC0002)) JOB(ACC0002) +
                          JOBD(MEODD) USER(*JOBD) RTGDTA(*JOBD) +
                          INLLIBL(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                          /*CSC023*/
 
 ALC2:       ENDDO
 
/* Receive message from DTAQ/CBDTQD */
 
 
/* Value is 'T' if end of monitor requested */
 
LOOP:        CALL       PGM(QRCVDTAQ) PARM('MONBCHQ ' '*LIBL   ' +
                          X'00001F' &DATA &WAIT2)
 
             IF         COND(&DATA *EQ 'T') THEN(DO)
                CHGVAR     VAR(&ALL) VALUE('*ALL      ')
                CHGVAR     VAR(%SST(&PARM 1 7)) VALUE('END    ')
                CHGVAR     VAR(%SST(&PARM 38 2)) VALUE('99')
                CALL       PGM(CBC0525) PARM(&ALL &PARM)
                IF         COND(&S01491 *EQ 'Y') THEN(DO)             /*089645*/
/**********        CALL      PGM(AC0007) PARM('CBCMONB   ' 'N')/*089645*091688*/
                   CALL       PGM(AC0007) PARM('COBMONITOR' 'N')      /*091688*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                                CMDLBL(ABNOR))                        /*089645*/
                ENDDO                                                 /*089645*/
                GOTO       CMDLBL(ENDP)
             ENDDO
 
             CHGVAR     VAR(&DATA) VALUE(' ')
 
/* */                                                                 /*DJB005*/
/* Loop when data present */                                          /*DJB005*/
/* */                                                                 /*DJB005*/
LOOP_DTA:                                                             /*DJB005*/
             CALL       PGM(QRCVDTAQ) PARM('CBDTQD    ' '*LIBL     ' +
                          &DTQDLEN &MSGD &WAIT)
 
/* Ensure CBRECV is updated */                                                            /*196795*/
                                                                                          /*196795*/
                RTVDTAARA  DTAARA(CBTRAN) RTNVAR(&CBTRAN)                                 /*196795*/
                MONMSG     MSGID(CPF0000)                                                 /*196795*/
                                                                                          /*196795*/
                CHGDTAARA  DTAARA(CBRECV) VALUE(&CBTRAN)                                  /*196795*/
                MONMSG     MSGID(CPF0000)                                                 /*196795*/
                                                                                          /*196795*/
/* Call the monitor */
 
             CHGVAR     VAR(&DOMNASA) VALUE(&DOMNAS)
 
             CALL       PGM(CBMONB) PARM(&JOB &MSGD &DOMNASA)
 
/* Move default msg of 'REFRESH' into &MSGD in case of DTAQ timeout */
 
             CHGVAR     VAR(&MSGD) +
                          VALUE('                                     -
                                 REFRESH         ')
/* */                                                                 /*DJB005*/
/* If data then loop */                                               /*DJB005*/
/* */                                                                 /*DJB005*/
             IF         COND(&DTQDLEN *GT 0) THEN(DO)                 /*DJB005*/
             GOTO       CMDLBL(LOOP_DTA)                              /*DJB005*/
             ENDDO                                                    /*DJB005*/
 
/* Retrieve DTAARA/CBSTAT to see if the scheduler is active */
 
             RTVDTAARA  DTAARA(CBSTAT (17 1)) RTNVAR(&SCHSTS)
             RTVDTAARA  DTAARA(CBSTAT (20 1)) RTNVAR(&HLTSTS)
 
/* If scheduler is active and no DB errors, go to LOOP tag */
 
             IF         COND((&SCHSTS *EQ 'Y') *AND +
                          (%SWITCH(XXXXXX00))) THEN(DO)
 
/* Control number of users */
 
                CALL       PGM(CBC0516)
 
                RTVDTAARA  DTAARA(CBTRAN) RTNVAR(&CBTRAN)
 
                CHGDTAARA  DTAARA(CBRECV) VALUE(&CBTRAN)
                MONMSG     MSGID(CPF0000)
 
/* Control Job activity */
 
                CALL       PGM(CBC0513) PARM(&DOMNASA &ERROR)
 
/**Send*data's to main data queue  */                                                     /*196795*/
/************                                                                             /*196795*/
/************   CALL       PGM(CBC0517)                                                   /*196795*/
 
 
 BYPASS:        GOTO       CMDLBL(LOOP)
 
             ENDDO
             ELSE       CMD(DO)                                       /*091570*/
               CALL       PGM(QRCVDTAQ) PARM('MONBCHQ ' '*LIBL   ' +
                            X'00001F' &DATA &WAIT2)                   /*091570*/
 
               IF         COND(&DATA *EQ 'T') THEN(DO)                /*091570*/
                 CHGVAR     VAR(&ALL) VALUE('*ALL      ')             /*091570*/
                 CHGVAR     VAR(%SST(&PARM 1 7)) VALUE('END    ')     /*091570*/
                 CHGVAR     VAR(%SST(&PARM 38 2)) VALUE('99')         /*091570*/
                 CALL       PGM(CBC0525) PARM(&ALL &PARM)             /*091570*/
                 IF         COND(&S01491 *EQ 'Y') THEN(DO)            /*091570*/
                   CALL       PGM(AC0007) PARM('CBCMONB   ' 'N')      /*091570*/
                   IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                                CMDLBL(ABNOR))                        /*091570*/
                ENDDO                                                 /*091570*/
                GOTO       CMDLBL(ENDP)                               /*091570*/
               ENDDO                                                  /*091570*/
             ENDDO                                                    /*091570*/
 
/* If scheduler has ended in error or error occurred in CBCMON/CBMON */
/* perform usual error processing                                    */
 
             RTVDTAARA  DTAARA(CBSTAT (17 1)) RTNVAR(&SCHSTS)
             IF         COND((&SCHSTS *EQ 'E') *OR +
                          (%SWITCH(XXXXXX11))) THEN(DO)
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) +
                                MSGDTA(&MEM) TOMSGQ(MOPERQ)
                ENDDO
 
/*/COPY WNCPYSRC,CBCMONBMPE                                          */
 
ABNOR:
/*/COPY WNCPYSRC,CBCMONBERR                                          */
 
                SNDPGMMSG  MSG('CBCMONB - COB Monitor +
                             terminated abnormally') +
                             TOMSGQ(MOPERQ)
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,CBCMONB003                                           /*S01408*/
/*                                                                    /*S01408*/
                MONMSG     MSGID(CPF0000)
 
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000)
 
/* If the monitor failed, then set the COB status field to 'M' */
 
                RTVDTAARA  DTAARA(CBSTAT (45 1)) RTNVAR(&COBSTS)
                MONMSG     MSGID(CPF0000)
 
                IF         COND(&COBSTS *EQ 'N') THEN(DO)
                   CHGDTAARA  DTAARA(CBSTAT (45 1)) VALUE('M')
                   MONMSG     MSGID(CPF0000)
                ENDDO
 
                GOTO       CMDLBL(ENDP)
             ENDDO
 
             DLYJOB     DLY(10)
 
/************DLTDTAARA  DTAARA(&LIB/CBTRAN)                                               /*196795*/
/************MONMSG     MSGID(CPF0000)                                                    /*196795*/
 
/************DLTDTAARA  DTAARA(&LIB/CBRECV)                                               /*196795*/
/************MONMSG     MSGID(CPF0000)                                                    /*196795*/
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,CBCMONBEND                                          */
 
             DLCOBJ     OBJ((MONCHK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)
 
             ENDPGM
