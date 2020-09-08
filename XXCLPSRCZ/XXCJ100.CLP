/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE Next Capitalisation Date update')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Retail Module                                       */
/*                                                                   */
/********RECJ100*-*NEXT*CAPITALISATION*DATE*UPDATE********************/ /*EML110*/
/*       XXCJ100 - NEXT CAPITALISATION DATE UPDATE                   */ /*EML110*/
/*                                                                   */
/********(c)*Misys*International*Banking*Systems*Ltd.*2005************/ /*EML110*/
/*       (c) Finastra International Limited 2018                     */ /*EML110*/
/*                                                                   */
/*       Last Amend No. EML110             Date 20Jan20              */
/*       Prev Amend No. TFJ11B  *CREATE    Date 17Jan07              */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       EML110 - Account Balance Pooling. Upgrade to FBM 2.1        */
/*       TFJ11B - Retail Interest Capitalisation Date Change         */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &RSEQ &RLEV &RENT)

/*           DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Misys +
                          International Banking Systems Ltd. 2005') */ /*EML110*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2018') /*EML110*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
             DCL        VAR(&PRTTXT) TYPE(*CHAR) LEN(30)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)                /*CCB009*/
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)                /*CCB009*/
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')      /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare variable CCB009 - flag for switchable feature           */ /*CCB009*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/                                                                  /*CCB009*/
/* Declare job name, user and number for remove journal changes    */ /*CCB009*/
/**/                                                                  /*CCB009*/
             DCL        VAR(&CCB009JOB) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009USR) TYPE(*CHAR) LEN(10)           /*CCB009*/
             DCL        VAR(&CCB009NBR) TYPE(*CHAR) LEN(6)            /*CCB009*/
             DCL        VAR(&CB0180DA) TYPE(*CHAR) LEN(26)            /*CCB009*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)              /*CCB009*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)             /*CCB009*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&REPORT) TYPE(*CHAR) LEN(1)

/* Global error trap                                                 */

             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNORMAL))
/**/                                                                  /*CCB009*/
/** Check for Switchable feature CCB009.                           */ /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/

             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO) +
                          PRTTXT(&PRTTXT)
             CHGJOB     PRTTXT(*BLANK)

/*           SNDMSG     MSG('RECJ100 - Next Capitalisation Date Update') +
                          TOMSGQ(MRUNQ) */ /*EML110*/
             SNDMSG     MSG('XXCJ100 - Next Capitalisation Date Update') +
                          TOMSGQ(MRUNQ) /*EML110*/
/* Get system ID to build JLIB name                                  */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&TOLIB) VALUE(&PREFIX *TCAT 'JLIB')

             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/*   If Restart, Remove Journalled Changes   */                       /*CCB009*/
/**/                                                                  /*CCB009*/
                IF         COND(&STAT *EQ 'Y') THEN(DO)               /*CCB009*/
/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/* Retrieve data area CB0180DA from QTEMP.                         */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVDTAARA  DTAARA(QTEMP/CB0180DA) RTNVAR(&CB0180DA)      /*CCB009*/
/**/                                                                  /*CCB009*/
/* If data area is not blank, calculate the job name, user and no. */ /*CCB009*/
/* of the previous run of this component.                             /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CB0180DA *NE ' ') THEN(DO)              /*CCB009*/
/**/                                                                  /*CCB009*/
             CHGVAR     VAR(&CCB009JOB) VALUE(%SST(&CB0180DA 1 10))   /*CCB009*/
             CHGVAR     VAR(&CCB009USR) VALUE(%SST(&CB0180DA 11 10))  /*CCB009*/
             CHGVAR     VAR(&CCB009NBR) VALUE(%SST(&CB0180DA 21 6))   /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/**/                                                                  /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the first journal entry sequence number               */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)                          /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&FINISH) VALUE(0)                         /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAB)) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/* Ensure that no pending changes exist                              */

/*              RMVJRNCHG  JRN(JRECJ100) FILE(ACCNTAB) */ /*EML110*/
                RMVJRNCHG  JRN(JXXCJ100) FILE(ACCNTAB) /*EML110*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801)
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/

/* End journal all files if previous error occured                   */

/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/*              ENDJRNPF   FILE(*ALL) JRN(JRECJ100) */ /*EML110*/
                ENDJRNPF   FILE(*ALL) JRN(JXXCJ100) /*EML110*/
             MONMSG MSGID(CPF0000)

/* Delete and recreate journal and receivers                         */

/*           DLTJRN     JRN(JRECJ100) */ /*EML110*/
             DLTJRN     JRN(JXXCJ100) /*EML110*/
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
/*           DLTJRNRCV  JRNRCV(JRRECJ100) */ /*EML110*/
             DLTJRNRCV  JRNRCV(JRXXCJ100) /*EML110*/
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
/*           CRTJRNRCV  JRNRCV(&TOLIB/JRRECJ100) */ /*EML110*/
             CRTJRNRCV  JRNRCV(&TOLIB/JRXXCJ100) /*EML110*/
/*           CRTJRN     JRN(&TOLIB/JRECJ100) JRNRCV(&TOLIB/JRRECJ100) */ /*EML110*/
             CRTJRN     JRN(&TOLIB/JXXCJ100) JRNRCV(&TOLIB/JRXXCJ100) /*EML110*/
/*           STRJRNPF   FILE(ACCNTAB) JRN(JRECJ100) IMAGES(*BOTH) OMTJRNE(*OPNCLO) */ /*EML110*/
             STRJRNPF   FILE(ACCNTAB) JRN(JXXCJ100) IMAGES(*BOTH) OMTJRNE(*OPNCLO) +
                          /*EML110*/
             ENDDO                                                    /*CCB009*/
