/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Start Loan Manager interface branch jobs')   */
/*********************************************************************/
/*                                                                   */
/*  Midas   - Customer Lending Module                                */
/*                                                                   */
/*  LEC2010 - Lending PC INTERFACE CONTROL                           */
/*                                                                   */
/*  Function: To submit the Lending PC Interface process LEC2010A    */
/*            during input cycle initiation.                         */
/*                                                                   */
/*  Calls:    LEC2010A                                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/*                      216770             Date 08Apr03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      213013             Date 06Dec02              */
/*                 208924            Date  03Sep02                   */
/*                 203561            Date  12Mar02                   */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                 191475            DATE  06Nov01                   */
/*                 CPK014            Date  14Nov01                   */
/*                 193083            Date  22May01                   */
/*                 188473            Date  22May01                   */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 155873            Date  24Feb99                   */
/*                 129195            DATE  20JAN98                   */
/*                 CLE004  *CREATE   DATE  06MAY97                   */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*  216770 - Check status of Loan Manager Server and do not submit   */
/*           job if it is equal to 'C' because of rundate mismatch   */
/*  213013 - Change conditioning of code to update LMxxx so that it  */
/*           depends on existing value being C not on phase being F  */
/*  208924 - Ensure submitted jobs do not auto shut down immediately */
/*  203561 - Send status messages via new program LEC2017 to control */
/*           changes of status within Loan Manager. Enable stopping */
/*           and starting of interface jobs by branch using LMxxx   */
/*           data area (new)                                        */
/*  191475 - Change the process for submitting LEC2010A so that      */
/*           users are not delayed unnecessarily when logging on     */
/*  CPK014 - Release 4 packaging:                                    */
/*           - Ensure that the dtaara picks up the system ownerships.*/
/*  193083 - Improvements to make the interface more robust          */
/*  188473 - Fix to 155873                                           */
/*  155873 - Prevent CL commands from being logged when job          */
/*           LEC2010A is submitted.                                  */
/*  129195 - Do not submit this job if the MQ channel fields are     */
/*           not set up on SDBRCHPD. Use access object to read       */
/*           SDBRCHPD.                                               */
/*  CLE004 - Customer Lending Enhancements - Syndications.           */
/*                                                                   */
/*********************************************************************/
/************PGM                                                                       */ /*193083*/
/************PGM        PARM(&RESETDRIP)                             */        /*193083*/ /*203561*/
             PGM        PARM(&LMSERVER &LMBRCH)                                           /*203561*/
 
             DCL        VAR(&LMBRCH) TYPE(*CHAR) LEN(3)                                   /*203561*/
             DCL        VAR(&LMSERVER) TYPE(*CHAR) LEN(3)                                 /*203561*/
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3) VALUE(' ')
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3) VALUE(' ')
             DCL        VAR(&DTAARA) TYPE(*CHAR) LEN(10) VALUE(' ')
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5) VALUE(' ')                      /*203561*/
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1) VALUE('N')                      /*203561*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OWNER) TYPE(*CHAR) LEN(10)                                   /*CPK014*/
/************DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                                 */ /*193083*/
             DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                                    /*203561*/
             DCL        VAR(&JSEQNO) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&W#LEJNSQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&#BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&RESETDRIP) TYPE(*CHAR) LEN(1)          */         /*193083*/ /*203561*/
             DCL        VAR(&P#RTCD) TYPE(*CHAR) LEN(7)                                   /*203561*/
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)                                  /*193083*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                                 /*193083*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/************DCLF       FILE(SDBRCHPD)                              */
 
/**  Global Monitor Message                                         */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/************SNDPGMMSG  MSG('LEC2010 - Customer Lending PC Interface') +               */ /*193083*/
/************              TOMSGQ(MRUNQ)                                               */ /*193083*/
             SNDPGMMSG  MSG('LEC2010 - Start Customer Lending PC +
                          Interface') TOMSGQ(MRUNQ)                                       /*193083*/
 
             RTVJOBA    TYPE(&JOBTYPE)                                                    /*193083*/
             CHGJOB     SWS(00000000)
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB')
 
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)                        */ /*203561*/ /*213013*/
             RTVOBJD    OBJ(&DMLIB) OBJTYPE(*LIB) OWNER(&OWNER)                           /*203561*/
 
