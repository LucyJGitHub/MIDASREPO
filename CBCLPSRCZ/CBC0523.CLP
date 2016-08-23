/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB End network job')                            */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0523 - COB END NETWORK JOB                               */
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
/*                      090415             DATE 12JUL95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK014 - Release 4 packaging:                               */
/*                - Userspaces should be created in the DPLIB.       */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0523INT                                       */
/*                - CBC0523MPE                                       */
/*                - CBC0523ERR                                       */
/*                - CBC0523END                                       */
/*              - Addition of hook:                                  */
/*                - CBC0523MPS                                       */
/*       090415 - Correct spelling on message.                       */
/*       S01420 - CoB Enhancements Batch Monitor.                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&JOB &USER &NBR)
 
/*/COPY WNCPYSRC,CBC0523INT                                          */
 
/* Declare work variables */
 
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(180)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,CBC0523MPS                                          */
                                                                      /*S01408*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
 
/**********  CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'XLIB') */                            /*CPK014*/
             CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'DPLIB')                              /*CPK014*/
 
             CHGVAR     VAR(&TEXT) VALUE('Job ' *CAT &JOB *CAT &USER +
                          *CAT &NBR *CAT ' disconnected because a +
                          problem occured within the monitor screen +
                          while trying to invite the display file.')
 
/**********  SNDBRKMSG  MSG('Your workstation is disconnected. +      /*090415*/
/**********             Insufficient system ressource.') TOMSGQ(&JOB) /*090415*/
             SNDBRKMSG  MSG('Your workstation is disconnected. +
                          Insufficient system resource.') +
                          TOMSGQ(&JOB)                                /*090415*/
             MONMSG     MSGID(CPF0000)
 
             ENDJOB     JOB(&NBR/&USER/&JOB) OPTION(*IMMED) LOGLMT(0)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT &LIB)
 
             CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                          X'00000180' &TEXT '0')
 
             CALL       PGM(CB0534)
 
/*/COPY WNCPYSRC,CBC0523MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0523ERR                                          */
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0523END                                          */
 
             ENDPGM
