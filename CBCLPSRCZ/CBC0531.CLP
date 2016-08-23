/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Attention key program')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0531 - COB ATTENTION PROGRAM                             */
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
/*                - CBC0531INT                                       */
/*                - CBC0531MPS                                       */
/*                - CBC0531MPE                                       */
/*                - CBC0531ERR                                       */
/*                - CBC0531END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,CBC0531INT                                          */
 
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
             DCL        VAR(&REPLY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global error message trap */
 
             MONMSG     MSGID(CPF0000 CPI0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0531MPS                                          */
 
             RTVMSG     MSGID(SCM0109) MSGF(MIDASMSG) MSG(&MESSAGE)
 
             CHGDTAARA  DTAARA(MIDASMSG (201 50)) VALUE(&MESSAGE)
 
             RTVMSG     MSGID(SCM0110) MSGF(MIDASMSG) MSG(&MESSAGE)
 
             CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)
 
             CALL       PGM(SCC0010) PARM('CBC0531' 'OPTION' &REPLY)
 
             IF         COND(&REPLY *EQ 'N') THEN(GOTO CMDLBL(ENDP))
 
LEAVE:
             CHGVAR     VAR(&MODE) VALUE('DELETE')
 
/* Remove user from file */
 
             CALL       PGM(CBC0515) PARM(&USER &JOB &NBR &DTAQ +
                          &MODE &ERROR)
 
             SIGNOFF    ENDCNN(*YES)
 
/*/COPY WNCPYSRC,CBC0531MPE                                          */
 
ABNOR:
/*/COPY WNCPYSRC,CBC0531ERR                                          */
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0531END                                          */
 
             RETURN
 
             ENDPGM
