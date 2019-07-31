/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Loan Manager i/c bulk transfer control')     */
/********************************************************************/
/*                                                                  */
/*  Midas   - Customer Lending Module                               */
/*                                                                  */
/*  LEC2015A - Lending Input Cycle Bulk Transfer Control            */
/*                                                                  */
/*  Function:  To call the Lending Bulk transfer process LE2015 on  */
/*             request during the Input Cycle to download the       */
/*             latest details of the Customer Lending Master files  */
/*             and/or the Standing Data master files to the PC file */
/*             server. Performed using MQ Series comms.             */
/*                                                                  */
/*  Calls:     LE2015                                               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      226539             Date 19Apr04              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                 208880            Date  03Sep02                  */
/*                 208170            Date  06Aug02                  */
/*                 203561            Date  17Jun02                  */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                 192560            Date  03Jul01                  */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                 176961            Date  27Mar00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 CLE004  *CREATE   DATE  18APR97                  */
/*                 XNNNNN            DATE  DDMMMYY                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*  CLE134 - Past Due Call Loan Processing (Recompile)              */
/*  226539 - This batch job no longer needs to shut down the drip   */
/*           feed job while it runs.                                */
/*  208880 - Requests for 'all' branch downloads were generating    */
/*           multiple sets of duplicate messages for branches using */
/*           the same Loan Manager server. Each set was then being  */
/*           transmitted to the server and being processed.         */
/*  208170 - &OPTN parameter now initialised as *FIRST              */
/*  203561 - Change parameters as MQM is not needed by LE2015       */
/*           Also, replace code for ending drip feed program by     */
/*           call to LEC2013                                        */
/*  192560 - Change program information message and check that the  */
/*           drip feed job has been shut down                       */
/*  176961 - Send 'YE' Journal entry to end LEC2016                 */
/*  CLE004 - Customer Lending Enhancements - Syndications.          */
/*                                                                  */
/********************************************************************/
/************PGM        PARM(&MODE &BRCH &MQM)                       */                   /*203561*/
             PGM        PARM(&MODE &LMSERVER &BRCH)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)                                    /*203561*/
             DCL        VAR(&LMSERVER) TYPE(*CHAR) LEN(3)                                 /*203561*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*203561*/
