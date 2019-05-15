/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Retrieve details from a job description')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0040 - Retrieve details of a Job Description             */
/*                                                                   */
/*       The command and program were both lifted from the           */
/*       IBM-supplied QUSRTOOL library of specimen utilities         */
/*       As such it is not as thoroughly supplied with comments      */
/*       as it might be.                                             */
/*                                                                   */
/*       Note further that the validity checking is carried out in   */
/*       this program, not in a separate validity cheker.            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BG6475             Date 11Apr05              */
/*                      CPK018             Date 25Apr04              */
/*                      CSC017             Date 14Feb03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP001 *CREATE     Date 23Dec98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BG6475 - Parameter for retrieval of data is too small.      */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CSC017 - Change to 250 library list.                        */
/*       CUP001 - Introduction of BRIDGE                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOBDFULL &JOBDL &USER &JOBQ &JOBQL +
                          &JOBPTY &OUTPTY &PRTDEV &LOGCLPGM &ACGCDE +
                          &PRTTXT &RTGDTA &RQSDTA &SYNTAX &INLLIBL +
                          &ENDSEV &LOGLVL &LOGSEV &LOGMSGTXT +
                          &INQMSGRPY &OUTQ &OUTQL &HOLD &DATE &SWS +
                          &DEVRCYACN &TSEPOOL &JOBMSGQMX &JOBMSGQFL +
                          &TEXT)
 
/*/COPY WNCPYSRC,RTVJOBDINT                                          */
 
             DCL        VAR(&JOBDFULL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&JOBD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBDL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&QLFDJOBD) TYPE(*CHAR) LEN(20)
             DCL        VAR(&LEN) TYPE(*CHAR) LEN(4)
/**********  DCL        VAR(&PARM) TYPE(*CHAR) LEN(1000)                               */ /*BG6475*/
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(4000)                                  /*BG6475*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBQL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBPTY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OUTPTY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PRTDEV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACGCDE) TYPE(*CHAR) LEN(15)
             DCL        VAR(&RTGDTA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&RQSDTA) TYPE(*CHAR) LEN(80)
             DCL        VAR(&SYNTAX) TYPE(*CHAR) LEN(6)
/************DCL        &INLLIBL *CHAR LEN(275)                                        */ /*CSC017*/
             DCL        VAR(&INLLIBL) TYPE(*CHAR) LEN(2750)                               /*CSC017*/
             DCL        VAR(&ENDSEV) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOGLVL) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LOGSEV) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LOGMSGTXT) TYPE(*CHAR) LEN(7)
             DCL        VAR(&INQMSGRPY) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&HOLD) TYPE(*CHAR) LEN(4)
             DCL        VAR(&DATE) TYPE(*CHAR) LEN(8)
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&LOGCLPGM) TYPE(*CHAR) LEN(4)
             DCL        VAR(&PRTTXT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&DEVRCYACN) TYPE(*CHAR) LEN(13)
             DCL        VAR(&TSEPOOL) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBMSGQMX) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOBMSGQFL) TYPE(*CHAR) LEN(9)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ERRCDE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&WORKD) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&CHAR22) TYPE(*CHAR) LEN(22)
             DCL        VAR(&OFFSET) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&LIBCNT) TYPE(*DEC) LEN(9 0)
             DCL        VAR(&OFFLEN) TYPE(*DEC) LEN(9 0)
 
             DCL        VAR(&ERRORSW) TYPE(*LGL)
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(512)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(512)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&KEYVAR) TYPE(*CHAR) LEN(4)
             DCL        VAR(&KEYVAR2) TYPE(*CHAR) LEN(4)
             DCL        VAR(&RTNTYPE) TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO STDERR1) /* Std err */
 
/*/COPY WNCPYSRC,RTVJOBDMPS                                          */
 
/* Break up input parameters where necessary                        */
             CHGVAR     VAR(&JOBD) VALUE(%SST(&JOBDFULL 1 10))
             CHGVAR     VAR(&JOBDLIB) VALUE(%SST(&JOBDFULL 11 10))
             CHKOBJ     OBJ(&JOBDLIB/&JOBD) OBJTYPE(*JOBD)
             CHGVAR     VAR(&QLFDJOBD) VALUE(&JOBD *CAT &JOBDLIB)
