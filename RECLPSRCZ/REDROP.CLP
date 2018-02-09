/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas RE Drop out of date history process')           */
/*********************************************************************/
/*                                                                   */
/*       Midas     Retail Module                                 */
/*                                                                   */
/*       REDROP - RETAIL DROP OUT-OF-DATE HISTORY PROCESSING         */
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
/*       PREV AMEND NO. S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       S01413 - Retail 3 Incorporation.                            */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/*                                                                   */
/* DECLARES PARAMETERS                                               */
/*                                                                   */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&KEY1) TYPE(*CHAR) LEN(18)
             DCL        VAR(&KEY2) TYPE(*CHAR) LEN(15)
             DCL        VAR(&BRCA) TYPE(*CHAR) LEN(3)
             DCL        VAR(&BVLMP) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BVLMM) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BVLMR) TYPE(*CHAR) LEN(5)
/*/COPY WNCPYSRC,REDROP001                                           */
/**/
/*                                                                   */
/* READING OF DATA AREA - LDA                                        */
/*                                                                   */
             RTVDTAARA  DTAARA(LDA (224 18)) RTNVAR(&KEY1)
             RTVDTAARA  DTAARA(LDA (227 15)) RTNVAR(&KEY2)
             RTVDTAARA  DTAARA(LDA (224 3)) RTNVAR(&BRCA)
             RTVDTAARA  DTAARA(LDA (242 5)) RTNVAR(&BVLMP)
             RTVDTAARA  DTAARA(LDA (247 5)) RTNVAR(&BVLMM)
             RTVDTAARA  DTAARA(LDA (252 5)) RTNVAR(&BVLMR)
/*                                                                   */
/*                                                                   */
/* DROP OUT-OF-DATE RETAIL HISTORY - POSTINGS RECORDS                */
/*                                                                   */
             CPYF       FROMFILE(REHPOSPP) TOFILE(REHPOOPP) +
                          MBROPT(*ADD) INCCHAR(*RCD 2 *EQ &KEY2) +
                          INCREL((*IF HISD *GE &BVLMP) (*AND BRCA *EQ +
                          &BRCA))
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with REHPOSPP found by PGM : +
                          REDROP') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/*                                                                   */
/* DROP OUT-OF-DATE RETAIL HISTORY - MANUAL ADJUSTMENTS RECORDS      */
/*                                                                   */
             CPYF       FROMFILE(REHPOSPM) TOFILE(REHPOOPM) +
                          MBROPT(*ADD) INCCHAR(*RCD 2 *EQ &KEY1) +
                          INCREL((*IF HISD *GE &BVLMM))
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with REHPOSPM found by PGM : +
                          REDROP') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/*                                                                   */
/* DROP OUT-OF-DATE RETAIL HISTORY - RATE CHANGES SEQ1 RECORDS       */
/*                                                                   */
             CPYF       FROMFILE(REHPOSR1) TOFILE(REHPOOR1) +
                          MBROPT(*ADD) INCCHAR(*RCD 2 *EQ &KEY2) +
                          INCREL((*IF HISD *GE &BVLMR) (*AND BRCA *EQ +
                          &BRCA))
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with REHPOSR1 found by PGM : +
                          REDROP') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/*                                                                   */
/* DROP OUT-OF-DATE RETAIL HISTORY - RATE CHANGES SEQ2 RECORDS       */
/*                                                                   */
             CPYF       FROMFILE(REHPOSR2) TOFILE(REHPOOR2) +
                          MBROPT(*ADD) INCCHAR(*RCD 2 *EQ &KEY2) +
                          INCREL((*IF HISD *GE &BVLMR) (*AND BRCA *EQ +
                          &BRCA))
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with REHPOSR2 found by PGM : +
                          REDROP') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/*                                                                   */
/* DROP OUT-OF-DATE RETAIL HISTORY - RATE CHANGES SEQ3 RECORDS       */
/*                                                                   */
             CPYF       FROMFILE(REHPOSR3) TOFILE(REHPOOR3) +
                          MBROPT(*ADD) INCCHAR(*RCD 2 *EQ &KEY2) +
                          INCREL((*IF HISD *GE &BVLMR) (*AND BRCA *EQ +
                          &BRCA))
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error with REHPOSR3 found by PGM : +
                          REDROP') TOMSGQ(MRUNQ)
             GOTO       CMDLBL(EXIT1)
             ENDDO
/**/
             GOTO       CMDLBL(ENDPGM)
/**/
EXIT1:
             CPYF       FROMFILE(XREHISPD) TOFILE(REHISPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHISPD in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
             CPYF       FROMFILE(XREHISPS) TOFILE(REHISPS) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHISPS in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
             CPYF       FROMFILE(XREHPOSPP) TOFILE(REHPOSPP) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSPP in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
             CPYF       FROMFILE(XREHPOSPM) TOFILE(REHPOSPPM) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSPM in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
             CPYF       FROMFILE(XREHPOSR1) TOFILE(REHPOSR1) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSR1 in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
             CPYF       FROMFILE(XREHPOSR2) TOFILE(REHPOSR2) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSR2 in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/**/
             CPYF       FROMFILE(XREHPOSR3) TOFILE(REHPOSR3) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)
/**/
             MONMSG     MSGID(CPF0000) EXEC(DO)
             SNDPGMMSG  MSG('Error in RESTART COPY with XREHPOSR3 in +
                          REDROP (EXIT1)') TOMSGQ(MRUNQ)
             ENDDO
/*/COPY WNCPYSRC,REDROP002                                           */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
ENDPGM:      ENDPGM
