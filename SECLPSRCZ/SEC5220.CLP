/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE List of Incomplete Pool Trades')             */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Securities Trading Module                       */
/*                                                                   */
/*       SEC5220 - LIST OF INCOMPLETE POOL TRADES                    */
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
/*       Prev Amend No. S01486             Date 14Dec94              */
/*                      058886             Date 20Jul93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01486 - Portfolio Management Upgrade to Release 10.        */
/*                Copyright Statement and Standard Header Box.       */
/*                Creation Parameters. Message Files.                */
/*       058886 - OBJECT PMC5120 RENAMED TO SEC5220                  */
/*       058886 - OBJECT RENAMED FROM PMC5110 TO SEC5210             */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
/*********** PGM                                                      /*S01486*/
             PGM        PARM(&RSEQ &RLVL &RENT)                       /*S01486*/
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01486*/
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)                                /*S01486*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                         /*S01486*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&LDAWK) TYPE(*CHAR) LEN(256)
 
/* SET OFF SWITCHES                                                 */
             CHGJOB     SWS(00000000)
 
/* SEND PROGRAM MESSAGE */
/*           SNDPGMMSG  MSG('PMC5120 - PM Incomplete Pool +
                          Trades List') TOMSGQ(MRUNQ) MSGTYPE(*INFO)    58886 */
             SNDPGMMSG  MSG('SEC5220 - PM Incomplete Pool +
                          Trades List') TOMSGQ(MRUNQ) MSGTYPE(*INFO)  /*58886 */
 
/* CREATE LDA IF NOT PRESENT        */
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          AUT(*EXCLUDE)
             ENDDO
 
/*           CALL       PGM(PM5120)                                     58886 */
/*********** CALL       PGM(SE5220)                                    *58886 */
             CALL       PGM(SE5220) PARM(&RSEQ &RLVL &RENT)           /*S01486*/
 
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                     */
 
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDAWK)
                CHGVAR     VAR(&MEM) VALUE(%SUBSTRING(&LDAWK 132 52))
/*********** SNDPGMMSG  MSGID(PEM0001) MSGF(CEUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
             SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*S01486*/
/*           CHGVAR     VAR(&MEM) VALUE('PMC5120  - JOB TERMINATED, +
                          DATABASE IN ERROR')                           58886 */
             CHGVAR     VAR(&MEM) VALUE('SEC5220  - JOB TERMINATED, +
                          DATABASE IN ERROR')                         /*58886 */
             SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
 
/***********ENDPGM:      ENDPGM                                       /*S01486*/
            ENDPGM:                                                   /*S01486*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
