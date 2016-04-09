/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GP Retreive library prefix for global')         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Global Processing Module                            */
/*                                                                   */
/*       GPRTVLIB  - Retreive library prefix for global              */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2004           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CGP001 *CREATE     Date 09Mar04              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CGP001 - Global Processing                                  */
/*                Required to add triggers to global files           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SYS)
 
             DCL        VAR(&SYS) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIBL) TYPE(*CHAR) LEN(2750)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE) USRLIBL(&LIBL)
             CHGJOB     SWS(00000000)
 
             CALL       PGM(GPFINDLIB) PARM(&LIBL &SYS)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            GPRTVLIB ended abnormally - see job log')  +
                            TOMSGQ(MOPERQ MRUNQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
/* Abnormal termination - interactive job */
 
             IF         COND(&JOBTYPE = '1') THEN(DO)
                SNDPGMMSG  MSGID(MEM5003) MSGF(MIDAS) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
