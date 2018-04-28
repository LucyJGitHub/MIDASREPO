/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Inform COB is halted')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0514 - COB HALT INFORMATION                              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. S01408             Date 07AUG95              */
/*       Prev Amend No. S01420 *Create     DATE 15MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0514INT                                       */
/*                - CBC0514MPS                                       */
/*                - CBC0514MPE                                       */
/*                - CBC0514ERR                                       */
/*                - CBC0514END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBC0514INT                                          */
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&SEVR) TYPE(*DEC) LEN(2 0)
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(40)
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
             CHGVAR     VAR(&PRC) VALUE('HALTED ')
             CHGVAR     VAR(%SST(&DTAQ 1 4)) VALUE('*ALL')
 
/*/COPY WNCPYSRC,CBC0514MPS                                          */
 
             RTVMSG     MSGID(CBM0126) MSGF(CBUSRMSG) MSG(&MSG) +
                          SEV(&SEVR)
 
             CHGVAR (%SST(&PARM   1 7)) VALUE(&PRC)
             CHGVAR (%SST(&PARM  38 2)) VALUE(&SEVR)
             CHGVAR (%SST(&PARM 217 40)) VALUE(&MSG)
 
/* First verify monitor activity */
 
             CALL       PGM(CBC0525) PARM(&DTAQ &PARM)
 
/*/COPY WNCPYSRC,CBC0514MPE                                          */
 
             GOTO       CMDLBL(ENDP)
ERROR:
/*/COPY WNCPYSRC,CBC0514ERR                                          */
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0514END                                          */
 
             ENDPGM
