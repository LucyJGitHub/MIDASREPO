/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rst FF Multimbr Files on Backup Mach')          */
/*********************************************************************/
/*                                                                   */
/*        Midas     - Restart Recovery Module                   */
/*                                                                   */
/*     SDC1743 - RESTORATION FF MULTIMEMBER FILES                    */
/*               ON BACKUP MACHINE                                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*     LAST AMEND NO. 00                 DATE 00/00/00               */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SEQN1 &SEQN2 &LRCV)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
             DCL        VAR(&SEQN1) TYPE(*DEC) LEN(10)
             DCL        VAR(&SEQN2) TYPE(*DEC) LEN(10)
             DCL        VAR(&LRCV) TYPE(*CHAR) LEN(8)
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
                CALL       PGM(SDC1746) PARM(&MRKT &SEQN1 &SEQN2 &LRCV)
                IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO END)
                GOTO       CMDLBL(READ)
/**/
/* ABNORMAL TERMINATION PROCESSING */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1748 - Restoration of FF +
                          multimember files on backup machine - ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
