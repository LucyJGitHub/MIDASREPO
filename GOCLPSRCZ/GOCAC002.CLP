/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas GO Global Update Accounts -Task Split Server')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GOCAC002  - Midas GO Global Update Accounts -               */
/*                   (Task Split Server)                             */
/*                                                                   */
/*       (c) Misys Banking Systems Ltd. 2009                         */
/*                                                                   */
/*       Last Amend No. AR1097467B         Date 17Apr13              */
/*       Prev Amend No. CGO001AA           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      CGP013  *Create    Date 18Feb09              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       AR1097467B - Expected 15% COB run optimization not met      */
/*       CGO001AA - COB Restructure - GO COB Optimisation Phase 1    */
/*       CGP013 - Task split component COB Global Update Accounts    */
/*                  (Start Task Split)                               */
/*                                                                   */
/*********************************************************************/
/**********  PGM        PARM(&CNAME &CSEQ &COPY_RECS)                */               /*AR1097467B*/
             PGM                                                                      /*AR1097467B*/
 
/* Declare variables */
 
/**********  DCL        VAR(&CNAME) TYPE(*CHAR) LEN(10)              */               /*AR1097467B*/
/**********  DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)               */               /*AR1097467B*/
/**********  DCL        VAR(&COPY_RECS) TYPE(*DEC) LEN(7 0)          */               /*AR1097467B*/
/**********  DCL        VAR(&RTN_CODE) TYPE(*CHAR) LEN(3)            */               /*AR1097467B*/
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1)                */               /*AR1097467B*/
/**********  DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)             */               /*AR1097467B*/
             DCL        VAR(&DTAQLIBL) TYPE(*CHAR) LEN(10) +
                          VALUE('*LIBL     ')
             DCL        VAR(&MSGLENGTH) TYPE(*DEC) LEN(5 0) VALUE(50)
             DCL        VAR(&MSGDATA) TYPE(*CHAR) LEN(50)
