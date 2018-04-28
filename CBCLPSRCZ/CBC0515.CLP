/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Maintain COB user file')                     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0515 - COB MAINTAIN USER FILE                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Last Amend No. CPK014             Date 09Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 07AUG95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK014 - Release 4 packaging:                               */
/*                - Userspaces should be created in the DPLIB.       */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0515INT                                       */
/*                - CBC0515MPS                                       */
/*                - CBC0515MPE                                       */
/*                - CBC0515ERR                                       */
/*                - CBC0515END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&USER &JOB &NBR &DTAQ &MODE &ERROR)
 
/*/COPY WNCPYSRC,CBC0515INT                                          */
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SBS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TRACELIB) TYPE(*CHAR) LEN(10)                                /*CPK014*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SELT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ALL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEVR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&PROC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESG) TYPE(*CHAR) LEN(40)
             DCL        VAR(&BOTH) TYPE(*CHAR) LEN(24)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(180)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* GLOBAL ERROR MESSAGE TRAP */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
/*/COPY WNCPYSRC,CBC0515MPS                                          */
 
             OVRMSGF    MSGF(CBUSRMSG) TOMSGF(GBCBUSRMSG)
 
             IF         COND((&MODE *EQ 'CREATE') *OR (&MODE *EQ +
                          'DELETE')) THEN(DO)
 
/* Retrieve job attributes */
 
                IF         COND(%SST(&USER 1 10) *EQ ' ') THEN(DO)
                   RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
                ENDDO
 
                CHGVAR     VAR(&BOTH) VALUE(&USER *CAT ' at ' +
                             *CAT &JOB)
                CHGVAR     VAR(%SST(&SELT 1 4)) VALUE(' ')
                CHGVAR     VAR(%SST(&ALL  1 4)) VALUE('*ALL')
                CHGVAR     VAR(%SST(&PARM 8 10)) VALUE(&USER)
                CHGVAR     VAR(%SST(&PARM 18 10)) VALUE(&JOB)
                CHGVAR     VAR(%SST(&PARM 28 6)) VALUE(&NBR)
                CHGVAR     VAR(%SST(&PARM 34 4)) VALUE(&SELT)
 
/* Retrieve subsystem ID */
 
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SBS)
 
                CHGVAR     VAR(&LIB) VALUE(&SBS *TCAT 'XLIB')
                CHGVAR     VAR(&TRACELIB) VALUE(&SBS *TCAT 'DPLIB')                       /*CPK014*/
 
                CHGVAR     VAR(&DTAQ) VALUE('DTQ' *TCAT &NBR)
 
                IF         COND(&MODE *EQ 'CREATE') THEN(CHGVAR +
                             VAR(&TEXT) VALUE('User signed in +
                             subsystem '))
                IF         COND(&MODE *EQ 'DELETE') THEN(CHGVAR +
                             VAR(&TEXT) VALUE('User signed out +
                             subsystem '))
 
/**********     CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT &LIB) */                    /*CPK014*/
                CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT &TRACELIB)                  /*CPK014*/
 
                CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                             X'00000180' &TEXT '0')
 
                CALL       PGM(CB0534)
             ENDDO
 
/* Two modes are accepted : CREATE and DELETE */
 
             IF         COND(&MODE *EQ 'CREATE') THEN(DO)
 
/* If mode is CREATE - log in user and */
/* create data queue for job           */
 
/************   CRTDTAQ    DTAQ(&LIB/&DTAQ) MAXLEN(256)                                */ /*CPK014*/
                CRTDTAQ    DTAQ(&LIB/&DTAQ) MAXLEN(256) AUT(*ALL)                         /*CPK014*/
 
                CHKOBJ     OBJ(&LIB/&DTAQ) OBJTYPE(*DTAQ)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ERROR))
 
                RTVMSG     MSGID(CBM0141) MSGF(CBUSRMSG) +
                             MSGDTA(&BOTH) MSG(&MESG) SEV(&SEVR)
                CHGVAR     VAR(&PROC) VALUE('NEWUSER')
                CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PROC)
                CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEVR)
                CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESG)
 
                CALL       PGM(CBC0525) PARM(&ALL &PARM)
             ENDDO
 
/* Delete data queue */
 
             IF         COND(&MODE *EQ 'DELETE') THEN(DO)
 
                RTVMSG     MSGID(CBM0142) MSGF(CBUSRMSG) +
                             MSGDTA(&BOTH) MSG(&MESG) SEV(&SEVR)
 
                CHGVAR     VAR(&PROC) VALUE('RMVUSER')
                CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PROC)
                CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEVR)
                CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESG)
 
                CALL       PGM(CBC0525) PARM(&ALL &PARM)
 
             ENDDO
 
/* Update COB users file */
 
             OVRDBF     FILE(CBUSERL0) TOFILE(CBUSERL0)
 
             CALL       PGM(CB0515) PARM(&JOB &USER &NBR &DTAQ +
                          &MODE &ERROR)
 
             DLTOVR     FILE(CBUSERL0)
 
/*/COPY WNCPYSRC,CBC0515MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ERROR:
 
/*/COPY WNCPYSRC,CBC0515ERR                                          */
 
             CHGVAR     VAR(&ERROR) VALUE('E')
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0515END                                          */
 
             ENDPGM
