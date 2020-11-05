/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Facility History Update 1')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC30  - Facility history update 1                         */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*                                                                   */
/*       Last Amend No. MD057158           Date 05Nov20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      MD033997           Date 11May15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE025             Date 20Oct03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CLE023             Date 19Nov01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      MOF60              Date 23Mar92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057158 - Incorrect update of facility amount and drawn    */
/*                  amount in FACHISA during ANWD COB for a facility */
/*                  with backvalued MR. Clear FACACT for non-working */
/*                  day processing and CLE025 is OFF. Pattern after  */
/*                  fix SC224775.                                    */
/*       MD046248 - Finastra Rebranding                              */
/*       MD033997 - Move process of facility expiry on 2nd COB.      */
/*                Populate LEHISAPD with 'FE' events as this file is */
/*                used on 2nd COB run instead of HISACT.             */
/*       CLE025 - Credit Lines                                       */
/*       CLE023 - Lending Facility History Improvements.             */
/*       MOF60  - Customer Lending R10 enhancements                  */
/*                                                                   */
/*********************************************************************/

/**********  PGM  PARM(&CNAM &CSEQ)                                  */                 /*MD033997*/
             PGM  PARM(&CNAM &CSEQ &RERUN)                                              /*MD033997*/

/* Declare the variables for rerun checking */

     DCL VAR(&CNAM) TYPE(*CHAR) LEN(10)
     DCL VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
     DCL VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             DCL        VAR(&RERUN) TYPE(*CHAR) LEN(10)                                 /*MD033997*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CLE023*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                     /*CLE023*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                                      /*CLE023*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CLE023*/
             DCL        VAR(&CLE023) TYPE(*CHAR) LEN(1)                                   /*CLE023*/
             DCL        VAR(&CLE025) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CLE025*/
                                                                                          /*CLE023*/
     SNDPGMMSG  MSG('Facility History Update Part 1') +
                                       TOMSGQ(MRUNQ)

/** Access SAR file to determine if switchable feature CLE023     */                      /*CLE023*/
/** is switched ON                                                */                      /*CLE023*/
                                                                                          /*CLE023*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE023*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE023*/
             CHGVAR     VAR(&SAR) VALUE('CLE023')                                         /*CLE023*/
             CHGVAR     VAR(&CLE023) VALUE('N')                                           /*CLE023*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE023*/
                                                                                          /*CLE023*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE023*/
             CHGVAR     VAR(&CLE023) VALUE('Y')                                           /*CLE023*/
             ENDDO                                                                        /*CLE023*/
                                                                                          /*CLE025*/
/** Access SAR file to determine if switchable feature CLE025     */                      /*CLE025*/
/** is switched ON                                                */                      /*CLE025*/
                                                                                          /*CLE025*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE025*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE025*/
             CHGVAR     VAR(&SAR) VALUE('CLE025')                                         /*CLE025*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE025*/
                                                                                          /*CLE025*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE025*/
             CHGVAR     VAR(&CLE025) VALUE('Y')                                           /*CLE025*/
             ENDDO                                                                        /*CLE025*/
                                                                                          /*CLE025*/
/* CLEAR EXTRACT FILES */

     IF         COND(&CLE025 = 'N') THEN(DO)                                              /*CLE025*/
     CLRPFM HISACT
     ENDDO                                                                                /*CLE025*/
                                                                                          /*CLE025*/
/****IF*COND(&CLE023 *EQ 'N') THEN(DO)                                        */ /*CLE023 MD057158*/
     IF         COND((&CLE023 *EQ 'N') +
                  *OR (&CLE025 *EQ 'N' *AND &CSEQ *EQ 2)) THEN(DO)                      /*MD057158*/
             CLRPFM     FILE(FACACT)
     ENDDO                                                                                /*CLE023*/

/* Check the current status of this component */

     CALL PGM(CB0160) PARM(&CNAM &CSEQ &STAT)

     IF COND(&STAT *EQ 'N') THEN(DO)

/* IF NOT RERUN Take Security Copy of History Files */

     CPYF       FROMFILE(FACHISH) TOFILE(XFACHISH) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XFACHISH))
                                                                                          /*CLE023*/
     IF COND(&CLE023 *EQ 'Y') THEN(DO)                                                    /*CLE023*/
             CPYF       FROMFILE(FACACT) TOFILE(XFACACT) +
                          MBROPT(*REPLACE)                                                /*CLE023*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XFACACT))                                                  /*CLE023*/
     ENDDO                                                                                /*CLE023*/

/* Set the status to failed (&STAT = Y) in case the program fails */

     CHGVAR VAR(&STAT) VALUE('Y')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

     ENDDO
     ELSE CMD(DO)

/* IF RERUN Copy back Security Copy of History Files*/
     CPYF       FROMFILE(XFACHISH) TOFILE(FACHISH) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(FACHISH))

     IF COND(&CLE023 *EQ 'Y') THEN(DO)                                                    /*CLE023*/
             CPYF       FROMFILE(XFACACT) TOFILE(FACACT) +
                          MBROPT(*REPLACE)                                                /*CLE023*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(FACACT))                                                   /*CLE023*/
     ENDDO                                                                                /*CLE023*/
                                                                                          /*CLE023*/
     ENDDO

  /* Call Manual Changes Extract Program */

             IF         COND(&RERUN *EQ 'NEWCOB') THEN(DO)                             /*MD033997*/
             CLRPFM     LEHISAPD                                                       /*MD033997*/
             OVRDBF     FILE(HISACT) TOFILE(LEHISAPD)                                  /*MD033997*/
             ENDDO                                                                     /*MD033997*/
             CALL LER030

  /* IF ERROR, SEND MSG & COPY BACK SECURITY FILES     */
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)

            SNDPGMMSG  MSG('Job terminated, database in error. +
                          Contact Systems Department.') +
                       TOMSGQ(MOPERQ MRUNQ)

     ENDDO
     ELSE  CMD(DO)

/* If the component has completed successfully reset the status field */

     CHGVAR VAR(&STAT) VALUE('N')
     CALL PGM(CB0150) PARM(&CNAM &CSEQ &STAT)

     ENDDO

             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

ENDPGM
