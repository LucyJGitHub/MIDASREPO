/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE I/C Pay/Receive Telexes - Control')          */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*       SEC3300 - INPUT CYCLE PAY/RECEIVE CONTROL                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*       Last Amend No. CSC011             Date 18Sep01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01502             Date 08Jul94              */
/*                      E28678             Date 19Nov91              */
/*                      S01117             DATE 11JAN91              */
/*                      S01271             DATE 08JUN90              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CSC011 - 24x7 Midas Availability                            */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*  E28678  -  PAY/RECEIVES NEED TO RUN THROUGH RCF REQUEST PROGRAM */
/*             WHICH DOES THE SUBMITTING OF THE JOB                 */
/*  S01117  -  MULTIBRANCHING                                       */
/*  S01271  -  THIS PROGRAM CREATED FOR IC PAY/RECEIVE MOD.         */
/*                                                                  */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*****PGM***                                                       */ /*E28678*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*E28678*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*E28678*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*E28678*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*E28678*/
/*****DCL**VAR(&RUNDAT) TYPE(*CHAR) LEN(13)                   *S01117* *E28678*/
      DCL  VAR(&ZMUSER) TYPE(*CHAR) LEN(17)                           /*S01117*/
/*****DCL  VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/                        /*S01502*/
      DCL  VAR(&SESTAT) TYPE(*CHAR) LEN(133)                          /*S01502*/
             DCL        VAR(&CSC011) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE('       ')                   /*CSC011*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7)                                    /*CSC011*/
             DCL        VAR(&PSARD) TYPE(*CHAR) LEN(6)                                    /*CSC011*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CSC011*/
             DCL        VAR(&S1SUPP) TYPE(*CHAR) LEN(2) VALUE(' ')                        /*CSC011*/
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(2) VALUE(' ')                          /*CSC011*/
                                                                                          /*CSC011*/
/**********                                                   *S01117* *E28678*/
/**CHECK*IF*USER*IS*AUTHORISED*TO*BANK-LEVEL*AUTHORITY*********S01117* *E28678*/
/**********                                                   *S01117* *E28678*/
/**********  RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)        *S01117* *E28678*/
/**********  IF        COND(%SST(&RUNDAT 13 1) = 'Y') THEN(DO)*S01117* *E28678*/
/**********  RTVDTAARA  DTAARA(ZMUSER) RTNVAR(&ZMUSER)        *S01117* *E28678*/
/**********  IF      COND(%SST(&ZMUSER 17 1) *NE 'Y') THEN(DO)*S01117* *E28678*/
/**********     SNDPGMMSG  MSG('User does not have Bank level +        *E28678*/
/**********        authority') TOPGMQ(*EXT)                   *S01117* *E28678*/
/**********     GOTO       CMDLBL(ENDPROG)                    *S01117* *E28678*/
/**********  ENDDO                                            *S01117* *E28678*/
/**********  ENDDO                                            *S01117* *E28678*/
 
/* Check if switchable feature CSC011 is on */                                            /*CSC011*/
                                                                                          /*CSC011*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSC011*/
             CHGVAR     VAR(&POPTN) VALUE('*VERIFY')                                      /*CSC011*/
             CHGVAR     VAR(&PSARD) VALUE('CSC011')                                       /*CSC011*/
             CALL       PGM(AOSARDR0) PARM(&PRTCD &POPTN &PSARD +
                          &SCSARD)                                                        /*CSC011*/
             IF         COND(&PRTCD *EQ '       ') THEN(DO)                               /*CSC011*/
             CHGVAR     VAR(&CSC011) VALUE('Y')                                           /*CSC011*/
             RTVDTAARA  DTAARA(SC24X7 (3 2)) RTNVAR(&S1SUPP)                              /*CSC011*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&LIBR)                                /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
             IF         COND((&CSC011 *EQ 'Y') *AND (&S1SUPP *EQ +
                &LIBR)) THEN(DO)                                                          /*CSC011*/
                  SNDPGMMSG  MSG('Confirmation requested, but not +
                     valid on the support system') TOPGMQ(*EXT) +
                     TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO)                                  /*CSC011*/
                  GOTO       CMDLBL(ENDPROG)                                              /*CSC011*/
             ENDDO                                                                        /*CSC011*/
                                                                                          /*CSC011*/
      RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
