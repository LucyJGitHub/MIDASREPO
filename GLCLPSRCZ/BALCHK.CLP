/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Statement & ledger balance reconciliation')  */
/********************************************************************/
/*                                                                  */
/*       Midas - General Ledger Module                               */
/*                                                                  */
/*       BALCHK - STATEMENT AND LEDGER BALANCE RECONCILIATION RPT    */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01.03 --------------------------------------------*/
/*       Last Amend No. 177160             Date 03Jan03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. 095892             Date 23Nov95              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       177160 - Create LDA in QTEMP if not there.                 */
/*       095892 - Incorporation of BALCHK utility into core          */
/*                                                                  */
/********************************************************************/
             PGM        PARM(&UPDATE)
 
             DCL        VAR(&UPDATE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&STSMSG) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MIDASMSG) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
/**/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)   /*E10877*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
             CHGVAR     VAR(&DPLIB) VALUE(&PREFIX *CAT 'DPLIB   ')
             CHGVAR     VAR(&DMLIB) VALUE(&PREFIX *CAT 'DMLIB  ')
/**/
/* Create dtaara/MIDASMSG in QTEMP */
/**/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')
             MONMSG     MSGID(CPF0000)
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)                            /*177160*/
             MONMSG     MSGID(CPF0000)                                                    /*177160*/
/**/                                                                                      /*177160*/
/* Override message file **/
/**/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)
/**/
             IF         COND(&MULT *EQ '  ') THEN(DO)
             CHGVAR     VAR(&MULT) VALUE('GB')
             ENDDO
             CHGVAR     VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ')
             OVRMSGF    MSGF(MIDASMSG) TOMSGF(&MIDASMSG)
 
/* Check that no Midas jobs are active                         */
/*                                                             */
 LOOP1:      CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STSMSG)
/**/
/* If &STSMSG not blank, then at least one Midas job is active */
/**/
             IF         COND(&STSMSG *NE '     ') THEN(DO)
 LOOP2:      CHGVAR     VAR(&RPY) VALUE('N')
 
             RTVMSG     MSGID(SCM0069) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0070) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('BALCHK' 'RETRY' &RPY)
 
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(END))
             ELSE       CMD(GOTO CMDLBL(LOOP2))
             ENDDO
 
/*  Create a copy of Accounts Master file for update  */
             DLTF       FILE(XACCNTAB)
             MONMSG     MSGID(CPF0000)
             CRTDUPOBJ  OBJ(ACCNTAB) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&DPLIB) NEWOBJ(XACCNTAB)
             OVRDBF     FILE(XACCNTAB) RCDFMTLCK((ACCNTABF *EXCL))
 
/*  Call Statement and Ledger Balance Reconciliation report/update */
             CALL       PGM(BALCHKR)
 
             IF            COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MESSAGE)         /*S01267*/
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MESSAGE) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
/*  If Update flag = 'Y', copy updated Account Master file into DMLIB */
             IF         COND(&UPDATE *EQ 'Y') THEN(DO)
             CPYF       FROMFILE(&DPLIB/XACCNTAB) +
                          TOFILE(&DMLIB/ACCNTAB) MBROPT(*REPLACE)
             ENDDO
 
             GOTO       CMDLBL(END)
 
ABNOR:
             CHGVAR     VAR(&RPY) VALUE('N')
             RTVMSG     MSGID(SCM0071) MSGF(MIDASMSG) MSG(&MESSAGE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('BALCHK' 'JOBLOG' &RPY)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
END:
             DLTOVR     FILE(*ALL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(&DPLIB/XACCNTAB)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
