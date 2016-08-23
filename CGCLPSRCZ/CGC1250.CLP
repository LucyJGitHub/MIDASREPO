/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CG Get Object Attributes')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - User Defined Correspondence                     */
/*                                                                   */
/*       CGC1250  -  Check object exists in library list, and        */
/*                   return attributes.                              */
/*                                                                   */
/*       Return code values: CGD2504 Object exists                   */
/*                           CGD2505 Object does not exist           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG5456            Date 03Feb05              */
/*       Prev Amend No. CSC022             Date 24Feb04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01522             Date 22Feb95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG5456 - Fixes for Commitment Control Changes (CSC022)     */
/*       CSC022 - Commitment Control Changes for MidasPlus           */
/*       S01522 - User Defined Correspondence                        */
/*                                                                   */
/*********************************************************************/
 
/* Hello                                                             */
             PGM        PARM(&RET_CODE &PROGRAM &OBJ_NAME &OBJ_TYPE +
                          &OBJ_LIB &OBJ_ATR &OBJ_UDFN &OBJ_TEXT +
                          &OBJ_OWNR)
 
/* Copyright statement                                               */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Input parameters                                                  */
             DCL        VAR(&PROGRAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_NAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_TYPE) TYPE(*CHAR) LEN(10)
 
/* Output parameters                                                 */
             DCL        VAR(&OBJ_LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_ATR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_UDFN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OBJ_TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&OBJ_OWNR) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&RET_CODE) TYPE(*CHAR) LEN(7)
 
/* Work                                                              */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(132)
             DCL        VAR(&CSC022) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC022*/
             DCL        VAR(&WCMTSK) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSC022*/
             DCL        VAR(&WSCCMTJOB) TYPE(*CHAR) LEN(256)                              /*CSC022*/
             DCL        VAR(&WCMTNUM) TYPE(*DEC) LEN(3 0)                                 /*CSC022*/
             DCL        VAR(&WCMTJOB) TYPE(*CHAR) LEN(100)                                /*CSC022*/
             DCL        VAR(&PRTN) TYPE(*CHAR) LEN(7)                                     /*CSC022*/
             DCL        VAR(&POPT) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC022*/
             DCL        VAR(&PSAR) TYPE(*CHAR) LEN(6) VALUE('CSC022')                     /*CSC022*/
             DCL        VAR(&PFMT) TYPE(*CHAR) LEN(200)                                   /*CSC022*/
             DCL        VAR(&WJOB) TYPE(*CHAR) LEN(10)                                    /*CSC022*/
/************DCL        VAR(&WSTR) TYPE(*DEC) LEN(2 0) VALUE(1) */                /*CSC022 BUG5456*/
             DCL        VAR(&WSTR) TYPE(*DEC) LEN(3 0) VALUE(1)                          /*BUG5456*/
             DCL        VAR(&WJOBCTR) TYPE(*DEC) LEN(3 0) VALUE(1)                       /*BUG5456*/
 
/* Global Monitor Message                                            */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
 
/* Clear program message queue and initialise return code            */
             RMVMSG     PGMQ(*SAME) CLEAR(*ALL)
             CHGVAR     VAR(&RET_CODE) VALUE('CGD2505')
/* */                                                                                     /*CSC022*/
/* Retrieve Commitment Control Jobs data area */                                          /*CSC022*/
/* */                                                                                     /*CSC022*/
             CALL       PGM(AOSARDR0) PARM(&PRTN &POPT &PSAR &PFMT)                       /*CSC022*/
                                                                                          /*CSC022*/