/**********  CHGVAR     VAR(%BIN(&LEN 1 4)) VALUE(1000)                                */ /*BG6475*/
             CHGVAR     VAR(%BIN(&LEN 1 4)) VALUE(4000)                                   /*BG6475*/
             CHGVAR     VAR(%BIN(&ERRCDE 1 4)) VALUE(0)
 
/* Use API to actually access information */
             CALL       QWDRJOBD PARM(&PARM &LEN JOBD0100 +
                          &QLFDJOBD &ERRCDE)
 
/* From API return parameter, access the separate pieces of data   */
JOBDL:
             CHGVAR     VAR(&JOBDL) VALUE(%SST(&PARM 19 10))
             MONMSG     MSGID(MCH3601)
USER:
             CHGVAR     VAR(&USER) VALUE(%SST(&PARM 29 10))
             MONMSG     MSGID(MCH3601)
DATE:
             CHGVAR     VAR(&DATE) VALUE(%SST(&PARM 39 8))
             MONMSG     MSGID(MCH3601)
SWS:
             CHGVAR     VAR(&SWS) VALUE(%SST(&PARM 47 8))
             MONMSG     MSGID(MCH3601)
JOBQ:
             CHGVAR     VAR(&JOBQ) VALUE(%SST(&PARM 55 10))
             MONMSG     MSGID(MCH3601)
JOBQL:
             CHGVAR     &JOBQL %SST(&PARM 65 10)
             MONMSG     MSGID(MCH3601)
JOBPTY:
             CHGVAR     VAR(&JOBPTY) VALUE(%SST(&PARM 76 1))
             MONMSG     MSGID(MCH3601)
HOLD:
             CHGVAR     VAR(&HOLD) VALUE(%SST(&PARM 77 5))
             MONMSG     MSGID(MCH3601)
OUTQ:
             CHGVAR     VAR(&OUTQ) VALUE(%SST(&PARM 87 10))
             MONMSG     MSGID(MCH3601)
OUTQL:
             CHGVAR     VAR(&OUTQL) VALUE(%SST(&PARM 97 10))
             MONMSG     MSGID(MCH3601)
OUTPTY:
             CHGVAR     VAR(&OUTPTY) VALUE(%SST(&PARM 108 1))
             MONMSG     MSGID(MCH3601)
PRTDEV:
             CHGVAR     VAR(&PRTDEV) VALUE(%SST(&PARM 109 10))
             MONMSG     MSGID(MCH3601)
PRTTXT:
             CHGVAR     VAR(&PRTTXT) VALUE(%SST(&PARM 119 30))
             MONMSG     MSGID(MCH3601)
SYNTAX:
             CHGVAR     VAR(&WORKD) VALUE(%BIN(&PARM 149 4))
             IF         COND(&WORKD *EQ -1) THEN(DO)                              /* *NOCHK value */
                CHGVAR     VAR(&SYNTAX) VALUE('*NOCHK')
                MONMSG     MSGID(MCH3601)
             ENDDO                                                                /* *NOCHK value */
             IF         COND(&WORKD *NE -1) THEN(DO)                               /* Digit value */
                EDTVAR     CHROUT(&CHAR22) NUMINP(&WORKD)
                CHGVAR     VAR(&SYNTAX) VALUE(&CHAR22)
                MONMSG     MSGID(MCH3601)
             ENDDO                                                                 /* Digit value */
ENDSEV:
             CHGVAR     VAR(&ENDSEV) VALUE(%BIN(&PARM 153 4))
             MONMSG     MSGID(MCH3601)
LOGSEV:
             CHGVAR     VAR(&LOGSEV) VALUE(%BIN(&PARM 157 4))
             MONMSG     MSGID(MCH3601)
LOGLVL:
             CHGVAR     VAR(&LOGLVL) VALUE(%SST(&PARM 161 1))
             MONMSG     MSGID(MCH3601)
LOGMSGTXT:
             CHGVAR     VAR(&LOGMSGTXT) VALUE(%SST(&PARM 162 10))
             MONMSG     MSGID(MCH3601)
LOGCLPGM:
             CHGVAR     VAR(&LOGCLPGM) VALUE(%SST(&PARM 172 10))
             MONMSG     MSGID(MCH3601)
