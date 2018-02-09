/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Midas user menu')                            */
/********************************************************************/
/*                                                                  */
/*        Midas     - System Control Module                     */
/*                                                                  */
/*     SCUSRMNU - MIDAS SYSTEM USER MENU                            */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Prev Amend No. BG18886            Date 23May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01343             Date 15Aug91              */
/*                      E15042            DATE  07/09/88            */
/*                      S01179            DATE  10/09/88            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       BG18886 - Amend non-standard codes.                        */
/*       S01343  -  SC/RR/SD MODULE RENAME PROJECT.                 */
/*                  - SCUSRMNU RENAMED FROM MUSRMNU                 */
/*                                                                  */
/*       E15042  -  REINSTATEMENT OF MRSLIB22 VERSION OF PROGRAM    *  *E15042*/
/*                                                                  */
/*       S01179 - AS400 CONVERSION                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
             DCLF       FILE(SCUSRMNUDF)
/***         DCLDTAARA  DTAARA(LDA)                                 *  *S01179*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)                /*S01179*/
             DCL        VAR(&QJOFFSET) TYPE(*DEC) LEN(3 0) VALUE(178)
             DCL        VAR(&QCOFFSET) TYPE(*DEC) LEN(3 0) VALUE(188)
             DCL        VAR(&QJOBQCONF) TYPE(*CHAR) LEN(20) +
                          VALUE('MPRINT    MPRINTCF')
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)
             MONMSG     MSGID(CPF0000) EXEC(GOTO ERROR)
             RTVJOBA    JOB(&JOB)
             CHGVAR     VAR(&WSID) VALUE(%SUBSTRING(&JOB 1 3))
/***         RCVDTAARA  DTAARA(LDA)                                 *  *S01179*/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                      /*S01179*/
/**/
             IF         COND(%SUBSTRING(&LDA &QJOFFSET 1) *LT 'A') +
                          THEN(GOTO CMDLBL(LDASET))
             IF         COND(%SUBSTRING(&LDA &QJOFFSET 1) *GT 'Z') +
                          THEN(GOTO CMDLBL(LDASET))
/**/
             CHGVAR     VAR(&CQUEUE) +
                        VALUE(%SUBSTRING(&LDA &QJOFFSET 10))
             CHKOBJ     OBJ(&CQUEUE) OBJTYPE(*OUTQ)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(LDASET))
/**/
             GOTO       CMDLBL(NOSET)
 LDASET:     CHGVAR     VAR(%SUBSTRING(&LDA &QJOFFSET 20)) +
                        VALUE(&QJOBQCONF)
             CHGDTAARA  DTAARA(LDA) VALUE(&LDA)
/**/
 NOSET:      CHGVAR     VAR(&ERRMSG1) VALUE('Error occurred on command, +
                        resubmit option')
/********************************************************************/
 INIT:       SNDRCVF    RCDFMT(SCUSRMNU1)
             CHGVAR     VAR(&IN99) VALUE('0')
/**/
             IF         COND(&OPTION = 1 *OR &OPTION = 3) THEN(DO)
/*OPTION1*/
                IF         COND(&OPTION = 1) THEN(DO)
/**/
                   CHGVAR     VAR(&TITLE) VALUE('REDIRECT NEW WORKSTATION +
                              PRINT')
/***            RCVDTAARA  DTAARA(LDA)                              *  *S01179*/
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                   /*S01179*/
                   CHGVAR     VAR(&CQUEUE) VALUE(%SUBSTRING(&LDA &QJOFFSET 10))
/**/
                ENDDO
/*OPTION3*/
                ELSE       CMD(DO)
/**/
                   CHGVAR     VAR(&TITLE) VALUE('     REDIRECT CONFIRMATIONS')
/***               RCVDTAARA  DTAARA(LDA)                           *  *S01179*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*S01179*/
                   CHGVAR     VAR(&CQUEUE) VALUE(%SUBSTRING(&LDA &QCOFFSET 10))
/**/
                ENDDO
                CHGVAR     VAR(&QUEUE) VALUE(' ')
LOOP1:          SNDRCVF    RCDFMT(SCUSRMNU2)
                CHGVAR     VAR(&IN90) VALUE('0')
                CHGVAR     VAR(&IN91) VALUE('0')
                CHGVAR     VAR(&IN92) VALUE('0')
                CHGVAR     VAR(&IN93) VALUE('0')
/**/
/**********     IF         COND(**&IN05) THEN(DO)                            /*BG18886*/
                IF         COND(*NOT &IN05) THEN(DO)                         /*BG18886*/
/**/
                   CHKOBJ     OBJ(&QUEUE) OBJTYPE(*OUTQ)
                   MONMSG     MSGID(CPF9801) EXEC(DO)
/**/
                      CHGVAR     VAR(&ERRMSG2) VALUE('Output queue not +
                                 available or doesn''t exist')
                      CHGVAR     VAR(&IN91) VALUE('1')
                      CHGVAR     VAR(&IN93) VALUE('1')
                      GOTO       CMDLBL(LOOP1)
/**/
                   ENDDO
/*OPTION1*/
                   IF         COND(&OPTION = 1) THEN(DO)
/**/
                      CHGJOB     OUTQ(&QUEUE)
                      CHGVAR     VAR(%SUBSTRING(&LDA &QJOFFSET 10)) +
                                 VALUE(&QUEUE)
                      CHGDTAARA  DTAARA(LDA) VALUE(&LDA)
/**/
                   ENDDO
/*OPTION3*/
                   ELSE       CMD(DO)
/**/
                      OVRPRTF    MPRINTCF OUTQ(&QUEUE)
                      CHGVAR     VAR(%SUBSTRING(&LDA &QCOFFSET 10)) +
                                 VALUE(&QUEUE)
                      CHGDTAARA  DTAARA(LDA) VALUE(&LDA)
/**/
                   ENDDO
                   IF         COND(&DSPOPT = 'YES') THEN(WRKOUTQ &QUEUE)
/**/
                ENDDO
/**/
             ENDDO
             ELSE        CMD(DO)
/*OPTION2*/
                IF          COND(&OPTION = 2) THEN(DO)
/**/
                   ?CHGSPLFA
/**/
                ENDDO
/*OPTION4*/
                IF          COND(&OPTION = 4) THEN(WRKOUTQ)
/*OPTION5*/
                IF          COND(&OPTION = 5) THEN(DO)
/**/
/***               RCVDTAARA  DTAARA(LDA)                           *  *S01179*/
                   RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)                /*S01179*/
                   CHGVAR      VAR(&CQUEUE) VALUE(%SUBSTRING(&LDA &QJOFFSET 10))
                   WRKOUTQ    OUTQ(&CQUEUE)
/**/
                ENDDO
/*OPTION6*/
                IF          COND(&OPTION = 6) THEN(DSPMSG)
/*OPTION7*/
                IF          COND(&OPTION = 7) THEN(DO)
                   ?SNDMSG
                ENDDO
/*OPTION23*/
                IF          COND(&OPTION = 23) THEN(RETURN)
/**/
             ENDDO
/**/
             GOTO           CMDLBL(INIT)
/*ERROR CONDITION*/
ERROR:       CHGVAR         VAR(&IN99) VALUE('1')
             GOTO           CMDLBL(INIT)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