/*  PAY/RECEIVES CANNOT BE RUN IF EUCLID INTERFACE IS INSTALLED */
/*  AND IS ACTIVE.                                              */
 
      IF  COND(%SST(&SESTAT 6 1) *EQ 'Y') +
      THEN(DO)
         IF  COND(%SST(&SESTAT 50 1) *EQ 'Y') +
         THEN(DO)
            SNDPGMMSG  MSG('PAY/RECEIVE PRINT REQUESTED BUT EUCLID +
                            TRANSMISSION IS ACTIVE') TOMSGQ(MOPERQ) +
                       TOPGMQ(*EXT) MSGTYPE(*INFO)
            GOTO CMDLBL(ENDPROG)
         ENDDO
      ENDDO
 
/*  PAY/RECEIVES CANNOT BE RUN IF THEY HAVE ALEADY BEEN SET    */
/*  RUNNING AND HAVE NOT YET COMPLETED.                        */
 
      RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
 
      IF COND(%SUBSTRING(&SESTAT 74 1) *EQ 'Y') +
      THEN(DO)
         SNDPGMMSG  MSG('PAY/RECEIVE PRINT REQUESTED +
                         BUT ACTIVE') TOMSGQ(MOPERQ) +
                    TOPGMQ(*EXT) MSGTYPE(*INFO)
         GOTO CMDLBL(ENDPROG)
      ENDDO
 
/*  PAY/RECEIVES CANNOT BE RUN IF CONFIRMATIONS ARE RUNNING    */
/*  AS FILES WILL NOT BE AVAILABLE.                            */
 
      RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
      IF    COND(%SUBSTRING(&SESTAT 73 1) *EQ Y) +
      THEN(DO)
         SNDPGMMSG  MSG('PAY/RECEIVE CANNOT BE RUN AS +
                         CONFIRMATIONS ARE ACTIVE') TOMSGQ(MOPERQ) +
                    TOPGMQ(*EXT) MSGTYPE(*INFO)
         GOTO CMDLBL(ENDPROG)
      ENDDO
 
/*  ALLOCATE SESTAT, INDICATE PAY/RECEIVE IS ACTIVE, AND THEN  */
/*  DEALLOCATE.                                                */
 
      ALCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
      RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)
      CHGVAR     VAR(%SUBSTRING(&SESTAT 74 1)) VALUE(Y)
      CHGDTAARA  DTAARA(SESTAT) VALUE(&SESTAT)
      DLCOBJ     OBJ((SESTAT *DTAARA *EXCLRD))
 
/***A*'MIDAS'*MESSAGE*IS*WRITTEN*TO*MSTATUS*WHILST*THE*PAY/**/        /*E28678*/
/***REPORTS*ARE*BEING*SUBMITTED*TO*BATCH*TO*PREVENT*A*CLOSE**/        /*E28678*/
/***OF*BUSINESS*BEING*STARTED.*******************************/        /*E28678*/
/**********                                                            *E28678*/
/*****SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)                          *E28678*/
/**********                                                            *E28678*/
/***PAY/RECEIVE*MESSAGES*ARE*SUBMITTED*TO*BATCH*SO*THAT********/      /*E28678*/
/***RESPONSE*TIMES*ARE*NOT*DEGRADED*WHILST*P/R*IS*ACTIVE.******/      /*E28678*/
/**********                                                            *E28678*/
/*****SBMJOB     JOB(SEC3305) JOBD(MBATCH) USER(*JOBD)              +  *E28678*/
/**********      RQSDTA('CALL SEC3305') MSGQ(MOPERQ)                   *E28678*/
/**********                                                            *E28678*/
/***REMOVE*MIDAS*MESSAGE*NOW*JOB*HAS*BEEN*SUBMITTED**********/        /*E18678*/
/**********                                                            *E28678*/
/*****SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD)             +  *E28678*/
/**********       RQSDTA('CALL MIDASRMV') MSGQ(MOPERQ)                 *E28678*/
                                                                      /*E28678*/
/***                                                                   *E28678*/
/** CALL CL PROGRAM WHICH PRODUCES PAY/RECEIVE MESSAGES                *E28678*/
/***                                                                   *E28678*/
             CALL       PGM(SEC3305)                                  /*E28678*/
 
/*  END PROGRAM                                             */
ENDPROG:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
      ENDPGM
