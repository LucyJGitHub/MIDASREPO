/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas COB Submit COB and Warning jobs')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Module                            */
/*                                                                   */
/*       CBC0005 - Submit COB and Warning JOB                        */
/*                                                                   */
/*       Function: This program submits 2 jobs : SCD_COB and SCD_WMSG*/
/*                                                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG10848R          Date 02May06              */
/*       Prev Amend No. BUG10848           Date 15Mar06              */
/*                      CCB014  *Create    Date 25Apr05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG10848R - Retrieved the UserId who runs the schedule      */
/*                   batch for COB.                                  */
/*                 - Additional code for Schedule not functioning    */
/*                   for Global Processing.                          */
/*       BUG10848 - Schedule not functioning for Global Processing   */
/*       CCB014 - Pre-Scheduled Batch Close Of Business              */
/*                                                                   */
/*********************************************************************/
/* MODE 'E' : End scheduling                                         */
/*      'S' : (Re)Start scheduling                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
             DCL        VAR(&DLYCOB) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DATE) TYPE(*DEC) LEN(5) VALUE(0)
             DCL        VAR(&DATETO) TYPE(*DEC) LEN(6) VALUE(0)
             DCL        VAR(&DATETOC) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DATE3) TYPE(*DEC) LEN(7) VALUE(0)
             DCL        VAR(&DATFMT) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIME) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIMW) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TIMH) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&TIMM) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&WARN) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(1) VALUE('D')
             DCL        VAR(&JOBNAM) TYPE(*CHAR) LEN(26) VALUE(' ')
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(06)
             DCL        VAR(&IUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             RTVDTAARA  DTAARA(DLYCOB) RTNVAR(&DLYCOB)
 
/** Endjob of Previous COB JOB if exists */
 
             CHGVAR     VAR(&JOB) VALUE(%SST(&DLYCOB 16 10))
             CHGVAR     VAR(&USER) VALUE(%SST(&DLYCOB 26 10))
             CHGVAR     VAR(&NBR) VALUE(%SST(&DLYCOB 36 06))
             CHGMSGQ    MSGQ(*USRPRF) DLVRY(*HOLD)
             MONMSG     MSGID(CPF0000)
             CHGMSGQ    MSGQ(*WRKSTN) DLVRY(*HOLD)
             MONMSG     MSGID(CPF0000)
             ENDJOB     JOB(&NBR/&USER/&JOB)
             MONMSG     MSGID(CPF0000)
             RTVJOBA    USER(&IUSER)
             IF         COND(&MODE *EQ 'E') THEN(DO)
             SNDMSG     MSG('Scheduling of COB with Ref. ' *CAT &JOB +
                          *TCAT '/' *TCAT &USER *TCAT '/' *TCAT +
                          &NBR *CAT ' stopped by a manual +
                          request of user ' *CAT &IUSER) +
                          TOMSGQ(MOPERQ MRUNQ)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('N')
             CHGDTAARA  DTAARA(DLYCOB (16 26)) VALUE(' ')
             CHGDTAARA  DTAARA(DLYCOB (42 26)) VALUE(' ')
             GOTO       CMDLBL(STOPMSG)
             ENDDO
             IF         COND(&MODE *EQ 'S') THEN(DO)
             SNDMSG     MSG('Scheduling of COB initiated/changed by +
                       user ' *CAT &IUSER) TOMSGQ(MOPERQ MRUNQ)
             ENDDO
 
/** Prepare Submit of COB */
 
             CHGVAR     VAR(&DATE) VALUE(%SST(&DLYCOB 3 5))
             CHGVAR     VAR(&TIME) VALUE(%SST(&DLYCOB 8  6))
             CALL       PGM(ZDATE2) PARM(&DATE &FMT &DATETO &DATE3)
             CHGVAR     VAR(&DATETOC) VALUE(&DATETO)
             CVTDAT     DATE(&DATETOC) TOVAR(&DATFMT) FROMFMT(*DMY) +
                          TOFMT(*JOB) TOSEP(*NONE)
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
/**********  SBMJOB     CMD(CALL PGM(CBC0003)) JOB(SCD_COB) +
                          JOBD(MEODD) JOBQ(MCOBQ) USER(*JOBD) +
                          RTGDTA(QCMDB) SCDDATE(&DATFMT) SCDTIME(&TIME) */              /*BUG10848*/
             SBMJOB     CMD(CALL PGM(CBC0003)) JOB(SCD_COB) +
                          JOBD(MEODD) JOBQ(MCOBQ) OUTQ(*JOBD) +
                          USER(*JOBD) RTGDTA(QCMDB) +
                          SCDDATE(&DATFMT) SCDTIME(&TIME)                               /*BUG10848*/
             MONMSG     MSGID(CPF1338 CPF1634) EXEC(DO)
             SNDMSG     MSG('Scheduling of COB ended abnormally. +
                          Scheduled date is incompatible with the +
                          system date. Review the actual status in +
                          Input Cycle') TOMSGQ(MOPERQ MRUNQ)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('Y')
             CHGDTAARA  DTAARA(DLYCOB (16 26)) VALUE(' ')
             CHGDTAARA  DTAARA(DLYCOB (42 26)) VALUE(' ')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             MONMSG     MSGID(CPF1338) EXEC(DO)
             SNDMSG     MSG('Scheduling of COB ended abnormally. +
                          Review the actual status in Input Cycle') +
                          TOMSGQ(MOPERQ MRUNQ)
             CHGDTAARA  DTAARA(DLYCOB (2 1)) VALUE('Y')
             CHGDTAARA  DTAARA(DLYCOB (16 26)) VALUE(' ')
             CHGDTAARA  DTAARA(DLYCOB (42 26)) VALUE(' ')
             GOTO       CMDLBL(ENDPGM)
             ENDDO
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&JOBNAM) +
                          MSGID(&MSGID)
 
/** Update DLYCOB dtaara */
 
             CHGVAR  VAR(%SST(&DLYCOB 2 1)) VALUE('Y')
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGVAR  VAR(%SST(&DLYCOB 16 26)) VALUE(&JOBNAM)
             CHGVAR  VAR(&JOB) VALUE(%SST(&JOBNAM 1 10))
             CHGVAR  VAR(&USER) VALUE(%SST(&JOBNAM 11 10))
             CHGVAR  VAR(&NBR) VALUE(%SST(&JOBNAM 21 06))
             ENDDO
             CHGDTAARA  DTAARA(DLYCOB)  VALUE(&DLYCOB)
             SNDMSG   MSG('COB scheduled to the ' *CAT &DATFMT *CAT +
                          ' at ' *CAT &TIME *CAT ' with Ref. ' *CAT +
                          &JOB *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &NBR) TOMSGQ(MOPERQ MRUNQ)
 
/** Endjob of Previous COBMSG JOB if exists */
 
STOPMSG:     CHGVAR     VAR(&JOB) VALUE(%SST(&DLYCOB 42 10))
             CHGVAR     VAR(&USER) VALUE(%SST(&DLYCOB 52 10))
             CHGVAR     VAR(&NBR) VALUE(%SST(&DLYCOB 62 06))
             ENDJOB     JOB(&NBR/&USER/&JOB)
             MONMSG     MSGID(CPF0000)
             IF         COND(&MODE *EQ 'E') THEN(GOTO CMDLBL(ENDPGM))
 
/** Prepare Submit of Warning Message */
 
             CHGVAR     VAR(&TIMW)  VALUE(&TIME)
             CHGVAR     VAR(&WARN) VALUE(%SST(&DLYCOB 14 2))
             CHGVAR     VAR(&TIMH) VALUE(%SST(&TIME 1 2))
             CHGVAR     VAR(&TIMM) VALUE(%SST(&TIME 3 2))
             CHGVAR     VAR(&TIMM) VALUE(&TIMM - &WARN)
             IF         COND(&TIMM < 0) THEN(DO)
             CHGVAR     VAR(&TIMM) VALUE(60 + &TIMM)
             CHGVAR     VAR(&TIMH) VALUE(&TIMH - 1)
             IF         COND(&TIMH < 0) THEN(DO)
             CHGVAR     VAR(&TIMH) VALUE(24 + &TIMH)
             CHGVAR     VAR(&DATE) VALUE(&DATE - 1)
             CALL       PGM(ZDATE2) PARM(&DATE &FMT &DATETO &DATE3)
             CHGVAR     VAR(&DATETOC) VALUE(&DATETO)
             CVTDAT     DATE(&DATETOC) TOVAR(&DATFMT) FROMFMT(*DMY) +
                          TOFMT(*JOB) TOSEP(*NONE)
             ENDDO
             ENDDO
             CHGVAR     VAR(%SST(&TIMW 1 2)) VALUE(&TIMH)
             CHGVAR     VAR(%SST(&TIMW 3 2)) VALUE(&TIMM)
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
 /********** SBMJOB     CMD(CALL PGM(CBC0001) PARM('I' 'M')) +
                          JOB(SCD_WMSG) JOBD(MEODD) JOBQ(MCOBQ) +
                          USER(*JOBD) RTGDTA(QCMDB) +
                          SCDDATE(&DATFMT) SCDTIME(&TIMW)            */                /*BUG10848R*/
             SBMJOB     CMD(CALL PGM(CBC0001) PARM('I' 'M')) +
                          JOB(SCD_WMSG) JOBD(MEODD) JOBQ(MCOBQ) +
                          OUTQ(*JOBD) USER(*JOBD) RTGDTA(QCMDB) +
                          SCDDATE(&DATFMT) SCDTIME(&TIMW)                              /*BUG10848R*/
             MONMSG     MSGID(CPF1338) EXEC(GOTO CMDLBL(ENDPGM))
             RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&JOBNAM) +
                          MSGID(&MSGID)
             IF         COND(&MSGID *EQ 'CPC1221') THEN(DO)
             CHGVAR  VAR(%SST(&DLYCOB 42 26)) VALUE(&JOBNAM)
             CHGDTAARA  DTAARA(DLYCOB)  VALUE(&DLYCOB)
             CHGVAR  VAR(&JOB) VALUE(%SST(&JOBNAM 1 10))
             CHGVAR  VAR(&USER) VALUE(%SST(&JOBNAM 11 10))
             CHGVAR  VAR(&NBR) VALUE(%SST(&JOBNAM 21 06))
             SNDMSG     MSG('COB WARNING MESSAGE scheduled to the ' +
                          *CAT &DATFMT *CAT ' at ' *CAT &TIMW *CAT +
                          ' with Ref. ' *CAT &JOB *TCAT '/' *TCAT +
                          &USER *TCAT '/' *TCAT &NBR) TOMSGQ(MOPERQ +
                          MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/** Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
              SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CBC0005 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/** Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
 
/** (Set up messages for Midas information screen and call */
/** appropriate module program to display screen)          */
 
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 ENDPGM:     ENDPGM
