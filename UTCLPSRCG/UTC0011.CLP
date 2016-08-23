/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Rename member')                              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Utilities Module                                */
/*                                                                   */
/*       UTC0011 - Rename Member                                     */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*       Last Amend No. BG18886            Date 22May08              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      084651 *CREATE     Date 13MAR95              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BG18886 - Amended non-standard codes                        */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       084651 - New program created for this change.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&OLDFILE &OLDMBR &NEWMBR &NEWFILE +
                          &DELETE &TEXT)
 
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(132)
             DCL        VAR(&OLDFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OLDFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDFILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OLDMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWMBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&NEWFILE1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&NEWFILE2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DELETE) TYPE(*CHAR) LEN(4)
             DCL        VAR(&TEXT) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&OLDFILE1) VALUE(%SUBSTRING(&OLDFILE 1 10))
             CHGVAR     VAR(&OLDFILE2) VALUE(%SUBSTRING(&OLDFILE 11 10))
             CHGVAR     VAR(&NEWFILE1) VALUE(%SUBSTRING(&NEWFILE 1 10))
             CHGVAR     VAR(&NEWFILE2) VALUE(%SUBSTRING(&NEWFILE 11 10))
 
             IF         COND(&NEWFILE1 *EQ '*OLDFILE  ') THEN(DO)
                CHGVAR     VAR(&NEWFILE1) VALUE(&OLDFILE1)
             ENDDO
 
             IF         COND(&NEWFILE2 *EQ '          ') THEN(DO)
                CHGVAR     VAR(&NEWFILE2) VALUE(&OLDFILE2)
             ENDDO
 
             IF         COND(&NEWMBR *EQ '*MBR      ') THEN(DO)
                CHGVAR     VAR(&NEWMBR) VALUE(&OLDMBR)
             ENDDO
 
             IF         COND(&NEWFILE1 *EQ &OLDFILE) THEN(DO)
                 IF         COND(&NEWFILE2 *EQ &OLDFILE2) THEN(DO)
                    CHGVAR     VAR(&MSG) VALUE('FILES ARE THE SAME  +
                                               ,COMMAND TERMINATED')
                    SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT)
                    RETURN
                 ENDDO
              ENDDO
 
             ADDPFM     FILE(&NEWFILE2/&NEWFILE1) MBR(&NEWMBR) +
                          TEXT(&TEXT) EXPDATE(*NONE) SHARE(*NO)
             MONMSG     MSGID(CPF0000) EXEC(DO)
                RCVMSG     MSG(&MSG)
 /**************CHGVAR     VAR(&MSG) VALUE('**WARNING** '**&MSG)      */ /*BG18886*/
                CHGVAR     VAR(&MSG) VALUE('**WARNING** ' *CAT &MSG)     /*BG18886*/
                SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT)
                CLRPFM     FILE(&NEWFILE2/&NEWFILE1) MBR(&NEWMBR)
             ENDDO
 
             CPYF       FROMFILE(&OLDFILE2/&OLDFILE1) +
                          TOFILE(&NEWFILE2/&NEWFILE1) +
                          FROMMBR(&OLDMBR) TOMBR(&NEWMBR) MBROPT(*ADD)
 
             IF         COND(&DELETE *EQ '*YES') THEN(RMVM +
                          FILE(&OLDFILE2/&OLDFILE1) MBR(&OLDMBR))
             RETURN
 
             GOTO       CMDLBL(END)
 
ABNOR:
             RCVMSG     MSG(&MSG) RMV(*NO)
             MONMSG     MSGID(CPF0000)
 
/************IF         COND(&MSG**' ') THEN(DO)                     */ /*BG18886*/
             IF         COND(&MSG *NE ' ') THEN(DO)                     /*BG18886*/
                SNDPGMMSG  MSG(&MSG)
                MONMSG     MSGID(CPF0000)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