/************IF         COND(&PRTN *EQ *BLANKS) THEN(DO) */                       /*CSC022 BUG5456*/
             IF         COND(&PRTN *EQ '       ') THEN(DO)                               /*BUG5456*/
             CHGVAR     VAR(&CSC022) VALUE('Y')                                           /*CSC022*/
             CHGVAR     VAR(&WCMTSK) VALUE('N')                                           /*CSC022*/
                                                                                          /*CSC022*/
             RTVDTAARA  DTAARA(SCCMTJOB) RTNVAR(&WSCCMTJOB)                               /*CSC022*/
             CHGVAR     VAR(&WCMTNUM) VALUE(%SST(&WSCCMTJOB 1 3))                         /*CSC022*/
             CHGVAR     VAR(&WCMTJOB) VALUE(%SST(&WSCCMTJOB 4 103))                       /*CSC022*/
                                                                                          /*CSC022*/
             IF         COND(&WCMTNUM *GT 0) THEN(DO)                                     /*CSC022*/
             RTVJOBA    JOB(&WJOB)                                                        /*CSC022*/
                                                                                          /*CSC022*/
 SCAN:       IF         COND(&WJOB *EQ %SST(&WCMTJOB &WSTR 10)) +
                          THEN(CHGVAR VAR(&WCMTSK) VALUE('Y'))                            /*CSC022*/
                                                                                          /*CSC022*/
             ELSE       CMD(DO)                                                           /*CSC022*/
             IF         COND(&WJOBCTR *LT &WCMTNUM) THEN(DO)                             /*BUG5456*/
             CHGVAR     VAR(&WJOBCTR) VALUE(&WJOBCTR + 1)                                /*BUG5456*/
             CHGVAR     VAR(&WSTR) VALUE(&WSTR + 10)                                      /*CSC022*/
             GOTO       CMDLBL(SCAN)                                                     /*BUG5456*/
 /***********IF         COND(&WSTR *LT 100) THEN(GOTO CMDLBL(SCAN)) */            /*CSC022 BUG5456*/
             ENDDO                                                                       /*BUG5456*/
             ENDDO                                                                        /*CSC022*/
                                                                                          /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ENDDO                                                                        /*CSC022*/
             ELSE       CMD(IF COND(&PRTN *NE '*NRF') THEN(GOTO +
                          CMDLBL(ABNORMAL)))                                              /*CSC022*/
 
/* Retrieve object definition                                        */
             RTVOBJD    OBJ(&OBJ_NAME) OBJTYPE(&OBJ_TYPE) +
                          RTNLIB(&OBJ_LIB) OBJATR(&OBJ_ATR) +
                          USRDFNATR(&OBJ_UDFN) TEXT(&OBJ_TEXT) +
                          OWNER(&OBJ_OWNR)
             MONMSG     MSGID(CPF0000) EXEC(DO)
 
/* If error occurs, copy messages to calling program                 */
 LOOP:       RCVMSG     PGMQ(*SAME) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) MSGFLIB(&MSGFLIB)
             IF         COND(&MSGID *NE '       ') THEN(DO)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) TOPGMQ(*SAME (&PROGRAM))
             GOTO       CMDLBL(LOOP)
             ENDDO
 
/* Terminate normally                                                */
             GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/* If no error, send message to ourseleves with retrieved data, so   */
/* that object attributes can be viewed in joblog, and terminate.    */
             CHGVAR     VAR(&RET_CODE) VALUE('CGD5204')
             SNDPGMMSG  MSGID(CGD2504) MSGF(CGUSRMSG) +
                          MSGDTA(&OBJ_NAME *CAT &OBJ_TYPE *CAT +
                          &OBJ_LIB *CAT &OBJ_ATR *CAT &OBJ_UDFN +
                          *CAT &OBJ_TEXT *CAT &OBJ_OWNR) TOPGMQ(*SAME)
             MONMSG     MSGID(CPF0000)
             GOTO       CMDLBL(ENDCLPGM)
 
/* Abnormal termination processing                                   */
ABNORMAL:
             IF         COND((&CSC022 *EQ 'N') *OR ((&CSC022 *EQ +
                          'Y') *AND (&WCMTSK *EQ 'N'))) THEN(DO)                          /*CSC022*/
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO                                                                        /*CSC022*/
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
             SNDPGMMSG  MSG('Program CGC1250 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          CGC1250 ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Bye                                                               */
             ENDPGM
