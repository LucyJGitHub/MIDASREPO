/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Rep last sucs. trans on primary mach')       */
/*********************************************************************/
/*                                                                   */
/*        Midas - Restart Recovery Module                            */
/*                                                                   */
/*       SDC1765 - Control rebuild of access paths using JRNFIL recs */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CSC023             Date 02Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014              ate 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date  10MAY95             */
/*                      S01337             DATE  17APR91             */
/*                      E20391             DATE  26NOV89             */
/*                      E13205             DATE  14/02/89            */
/*                                                                   */
/*********************************************************************/
/*       New Program Overview                                        */
/*                                                                   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       S01408 - Addition of core hook SDC1765MPS                  */
/*       S01337 - SPLIT 'D' LIBRARY INTO 'DP' AND 'DV' LIBRARIES    */
/*       E20391 - RTGDTA(*JOBD) ADDED TO ALL SBMJOB CMDS.           *  *E20391*/
/*       E13205 - Read JRNFIL and for each record place contents    */
/*                in the *LDA and submit a rebuild job.             */
/*                                                                  */
/********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*           Declare variables                                       */
/**/
             DCL        VAR(&FIRST_FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DBPREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
/**********  DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)                 *S01337*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10)               /*S01337*/
/**/
             DCLF       FILE(*LIBL/JRNFIL)
/**/
/*           Global Monitor message                                  */
/**/
             MONMSG     MSGID(MCH0000 CPF0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
/*           Set rebuild flags on file SD1724 to 'N'                 */
/**/
             RTVDTAARA  DTAARA(*LIBL/SDSTAT (6 2)) RTNVAR(&DBPREFIX)
/**********  CHGVAR     VAR(&DLIB) VALUE(&DBPREFIX *CAT 'DLIB')        *S01337*/
             CHGVAR     VAR(&DVLIB) VALUE(&DBPREFIX *CAT 'DVLIB')     /*S01337*/
/**********  CALL       PGM(*LIBL/SD1731) PARM('*ALLOFF' ' ' &DLIB ' + *S01337*/
/**********               ' &RTNCDE)                                   *S01337*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SDC1765MPS                                          */
                                                                      /*S01408*/
             CALL     PGM(*LIBL/SD1731) PARM('*ALLOFF' ' ' &DVLIB ' +
                          ' &RTNCDE)                                  /*S01337*/
             IF         COND(&RTNCDE *EQ '*ERROR') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
/*           Read until end of file                                  */
/**/
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/**/
/*           Clear *LDA and then place JRNFIL record in it           */
/**/
             CHGDTAARA  DTAARA(*LDA *ALL) VALUE(' ')
             CHGDTAARA  DTAARA(*LDA (1 225)) VALUE(&FILEA)
             CHGDTAARA  DTAARA(*LDA (226 225)) VALUE(&FILEB)
             CHGVAR     VAR(&FIRST_FILE) VALUE(%SST(&FILEA 1 9))
/**/
/*           Submit Job to MEODQ with job description MEODD          */
/**/
/************SBMJOB     JOB(&FIRST_FILE) JOBD(MEODD) JOBQ(MEODQ) +                        /*CPK014*/
/************             RQSDTA('Call SDC1766') INLLIBL(*JOBD) +                         /*CPK014*/
/************             MSGQ(MOPERQ) RTGDTA(*JOBD)                  /*E20391*/          /*CPK014*/
/***********              MSGQ(MOPERQ)                                /*E20391*/
/************SBMJOB     JOB(&FIRST_FILE) JOBD(MEODD) JOBQ(MEODQ) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('Call +                        /*CSC023*/
/************             SDC1766') INLLIBL(*JOBD) MSGQ(MOPERQ)                /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(&FIRST_FILE) JOBD(MEODD) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('Call +
                          SDC1766') INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)               /*CSC023*/
/**/
             GOTO       CMDLBL(READ)
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1765 - Control rebuild of +
                          access paths using JRNFIL recs  - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
