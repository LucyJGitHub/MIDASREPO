/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Remove empty members from a source')         */
/*OVR    OVRDBF FILE(UTSTRIPSRC) TOFILE(QAFDMBRL)                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities Module                                    */
/*                                                                   */
/*       UTC0050 - Remove Empty Members from a Source File           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01516  *CREATE    DATE 31AUG95              */
/*       PREV AMEND NO. 000000             DATE 00XXX00              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01516 - Do not use SDSTAT                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SRCFILE &SRCLIB &REPLACE)
 
             DCL        VAR(&SRCFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REPLACE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NEWSRC) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCTEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(QTEMP/UTSTRIPSRC)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             DLTF       FILE(QTEMP/UTSTRIPSRC)
             MONMSG     MSGID(CPF0000)
 
             DSPFD      FILE(&SRCLIB/&SRCFILE) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/UTSTRIPSRC)
 
             IF         COND(&REPLACE *NE 'Y') THEN(DO)
 
                IF         COND(%SST(&SRCFILE 10 1) *EQ ' ') THEN(DO)
                   CHGVAR     VAR(&NEWSRC) VALUE(&SRCFILE *TCAT 'X')
                ENDDO
 
                IF         COND(%SST(&SRCFILE 10 1) *NE ' ') THEN(DO)
                   CHGVAR     VAR(&NEWSRC) VALUE(%SST(&SRCFILE 1 8) +
                                *CAT 'X' *CAT %SST(&SRCFILE 10 1))
                ENDDO
 
                CHGVAR     VAR(&SRCTEXT) VALUE('Stripped version of +
                             source file ' *CAT &SRCFILE)
 
                CRTSRCPF   FILE(&SRCLIB/&NEWSRC) TEXT(&SRCTEXT)
 
             ENDDO
 
 RCVF:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDPGM))
 
             IF         COND(&MLNRCD *EQ 0) THEN(DO)
                IF         COND(&REPLACE *EQ 'Y') THEN(DO)
                   RMVM       FILE(&SRCLIB/&SRCFILE) MBR(&MLNAME)
                ENDDO
             ENDDO
 
             IF         COND(&MLNRCD *GT 0) THEN(DO)
                IF         COND(&REPLACE *NE 'Y') THEN(DO)
                   CPYF       FROMFILE(&SRCLIB/&SRCFILE) +
                                TOFILE(&SRCLIB/&NEWSRC) +
                                FROMMBR(&MLNAME) TOMBR(*FROMMBR) +
                                MBROPT(*REPLACE)
                ENDDO
             ENDDO
 
             GOTO       CMDLBL(RCVF)
 
 ABNOR:
             RTVJOBA    TYPE(&JOBTYPE)
 
             IF         COND(&JOBTYPE *EQ '1') THEN(DO)
                SNDPGMMSG  MSG('Program UTC0050 ended abnormally') +
                             TOPGMQ(*EXT)
                MONMSG     MSGID(CPF0000)
             ENDDO
 
 ENDPGM:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
