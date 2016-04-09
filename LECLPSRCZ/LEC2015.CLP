/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Loan Manager COB bulk transfer control')     */
/*********************************************************************/
/*                                                                  */
/*  Midas   - Customer Lending Module                               */
/*                                                                  */
/*  LEC2015 - Lending COB Bulk Transfer Control (COB version)       */
/*                                                                  */
/*  Function: To call the Lending Bulk transfer process LE2015      */
/*            during Close of Business to download the latest       */
/*            details of the Customer Lending Master file to the    */
/*            PC file server. Performed using MQ Series comms.      */
/*                                                                  */
/*  Calls:    LE2015                                                */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*  Last Amend No. CLE134             Date 01Aug12                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*  Prev Amend No. 225286            Date  17Mar04                  */
/*                 225427            Date  05Mar04                  */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                 203561            Date  17Jun02                  */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                 192560            Date  06Jun01                  */
/*                 193560            Date  22May01                  */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                 176961            Date  27Mar00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                 129195            DATE  20JAN98                  */
/*                 CLE004  *CREATE   DATE  18APR97                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*  CLE134 - Past Due Call Loan Processing (Recompile)              */
/*  225286 - Re-run the download if the Midas I/C was reopened      */
/*           after initial download was completed during COB        */
/*  203561 - Loan Manager download does not take place if LEC2016   */
/*           job is not running. New program LEC2017 added.         */
/*  192560 - Removal of call to LEC2010 as not correct for COB      */
/*           because I/C jobs cause locking problems with BOB save  */
/*  193560 - Only send 'YE' journal entry if LEC2016 is still       */
/*           running. Check by allocating LEDRIP data area          */
/*           exclusively                                            */
/*  176961 - Send 'YE' Journal entry to end LEC2016 before LE2015 is*/
/*           called. Also call LEC2010 to start up I/C jobs at end  */
/*  129195 - Do not submit this job if the MQ channel fields are    */
/*           not set up on SDBRCHPD.                                */
/*  CLE004 - Customer Lending Enhancements - Syndications.          */
/*                                                                  */
/********************************************************************/
             PGM
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1) VALUE('L')                          /*225427*/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1) VALUE('B')                          /*225427*/
             DCL        VAR(&BRCH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DBER) TYPE(*CHAR) LEN(50)
             DCL        VAR(&SERV) TYPE(*CHAR) LEN(3) VALUE(' ')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)
             DCL        VAR(&BRCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
/************DCL        VAR(&PHASE) TYPE(*CHAR) LEN(1)                      */ /*193560*/ /*192560*/
             DCL        VAR(&LMDTAARA) TYPE(*CHAR) LEN(5)                                 /*203561*/
             DCL        VAR(&LMSTS) TYPE(*CHAR) LEN(5)                                    /*203561*/
             DCL        VAR(&DISABLED) TYPE(*CHAR) LEN(1)                                 /*203561*/
             DCL        VAR(&COBREOPEN) TYPE(*CHAR) LEN(1)                                /*225286*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitored message occurs perform error processing      */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('LEC2015 - Customer Lending PC Bulk +
                          Transfer') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
 
             CHGVAR     VAR(&RTCD) VALUE('       ')
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')
             CHGVAR     VAR(&FMT) VALUE(*BLANKS)
 
/************RTVDTAARA  DTAARA(MPHAS) RTNVAR(&PHASE)                        */ /*193560*/ /*192560*/
 
/* If LEC2016 drip feed job still running, attempt to shut it down */                     /*203561*/
                                                                                          /*203561*/
             CALL       PGM(LEC2013)                                                      /*203561*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*203561*/
             ALCOBJ     OBJ((LEBULK *DTAARA *EXCLRD))                                     /*203561*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                                                  /*203561*/
 LOOP:
/**/
/***Access*PF/SDBRCHPD*to*retrieve*MQ*names**/                                            /*203561*/
/***Loop*round*to*confirm*that*there*is*at*least*one*active*Loan***/           /*192560*/ /*203561*/
/***Manager*branch.*If*there*is*more*than*one,*download*to*each****/           /*192560*/ /*203561*/
/***will*be*handled*within*LE2015**********************************/           /*192560*/ /*203561*/
/**/
/* Process all branches and pick out those with a Loan Manager Server*/                   /*203561*/
/**/                                                                                      /*203561*/
             CALL       PGM(AOBRCHR0) PARM(&RTCD &OPTN &BRCH &FMT)
 
/**/
/*  Database error handling. */
/**/
             IF         COND(&RTCD *NE '       ') THEN(DO)
/************IF*********COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(SKIP)) */                 /*203561*/
             IF         COND(&RTCD *EQ '*EOF') THEN(GOTO CMDLBL(END))
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDBRCHPD')
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
             CHGVAR     VAR(&SERV) VALUE(%SST(&FMT 184 3))
             CHGVAR     VAR(&BRCH) VALUE(%SST(&FMT 1 3))                                  /*203561*/
                                                                                          /*192560*/
/**Drop*out*of*loop*if*active*Loan*Manager*branch*found.**/                    /*192560*/ /*203561*/
                                                                                          /*192560*/
/************IF         COND(&SERV *NE ' ') THEN(GOTO CMDLBL(SKIP))            /*192560*/ /*203561*/
             CHGVAR     VAR(&OPTN) VALUE('*NEXT')
             IF         COND(&SERV *EQ ' ') THEN(GOTO CMDLBL(LOOP))                       /*203561*/
             CHGVAR     VAR(&LMDTAARA) VALUE('LM' *CAT +
                          &SERV)                                                          /*203561*/
                                                                                          /*203561*/
/* Check the LMxxx data area to see if this branch has been disabled     */               /*203561*/
                                                                                          /*203561*/
             RTVDTAARA  DTAARA(&LMDTAARA (7 1)) RTNVAR(&DISABLED)                         /*203561*/
             IF         COND(&DISABLED *EQ 'Y') THEN(GOTO CMDLBL(LOOP))                   /*203561*/
                                                                                          /*203561*/
/* Check the LMxxx data area to see if the Midas I/C was re-opened     */                 /*225286*/
                                                                                          /*225286*/
             RTVDTAARA  DTAARA(&LMDTAARA (11 1)) RTNVAR(&COBREOPEN)                       /*225286*/
                                                                                          /*225286*/
/* Check the LMxxx data area to see if the download for this branch has  */               /*203561*/
/* already been processed                                                */               /*203561*/
                                                                                          /*203561*/
             RTVDTAARA  DTAARA(&LMDTAARA (5 1)) RTNVAR(&LMSTS)                            /*203561*/
/**********  IF         COND(&LMSTS *EQ 'C') THEN(GOTO LOOP)         */            /*203561 225286*/
             IF         COND((&LMSTS *EQ 'C') *AND (&COBREOPEN *NE +
                          'Y')) THEN(GOTO CMDLBL(LOOP))                                   /*225286*/
                                                                                          /*203561*/
/************GOTO       CMDLBL(LOOP)                                 */                   /*203561*/
/*SKIP:***************************************************************/                   /*203561*/
/************IF         COND(&SERV *NE ' ') THEN(DO)                 */        /*192560*/ /*203561*/
/************ALCOBJ     OBJ((LEBULK *DTAARA *EXCLRD))                */                   /*203561*/
/************MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                             */                   /*203561*/
 
/************IF         COND(&SERV *NE ' ') THEN(DO)                                   */ /*192560*/
                                                                               /*192560*/ /*203561*/
/**If*LEC2016*drip*feed*job*still*running,*attempt*to*shut*it*down**/          /*192560*/ /*203561*/
                                                                               /*192560*/ /*203561*/
/************ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(5)                  /*192560*/ /*203561*/
/************MONMSG     MSGID(CPF1002) EXEC(DO)                                /*192560*/ /*203561*/
/************                                                                  /*192560*/ /*203561*/
/************    SNDJRNE    JRN(ICJRN) TYPE('YE') ENTDTA('STOP LE +                       /*203561*/
/************                 UPDATE') FILE(SDCLNDPD)                          /*192560*/ /*203561*/
/************    ALCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD)) WAIT(60)             /*192560*/ /*203561*/
/************    MONMSG     MSGID(CPF1002) EXEC(DO)                            /*192560*/ /*203561*/
/************       SNDPGMMSG  MSG('Unable to terminate LEC2016   +                       /*203561*/
/************       job (Lending PC interface drip feed process)') +                      /*203561*/
/************       TOMSGQ(MOPERQ MRUNQ)                                                  /*203561*/
/************       GOTO CMDLBL(ABNOR)                                         /*192560*/ /*203561*/
/************    ENDDO                                                         /*192560*/ /*203561*/
/************    DLCOBJ     OBJ((LEDRIP *DTAARA *EXCLRD))                      /*192560*/ /*203561*/
/************    MONMSG     MSGID(CPF0000)                                     /*192560*/ /*203561*/
/************ENDDO                                                             /*192560*/ /*203561*/
                                                                                          /*192560*/
             CALL       PGM(LE2015) PARM(&MODE &BRCH)                                     /*192560*/
/************ENDDO                                                   */                   /*203561*/
 
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
/**/                                                                                      /*203561*/
/** Download okay - Update LM LMxxx data area with last message sent*/                    /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (1 4)) VALUE('DOWN')
/**/                                                                                      /*203561*/
/** Update LM LMxxx data area with new Loan Manager status         */                     /*203561*/
/**/                                                                                      /*203561*/
             CHGDTAARA  DTAARA(&LMDTAARA (5 1)) VALUE('C')                                /*203561*/
                                                                                          /*203561*/
/* Update the LMxxx data area to reset the COBREOPEN flag to 'N' so    */                 /*225286*/
/* that this server's download will not happen more than once          */                 /*225286*/
                                                                                          /*225286*/
             CHGDTAARA  DTAARA(&LMDTAARA (11 1)) VALUE('N')                               /*225286*/
                                                                                          /*225286*/
             GOTO       CMDLBL(LOOP)                                                      /*203561*/
                                                                                          /*203561*/
/*     Abnormal termination                                          */
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Lending PC Bulk Transfer Process has +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 
/*     Normal termination                                            */
 END:
             DLCOBJ     OBJ((LEBULK *DTAARA *EXCLRD))
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/************IF         COND(&PHASE *EQ 'A') THEN(DO)                       */ /*193560*/ /*192560*/
/************CALL       PGM(LEC2010)                                        */ /*176961*/ /*192560*/
/************ENDDO                                                          */ /*193560*/ /*192560*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
