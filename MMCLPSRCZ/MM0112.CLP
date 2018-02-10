/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM IC initiation file setup control')           */
/*********************************************************************/
/*                                                                   */
/*       MIDAS/AS400 MM MODULE                                       */
/*                                                                   */
/*       MM0112 - MM INPUT CYCLE INITIATION FILE SETUP CONTROL       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG3806            Date 20Apr05              */
/*                      CSC023             Date 30Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      067098            Date  13Feb96              */
/*                      S01319            DATE 19SEP91               */
/*                      E20773            DATE 05NOV90               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG3806 - Changed Dlyjob from 60 seconds to 1 second        */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*   067098  -  Increment count of no. of submitted jobs before      */
/*              submitting the job, to prevent the value becoming    */
/*              negative if the submitted job has completed before   */
/*              the no. of submitted jobs has been incremented.      */
/*           -  SBMJOB does not require USER(*JOBD) and it can       */
/*              cause authority problems - remove.                   */
/*           -  Remove redundant variable &WWCALL.                   */
/*           S01319 - Remove redundant processing                    */
/*           E20773 - DEFAULT CHANGED ON SBMJOB TO INLLIBL(*JOBD)    */
/*                    & RGDTA(*JOBD)                                 */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TERM)
 
             DCL        VAR(&WWSUBN) TYPE(*DEC) LEN(1)
             DCL        VAR(&WWSUBNA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWSUBER) TYPE(*CHAR) LEN(1)
             DCL        VAR(&WWSDSTAT) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&WWCALL) TYPE(*CHAR) LEN(24)           */ /*067098*/
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*  GLOBAL MONITOR MESSAGE                                          */
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
/**/
/*   Initialize control section of SDSTAT        */
 
             CHGDTAARA  DTAARA(SDSTAT (102 2)) VALUE('0 ')
 
/**/
/* SUBMIT MM0175 - FORWARD BOOK ENQUIRY FILE REBUILD   */
/**/
                                                                      /*E20773*/
/************SBMJOB     JOB(MM0175) JOBD(MJBTCH) JOBQ(MEODQ) +
/************             USER(*JOBD) RQSDTA('CALL MM0175 ''  ''') +
/************             MSGQ(*NONE)                                */
/************SBMJOB     JOB(MM0175) JOBD(MJBTCH) JOBQ(MEODQ) +        /*067098*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +    /*067098*/
/************             MM0175 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)  /*067098*/
                                                                      /*E20773*/
 
             RTVDTAARA  DTAARA(SDSTAT (102 1)) RTNVAR(&WWSUBNA)
             CHGVAR     &WWSUBN   &WWSUBNA
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN+1)
             CHGVAR     &WWSUBNA  &WWSUBN
 
             CHGDTAARA  DTAARA(SDSTAT (102 1)) VALUE(&WWSUBNA)
 
/************SBMJOB     JOB(MM0175) JOBD(MJBTCH) JOBQ(MEODQ) +                            /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MM0175 ''  +                         /*CPK014*/
/************             ''') INLLIBL(*JOBD) MSGQ(*NONE)             /*067098*/          /*CPK014*/
/************SBMJOB     JOB(MM0175) JOBD(MJBTCH) JOBQ(MEODQ) +                            /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MM0175 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)           /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(MM0175) JOBD(MJBTCH) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MM0175 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE) +
                          OUTQ(*JOBD)                                                     /*CSC023*/
/**/
/**MM0174*-*CUSTOMER*EXPOSURE*ENQUIRY*FILE*REBUILD****/               /*S01319*/
/**/
 
                                                                      /*E20773*/
/************SBMJOB     JOB(MM0174) JOBD(MJBTCH) USER(*JOBD) +
/************             JOBQ(MEODQ) +
/************              RQSDTA('CALL MM0174 ''  ''') +
/************               MSGQ(*NONE)                             */
/************SBMJOB     JOB(MM0174) JOBD(MJBTCH) JOBQ(MEODQ) +
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
/************             MM0174 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)*/
                                                           /*E20773*/ /*S01319*/
/************RTVDTAARA  DTAARA(SDSTAT (102 1)) RTNVAR(&WWSUBNA)       /*S01319*/
/************CHGVAR     &WWSUBN   &WWSUBNA                            /*S01319*/
/************CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN+1)                 /*S01319*/
/************CHGVAR     &WWSUBNA  &WWSUBN                             /*S01319*/
 
/************CHGDTAARA  DTAARA(SDSTAT (102 1)) VALUE(&WWSUBNA)        /*S01319*/
 
/**/
/* SUBMIT MM0173 - NEAR DATES AND POSITIONS AND ENQUIRY FILE REBUILD   */
/**/
 
                                                                      /*E20773*/
