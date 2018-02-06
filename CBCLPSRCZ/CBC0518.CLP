/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Terminate jobs')                             */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0518 - Terminate jobs                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/*       Prev Amend No. CPK014             Date 09Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 07Aug95              */
/*                      S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK014 - Release 4 packaging:                               */
/*                - Userspaces should be created in the DPLIB.       */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0518INT                                       */
/*                - CBC0518MPS                                       */
/*                - CBC0518MPE                                       */
/*                - CBC0518ERR                                       */
/*                - CBC0518END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBC0518INT                                          */
 
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&QUAL) TYPE(*CHAR) LEN(20)
             DCL        VAR(&TXT) TYPE(*CHAR) LEN(180)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(CBUSERPD)
 
             RTVJOBA    NBR(&NBR)
 
             CHGVAR     VAR(%SST(&DTQ 1 10))  VALUE(' ')
             CHGVAR     VAR(%SST(&DTQ 1 3)) VALUE('DTQ')
             CHGVAR     VAR(%SST(&DTQ 4 6)) VALUE(&NBR)
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0518MPS                                          */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
 
/**********  CHGVAR     VAR(&LIB) VALUE(&PREFIX *TCAT 'XLIB') */                          /*CPK014*/
             CHGVAR     VAR(&LIB) VALUE(&PREFIX *TCAT 'DPLIB')                            /*CPK014*/
             CHGVAR     VAR(&QUAL) VALUE('USRTRACE  ' *CAT &LIB)
 
LOOP:
             RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDREAD))
 
             IF         COND(&DTQ *NE &USDTAQ) THEN(DO)
                ENDJOB     JOB(&USNBR/&USUSER/&USJOB) OPTION(*IMMED) +
                             LOGLMT(0) ADLINTJOBS(*NONE)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
             GOTO       CMDLBL(LOOP)
 
             CHGVAR     VAR(&TXT) VALUE('General ENDJOB requested ')
 
             CALL       PGM(QUSCHGUS) PARM(&QUAL X'00000001' +
                          X'00000180' &TXT '0')
 
             CALL       PGM(CB0534)
 
ENDREAD:
/*/COPY WNCPYSRC,CBC0518MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0518ERR                                          */
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,CBC0518END                                          */
 
             RETURN
 
             ENDPGM