INQMSGRPY:
             CHGVAR     VAR(&INQMSGRPY) VALUE(%SST(&PARM 182 10))
             MONMSG     MSGID(MCH3601)
DEVRCYACN:
             CHGVAR     VAR(&DEVRCYACN) VALUE(%SST(&PARM 192 13))
             MONMSG     MSGID(MCH3601)
TSEPOOL:
             CHGVAR     VAR(&TSEPOOL) VALUE(%SST(&PARM 205 10))
             MONMSG     MSGID(MCH3601)
ACGCDE:
             CHGVAR     VAR(&ACGCDE) VALUE(%SST(&PARM 215 15))
             MONMSG     MSGID(MCH3601)
RTGDTA:
             CHGVAR     VAR(&RTGDTA) VALUE(%SST(&PARM 230 80))
             MONMSG     MSGID(MCH3601)
JOBMSGQMX:
             CHGVAR     VAR(&WORKD) VALUE(%BIN(&PARM 377 4))
             IF         COND(&WORKD *EQ 0) THEN(DO)                              /* Special value */
                CHGVAR     VAR(&JOBMSGQMX) VALUE('*SYSVAL')
                MONMSG     MSGID(MCH3601)
             ENDDO                                                               /* Special value */
             IF         COND(&WORKD *NE 0) THEN(DO)                                     /* Number */
/* TAA Tool command */
                EDTVAR     CHROUT(&CHAR22) NUMINP(&WORKD)
                CHGVAR     VAR(&JOBMSGQMX) VALUE(&CHAR22)
                MONMSG     MSGID(MCH3601)
             ENDDO                                                                      /* Number */
JOBMSGQFL:
             CHGVAR     VAR(&JOBMSGQFL) VALUE(%SST(&PARM 381 9))
             MONMSG     MSGID(MCH3601)
TEXT:
             CHGVAR     VAR(&TEXT) VALUE(%SST(&PARM 310 50))
             MONMSG     MSGID(MCH3601)
INLLIBL:
             CHGVAR     VAR(&OFFSET) VALUE(%BIN(&PARM 361 4))
             CHGVAR     VAR(&OFFSET) VALUE(&OFFSET + 1)
             CHGVAR     VAR(&LIBCNT) VALUE(%BIN(&PARM 365 4))
             CHGVAR     VAR(&OFFLEN) VALUE(11 * &LIBCNT)
             CHGVAR     VAR(&INLLIBL) VALUE(%SST(&PARM &OFFSET +
                          &OFFLEN))
             MONMSG     MSGID(MCH3601)
RQSDTA:
             CHGVAR     VAR(&OFFSET) VALUE(%BIN(&PARM 369 4))
             CHGVAR     VAR(&OFFSET) VALUE(&OFFSET + 1)
             CHGVAR     VAR(&OFFLEN) VALUE(%BIN(&PARM 373 4))
             CHGVAR     VAR(&RQSDTA) VALUE(%SST(&PARM &OFFSET &OFFLEN))
             MONMSG     MSGID(MCH3601)
             RMVMSG     CLEAR(*ALL)
 
/*/COPY WNCPYSRC,RTVJOBDMPE                                          */
 
             GOTO       CMDLBL(END)
 
/* Standard error handling routine */
STDERR1:
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE)
             CHGVAR     VAR(&ERRORSW) VALUE('1')                         /* Set to fail on error. */
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) KEYVAR(&KEYVAR)
 
STDERR2:
             RCVMSG     MSGTYPE(*PRV) MSGKEY(&KEYVAR) RMV(*NO) +
                          KEYVAR(&KEYVAR2) MSG(&MSG) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          RTNTYPE(&RTNTYPE) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             IF         COND(&RTNTYPE *NE '02') THEN(GOTO +
                          CMDLBL(STDERR3))
             IF         COND(&MSGID *NE ' ') THEN(SNDPGMMSG +
                          MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG))
             IF         COND(&MSGID *EQ ' ') THEN(SNDPGMMSG +
                          MSG(&MSG) MSGTYPE(*DIAG))
             RMVMSG     MSGKEY(&KEYVAR2)
 
STDERR3:
             RCVMSG     MSGKEY(&KEYVAR) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
/*/COPY WNCPYSRC,RTVJOBDERR                                          */
 
/* Abnormal termination */
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,RTVJOBDEND                                          */
 
             ENDPGM