/************SBMJOB     JOB(MM0173) JOBD(MJBTCH) USER(*JOBD) +
/************             JOBQ(MEODQ) +
/************              RQSDTA('CALL MM0173 ''  ''') +
/************               MSGQ(*NONE)       */
/************SBMJOB     JOB(MM0173) JOBD(MJBTCH) JOBQ(MEODQ) +        /*067098*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +    /*067098*/
/************             MM0173 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)  /*067098*/
                                                                      /*E20773*/
 
             RTVDTAARA  DTAARA(SDSTAT (102 1)) RTNVAR(&WWSUBNA)
             CHGVAR     &WWSUBN   &WWSUBNA
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN+1)
             CHGVAR     &WWSUBNA  &WWSUBN
 
             CHGDTAARA  DTAARA(SDSTAT (102 1)) VALUE(&WWSUBNA)
 
/************SBMJOB     JOB(MM0173) JOBD(MJBTCH) JOBQ(MEODQ) +                            /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MM0173 ''  +                         /*CPK014*/
/************             ''') INLLIBL(*JOBD) MSGQ(*NONE)             /*067098*/          /*CPK014*/
/************SBMJOB     JOB(MM0173) JOBD(MJBTCH) JOBQ(MEODQ) +                            /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MM0173 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)           /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(MM0173) JOBD(MJBTCH) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MM0173 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE) +
                          OUTQ(*JOBD)                                                     /*CSC023*/
/**/
/* SUBMIT MM0194 - LIQUIDITY EXPOSURE ENQUIRY FILE REBUILD   */
/**/
 
                                                                      /*E20773*/
/************SBMJOB     JOB(MM0194) JOBD(MJBTCH) USER(*JOBD) +
/************             JOBQ(MEODQ) +
/************              RQSDTA('CALL MM0194 ''  ''') +
/************               MSGQ(*NONE)                            */
/************SBMJOB     JOB(MM0194) JOBD(MJBTCH) JOBQ(MEODQ) +        /*067098*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +    /*067098*/
/************             MM0194 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)  /*067098*/
                                                                      /*E20773*/
             RTVDTAARA  DTAARA(SDSTAT (102 1)) RTNVAR(&WWSUBNA)
             CHGVAR     &WWSUBN   &WWSUBNA
             CHGVAR     VAR(&WWSUBN) VALUE(&WWSUBN+1)
             CHGVAR     &WWSUBNA   &WWSUBN
 
             CHGDTAARA  DTAARA(SDSTAT (102 1)) VALUE(&WWSUBNA)
 
/************SBMJOB     JOB(MM0194) JOBD(MJBTCH) JOBQ(MEODQ) +                            /*CPK014*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MM0194 ''  +                         /*CPK014*/
/************             ''') INLLIBL(*JOBD) MSGQ(*NONE)             /*067098*/          /*CPK014*/
/************SBMJOB     JOB(MM0194) JOBD(MJBTCH) JOBQ(MEODQ) +                            /*CSC023*/
/************             USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +                        /*CSC023*/
/************             MM0194 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE)           /*CPK014*/ /*CSC023*/
             SBMJOB     JOB(MM0194) JOBD(MJBTCH) JOBQ(MEODQ) +
                          USER(*JOBD) RTGDTA(*JOBD) RQSDTA('CALL +
                          MM0194 ''  ''') INLLIBL(*JOBD) MSGQ(*NONE) +
                          OUTQ(*JOBD)                                                     /*CSC023*/
/**/
/*  When all jobs have been submitted, loop until all jobs complete */
/*  or when error detected                                          */
/**/
 
TAG010:
/**********  DLYJOB     (60) */                                                          /*BUG3806*/
             DLYJOB     (1)                                                              /*BUG3806*/
 
             RTVDTAARA  DTAARA(SDSTAT (102 2)) RTNVAR(&WWSDSTAT)
             CHGVAR     &WWSUBN   (%SST(&WWSDSTAT 1 1))
             CHGVAR     &WWSUBER  (%SST(&WWSDSTAT 2 1))
             IF         ((&WWSUBN *GT 0) *AND (&WWSUBER *NE 'X')) +
                                     THEN(GOTO TAG010)
 
             IF         (&WWSUBER *EQ 'X') THEN(GOTO ERROR)
 
 
/*    Bypass error processing                              */
             GOTO       TAG999
/**/
/*PROCESSING WHEN ERROR HAS OCCURRED                                */
 ERROR:      CHGJOB     SWS(XXXXX1XX)
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (171 10)) VALUE('MM0112    ')
             MONMSG     MSGID(CPF0000)
             CHGDTAARA  DTAARA(*LDA (181 3)) VALUE('001')
             MONMSG     MSGID(CPF0000)
             CHGVAR     VAR(&TERM) VALUE('E')
             MONMSG     MSGID(CPF0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
 TAG999:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
