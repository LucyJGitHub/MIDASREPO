/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas LE Profitability Format File Maint. obj')       */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                     */
/*                                                                   */
/*       LERC41 - PROFITABILTY FORMAT FILE MAINTENANCE               */
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
/*       PREV AMEND NO. XXXXXX            DATE  DDMMMYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*********************************************************************/
 
PGM
 
     DCL        VAR(&AUDR) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Take Security Copy of Profitability Format Files */
 
     CPYF       FROMFILE(PEFMTC) TOFILE(XPFMTC) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XPFMTC))
     CPYF       FROMFILE(PEFMTD) TOFILE(XPFMTD) MBROPT(*REPLACE)
     MONMSG MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM FILE(XPFMTD))
 
  /* Call Profitability Format File Maintenance Program */
 
             CALL       LER410 &AUDR
 
     MONMSG MSGID(RPG0000 CPF0000 MCH0000) EXEC(DO)
            CPYF FROMFILE(XPFMTC) TOFILE(PEFMTC) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(PEFMTC))
            CPYF FROMFILE(XPFMTD) TOFILE(PEFMTD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(PEFMTD))
            SNDPGMMSG MSG('Transaction failed. Re-input necessary. -
            Enter to continue.') TOPGMQ(*EXT)
            CHGJOB SWS(00000000)
            GOTO CMDLBL(END)
     ENDDO
 
     IF COND(%SWITCH(XXXXXX11)) THEN(DO)
            CPYF FROMFILE(XPFMTC) TOFILE(PEFMTC) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(PEFMTC))
            CPYF FROMFILE(XPFMTD) TOFILE(PEFMTD) MBROPT(*REPLACE)
            MONMSG MSGID(CPF2817) CMPDTA(CPF2869) +
                   EXEC(CLRPFM FILE(PEFMTD))
            SNDPGMMSG  MSG('Job terminated, database in error. +
                           Contact Systems Department.') TOPGMQ(*EXT) +
                           TOMSGQ(MOPERQ)
             CHGJOB SWS(00000000)
             GOTO CMDLBL(END)
     ENDDO
 
  /* Call Profitability Cross-Reference File Creation Program */
 
             IF         (&AUDR = 'Y') CALL LERC415
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
          ENDPGM