/* Processing for single branch request */                                                /*203561*/
                                                                                          /*203561*/
             IF         COND(&LMSERVER *NE 'ALL') THEN(DO)                                /*203561*/
                                                                                          /*203561*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &LMSERVER)                                                      /*203561*/
 
             CHGVAR     VAR(&DTAARA) VALUE('LEC2010' *CAT +
                          &LMSERVER)                                                      /*203561*/
                                                                                          /*203561*/
/* Create the branch job data area if it doesn't already exist                            /*203561*/
                                                                                          /*203561*/
             CHKOBJ     OBJ(&DTAARA) OBJTYPE(*DTAARA)                                     /*203561*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*203561*/
                CRTDTAARA  DTAARA(&DMLIB/&DTAARA) TYPE(*CHAR) LEN(1) +
                          VALUE('N')                                                      /*203561*/
/* Correct the ownership of the dtaara */                                                 /*203561*/
                CHGOBJOWN  OBJ(&DMLIB/&DTAARA) OBJTYPE(*DTAARA) +
                          NEWOWN(&OWNER)                                                  /*203561*/
             ENDDO                                                                        /*203561*/
                                                                                          /*203561*/
             ALCOBJ     OBJ((&DTAARA *DTAARA *EXCL)) WAIT(0)                              /*203561*/
                                                                                          /*203561*/
/* If unable to allocate, job is already running */                                       /*203561*/
                                                                                          /*203561*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(DRIP))                            /*203561*/
             DLCOBJ     OBJ((&DTAARA *DTAARA *EXCL))                                      /*203561*/
                                                                                          /*203561*/
/**/                                                                                      /*203561*/
/** Check if LM Server Interface has been disabled                  */                    /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(LEC2019) PARM(&LMSERVER &DISABLED)                            /*203561*/
             IF         COND(&DISABLED *NE 'Y') THEN(DO)                                  /*203561*/
                                                                                          /*216770*/
             RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&PHASE)                            /*216770*/
             IF         COND(&PHASE *NE 'R') THEN(DO)                                     /*216770*/
                                                                                          /*203561*/
             CHGDTAARA  DTAARA(&DTAARA) VALUE('N')                                        /*208924*/
/************SBMJOB     CMD(CALL PGM(LEC2010A) PARM(&LMSERVER +                           /*CSC023*/
/************             &LMBRCH)) JOB(&DTAARA) JOBD(MBATCH) +                           /*CSC023*/
/************             JOBQ(TSJOBQ) USER(*JOBD) +                                      /*CSC023*/
/************             RTGDTA(PCLENDING) LOGCLPGM(*JOBD) +                             /*CSC023*/
/************             MSGQ(*NONE)                                          /*203561*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(LEC2010A) PARM(&LMSERVER +
                          &LMBRCH)) JOB(&DTAARA) JOBD(MBATCH) +
                          JOBQ(TSJOBQ) USER(*JOBD) +
                          RTGDTA(PCLENDING) LOGCLPGM(*JOBD) +
                          MSGQ(*NONE) OUTQ(*JOBD)                                         /*CSC023*/
             ENDDO                                                                        /*216770*/
/************RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&PHASE)      */         /*213013*/ /*216770*/
/************IF         COND(&PHASE *EQ 'F') THEN(DO)               */         /*203561*/ /*213013*/
             IF         COND(&PHASE *EQ 'C') THEN(DO)                                     /*213013*/
/**/                                                                                      /*203561*/
/** Send message to Loan Manager to change status to 'N'ormal       */                    /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(LEC2017) PARM(&P#RTCD 'OPEN' &LMSERVER &LMBRCH)               /*203561*/
             IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                          '*SENT')) THEN(GOTO CMDLBL(ABNOR))                              /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with last message sent               */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('OPEN')
             ENDDO
