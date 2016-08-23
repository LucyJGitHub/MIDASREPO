/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Unlock close of business display')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0521 - COB UNLOCK MONITOR                                */
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
/*                - DTAARA/CBLOCK is now a delivered object and      */
/*                  resides in the DPLIB.                            */
/*                - Userspaces should be created in the DPLIB.       */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0521INT                                       */
/*                - CBC0521MPS                                       */
/*                - CBC0521MPE                                       */
/*                - CBC0521ERR                                       */
/*                - CBC0521END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DTAQ &ERROR)
 
/*/COPY WNCPYSRC,CBC0521INT                                          */
 
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SELT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEVR) TYPE(*CHAR) LEN(2)
             DCL        VAR(&PROC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&MESG) TYPE(*CHAR) LEN(40)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(180)
             DCL        VAR(&LOCKUSER) TYPE(*CHAR) LEN(26)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000 CPA0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0521MPS                                          */
 
/* Retrieve subsystem prefix */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/**********  CHGVAR     VAR(&LIB) VALUE(&PREFIX *TCAT 'XLIB') */                          /*CPK014*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *TCAT 'DPLIB')                            /*CPK014*/
 
/* Initialize work variables */
 
             CHGVAR     VAR(&PROC) VALUE('UNLOCK ')
             CHGVAR     VAR(%SST(&SELT 1 4)) VALUE(' ')
             CHGVAR     VAR(&SEVR) VALUE('01')
 
/* Retrieve Job details */
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
 
             IF         COND(%SST(&DTAQ 1 4) *EQ '*ALL') THEN(DO)
/**********     CHKOBJ     OBJ(&LIB/CBLOCK) OBJTYPE(*DTAARA)                              /*CPK014*/
                CHKOBJ     OBJ(CBLOCK) OBJTYPE(*DTAARA)                                   /*CPK014*/
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(ABNOR))
                CHGVAR     VAR(&QUAL) VALUE('USERLOCK  ' *CAT &LIB)
                CHGVAR     VAR(%SST(&LOCKUSER 1 26)) VALUE(' ')
                CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                             X'00000026' &LOCKUSER '0')
                DLCOBJ     OBJ((CBLOCK *DTAARA *EXCL))
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
                CHGVAR     VAR(&SELT) VALUE('OMIT')
                CHGVAR     VAR(&SEVR) VALUE('00')
             ENDDO
 
/* Build parameter to pass to CBC0525                                */
/* if *ALL has been requested in Unlock mode do not unck workstation */
/* that has requested the Unlock Status. So specify OMIT in select   */
 
             CHGVAR     VAR(%SST(&PARM 1 7)) VALUE(&PROC)
             CHGVAR     VAR(%SST(&PARM 8 10)) VALUE(&USER)
             CHGVAR     VAR(%SST(&PARM 18 10)) VALUE(&JOB)
             CHGVAR     VAR(%SST(&PARM 28 6)) VALUE(&NBR)
             CHGVAR     VAR(%SST(&PARM 34 4)) VALUE(&SELT)
             CHGVAR     VAR(%SST(&PARM 38 2)) VALUE(&SEVR)
             CHGVAR     VAR(%SST(&PARM 217 40)) VALUE(&MESG)
 
             CALL       PGM(CBC0525) PARM(&DTAQ &PARM)
 
             CHGVAR     VAR(&TEXT) VALUE('Job(s) ' *CAT &DTAQ *CAT ' +
                          have been unlocked')
 
             CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT &LIB)
 
             CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                          X'00000180' &TEXT '0')
 
             CALL       PGM(CB0534)
 
/*/COPY WNCPYSRC,CBC0521MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0521ERR                                          */
 
             SNDPGMMSG  MSG('Unable to unlock monitor job. Abnormal +
                          end.') TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&ERROR) VALUE('E')
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0521END                                          */
 
             ENDPGM
