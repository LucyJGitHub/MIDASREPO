/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL On-request menu - interest tax')             */
/********************************************************************/
/*                                                                  */
/*       Midas     - Dealing Module                             */
/*                                                                  */
/*       DLC1402P - ON REQUEST PROCESSING MENU                      */
/*                  (BASED ON L3MNUK)                               */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E36223             Date 30Apr92              */
/*                      E38675             Date 23Apr92              */
/*                      E245           DATE 7MAR90                  */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*    E36223 - ALLOW DISPLAY OF PROMPT VALUE WHEN AMEND             */
/*    E38675 - SHOW MIDAS RUN DATE ON DISPLAY INSTEAD OF ACTUAL DATE*/
/*    E245 - CORRECT PARMS AND ADD CMD PROCESSING                   */
/*                                                                  */
/********************************************************************/
/************PGM PARM(&RSEQ &RLEV &RENT &PARM &ACTN)                  /*E245*/
             PGM PARM(&RSEQ &RLEV &RENT &PARM &RACT &RCMD)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(1) VALUE(C)
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(100)
/************DCL        VAR(&ACTN) TYPE(*CHAR) LEN(1)                 /*E245*/
             DCL        VAR(&RACT) TYPE(*CHAR) LEN(1) /* ACTION */
             DCL        VAR(&RCMD) TYPE(*CHAR) LEN(1) /* CMD KEY*/
   DCL VAR(&RSEQ) TYPE(*CHAR) LEN(5) /* RCF sequence number */
   DCL VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level flag (S/C/B)*/
   DCL VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity code (all/comp/bch)*/
             DCL        VAR(&DEVNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCLF       DL1402DF RCDFMT(DL1402DF)
/**/
/* RETRIEVE THE RUN DATE FOR DISPLAY                                 /*E38675*/
             RTVDTAARA  DTAARA(RUNDAT (1 7)) RTNVAR(&SRUNA)          /*E38675*/
/**/
             IF         COND(%SWITCH(XXX1XXXX)) THEN(CHGVAR VAR(&TYPE) +
                          VALUE(I))
                                                                      /*E245*/
/* IF DELETE THEN ENABLE F10                                   */     /*E245*/
             IF (&RACT *EQ 'D') THEN(CHGVAR &IN25 '1')                /*E245*/
 
                                                                      /*E245*/
/* IF DELETE OR ENQUIRY PROTECT FIELDS TO PREVENT INPUT        */     /*E245*/
/* AND DISPLAY SELECTED OPTION                                 */
 
             IF         COND((&RACT *EQ 'D') *OR (&RACT *EQ 'E')) +
                          THEN(DO)                                    /*E245*/
                    CHGVAR VAR(&IN30) VALUE('1')                      /*E245*/
                    CHGVAR VAR(&MOPTN) VALUE(%SST(&PARM 1 2))         /*E245*/
             ENDDO                                                    /*E245*/
             IF         COND(&RACT *EQ 'A') THEN(DO)                  /*E36223*/
                    CHGVAR VAR(&MOPTN) VALUE(%SST(&PARM 1 2))         /*E36223*/
             ENDDO                                                    /*E36223*/
 
             RTVJOBA    JOB(&DEVNM) USER(&USER)
MNUBGN:      SNDRCVF    RCDFMT(DL1402DF)
/**/
 
/*  TEST FOR FUNCTION KEY F3 - EXIT OPTION                     */
 
             IF         COND(&IN03 *EQ '1') THEN(DO)
/**************             CHGVAR     VAR(&ACTN) VALUE(I)            /*E245*/
                            CHGVAR     VAR(&RCMD) VALUE(E)
                            RETURN
             ENDDO
 
/*  TEST FOR FUNCTION KEY F12 - PREVIOUS SCREEN                */
 
             IF         COND(&IN12 *EQ '1') THEN(DO)
/**************             CHGVAR     VAR(&ACTN) VALUE(E)            /*E245*/
                            CHGVAR     VAR(&RCMD) VALUE(F)
                            RETURN
             ENDDO
 
/*  TEST FOR FUNCTION KEY F10 - DELETE REPORT REQUEST          */
 
             IF         COND(&IN10 *EQ '1') THEN(DO)                  /*E245*/
                            CHGVAR     VAR(&RCMD) VALUE(D)            /*E245*/
                            RETURN                                    /*E245*/
             ENDDO
 
/*  CHECK FOR REQUEST OPTIONS                                    */
 
             IF         COND((&MOPTN *EQ '01') *OR (&MOPTN *EQ '1')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(01I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '02') *OR (&MOPTN *EQ '2')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(02I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '03') *OR (&MOPTN *EQ '3')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(03I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '04') *OR (&MOPTN *EQ '4')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(04I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '05') *OR (&MOPTN *EQ '5')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(05I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '06') *OR (&MOPTN *EQ '6')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(06I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '07') *OR (&MOPTN *EQ '7')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(07I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '08') *OR (&MOPTN *EQ '8')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(08I)
                            GOTO  MNUEND
             ENDDO
             IF         COND((&MOPTN *EQ '09') *OR (&MOPTN *EQ '9')) +
                          THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(09I)
                            GOTO  MNUEND
             ENDDO
             IF         COND(&MOPTN *EQ '10') THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(10I)
                            GOTO  MNUEND
             ENDDO
             IF         COND(&MOPTN *EQ '11') THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(11I)
                            GOTO  MNUEND
             ENDDO
             IF         COND(&MOPTN *EQ '12') THEN(DO)
                            CHGVAR     VAR(&PARM) VALUE(12I)
                            GOTO  MNUEND
             ENDDO
             CHGVAR     VAR(&IN20) VALUE('1')
             GOTO       MNUBGN
MNUEND:      CHGJOB     SWS(00000000)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             ENDPGM
