/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AC ACSTAT data area maintenance program')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       ACC0009 - ACSTAT data area maintenance program.             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. 098705             DATE 05FEB96              */
/*       PREV AMEND NO. S01491 *CREATE     DATE 01OCT94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       098705 - Amend setup program to set up primary and          */
/*                secondary devices.                                 */
/*              - Remove redundant fields ACUSER and ACJOBN          */
/*       S01491 - Autocall.                                          */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&ACSTAT) TYPE(*CHAR) LEN(100)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE(' ')     /*098705*/
             DCLF       FILE(AC0009DF)
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO ABNOR)
/**/
/* Allocate data area ACSTAT */
/**/
             ALCOBJ     OBJ((ACSTAT *DTAARA *EXCL))
/**/
             RTVJOBA    JOB(&WJOB) USER(&WUSER)
/**/
 REFRESH:    RTVDTAARA  DTAARA(ACSTAT) RTNVAR(&ACSTAT)
             CHGVAR     VAR(&ACRMTS) VALUE(%SST(&ACSTAT 1 1))
             CHGVAR     VAR(&ACMIDS) VALUE(%SST(&ACSTAT 2 2))
             CHGVAR     VAR(&ACRMTR) VALUE(%SST(&ACSTAT 4 1))
             CHGVAR     VAR(&ACRSNM) VALUE(%SST(&ACSTAT 5 10))        /*098705*/
/************CHGVAR     VAR(&ACUSER) VALUE(%SST(&ACSTAT 5 10))     */ /*098705*/
/************CHGVAR     VAR(&ACJOBN) VALUE(%SST(&ACSTAT 15 6))     */ /*098705*/
             CHGVAR     VAR(&ACECSU) VALUE(%SST(&ACSTAT 21 10))
             CHGVAR     VAR(&ACECSP) VALUE(%SST(&ACSTAT 31 10))
             CHGVAR     VAR(&ACCLNT) VALUE(%SST(&ACSTAT 41 10))
             CHGVAR     VAR(&ACFALB) VALUE(%SST(&ACSTAT 51 1))
/**/
/* Display screen */
DISPLAY:                                                              /*098705*/
/**/
             SNDRCVF    RCDFMT(AC0009S0)
/**/
             IF         COND(&IN03) THEN(GOTO CMDLBL(ENDPGM))
             IF         COND(&IN05) THEN(GOTO CMDLBL(REFRESH))
/**/
/* Validate screen */                                                 /*098705*/
             CHGVAR     VAR(&IN20) VALUE('0')                         /*098705*/
             CHGVAR     VAR(&ERMSG) VALUE(' ')                        /*098705*/
/**/                                                                  /*098705*/
             IF         COND(&ACCLNT  *EQ ' ') THEN(DO)               /*098705*/
             CHGVAR     VAR(&IN20) VALUE('1')                         /*098705*/
             CHGVAR     VAR(&ERMSG) VALUE('Client name not valid')    /*098705*/
             GOTO       DISPLAY                                       /*098705*/
             ENDDO                                                    /*098705*/
/**/                                                                  /*098705*/
             IF         COND((&ACECSU *EQ ' ') *OR (&ACECSP *EQ ' '))  +
                          THEN(DO)                                    /*098705*/
             CHGVAR     VAR(&IN20) VALUE('1')                         /*098705*/
             CHGVAR     VAR(&ERMSG) VALUE('ECS Profile/Password not +
                          correct')                                   /*098705*/
             GOTO       DISPLAY                                       /*098705*/
             ENDDO                                                    /*098705*/
/**/                                                                  /*098705*/
             IF         COND(&ACRSNM *EQ ' ') THEN(DO)                /*098705*/
             CHGVAR     VAR(&IN20) VALUE('1')                         /*098705*/
             CHGVAR     VAR(&ERMSG) VALUE('Resource name not valid')  /*098705*/
             GOTO       DISPLAY                                       /*098705*/
             ENDDO                                                    /*098705*/
/**/                                                                  /*098705*/
/* If any errors, redisplay screen.                                   /*098705*/
/**/                                                                  /*098705*/
/* Update data area with new values */
/**/
             CHGVAR     VAR(%SST(&ACSTAT 1 1)) VALUE(&ACRMTS)
             CHGVAR     VAR(%SST(&ACSTAT 2 2)) VALUE(&ACMIDS)
             CHGVAR     VAR(%SST(&ACSTAT 4 1)) VALUE(&ACRMTR)
             CHGVAR     VAR(%SST(&ACSTAT 5 10)) VALUE(&ACRSNM)        /*098705*/
/************CHGVAR     VAR(%SST(&ACSTAT 5 10)) VALUE(&ACUSER)     */ /*098705*/
/************CHGVAR     VAR(%SST(&ACSTAT 15 6)) VALUE(&ACJOBN)     */ /*098705*/
             CHGVAR     VAR(%SST(&ACSTAT 21 10)) VALUE(&ACECSU)
             CHGVAR     VAR(%SST(&ACSTAT 31 10)) VALUE(&ACECSP)
             CHGVAR     VAR(%SST(&ACSTAT 41 10)) VALUE(&ACCLNT)
             CHGVAR     VAR(%SST(&ACSTAT 51 1)) VALUE(&ACFALB)
/**/
             CHGDTAARA  DTAARA(ACSTAT) VALUE(&ACSTAT)
/**/
/* Create Primary and Secondary (Fallback) devices                    /*098705*/
             CALL       PGM(PRIMARY) PARM(&ACRSNM &ERROR)             /*098705*/
             IF         COND(&ERROR *EQ 'Y') THEN(DO)                 /*098705*/
             GOTO       CMDLBL(ABNOR)                                 /*098705*/
             ENDDO                                                    /*098705*/
             CALL       PGM(SECONDARY) PARM(&ACRSNM &ERROR)           /*098705*/
             IF         COND(&ERROR *EQ 'Y') THEN(DO)                 /*098705*/
             GOTO       CMDLBL(ABNOR)                                 /*098705*/
             ENDDO                                                    /*098705*/
/**/                                                                  /*098705*/
             GOTO       CMDLBL(ENDPGM)
/**/
/* Error processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('ACSTAT data area maintenance program +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 ENDPGM:     DLCOBJ     OBJ((ACSTAT *DTAARA *EXCL))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
