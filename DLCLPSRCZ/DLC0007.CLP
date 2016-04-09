/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer FT, RE & NT Exp Extract Ctl')     */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0007 - Citydealer FT, RE & NT Exposure Extract Control   */
/*                                                                   */
/*       Function: This program will be called during Close of       */
/*                 Business processing.  It may only run after       */
/*                 DLC0006 and GLC63 have completed.  A security     */
/*                 copy of PF/DLCDNCPD will be created and then      */
/*                 PGM/DL0007 will be called.                        */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. 096395             DATE 24NOV95              */
/*       Prev Amend No. CCM002 *CREATE     DATE 04SEP95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       096395 - Process items in clearing separately to avoid      */
/*                extracting the same posting more than once.        */
/*       CCM002 - Midas/Citydealer Interface (Phases V and VI)       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
/**/
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&ACCR) TYPE(*CHAR) LEN(5)                 /*096395*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/*    Global monitor message                                         */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('DLC0007 - Citydealer FT, RE & NT +
                          Exposure Extract') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/**/
/*    Setup system prefix variable from SDSTAT data area.            */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)
/**/                                                                  /*096395*/
/*   Obtain Accrual Type from Close of Business Dataarea           */ /*096395*/
             RTVDTAARA  DTAARA(CBSTAT (46 5)) RTNVAR(&ACCR)           /*096395*/
/**/
/*    Call program CB0160 to get value of restart indicator.         */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
/**/
/*    If it is NOT a restart.                                        */
/**/
             IF         COND(&STAT *EQ 'N') THEN(DO)
               DLTF       FILE(XDLCDNCPD)
               MONMSG     MSGID(CPF2105)
/**/
               CPYF       FROMFILE(DLCDNCPD) TOFILE(&DPLIB/XDLCDNCPD) +
                            MBROPT(*REPLACE) CRTFILE(*YES)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             ENDDO
/**/
/*    If it is a restart .                                           */
/**/
             IF         COND(&STAT *EQ 'Y') THEN(DO)
               CPYF       FROMFILE(XDLCDNCPD) TOFILE(DLCDNCPD) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM FILE(DLCDNCPD))
             ENDDO
/**/
             CHGVAR     VAR(&STAT) VALUE('Y')
/**/
/** Call CB0150 to update restart indicator */
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/                                                                  /*096395*/
/*    If processing Accrual followed by Non-working Day, use CLEAR2*/ /*096395*/
/**/                                                                  /*096395*/
             IF COND(&ACCR = 'THREE') THEN(DO)                        /*096395*/
             OVRDBF     FILE(CLEAR) TOFILE(CLEAR2)                    /*096395*/
             ENDDO                                                    /*096395*/
/**/
/*    Call FT, RE & NT Exposure Extract program.                     */
/**/
             CALL       PGM(DL0007)
/**/
/*    If no error occured in the program                             */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/** Call CB0150 to update restart indicator */
/**/
               CHGVAR     VAR(&STAT) VALUE('N')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
               DLTF       FILE(XDLCDNCPD)
               MONMSG     MSGID(CPF2105)
             ENDDO
/**/
/*    Database error processing                                      */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO
/**/
             GOTO       CMDLBL(END)
/**/
/*   Abnormal termination - batch job                                */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Citydealer FT, RE & NT Exposure Extract +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