/**/                                                                                      /*203561*/
/** Update LM Branch data area with new Loan Manager status         */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (5 1)) VALUE('N')
             GOTO       CMDLBL(DRIP)                                                      /*203561*/
             ENDDO                                                                        /*203561*/
             ENDDO                                                                        /*203561*/
/*LOOP:*******RCVF                                                  */
 
/**MONITOR FOR EOF***************************************************/
 
/************MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(DRIP))      */
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
             CHGVAR     VAR(&FMT) VALUE(*BLANKS)
 
 LOOP:
/**/
/*  Access PF/SDBRCHPD to retrieve MQ names */
/**/
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &#BRCD &FMT)
 
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')                                         /*193083*/
/**/
/*  Database error handling. */
/**/
             IF         COND(&RTCD *NE '       ') THEN(DO)
             IF         COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(DRIP))
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDBRCHPD')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/************CHGVAR     VAR(&SERV) VALUE(%SST(&A8MQSM  1 3))        */
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))
 
/************CHGVAR     VAR(&BRCD) VALUE(&A8BRCD)                   */
             CHGVAR     VAR(&BRCD) VALUE(%SST(&FMT 1 3))
 
/* Only process live Loan Manager branches */                                             /*193083*/
                                                                                          /*193083*/
             IF         COND(&SERV *EQ ' ') THEN(GOTO CMDLBL(LOOP))                       /*193083*/
             CHGVAR     VAR(&DTAARA) VALUE('LEC2010' *CAT +
                          &SERV)
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)                                                          /*203561*/
                                                                                          /*203561*/
/* Create the branch job data area if it doesn't already exist                            /*193083*/
                                                                                          /*193083*/
             CHKOBJ     OBJ(&DTAARA) OBJTYPE(*DTAARA)                                     /*203561*/
             MONMSG     MSGID(CPF9801) EXEC(DO)                                           /*203561*/
             CRTDTAARA  DTAARA(&DMLIB/&DTAARA) TYPE(*CHAR) LEN(1) +
                          VALUE('N')
/************MONMSG     MSGID(CPF1023)                               */        /*CPK014*/ /*203561*/
                                                                                          /*193083*/
/* Correct the ownership of the dtaara */                                                 /*CPK014*/
/************RTVOBJD    OBJ(&DMLIB) OBJTYPE(*LIB) OWNER(&OWNER)      */        /*CPK014*/ /*203561*/
             CHGOBJOWN  OBJ(&DMLIB/&DTAARA) OBJTYPE(*DTAARA) +
                          NEWOWN(&OWNER)                                                  /*CPK014*/
             ENDDO                                                                        /*203561*/
 
/**Delay*for*10*seconds*if*the*data*area*already*exists*so*that*any            /*193083*/ /*191475*/
/**previous*batch*job*submission/*19r*this*branch*have*had*a*chance            /*193083*/ /*191475*/
/**to*allocate*the*data*area*and*thus*prevent*job*duplication.*Note            /*193083*/ /*191475*/
/**that*it*is*possible*for*multiple*Midas*branches*to*be*associated            /*193083*/ /*191475*/
/**with*the*same*Loan*Manager*server*but*they*should*all*use*the*same          /*193083*/ /*191475*/
/**LEC2010xxx*branch*job*when*linking*to*Loan*Manager                          /*193083*/ /*191475*/
                                                                                          /*193083*/
/************MONMSG     MSGID(CPF1023) EXEC(GOTO CMDLBL(LOOP))                         */ /*193083*/
/************MONMSG     MSGID(CPF1023) EXEC(DLYJOB DLY(10)) */                 /*193083*/ /*191475*/
/************MONMSG     MSGID(CPF1023)                            */           /*191475*/ /*203561*/
 
             ALCOBJ     OBJ((&DTAARA *DTAARA *EXCL)) WAIT(0)                              /*193083*/
                                                                                          /*193083*/
/* If unable to allocate, job is already running */                                       /*193083*/
                                                                                          /*193083*/
             MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(LOOP))                            /*193083*/
             DLCOBJ     OBJ((&DTAARA *DTAARA *EXCL))                                      /*193083*/
                                                                                          /*193083*/
