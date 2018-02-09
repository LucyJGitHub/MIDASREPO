/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RR Restore FF multimember files')               */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Restart Recovery Module                   */
/*                                                                   */
/*     SDC1743 - RESTORATION FF MULTIMEMBER FILES                    */
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
/*     PREV AMEND NO. 00                 DATE 00/00/00               */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQN1 &SEQN2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&SEQN1) TYPE(*DEC) LEN(10)
             DCL        VAR(&SEQN2) TYPE(*DEC) LEN(10)
/**/
             DCLF       FILE(MKCTL)
/**/
/* GLOBAL MONITOR MESSAGE */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)
/**/
/* SET UP RECOVERY AREAS & FORWARD RECOVER INDIVIDUALLY EACH         */
/* MEMBER FOR ALL FF MULTIMEMBER FILES ( = RECORD ON LF/MKCTL )      */
/**/
 READ:          RCVF
                MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
/*                                                                   */
/* PROCESS ALL FILES IF MARKET CENTRE MEMBERS HAVE BEEN SET UP       */
/*                                                                   */
                IF         COND(&MKCI *EQ 'S') THEN(GOTO READ)
                CALL       PGM(SDC1741) PARM(&MRKT &SEQN1 &SEQN2)
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
                GOTO       CMDLBL(READ)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1743 - Restoration of FF +
                          multimember files - ENDED ABNORMALLY') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
