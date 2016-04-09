/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AB Execute AB0340 - funding input')             */
/*********************************************************************/
/*                                                                   */
/*       Midas      -  Dealing Module                            */
/*                                                                   */
/*       ABC0340   - DL Internal Funding Deals Input                 */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 116094             DATE 06JUN06              */
/*       Prev Amend No. CSC023             Date 28Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      055989             Date 16Sep93              */
/*                      047073             Date 13Nov92              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       116094 - Partial incorporation of fix 116094 in Midas Plus. */
/*                Call DLC0211 via FCC0201 instead of via FCC0202.   */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       055989 - Apply GEMS fix 047073 & apply MONMSG to other      */
/*                occurence of QWSSSETWS.                            */
/*       047073 - V2 OF OPERATING SYSTEM CAUSES CPF94FC, TYPEAHEAD   */
/*                DATA STREAM NOT SUPPORTED BY CONTROLLER.           */
/*                                                                   */
/*********************************************************************/
 
             PGM        /* No parameters */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&TERM) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&MGDA) TYPE(*CHAR) LEN(50)
             DCL        VAR(&VERS) TYPE(*CHAR) LEN(70)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DLSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&KEYBUF) TYPE(*CHAR) LEN(1)
/*/COPY WNCPYSRC,ABC0340001                                          */
 
             DCLF       FILE(SDMGMEPD)
 
/* Monitor for fatal errors and exit program :                  */
 
             MONMSG     MSGID(CPF0000 CPA0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(PGMERR))
/* Set Job switches and LDA :                                   */
 
             CHGJOB     SWS(XXXXXX00)
             CHGDTAARA  DTAARA(*LDA) VALUE(' ')
 
/* Call the Internal Funding maintenance program :              */
 
             OVRDBF PRONO  SHARE(*NO)
             CALL   PGM(QWSSETWS) PARM('0')
             MONMSG     MSGID(CPF0000)                                /*047073*/
 
             CALL       PGM(AB0340) PARM(&TERM)
 
             RTVDTAARA  DTAARA(SDSTAT (11 1)) RTNVAR(&KEYBUF)
/************IF         COND(&KEYBUF *NE N) THEN(CALL +
                          PGM(QWSSETWS) PARM('1'))          */ /*LN1215 055989*/
             IF         COND(&KEYBUF *NE N) THEN(DO)                  /*055989*/
                  CALL         PGM(QWSSETWS) PARM('1')                /*055989*/
                  MONMSG     MSGID(CPF0000)                           /*055989*/
             ENDDO                                                    /*055989*/
             DLTOVR PRONO
 
/* Check Job switches for DB/Pgm. error :                      */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                 RTVDTAARA  DTAARA(*LDA (134 50)) RTNVAR(&MGDA)
                 SNDPGMMSG  MSGID(DBM0001) MSGF(DRSMM) MSGDTA(&MGDA) +
                            TOMSGQ(*LIBL/MOPERQ)
 
                 SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.+
                            Press ENTER to Continue.') TOPGMQ(*EXT)
 
                 ROLLBACK
             ENDDO
 
/* Call Confirmation Processing */
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
 
             IF         COND(%SWITCH(XXXXX000)) THEN(DO)
 
             RTVDTAARA  DTAARA(DLSTAT) RTNVAR(&DLSTAT)
 
/* Are Confirmations Running?  */
 
             IF         COND(%SST(&DLSTAT 6 1) *EQ 'N') THEN(DO)
 
             ALCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
             CHGDTAARA  DTAARA(DLSTAT (6 1)) VALUE('Y')
             DLCOBJ     OBJ((DLSTAT *DTAARA *EXCLRD))
 
             SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS)
 
/*/COPY WNCPYSRC,ABC0340002                                          */
/************SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(DLC0210A) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL DLC0210A') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
 
/************SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +                          /*CSC023*/
/************             RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +                         /*CSC023*/
/************             INLLIBL(*JOBD) MSGQ(MOPERQ)                                     /*CSC023*/
             SBMJOB     JOB(MIDASRMV) JOBD(MBATCH) USER(*JOBD) +
                          RTGDTA(*JOBD) RQSDTA('CALL MIDASRMV') +
                          INLLIBL(*JOBD) MSGQ(MOPERQ) OUTQ(*JOBD)                         /*CSC023*/
 
/*/COPY WNCPYSRC,ABC0340003                                          */
                     RCVF
                     IF         COND(&ENAPRG *EQ 'Y') THEN(DO)
/******************* CALL  PGM(FCC0202) PARM('DLC0211' '10001' + ***** 116094 */
/******************* 'DL0308' 'B')                                                   ***** 116094 */
                     CALL  PGM(FCC0201) PARM('DLC0211' '10001' +
                     'DL0308' 'B')                                                      /* 116094 */
                     ENDDO
 
             ENDDO
             ENDDO
 
 /* No errors - exit program normally :                         */
 
             GOTO       CMDLBL(PGMEND)
 
 /* Database or Program error - inform User and calling pgm.:   */
 
 PGMERR:     SNDPGMMSG MSG('Transaction Failed. Re-input Necessary.    +
                        Press ENTER to Continue.') TOPGMQ(*EXT)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
/* Program end (Normal or Abnormal) :                           */
 
 PGMEND:
 
/* Reclaim resources :                                          */
 
             RCLRSC
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