/**/

             CHGVAR     VAR(&STAT) VALUE('Y')                         /*CCB009*/
/**/                                                                  /*CCB009*/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)           /*CCB009*/
/**/                                                                  /*CCB009*/
/*           CLRPFM     FILE(REIORCPP) */ /*EML110*/
             CLRPFM     FILE(XXIORCPP) /*EML110*/
             MONMSG     CPF0000

             CHGVAR     VAR(&REPORT) VALUE(' ')
/*           CALL       PGM(REJ100) PARM(&REPORT) */ /*EML110*/
             CALL       PGM(XXJ100) PARM(&REPORT) /*EML110*/

             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             IF         COND(&REPORT *NE 'N') THEN(DO)
/*              CALL       PGM(REJ100P) PARM(&RSEQ) */ /*EML110*/
                CALL       PGM(XXJ100P) PARM(&RSEQ) /*EML110*/
             ENDDO
             ENDDO

             IF  COND(*NOT %SWITCH(XXXXXX00)) THEN(DO)
/*              SNDMSG     MSG('RECJ100 ended abnormally for job ' *CAT &JOBNO +
                             *TCAT '/' *TCAT &USER *TCAT '/' *TCAT &JOB *TCAT '.') +
                             TOMSGQ(MOPERQ MRUNQ) */ /*EML110*/
                SNDMSG     MSG('XXCJ100 ended abnormally for job ' *CAT &JOBNO +
                             *TCAT '/' *TCAT &USER *TCAT '/' *TCAT &JOB *TCAT '.') +
                             TOMSGQ(MOPERQ MRUNQ) /*EML110*/

/**/                                                                  /*CCB009*/
/* If Feature CCB009 is 'on' (close of business journaling),       */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *EQ '       ') THEN(DO)          /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve attributes of current job.                            */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJOBA    JOB(&CCB009JOB) USER(&CCB009USR) +
                          NBR(&CCB009NBR)                             /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the most recent journal entry sequence number         */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&START)                           /*CCB009*/
/**/                                                                  /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&START) VALUE(0)                          /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Retrieve the first journal entry sequence number               */ /*CCB009*/
/*  for the specific job.                                          */ /*CCB009*/
/**/                                                                  /*CCB009*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*FIRST) +
                          TOENT(*LAST) SEARCH(*ASCEND) +
                          JOB(&CCB009NBR/&CCB009USR/&CCB009JOB) +
                          RTNSEQNBR(&FINISH)                          /*CCB009*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)               /*CCB009*/
             CHGVAR     VAR(&FINISH) VALUE(0)                         /*CCB009*/
             ENDDO                                                    /*CCB009*/
/**/                                                                  /*CCB009*/
/*  Remove journaled changes.                                      */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                    /*CCB009*/
             RMVJRNCHG  JRN(ICJRN) FILE(ACCNTAB) +
                          FROMENT(&START) TOENT(&FINISH)              /*CCB009*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041) +
                                                                      /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ENDDO                                                    /*CCB009*/
             ELSE       CMD(DO)                                       /*CCB009*/
/*              RMVJRNCHG  JRN(JRECJ100) FILE(ACCNTAB) */ /*EML110*/
                RMVJRNCHG  JRN(JXXCJ100) FILE(ACCNTAB) /*EML110*/
                MONMSG     (CPF7049)
             ENDDO                                                    /*CCB009*/
             ENDDO

             ELSE       CMD(DO)
/*              SNDMSG     MSG('RECJ100 - Next Capitalisation Date Update +
                             complete') TOMSGQ(MRUNQ) */ /*EML110*/
                SNDMSG     MSG('XXCJ100 - Next Capitalisation Date Update +
                             complete') TOMSGQ(MRUNQ) /*EML110*/
             ENDDO

/**/                                                                  /*CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),   */ /*CCB009*/
/**/                                                                  /*CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             ENDJRNPF   FILE(*ALL) JRN(JRECJ100)
             MONMSG MSGID(CPF0000)
/*           DLTJRN     JRN(JRECJ100) */ /*EML110*/
             DLTJRN     JRN(JXXCJ100)
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*DFT)
/*           DLTJRNRCV  JRNRCV(JRRECJ100) */ /*EML110*/
             DLTJRNRCV  JRNRCV(JRXXCJ100) /*EML110*/
             MONMSG MSGID(CPF0000)
             CHGJOB     INQMSGRPY(*RQD)
             ENDDO                                                    /*CCB009*/
             CHGJOB     PRTTXT(&PRTTXT)

                 CHGVAR     VAR(&STAT) VALUE('N')                     /*CCB009*/
/**/                                                                  /*CCB009*/
                 CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)       /*CCB009*/
/**/                                                                  /*CCB009*/
             RETURN

/* ABNORMAL:   SNDMSG     MSG('RECJ100 ended abnormally for job ' *CAT &JOBNO *TCAT +
                          '/' *TCAT &USER *TCAT '/' *TCAT &JOB *TCAT '.') +
                          TOMSGQ(MOPERQ MRUNQ)  */ /*EML110*/
 ABNORMAL:   SNDMSG     MSG('XXCJ100 ended abnormally for job ' *CAT &JOBNO *TCAT +
                          '/' *TCAT &USER *TCAT '/' *TCAT &JOB *TCAT '.') +
                          TOMSGQ(MOPERQ MRUNQ) /*EML110*/
             CHGJOB     SWS(XXXXXXX1)
             MONMSG     MSGID(CPF0000 MCH0000)

/*           CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International Banking +
                          Systems Ltd.') */ /*EML110*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2018') /*EML110*/
 END:        ENDPGM
