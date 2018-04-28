/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Exit from monitor')                          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0522 - EXIT FROM MONITOR                                 */
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
/*                - CBC0522INT                                       */
/*                - CBC0522MPS                                       */
/*                - CBC0522MPE                                       */
/*                - CBC0522ERR                                       */
/*                - CBC0522END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SUSER &SJOB &SNBR &DTAQ)
 
/*/COPY WNCPYSRC,CBC0522INT                                          */
 
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LEN2) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&PRC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DATA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SJOB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SUSER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SNBR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SEV) TYPE(*CHAR) LEN(2)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(6)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000 CPA0000 CPI0000 MCH0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0522MPS                                          */
 
/* Retrieve Job Information */
 
             RTVJOBA    JOB(&JOB) USER(&USER) NBR(&NBR)
 
/* Initialize work variables */
 
             CHGVAR     VAR(&LIBR) VALUE('*LIBL     ')
             CHGVAR     VAR(&PRC) VALUE('SIGNOFF')
             CHGVAR     VAR(&SEV) VALUE('01')
             CHGVAR     VAR(&MODE) VALUE('DELETE')
             CHGVAR     VAR(&LEN2) VALUE(256)
 
/* Update data to be send */
 
             CHGVAR     VAR(%SST(&DATA 1 7)) VALUE(&PRC)
             CHGVAR     VAR(%SST(&DATA 38 2)) VALUE(&SEV)
 
/* Send data to job data queue */
 
             CALL       PGM(QSNDDTAQ) PARM(&DTAQ &LIBR &LEN2 &DATA)
 
             IF         COND((%SST(&SUSER 1 10)) *NE ' ') THEN(DO)
                ENDJOB     JOB(&SNBR/&SUSER/&SJOB) OPTION(*IMMED) +
                             LOGLMT(0) ADLINTJOBS(*NONE)
                MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
 
/* Remove user from user file */
 
                CALL       PGM(CBC0515) PARM(&SUSER &SJOB &SNBR &DTAQ +
                             &MODE &ERROR)
             ENDDO
 
             ELSE       CMD(DO)
 
/* Remove user from user file */
 
                CALL       PGM(CBC0515) PARM(&USER &JOB &NBR &DTAQ +
                             &MODE &ERROR)
             ENDDO
 
/*/COPY WNCPYSRC,CBC0522MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
ABNOR:
/*/COPY WNCPYSRC,CBC0522ERR                                          */
 
             SNDPGMMSG  MSG('Unable to Exit Monitor for ' *CAT +
                          &SUSER *CAT &SJOB *CAT &SNBR) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*/COPY WNCPYSRC,CBC0522END                                          */
 
             ENDPGM
