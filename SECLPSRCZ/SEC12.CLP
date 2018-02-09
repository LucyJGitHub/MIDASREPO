/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE EUCLID Interface Control Program')           */
/********************************************************************/
/*                                                                  */
/*         Midas     - Securities Trading Module                */
/*                                                                  */
/*         SEC12 - EUCLID PROCESSING                                */
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
/*       Prev Amend No. S01502             Date 08Jul94              */
/*                      E32025             Date 18Nov91              */
/*                      S01117                  DATE  10JAN91       */
/*                      E23408                  DATE  06SEP90       */
/*                      E16870                  DATE  08/03/89      */
/*                      S01179                  DATE  16/09/88      */
/*                      S01158                  DATE  09/05/88      */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       S01502 - BLI Telekurs Processing.  Recompiled due to        */
/*                change in length of SESTAT, 133 long.              */
/*       E32025 - Prevent the running of this pgm if Pay/Receive    */
/*                I/C run has failed to complete successfully       */
/*       S01117 - MULTIBRANCHING                                    */
/*       E23408 - SETON U1 IF RETAIL II OR INTEREST ON ACCOUNTS     */
/*                SET ON IN SYSTEM - CONDITIONS UPDATE OF RETAIL    */
/*                ACCOUNT SHADOW BALANCES IN SE1270.                */
/*       E16870 - SESTAT REDEFINED AS 128 BYTES.                    */
/*       S01179 -  RELEASE                                       */
/*       S01158 - POST INCORPORATION DEVELOPMENT FIXES              */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/                                                                  /*S01117*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PGM) TYPE(*CHAR) LEN(8)
/************DCL        VAR(&MEM)  TYPE(*CHAR) LEN(44)               * *S01117*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*S01117*/
             DCL        VAR(&MSG2) TYPE(*CHAR) LEN(80)
             DCL        VAR(&MSG3) TYPE(*CHAR) LEN(80)
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5) VALUE('     ')  /*S01117*/
/*                                                                     *S01179*/
/************DCLDTAARA  DTAARA(LDA)                          ********  *S01179*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)               /*E23408*/
             DCL        VAR(&RUNDAT) TYPE(*CHAR) LEN(13)              /*S01117*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(17)              /*S01117*/
/*                                                                     *S01179*/
/************DCLDTAARA  DTAARA(SESTAT)                       ********  *S01179*/
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(256)        *S01179E16870*/
/************DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(128)*/    /*E16870 S01502*/
             DCL        VAR(&SESTAT) TYPE(*CHAR) LEN(133)             /*S01502*/
/**/                                                                  /*S01158*/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNORMAL))    /*S01158*/
/**/
/*********   RCVDTAARA  DTAARA(SESTAT)                      *********  *S01179*/
             RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)                /*S01179*/
