/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas COB Scheduling maintenance/control')            */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       CBC0004 - COB Scheduling Maintenance/Control                */
/*                                                                   */
/*       (c) Finastra International Limited 2006                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD038993 *CREATE   Date 21Nov16              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG10848 *CREATE   Date 15Mar06              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD038993 - Missing code functionality on CCB014.            */
/*                  Define 10 jobs. COB will not run if one of the   */
/*                  job is active.                                   */
/*       BUG10848 - Schedule not functioning for Global Processing   */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&POFFST) TYPE(*CHAR) LEN(5)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2004')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Retrieve offset value (time difference) */
 
             RTVSYSVAL  SYSVAL(QUTCOFFSET) RTNVAR(&POFFST)
 
/* COB Scheduling Maintenance */
 
/**********  CALL       PGM(CB0004) PARM(&POFFST)                                       /*MD038993*/
             CALL       PGM(CB000401) PARM(&POFFST)                                     /*MD038993*/
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            CBC0004 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