/************SBMJOB*****CMD(CALL PGM(LEC2010A) PARM(&SERV &BRCD)) +*/ /*155873*/
/*************************JOB(&DTAARA) JOBD(MBATCH) JOBQ(TSJOBQ) + */ /*155873*/
/*************************USER(*JOBD) RTGDTA(PCLENDING) MSGQ(*NONE)*/ /*155873*/
/**********  SBMJOB     CMD(CALL PGM(LEC2010A) PARM(&SERV &BRCD)) +            /*155873*/ /*198083*/
/**********               JOB(&DTAARA) JOBD(MBATCH) JOBQ(TSJOBQ) +             /*155873*/ /*198083*/
/**********               USER(*JOBD) RTGDTA(PCLENDING) +                      /*155873*/ /*198083*/
/**********               LOGCLPGM(*NO) MSGQ(*NONE)                            /*155873*/ /*198083*/
                                                                                          /*198083*/
/**/                                                                                      /*203561*/
/** Check if LM Server Interface has been disabled                  */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGVAR     VAR(&DISABLED) VALUE('N')
             CALL       PGM(LEC2019) PARM(&SERV &DISABLED)
 
             IF         COND(&DISABLED *NE 'Y') THEN(DO)
                                                                                          /*216770*/
             RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&PHASE)                            /*216770*/
             IF         COND(&PHASE *NE 'R') THEN(DO)                                     /*216770*/
 
             CHGDTAARA  DTAARA(&DTAARA) VALUE('N')                                        /*208924*/
/************SBMJOB     CMD(CALL PGM(LEC2010A) PARM(&SERV &BRCD)) +                       /*CSC023*/
/************             JOB(&DTAARA) JOBD(MBATCH) JOBQ(TSJOBQ) +                        /*CSC023*/
/************             USER(*JOBD) RTGDTA(PCLENDING) +                                 /*CSC023*/
/************             LOGCLPGM(*JOBD) MSGQ(*NONE)                          /*198083*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(LEC2010A) PARM(&SERV &BRCD)) +
                          JOB(&DTAARA) JOBD(MBATCH) JOBQ(TSJOBQ) +
                          USER(*JOBD) RTGDTA(PCLENDING) +
                          LOGCLPGM(*JOBD) MSGQ(*NONE) OUTQ(*JOBD)                         /*CSC023*/
             ENDDO                                                                        /*216770*/
 
/************RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&PHASE)      */         /*213013*/ /*216770*/
/************IF         COND(&PHASE *EQ 'F') THEN(DO)               */         /*203561*/ /*213013*/
             IF         COND(&PHASE *EQ 'C') THEN(DO)                                     /*213013*/
/**/                                                                                      /*203561*/
/** Send message to Loan Manager to change status to 'N'ormal       */                    /*203561*/
/**/                                                                                      /*203561*/
                 CALL       PGM(LEC2017) PARM(&P#RTCD 'OPEN' &SERV  &BRCD)                /*203561*/
                 IF         COND(%SWITCH(XXXXXX11) *OR (&P#RTCD *NE +
                          '*SENT')) THEN(GOTO CMDLBL(ABNOR))                              /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with last message sent               */                    /*203561*/
/**/                                                                                      /*203561*/
                 CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('OPEN')
/**/                                                                                      /*203561*/
/** Update LM Branch data area with new Loan Manager status         */                    /*203561*/
/**/                                                                                      /*203561*/
                 CHGDTAARA  DTAARA(&LMDTAARA (5 1)) VALUE('N')
             ENDDO                                                                        /*203561*/
                                                                                          /*191475*/
/* Delay for 5 seconds once job has been submitted so that the                            /*191475*/
/* submitted job has time to allocate the data area (*SHRRD). This                        /*191475*/
/* is required because this job might immediately try and allocate the                    /*191475*/
/* same data area again when it loops around. Note that this will only                    /*191475*/
/* happen if there is more than one branch associated with the same                       /*191475*/
/* Loan Manager Server. In this instance the branches sharing the                         /*191475*/
/* Server will all use the same LEC2010xxx branch job when linking to                     /*191475*/
/* Loan Manager                                                                           /*191475*/
 
             DLYJOB     DLY(5)                                                            /*191475*/
             ENDDO                                                                        /*203561*/
 
/************CHGVAR     VAR(&OPTN) VALUE('*NEXT')                                      */ /*193083*/
             GOTO       CMDLBL(LOOP)
 DRIP:
 
/*********   IF         COND(&SERV *NE *BLANKS) THEN(DO)              /*188473*/
/************IF         COND(&SERV *NE ' ') THEN(DO)                        */ /*188473*/ /*193083*/
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)                                   */ /*193083*/
/************IF         COND(&PHASE *NE 'A') THEN(DO)                                  */ /*193083*/
/************IF         COND(&RESETDRIP *EQ 'Y') THEN(DO)            */        /*193083*/ /*203561*/
/**/
/***Retrieve*Journal*Entry.                                          */                   /*203561*/
/**/
/****************RTVJRNE    JRN(ICJRN) FROMENT(*LAST) TOENT(*LAST) +
                            SEARCH(*DESCEND) RTNSEQNBR(&JSEQNO)      */                   /*203561*/
