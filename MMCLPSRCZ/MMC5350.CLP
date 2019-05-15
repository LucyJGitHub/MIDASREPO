/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MM Deposits Rolled Automatically Control')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Money Market Module                                 */
/*                                                                   */
/*       MMC5350 - MM Deposits Rolled Automatically Control          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*       Prev Amend No. CGL011  *CREATE    Date 20Sep99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CGL011 - Collateral Processing for Midas                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PCNAM &PCSEQ)
 
             DCL        VAR(&PCNAM)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PCSEQ)   TYPE(*CHAR) LEN(5)
             DCL        VAR(&WPREF)   TYPE(*CHAR) LEN(2)
             DCL        VAR(&WLIB)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
             STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(MM5350)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                SNDPGMMSG  MSG('MMC5350. Job Terminated, Database in +
                          Error - see job log.') TOMSGQ(MOPERQ)
                ROLLBACK
                ENDDO
             ELSE       CMD(DO)
                COMMIT
                SNDPGMMSG  MSG('Component MCC5350 has completed +
                          normally') TOMSGQ(MRUNQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
/* Abnormal termination - batch job */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          MMC5350 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
