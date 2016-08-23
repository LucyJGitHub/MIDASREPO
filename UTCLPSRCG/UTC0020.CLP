/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT WRTSRC main program')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas     Utilities Module                                  */
/*                                                                   */
/*       UTC0020 - Write source record                               */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 26Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. S01516             Date 18Jul94              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       S01516 - Incorporation of enhanced CRTOBJ into core         */
/*                                                                   */
/*********************************************************************/
/* TAASRCGC - CPP for WRTSRC command - Write source record        */
             PGM        PARM(&FULLFILE &MBR &RELRCD &ACTION &STMT +
                          &POS1 &TXT1 &POS2 &TXT2 &POS3 &TXT3 &POS4 +
                          &TXT4)
             DCL        &FULLFILE *CHAR LEN(20)
             DCL        &FILE *CHAR LEN(10)
             DCL        &LIB *CHAR LEN(10)
             DCL        &MBR *CHAR LEN(10)
             DCL        &RELRCD *DEC LEN(3 0)
             DCL        &RELRCDA *CHAR LEN(3)
             DCL        &ACTION *CHAR LEN(4)
             DCL        &STMT *CHAR LEN(80)
             DCL        &POS1 *DEC LEN(2 0)
             DCL        &TXT1 *CHAR LEN(25)
             DCL        &POS2 *DEC LEN(2 0)
             DCL        &TXT2 *CHAR LEN(25)
             DCL        &POS3 *DEC LEN(2 0)
             DCL        &TXT3 *CHAR LEN(25)
             DCL        &POS4 *DEC LEN(2 0)
             DCL        &TXT4 *CHAR LEN(25)
             DCL        &RTNCDE *CHAR LEN(8)
             DCL        &ERRORSW *LGL                     /* Std err */
             DCL        &MSGID *CHAR LEN(7)               /* Std err */
             DCL        &MSGDTA *CHAR LEN(100)            /* Std err */
             DCL        &MSGF *CHAR LEN(10)               /* Std err */
             DCL        &MSGFLIB *CHAR LEN(10)            /* Std err */
             DCL        &KEYVAR *CHAR LEN(4)              /* Std err */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO STDERR1) /* Std err */
             CHGVAR     &FILE %SST(&FULLFILE 1 10)
             CHGVAR     &LIB %SST(&FULLFILE 11 10)
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) MBR(&MBR)
             IF         ((&ACTION *EQ '*UPD') *AND (&STMT *NE ' ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If ACTION(*UPD) +
                          is specified, STMT must be blank')
             IF         ((&ACTION *EQ '*UPD') *AND (&RELRCD *EQ 0)) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If ACTION(*UPD) +
                          is specified, RELRCD must not be *NEXT')
             IF         ((&ACTION *EQ '*RPL') *AND (&RELRCD *EQ 0)) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If ACTION(*RPL) +
                          is specified, RELRCD must not be *NEXT')
             IF         ((&ACTION *EQ '*ADD') *AND (&RELRCD *GT 0)) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If ACTION(*ADD) +
                          is specified, RELRCD must be *NEXT')
             IF         ((&POS1 *GT 0) *AND (&TXT1 *EQ '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS1 is +
                          specified, TXT1 must not be blank')
             IF         ((&POS2 *GT 0) *AND (&TXT2 *EQ '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS2 is +
                          specified, TXT2 must not be blank')
             IF         ((&POS3 *GT 0) *AND (&TXT3 *EQ '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS3 is +
                          specified, TXT3 must not be blank')
             IF         ((&POS4 *GT 0) *AND (&TXT4 *EQ '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS4 is +
                          specified, TXT4 must not be blank')
             IF         ((&POS1 *EQ 0) *AND (&TXT1 *NE '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS1 is not +
                          specified, TXT1 must be blank')
             IF         ((&POS2 *EQ 0) *AND (&TXT2 *NE '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS2 is not +
                          specified, TXT2 must be blank')
             IF         ((&POS3 *EQ 0) *AND (&TXT3 *NE '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS3 is not +
                          specified, TXT3 must be blank')
             IF         ((&POS4 *EQ 0) *AND (&TXT4 *NE '  ')) +
                          SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) +
                          MSGTYPE(*ESCAPE) MSGDTA('If POS4 is not +
                          specified, TXT4 must be blank')
             OVRDBF     FILE(QCLSRC) TOFILE(&LIB/&FILE) MBR(&MBR)
             CALL       PGM(UT0020) PARM(&RELRCD &ACTION &STMT +
                          &POS1 &TXT1 &POS2 &TXT2 &POS3 &TXT3 &POS4 +
                          &TXT4 &RTNCDE)
             IF         (&RTNCDE *EQ 'GOOD') RETURN
             IF         (&RTNCDE *EQ 'NOTFOUND') DO /* Not found */
             CHGVAR     &RELRCDA &RELRCD
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGTYPE(*ESCAPE) +
                          MSGDTA('Relative record number ' *CAT +
                          &RELRCDA *CAT ' was not found in ' *CAT +
                          &FILE *TCAT ' in ' *CAT &LIB *CAT +
                          ' member ' *CAT &MBR)
             ENDDO      /* Not found */
             IF         (&RTNCDE *EQ 'OVERFLOW') DO /* Overflow */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGTYPE(*ESCAPE) +
                          MSGDTA('The POSn value and the truncated +
                          value of TXTn exceed 80 bytes')
             ENDDO      /* Overflow */
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGTYPE(*ESCAPE) +
                          MSGDTA('Bad return code of ' *CAT +
                          &RTNCDE *CAT ' from WRTSRC')
 STDERR1:               /* Standard error handling routine */
             IF         &ERRORSW SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE) /* Func chk */
             CHGVAR     &ERRORSW '1' /* Set to fail if error occurs */
 STDERR2:    RCVMSG     MSGTYPE(*DIAG) RMV(*NO) KEYVAR(&KEYVAR) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             IF         (&KEYVAR *EQ '    ') GOTO STDERR3
             RMVMSG     MSGKEY(&KEYVAR)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
             GOTO       STDERR2 /* Loop back for addl diagnostics */
 STDERR3:    RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