/************DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) */                       /*203561*/ /*208170*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')                     /*208170*/
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)                                     /*203561*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)                                   /*203561*/
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5)                                 /*203561*/
             DCL        VAR(&LMSTS) TYPE(*CHAR) LEN(5)                                    /*203561*/
             DCL        VAR(&DOWNLOADED) TYPE(*CHAR) LEN(1)                               /*208880*/
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1) VALUE('N')                      /*203561*/
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3) VALUE(' ')                          /*203561*/
/************DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3) VALUE(' ')     */        /*203561*/ /*208880*/
/************DCL        VAR(&MQM) TYPE(*CHAR) LEN(10)                */                   /*203561*/
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)                                     /*203561*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                                 /*192560*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitored message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/************SNDPGMMSG  MSG('LEC2015A - Customer Lending PC Bulk +                     */ /*192560*/
/************             Transfer') TOMSGQ(MRUNQ)                                     */ /*192560*/
             SNDPGMMSG  MSG('LEC2015A - Customer Lending I/C PC +
                          Bulk Transfer') TOMSGQ(MRUNQ)                                   /*192560*/
 
             CHGJOB     SWS(00000000)
 
/* Lock LEBULK data area to say job is running                       */
/*                                                                   */
             ALCOBJ     OBJ((LEBULK *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*  Create LDA data area                                             */
/*                                                                   */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
                                                                                          /*192560*/
/**If*LEC2016*drip*feed*job*still*running,*attempt*to*shut*it*down */              /*192560 226539*/
                                                                                   /*192560 226539*/
/**********  CALL       PGM(LEC2013)                                               /*203561 226539*/
/**********  IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                             */            /*203561 226539*/
                                                                                          /*203561*/
/************ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(0)        */        /*192560*/ /*203561*/
/************MONMSG     MSGID(CPF1002) EXEC(DO)                      */        /*192560*/ /*203561*/
/****************SNDJRNE    JRN(ICJRN) TYPE('YE') ENTDTA('STOP LE +  */                   /*203561*/
/***************************UPDATE') FILE(SDCLNDPD)                  */        /*176961*/ /*203561*/
/****************ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(30)   */        /*192560*/ /*203561*/
/****************MONMSG     MSGID(CPF1002) EXEC(DO)                  */        /*192560*/ /*203561*/
/****************SNDPGMMSG  MSG('Unable to terminate LEC2016 drip fee*/                   /*203561*/
/*************************process - please try again later') +       */                   /*203561*/
/*************************TOMSGQ(MOPERQ MRUNQ)                       */        /*192560*/ /*203561*/
/****************GOTO CMDLBL(ABNOR)                                  */        /*192560*/ /*203561*/
/****************ENDDO                                               */        /*192560*/ /*203561*/
/****************DLCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD))            */        /*192560*/ /*203561*/
/****************MONMSG     MSGID(CPF0000)                           */        /*192560*/ /*203561*/
/************ENDDO                                                   */        /*192560*/ /*203561*/
                                                                                          /*203561*/
             IF         COND(&LMSERVER *NE 'ALL') THEN(DO)                                /*203561*/
                                                                                          /*203561*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &LMSERVER)                                                      /*203561*/
                                                                                          /*203561*/
/* Check the LMxxx data area to see if this branch has been disabled     */               /*203561*/
                                                                                          /*203561*/
             CALL       PGM(LEC2019) PARM(&LMSERVER &DISABLED)
                                                                                          /*203561*/
             IF         COND(&DISABLED *NE 'Y') THEN(DO)                                  /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with current action                  */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('BULK')                             /*203561*/
             ENDDO                                                                        /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area download active flag                  */                   /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (8 1)) VALUE('Y')                                /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(LE2015) PARM(&MODE &BRCH)                                     /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area download active flag                  */                   /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (8 1)) VALUE('N')                                /*203561*/
/**/                                                                                      /*203561*/
/*    Error processing                                               */                   /*203561*/
/**/                                                                                      /*203561*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*203561*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                                       /*203561*/
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))                            /*203561*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)                                           /*203561*/
                GOTO       CMDLBL(ABNOR)                                                  /*203561*/
             ENDDO                                                                        /*203561*/
             GOTO       CMDLBL(END)                                                       /*203561*/
             ENDDO                                                                        /*203561*/
/**/                                                                                      /*203561*/
/* Multiple branch request                                           */                   /*203561*/
 
 LOOP:                                                                                    /*203561*/
/**/                                                                                      /*203561*/
/* Process all branches and pick out those with a Loan Manager Server*/                   /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &BRCD &FMT)                        /*203561*/
                                                                                          /*203561*/
/**/                                                                                      /*203561*/
/*  Database error handling. */                                                           /*203561*/
/**/                                                                                      /*203561*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                                /*203561*/
/************IF         COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(END)) */       /*203561*/ /*208880*/
             IF         COND(&RTCD *EQ '*EOF') THEN(DO)                                   /*208880*/
                CHGVAR     VAR(&OPTN) VALUE('*FIRST')                                     /*208880*/
                GOTO       CMDLBL(LOOP2)                                                  /*208880*/
             ENDDO                                                                        /*208880*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDBRCHPD')                                              /*203561*/
                GOTO       CMDLBL(ABNOR)                                                  /*203561*/
             ENDDO                                                                        /*203561*/
                                                                                          /*203561*/
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))                                /*203561*/
             CHGVAR     VAR(&BRCD) VALUE(%SST(&FMT 1 3))                                  /*203561*/
                                                                                          /*192560*/
             IF         COND(&SERV *EQ ' ') THEN(GOTO CMDLBL(LOOP))                       /*203561*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)                                                          /*203561*/
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')
                                                                                          /*203561*/
