/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CB Send data to data queues')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business Processing                        */
/*                                                                   */
/*       CBC0525 - SEND DATA TO DATA QUEUES                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01408             Date 07Aug95              */
/*                      S01420 *C *CREATE  Date 15Mar95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01408 - Hooks moved to WNCPYSRC from CBCPYSRC:             */
/*                - CBC0525INT                                       */
/*                - CBC0525MPS                                       */
/*                - CBC0525MPE                                       */
/*                - CBC0525ERR                                       */
/*                - CBC0525END                                       */
/*       S01420 - CoB Enhancements (Batch Monitor).                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&DTAQ &PARM)
 
/*/COPY WNCPYSRC,CBC0525INT                                          */
 
             DCL        VAR(&PARM) TYPE(*CHAR) LEN(256)
             DCL        VAR(&DTAQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000 CPA0000 CPI0000 MCH0000) +
                          EXEC(GOTO CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,CBC0525MPS                                          */
 
             OVRDBF     FILE(CBUSERL1) SHARE(*YES)
 
             CALL       PGM(CB0525) PARM(&DTAQ &PARM)
 
/*/COPY WNCPYSRC,CBC0525MPE                                          */
 
             GOTO       CMDLBL(ENDP)
 
 ABNOR:
/*/COPY WNCPYSRC,CBC0525ERR                                          */
 
             SNDPGMMSG  MSG('CBC0525 - Unable to send data ') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
ENDP:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/*/COPY WNCPYSRC,CBC0525END                                          */
 
             DLTOVR     FILE(CBUSERL1)
             MONMSG     MSGID(CPF0000)
 
             RETURN
 
             ENDPGM