/**/
/* CHECK IF EUROCLEAR INTERFACE SELECTED                            */
/**/
             IF         COND(%SST(&SESTAT 6 1) = 'N') THEN(DO)
                SNDPGMMSG  MSG('Euroclear Interface Not Selected In +
                          Installation Control') TOPGMQ(*EXT)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/
/* CHECK IF EUROCLEAR AUTOMATIC SETTLEMENT OPTION SELECTED          */
/**/
             IF         COND(%SST(&SESTAT 20 1) = ' ') THEN(DO)
                SNDPGMMSG  MSG('Euroclear Automatic Transmission +
                   Option Not Selected In Installation Control') +
                          TOPGMQ(*EXT)
                GOTO       CMDLBL(ENDPGM)
             ENDDO
/**/                                                                  /*S01117*/
/* CHECK IF USER IS AUTHORISED TO BANK-LEVEL AUTHORITY                 *S01117*/
/**/                                                                  /*S01117*/
             RTVDTAARA  DTAARA(RUNDAT) RTNVAR(&RUNDAT)                /*S01117*/
             IF         COND(%SST(&RUNDAT 13 1) = 'Y') THEN(DO)       /*S01117*/
             RTVDTAARA  DTAARA(ZMUSER) RTNVAR(&ZMUSER)                /*S01117*/
             IF         COND(%SST(&ZMUSER 17 1) *NE 'Y') THEN(DO)     /*S01117*/
                SNDPGMMSG  MSG('User does not have Bank level +
                   authority') TOPGMQ(*EXT)                           /*S01117*/
                GOTO       CMDLBL(ENDPGM)                             /*S01117*/
             ENDDO                                                    /*S01117*/
             ENDDO                                                    /*S01117*/
/**/                                                                  /*E32025*/
/* Check if Pay/Receive I/C has completed successfully                 *E32025*/
/**/                                                                  /*E32025*/
IF COND(%SST(&SESTAT 75 1) = 'Y' *OR %SST(&SESTAT 74 1) = 'Y') THEN(DO)
   SNDPGMMSG  MSG('Pay/Receive telex generation must complete +
 successfully before Euclid transmission is possible') TOPGMQ(*EXT)   /*E32025*/
                GOTO       CMDLBL(ENDPGM)                             /*E32025*/
             ENDDO                                                    /*E32025*/
/**/
/* CHECK EUCLID 'BUSY' FLAG                                         */
/**/
             IF         COND(%SST(&SESTAT 50 1) = 'N') THEN(DO)
/**/
/* SET 'BUSY' FLAG ON                                               */
/**/
                CHGDTAARA  DTAARA(SESTAT (50 1)) VALUE('Y')
                CHGDTAARA  DTAARA(LDA) VALUE(' ')
                CHGJOB     SWS(00000000)
/**/
RERUN:
/**/
/* CALL SUB-COMPONENT FOR TRANSMISSION                              */
/**/
/***************CALL       PGM(SEC1201) PARM(&MSG2 &MSG3)            * *S01117*/
                CALL       PGM(SEC1201) PARM(&MSG2 &MSG3 &RSEQ)       /*S01117*/
/**/
/* CALL SUB-COMPONENT FOR REFORMAT, IF SUCCESSFUL COMPLETION        */
/**/
                IF         COND(%SWITCH(XXXXX000)) THEN(DO)
/**/
/* & CMD/7 NOT TAKEN IN ST1200                                      */
/**/
/*********         RCVDTAARA  DTAARA(SESTAT)                *********  *S01179*/
                   RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)          /*S01179*/
                   IF         COND(%SST(&SESTAT 52 1) *EQ 'Y') THEN(DO)
/**/
/* IF RETAIL II OR INTEREST ON ACCOUNTS INSTALLED, SETON U1            *E23408*/
/*  (USED TO CONDITION UPDATE OF RETAIL A/C SHADOW BAL. IN SE1270)     *E23408*/
                      CHGJOB     SWS(0XXXXXXX)                        /*E23408*/
                      RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)           /*E23408*/
                      IF         COND((%SST(&MMOD 16 1) *EQ 'Y') *OR +
                              (%SST(&MMOD 23 1) *EQ 'Y')) THEN( +
                              CHGJOB SWS(1XXXXXXX))                   /*E23408*/
/**/
/*********************CALL       PGM(SEC1202) PARM(&MSG2 &MSG3)      * *S01117*/
                      CALL       PGM(SEC1202) PARM(&MSG2 &MSG3 &RSEQ) /*S01117*/
                      CHGJOB     SWS(0XXXXXXX)                        /*E23408*/
/**/
/* CALL SUB-COMPONENT FOR REPORTS, IF SUCCESSFUL COMPLETION        */
/**/
                      IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/*********************CALL       PGM(SEC1203) PARM(&MSG2 &MSG3)      * *S01117*/
                      CALL       PGM(SEC1203) PARM(&MSG2 &MSG3 &RSEQ) /*S01117*/
                      ENDDO
                   ENDDO
                ENDDO
/**/
/*          IF STILL INSTRUCTIONS OUTSTANDING PROMPT FOR ANOTHER     */
/*          TRANSMISSION                                             */
/**/
                IF         COND(%SWITCH(XXXXXXX0)) THEN(DO)
/* S01179                                                              *S01179*/
/*********         RCVDTAARA  DTAARA(SESTAT)                *********  *S01179*/
                   RTVDTAARA  DTAARA(SESTAT) RTNVAR(&SESTAT)          /*S01179*/
                   IF         COND(%SST(&SESTAT 53 1) ='Y') THEN(DO)
RETRY:
                      SNDPGMMSG  MSG('Instructions are still available +
                         for transmission. Do you wish to transmit again +
                         (''Y'' or ''N'')?') TOPGMQ(*EXT) +
                         MSGTYPE(*INQ)
             RCVMSG     PGMQ(*EXT) MSGTYPE(*RPY) WAIT(*MAX) MSG(&RPY)
                      IF         COND((&RPY *EQ 'Y') *OR +
                         (&RPY *EQ 'y')) THEN(GOTO   CMDLBL(RERUN))
                      IF         COND((&RPY *NE 'N') *AND +
                         (&RPY *NE 'n')) THEN(GOTO   CMDLBL(RETRY))
                   ENDDO
                ENDDO
/**/
/*          FOR DATABASE ERRORS RECOVER DATA FROM LDA                */
/**/
                IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/* S01179                                                              *S01179*/
/*********         RCVDTAARA  DTAARA(LDA)                   *********  *S01179*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*S01179*/
/******************CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 44))     * *S01117*/
                   CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))      /*S01117*/
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
/**/
/*         FOR FILE CONTROL ERROR RECOVER DATA FROM LDA              */
/**/
                IF         COND(%SWITCH(XXXXXX01)) THEN(DO)
/* S01179                                                              *S01179*/
/*********         RCVDTAARA  DTAARA(LDA)                   *********  *S01179*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*S01179*/
                   CHGVAR     VAR(&PGM) VALUE(%SST(&LDA 168 8))
                   SNDPGMMSG  MSGID(MEM0002) MSGF(MIDAS) MSGDTA(&PGM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                ENDDO
/**/
/* SET 'BUSY' FLAG OFF                                              */
/**/
                CHGDTAARA  DTAARA(SESTAT (50 1)) VALUE('N')
             ENDDO
/**/
             ELSE       CMD(DO)
/**/
/* SEND PROGRAM MESSAGE IF 'BUSY' FLAG IS ON                        */
/**/
                SNDPGMMSG  MSG('Program cannot be run at this time') +
                          TOPGMQ(*EXT)
             ENDDO
             GOTO ENDPGM                                              /*S01158*/
/**/                                                                  /*S01158*/
/*          IF UNSPECIFIED ERROR SEND MESSAGE AND RESET BUSY FLAG   *  *S01158*/
/**/                                                                  /*S01158*/
ABNORMAL:    SNDPGMMSG  MSG('PROGRAM SEC12 ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*S01158*/
                MONMSG     MSGID(CPF2400)                             /*S01158*/
                CHGDTAARA  DTAARA(SESTAT (50 1)) VALUE('N')           /*S01158*/
                MONMSG     MSGID(CPF1000)                             /*S01158*/
/**/
ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
