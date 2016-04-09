/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas AA Funds transfer transaction audit list ctl')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Analytical Accounting Module                        */
/*                                                                   */
/*       AAC0070 - Funds Transfer Transaction Audit List Control     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CAC001 *CREATE     Date 01FEB96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CAC001 - Profit Centre Accounting Development:              */
/*                New CL program.                                    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(128)
             DCL        VAR(&QRYSEL) TYPE(*CHAR) LEN(20)
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CALL       PGM(AOMMODR0) PARM('*DBERR' '*FIRST' &MMOD)
/**/
/**  If Analytical Accounting is not present, then end the program */
/**/
             IF         COND(%SST(&MMOD 100 1) *EQ 'N') THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Funds +
                             Transfer Transaction Audit List is not +
                             allowed.  Analytical Accounting is not +
                             present') TOMSGQ(MOPERQ)
                MONMSG     MSGID(CPF0000 MCH0000)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/**  Create LDA if it does not already exist */
/**/
             SNDMSG     MSG('AAC0070 - Funds Transfer Transaction +
                          Audit List') TOMSGQ(MRUNQ)
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 local +
                          data area equivalent'))
/**/
/**  Select records for particular branch if requested */
/**/
             IF         COND((&RENT *NE '   ') *AND (&RENT *NE +
                          'ALL')) THEN(DO)
                CHGVAR     VAR(&QRYSEL) VALUE('BRCA +
                             *EQ "' *CAT &RENT *CAT '"')
             OPNQRYF    FILE((OTPAYL1)) QRYSLT(&QRYSEL) KEYFLD(*FILE)
                OPNQRYF    FILE((INPAYL1)) QRYSLT(&QRYSEL) KEYFLD(*FILE)
                OPNQRYF    FILE((CQCOCL1)) QRYSLT(&QRYSEL) KEYFLD(*FILE)
                OPNQRYF    FILE((CQPADL1)) QRYSLT(&QRYSEL) KEYFLD(*FILE)
             ENDDO
/**/
/**  Call report program  */
/**/
             CHGJOB     SWS(00000000)
             CALL       PGM(AA0070) PARM(&RSEQ &RLEV &RENT)
/**/
/**  Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOMSGQ(MOPERQ)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 /**/
             GOTO       CMDLBL(END)
 /**/
 ABNOR:      DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          AAC0070 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 /**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CLOF       OPNID(OTPAYL1)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(INPAYL1)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(CQCOCL1)
             MONMSG     MSGID(CPF0000)
             CLOF       OPNID(CQPADL1)
             MONMSG     MSGID(CPF0000)
             ENDPGM
