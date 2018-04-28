/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Allocation List/Audit')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC6800 - Early Redemptions Allocation Audit Report         */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01496             DATE 12OCT94              */
/*       PREV AMEND NO. S10978             DATE 26MAR93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                   */ /*S01496*/
             PGM        PARM(&RSEQ &RLEV &RENT)                       /*S01496*/
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01496*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01496*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01496*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)
 
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Create LDA if not present */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE))
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
 
/* Retrieve Job attributes */
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)
 
             SNDPGMMSG  MSG('SE6800 - Early Redemptions Allocations +
                          Audit Report') TOMSGQ(MRUNQ)
 
/* Override the File on itself */
             OVRDBF     FILE(SEERRFL1) SHARE(*YES)
 
/* Process an Open Query File to Select the Records of Today */
             OPNQRYF    FILE((SEERRFL1) (SDBANKPD)) FORMAT(SEERRFL1 +
                          SEERRFD0) QRYSLT('VALCD *EQ BJRDNB') +
                          KEYFLD((1/VAERRF *ASCEND)) JFLD(*NONE) +
                          MAPFLD(*NONE)
 
/* Call RPG Pgm */
/*********** CALL       PGM(SE6800) PARM(' ' '*AUDIT')             */ /*S01496*/
             CALL       PGM(SE6800) PARM(' ' '*AUDIT' &RSEQ)          /*S01496*/
 
/* If error */
             MONMSG     MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
               CHGJOB     SWS(XXXXXX11)
               RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********   SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) +          */ /*S01496*/
/***********              MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ) */ /*S01496*/
/***********   SNDMSG     MSG('SE6820 ENDED ABNORMALLY FOR JOB ' *CAT /*S01496*/
/***********              &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +    /*S01496*/
/***********              *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)     */ /*S01496*/
               SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) +
                          MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    /*S01496*/
               SNDMSG     MSG('SE6800 ENDED ABNORMALLY FOR JOB ' *CAT +
                          &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' +
                          *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)        /*S01496*/
               GOTO       CMDLBL(ERROR)
             ENDDO
 
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) /*S01496*/
/***********                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
/***********    CHGVAR VAR(&MEM) VALUE('SEC6820 - JOB TERMINATED, +*/ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6800 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
             ENDDO
 
 ERROR:      CLOF       OPNID(SEERRFL1)
             MONMSG     MSGID(CPF0000)
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             RETURN
 
 ENDCLPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
