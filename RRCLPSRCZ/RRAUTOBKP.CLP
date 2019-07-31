/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Auto-backup of journal receivers')           */
/********************************************************************/
/*                                                                  */
/*  Midas - Restart Recovery Module                         */
/*                                                                  */
/*  RRAUTOBKP - AUTO BACKUP OF JOURNAL RECEIVERS                    */
/*                                                                  */
/*       (c) Finastra International Limited 2001                    */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  PREV AMEND NO. S01343                       DATE 15AUG91        */
/*                 S01179                       DATE 10/09/88       */
/*                                                                  */
/********************************************************************/
/*  MD046248 - Finastra Rebranding                                  */
/*  S01343  -  SC/RR/SD MODULE RENAME PROJECT.                      */
/*             - RENAMED FROM AUTOBKP.                              */
/*  S01179 - AS400 CONVERSION                                       */
/********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
/*/COPY WNCPYSRC,RRAUTOBK01                                          */
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(1) VALUE('1')
/*/COPY WNCPYSRC,RRAUTOBK02                                          */
/**/
/********    DCLDTAARA  DTAARA(JNSTAT)                             *  *S01179*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)            /*S01179*/
/**/
/* GLOBAL MONITOR MESSAGES */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* RETRIEVE JOB ATTRIBUTES */
/**/
             RTVJOBA    JOB(&JOBN) USER(&USRN) NBR(&JBNB)
/**/
/* AMEND JNSTAT WITH JOB DETAILS                                    */
/**/
             CHGDTAARA  DTAARA(JNSTAT (111 26)) VALUE(&JOBN *CAT +
                          &USRN *CAT &JBNB)
/**/
/*START:***  RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
 START:      RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
/* CAUSE THE JOB TO PAUSE FOR THE SPECIFIED PERIOD AFTER EACH CYCLE */
/**/
             DLYJOB     DLY(%SST(&JNSTAT 106 5))
/**/
/*********   RCVDTAARA  DTAARA(JNSTAT)                              *  *S01179*/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)                /*S01179*/
/**/
/* IF 'DELAY PERIOD' IS ZERO THEN END PROCESSING */
/**/
             IF         COND(%SST(&JNSTAT 106 5) *EQ '00000') THEN(DO)
                  CHGDTAARA  DTAARA(JNSTAT (111 26)) +
                               VALUE('                          ')
                  GOTO END
             ENDDO
/**/
/* SAVE JOURNAL RECEIVERS */
/**/
             CALL       PGM(SDC1715) PARM(&PARM)
/**/
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
/**/
             GOTO       CMDLBL(START)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('RRAUTOBKP ENDED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:         ENDPGM