/* Check the LMxxx data area to see if this branch has been disabled     */               /*203561*/
                                                                                          /*203561*/
             CHGVAR     VAR(&DISABLED) VALUE('N')                                         /*203561*/
             CALL       PGM(LEC2019) PARM(&SERV &DISABLED)                                /*203561*/
                                                                                          /*203561*/
             IF         COND(&DISABLED *EQ 'Y') THEN(GOTO CMDLBL(LOOP))                   /*203561*/
/**/                                                                                      /*203561*/
/** Retrieve Branch data area to see if download to this Loan Manager */                  /*208880*/
/** Server has already taken place                                    */                  /*208880*/
/**/                                                                                      /*208880*/
             RTVDTAARA  DTAARA(&LMDTAARA (8 1)) RTNVAR(&DOWNLOADED)                       /*208880*/
/**/                                                                                      /*208880*/
             IF         COND(&DOWNLOADED *EQ 'Y') THEN(GOTO CMDLBL(LOOP))                 /*208880*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area with current action                  */                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('BULK')                             /*203561*/
/**/                                                                                      /*203561*/
/** Update LM Branch data area download active flag                  */                   /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (8 1)) VALUE('Y')                                /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(LE2015) PARM(&MODE &BRCD)
 
/**/
/*    Error processing                                               */
/*    Retrieve LDA and store values                                  */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&DBER) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DBER) +
                           TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)                                                     /*203561*/
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 LOOP2:                                                                                   /*208880*/
                                                                                          /*208880*/
/**/                                                                                      /*208880*/
/* Process all branches again and reset download active flags        */                   /*208880*/
/**/                                                                                      /*208880*/
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &BRCD &FMT)                        /*208880*/
                                                                                          /*208880*/
/**/                                                                                      /*208880*/
/*  Database error handling. */                                                           /*208880*/
/**/                                                                                      /*208880*/
             IF         COND(&RTCD *NE '       ') THEN(DO)                                /*208880*/
             IF         COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(END))                     /*208880*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDBRCHPD')                                              /*208880*/
                GOTO       CMDLBL(ABNOR)                                                  /*208880*/
             ENDDO                                                                        /*208880*/
                                                                                          /*208880*/
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))                                /*208880*/
             CHGVAR     VAR(&BRCD) VALUE(%SST(&FMT 1 3))                                  /*208880*/
                                                                                          /*208880*/
             IF         COND(&SERV *EQ ' ') THEN(GOTO CMDLBL(LOOP2))                      /*208880*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)                                                          /*208880*/
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')
/**/                                                                                      /*208880*/
/** Update LM Branch data area download active flags                 */                   /*208880*/
/**/                                                                                      /*208880*/
             CHGDTAARA  DTAARA(&LMDTAARA (8 1)) VALUE('N')                                /*208880*/
             GOTO       CMDLBL(LOOP2)
                                                                                          /*208880*/
             GOTO       CMDLBL(END)
 
 
/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
/************SNDPGMMSG  MSG('Lending PC Bulk Transfer Process has                      */ /*192560*/
/************             ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)                      */ /*192560*/
             SNDPGMMSG  MSG('Lending PC I/C Bulk Transfer Process +
                          has ENDED ABNORMALLY') TOMSGQ(MOPERQ +
                          MRUNQ)                                                          /*192560*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/*     Normal termination                                            */
 END:
             DLCOBJ     OBJ((LEBULK *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/                                                                                      /*203561*/
/* Restart the drip feed job */                                                           /*203561*/
/**/                                                                                      /*203561*/
/************CALL       PGM(LEC2010) PARM('N')                       */        /*176961*/ /*203561*/
/**********  CALL       PGM(LEC2012)                                 */            /*203561 226539*/
/**********  MONMSG     MSGID(CPF0000 MCH0000)                       */            /*192560 226539*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
