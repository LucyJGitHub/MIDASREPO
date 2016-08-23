/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ML Access RPG source for SFL text change')      */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       MLC0130  - ACCESS RPG SRC FOR SFL TEXT CHANGE               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       LAST AMEND NO. S01516             DATE 18JUL94              */
/*       PREV AMEND NO. Xnnnnn             DATE ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       S01516 - Incorporation into core                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&SOURCE &LIB &SRCF &MSGFNM &MULTLIB +
                          &MODUL)
 
             DCL        VAR(&SOURCE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB)       TYPE(*CHAR) LEN(10)
             DCL        VAR(&SRCF)      TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFNM)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MULTLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&MODUL)     TYPE(*CHAR) LEN(2)
 
             DCL        VAR(&RPG) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')
             DCL        VAR(&RPGSRCF) TYPE(*CHAR) LEN(10) +
                          VALUE('          ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCLF       FILE(SFLMSGPF)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
/******************************************************************/
 
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
 
/******************************************************************/
 
 
/* if record found - copy RPG source file to the QTEMP/RPGTEMP    +
  ~~~~~~~~~~~~~~~~~  and call  ML0140 to amend the source        +
                     then replace old source with amended version */
 
             IF         COND((%SST(&SOURCE 8 1)) *EQ '#') THEN(DO)
               CHGVAR     VAR(&RPG) VALUE(%SST(&SOURCE 1 7))
             ENDDO
             ELSE       CMD(CHGVAR VAR(&RPG) VALUE(%SST(&SOURCE 1 6)))
 
             CHGVAR     VAR(&RPGSRCF) VALUE(&SRCF)
             CHGVAR     VAR(%SST(&RPGSRCF 3 3)) VALUE('RPG')
 
 
             CHKOBJ     OBJ(&LIB/&RPGSRCF) OBJTYPE(*FILE) MBR(&RPG)
             MONMSG     MSGID(CPF9801 CPF9815) EXEC(DO)
               SNDMSG     MSG(&RPG *CAT ' NOT PRESENT IN ' +
                              *CAT &LIB *CAT ' / ' *CAT &RPGSRCF) +
                            TOMSGQ(QTEMP/RPGMSGQ)
               GOTO END
             ENDDO
 
             CPYF       FROMFILE(&LIB/&RPGSRCF) +
                          TOFILE(QTEMP/RPGTEMP) FROMMBR(&RPG) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          FMTOPT(*CVTSRC)
 
             DLTF       FILE(QTEMP/RPGOUTP)
             CRTDUPOBJ  OBJ(RPGTEMP) FROMLIB(QTEMP) OBJTYPE(*FILE) +
                          NEWOBJ(RPGOUTP)
 
             CALL       PGM(ML0140) PARM(&MSGFNM &SOURCE &LIB +
                          &MULTLIB &MODUL)
 
             CPYF       FROMFILE(QTEMP/RPGOUTP) +
                          TOFILE(&LIB/&RPGSRCF) FROMMBR(&RPG) +
                          TOMBR(*FROMMBR) MBROPT(*REPLACE) +
                          FMTOPT(*CVTSRC) SRCOPT(*SEQNBR)
 
             RMVM       FILE(QTEMP/RPGTEMP) MBR(*ALL)
             MONMSG     MSGID(CPF0000)
             DLTF       FILE(QTEMP/RPGOUTP)
             MONMSG     MSGID(CPF0000)
 
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             CLRPFM     FILE(SFLMSGPF)
             RETURN
ENDPGM