/**********  DCL        VAR(&SNDDTAQ) TYPE(*CHAR) LEN(10)            */               /*AR1097467B*/
             DCL        VAR(&RCVDTAQ) TYPE(*CHAR) LEN(10) +
                          VALUE('GOACNTSRV')
             DCL        VAR(&RCVWAIT) TYPE(*DEC) LEN(5 0) VALUE(-1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2009')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Send message to MRUNQ */
 
             SNDPGMMSG  MSG('GOCAC002  - Global Update Accounts - +
                          Task Split Server') TOMSGQ(MRUNQ)
 
/**Start*commitment*control**/                                                        /*AR1097467B*/
 
/**********  STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)                  */               /*AR1097467B*/
 
/**Read*COB*components*file*to*check*the*restart*status**/                            /*AR1097467B*/
 
/**********  CALL       PGM(CB0160) PARM(&CNAME &CSEQ &STAT)         */               /*AR1097467B*/
 
/**Check*if*any*problems*with*COB*components*file**/                                  /*AR1097467B*/
 
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             */               /*AR1097467B*/
/**********  GOTO       CMDLBL(ABNOR)                                */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/
 
/**If*restart*status*=*Y,*send*message*to*each*sub-task*data*queue**/                 /*AR1097467B*/
 
/**********  IF         COND(&STAT = 'Y') THEN(DO)                   */               /*AR1097467B*/
 
/**Retrieve*first*member*description**/                                               /*AR1097467B*/
 
/**********  RTVMBRD    FILE(ACTSDVPD) RTNMBR(&MEMBER)               */               /*AR1097467B*/
 
/**Set*up*data*queue*and*message*data**/                                              /*AR1097467B*/
 
/**********  CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)                 */               /*AR1097467B*/
/**********  CHGVAR     VAR(&MSGDATA) VALUE('RESTART')               */               /*AR1097467B*/
 
/**Send*message*data*to*data*queue**/                                                 /*AR1097467B*/
 
/***LOOP:    CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                       */               /*AR1097467B*/
 
/**Retrieve*next*member*description**/                                                /*AR1097467B*/
 
/**********  RTVMBRD    FILE(ACTSDVPD) MBR(&MEMBER *NEXT) +
                          RTNMBR(&SNDDTAQ)                           */               /*AR1097467B*/
/**********  MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(ENDLOOP))    */               /*AR1097467B*/
 
/**Loop*for*all*members*in*driving*file**/                                            /*AR1097467B*/
 
/**********  CHGVAR     VAR(&MEMBER) VALUE(&SNDDTAQ)                 */               /*AR1097467B*/
/**********  GOTO       CMDLBL(LOOP)                                 */               /*AR1097467B*/
 
/***ENDLOOP:    ENDDO                                                                 /*AR1097467B*/
 
/**Set*restart*status*to*'Y'**/                                                       /*AR1097467B*/
 
/**********  CHGVAR     VAR(&STAT) VALUE('Y')                        */               /*AR1097467B*/
/**********  CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)         */               /*AR1097467B*/
 
/* Wait for data queue entry */
/* Wait for message that all sub tasks have completed successfully */                 /*AR1097467B*/
 
 RECEIVE:    CALL       PGM(QRCVDTAQ) PARM(&RCVDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA &RCVWAIT)
 
/* If message = FINISH, terminate the program */                                      /*AR1097467B*/
                                                                                      /*AR1097467B*/
             IF         COND(%SST(&MSGDATA 1 6) = 'FINISH') THEN(DO)                  /*AR1097467B*/
             GOTO       CMDLBL(END)                                                   /*AR1097467B*/
             ENDDO                                                                    /*AR1097467B*/
             ELSE       CMD(DO)                                                       /*AR1097467B*/
             GOTO       CMDLBL(RECEIVE)                                               /*AR1097467B*/
             ENDDO                                                                    /*AR1097467B*/
                                                                                      /*AR1097467B*/
/**Extract*member*name**/                                                             /*AR1097467B*/
 
/**********  CHGVAR     VAR(&MEMBER) VALUE(%SUBSTRING(&MSGDATA 1 10))*/               /*AR1097467B*/
 
/**Override*driving*file*and*trailer*file**/                                          /*AR1097467B*/
 
/**********  OVRDBF     FILE(ACTSDVPD) TOFILE(ACTSDVPD) MBR(&MEMBER) +
                          FRCRATIO(500) NBRRCDS(1000) SEQONLY(*YES +
                          2000)                                      */               /*AR1097467B*/
 
/**Call*the*program*to*copy*records*to*specified*member**/                            /*AR1097467B*/
 
/**********  CALL       PGM(GOAC002) PARM(&COPY_RECS &RTN_CODE)      */               /*AR1097467B*/
 
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(DO)             */               /*AR1097467B*/
/**********  GOTO       CMDLBL(ABNOR)                                */               /*AR1097467B*/
/**********  ENDDO                                                   */               /*AR1097467B*/
 
/**Set*up*data*queue*and*message*data**/                                              /*AR1097467B*/
 
/**********  IF         COND(&RTN_CODE *NE 'NRF') THEN(DO)           */      /*CGO001AA AR1097467B*/
/**********  CHGVAR     VAR(&SNDDTAQ) VALUE(&MEMBER)                 */               /*AR1097467B*/
/**********  CHGVAR     VAR(&MSGDATA) VALUE('PROMPT')                */               /*AR1097467B*/
/**********  ENDDO                                                   */      /*CGO001AA AR1097467B*/
 
/**Send*message*data*to*data*queue**/                                                 /*AR1097467B*/
 
/**********  CALL       PGM(QSNDDTAQ) PARM(&SNDDTAQ &DTAQLIBL +
                          &MSGLENGTH &MSGDATA)                       */               /*AR1097467B*/
 
/**If*return*code*=*EOF,*set*restart*status*to*'N'*and*terminate**/                   /*AR1097467B*/
 
/**********  IF         COND(&RTN_CODE = 'EOF') THEN(DO)           */                   /*CGO001AA*/
/**********  IF         COND(&RTN_CODE *EQ 'EOF' *OR &RTN_CODE *EQ +
                          'NRF') THEN(DO)                            */      /*CGO001AA AR1097467B*/
 
/**********  CHGVAR     VAR(&STAT) VALUE('N')                        */               /*AR1097467B*/
/**********  CALL       PGM(CB0150) PARM(&CNAME &CSEQ &STAT)         */               /*AR1097467B*/
 
/**********  GOTO       CMDLBL(END)                                  */               /*AR1097467B*/
 
/**********  ENDDO                                                   */               /*AR1097467B*/
 
/**If*return*code*<>*EOF,*wait*for*another*data*queue*entry**/                        /*AR1097467B*/
 
/**********  GOTO       CMDLBL(RECEIVE)                              */               /*AR1097467B*/
 
 ABNOR:      SNDPGMMSG  MSG('Program GOCAC002 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
 
             ENDPGM
