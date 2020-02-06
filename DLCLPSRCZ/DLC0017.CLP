/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Initialisation Program for CAS005')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0017 - Initialization Program for CAS005                 */
/*                                                                   */
/*       (c) Finastra International Limited 2002                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CAS005  *CREATE    Date 16Dec02              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAS005 - Enhancements to CAS001, CAS002 and CAS004          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCD &PMODE)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2002')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
 
/** Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256))
 
/** Mode 1 (First call) or Mode 2 (Second call) */
 
             IF         COND((&PMODE *EQ '1') *OR (&PMODE *EQ '2')) +
                          THEN(DO)
                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)
                MONMSG     MSGID(CPF8351)
 
                CALL       PGM(DL0017)
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
             ENDDO
 
/** Mode 3 - Deletion */
 
             IF         COND(&PMODE *EQ '3') THEN(DO)
             ENDDO
 
             GOTO       CMDLBL(END)
 
/** Abnormal termination */
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
             ROLLBACK
             MONMSG     MSGID(CPF0000 MCH0000)
 
             CHGVAR     VAR(&RTCD) VALUE('*ERROR*')
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0017 ended abnormally - see joblog +
                          ') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
/** End program */
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