/****************RTVDTAARA  DTAARA(LEJNSQ) RTNVAR(&W#LEJNSQ)         */                   /*203561*/
/****************CHGVAR     VAR(&W#LEJNSQ) VALUE(&JSEQNO)            */                   /*203561*/
/**/
/***Update*data*area*with*last*journal*sequence*number               */                   /*203561*/
/**/
/****************CHGDTAARA  DTAARA(LEJNSQ) VALUE(&W#LEJNSQ)                               /*203561*/
                                                                                          /*203561*/
/************ENDDO                                                   */                   /*203561*/
 
/************ALCOBJ     OBJ((LEDRIP *DTAARA *EXCL)) WAIT(0)          */        /*193083*/ /*203561*/
/************MONMSG     MSGID(CPF1002) EXEC(GOTO CMDLBL(END))        */        /*193083*/ /*203561*/
/************DLCOBJ     OBJ((LEDRIP *DTAARA *EXCL))                  */        /*193083*/ /*203561*/
                                                                                          /*193083*/
/************SBMJOB     CMD(CALL PGM(LEC2016)) JOB(LEC2016) +
                          JOBD(MBATCH) JOBQ(TSJOBQ) USER(*JOBD) +
                          RTGDTA(PCLENDING) MSGQ(*NONE)              */                   /*203561*/
 
/************ENDDO                                                                     */ /*193083*/
/************CALL       PGM(LEC2012)                                 */                   /*203561*/
 
             GOTO       CMDLBL(END)
 
/*     Abnormal termination                                          */
 ABNOR:
                                                                                          /*193083*/
/* Abnormal termination - batch job */                                                    /*193083*/
                                                                                          /*193083*/
             IF         COND(&JOBTYPE = '0') THEN(DO)                                     /*193083*/
             CHGJOB     SWS(XXXXXX11)
/************SNDPGMMSG  MSG('LEC2010 - Customer Lending PC Interface +                 */ /*193083*/
/************          has ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)                     */ /*193083*/
             SNDPGMMSG  MSG('LEC2010 - Start Customer Lending PC +
                          Interface has ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
             ENDDO                                                                        /*193083*/
                                                                                          /*193083*/
/* Abnormal termination - interactive job */                                              /*193083*/
                                                                                          /*193083*/
             IF         COND(&JOBTYPE = '1') THEN(DO)                                     /*193083*/
             SNDPGMMSG  MSG('LEC2010 - Start Customer Lending PC +
                          Interface has ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)                                            /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
                                                                                          /*193083*/
/* Call SCC0010 to inform the user that an error has occurred */                          /*193083*/
                                                                                          /*193083*/
             RTVMSG     MSGID(SCM0087) MSGF(GBMIDASMSG) MSG(&MESSAGE)                     /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
                                                                                          /*193083*/
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)                         /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
                                                                                          /*193083*/
             CALL       PGM(SCC0010) PARM('LEC2010' 'ENTER' ' ')                          /*193083*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*193083*/
             ENDDO                                                                        /*193083*/
 
/*     Normal termination                                            */
 END:
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
