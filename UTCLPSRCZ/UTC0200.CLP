/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT CPP for CPYTOOUTQ command')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Utilities module                                    */
/*                                                                   */
/*       UTC0200 - CPP for CPYTOOUTQ                                 */
/*                                                                   */
/*      This program is the command-processing program for the       */
/*      CPYTOOUTQ command.  The command and program were both lifted */
/*      from the IBM-supplied QUSRTOOL library of specimen           */
/*      utilities.  As such it is not as thoroughly supplied with    */
/*      comments as it might be.                                     */
/*                                                                   */
/*      Note further that the validity checking is carried out in    */
/*      this program, not in a separate validity cheker.             */
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
/*       Prev Amend No. CAA002 *CREATE     Date 31OCT95              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CAA002 - Development of utility to save, edit and restore   */
/*                spooled files.                                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&FULLFILE &FULLOUTQ &FULLPRTF &MBR +
                          &PRTWIDTH)
             DCLF       FILE(QAFDMBRL) /* DSPFD *MBRLIST out file */
             DCL        VAR(&FULLOUTQ) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTQ) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OUTQL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FULLFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FULLPRTF) TYPE(*CHAR) LEN(20)
             DCL        VAR(&PRTF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MBR) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRTWIDTH) TYPE(*DEC) LEN(3 0)
             DCL        VAR(&SPLFNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(22)
             DCL        VAR(&ERRORSW) TYPE(*LGL) /* Standard error */
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7) /* Standard +
                          error */
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(512) /* Standard +
                          error */
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(512) /* +
                          Standard error */
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10) /* Standard +
                          error */
             DCL        &MSGFLIB *CHAR LEN(10)  /* Standard error */
             DCL        &KEYVAR *CHAR LEN(4)    /* Standard error */
             DCL        &KEYVAR2 *CHAR LEN(4)   /* Standard error */
             DCL        &RTNTYPE *CHAR LEN(2)   /* Standard error */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(STDERR1)) /* +
                          Std err */
             CHGVAR     VAR(&FILE) VALUE(%SST(&FULLFILE 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&FULLFILE 11 10))
             CHGVAR     VAR(&OUTQ) VALUE(%SST(&FULLOUTQ 1 10))
             CHGVAR     VAR(&OUTQL) VALUE(%SST(&FULLOUTQ 11 10))
             CHGVAR     VAR(&PRTF) VALUE(%SST(&FULLPRTF 1 10))
             CHGVAR     VAR(&PRTFL) VALUE(%SST(&FULLPRTF 11 10))
                        /* Ensure OUTQ exists */
             CHKOBJ     OBJ(&OUTQL/&OUTQ) OBJTYPE(*OUTQ)
                        /* Ensure PRTF exists */
             CHKOBJ     OBJ(&PRTFL/&PRTF) OBJTYPE(*FILE)
                        /* Ensure data base file exists */
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE)
             IF         COND(&MBR *EQ '*ALL') THEN(DO) /* All +
                          members */
                DLTF       FILE(QTEMP/DSPFDP)
                MONMSG     MSGID(CPF2105) /* No file */
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('DSPFD +
                             of member list in operation for ' *CAT +
                             &FILE) TOPGMQ(*EXT) MSGTYPE(*STATUS) /* +
                             Status message */
                DSPFD      FILE(&LIB/&FILE) TYPE(*MBRLIST) +
                             OUTPUT(*OUTFILE) OUTFILE(QTEMP/DSPFDP)
                SNDPGMMSG  MSGID(CPI9801) MSGF(QCPFMSG) TOPGMQ(*EXT) +
                             MSGTYPE(*STATUS) /* Blank status message */
             ENDDO      /* All members */
/* Change *LIBL to actual name */
             IF         COND(&OUTQL *EQ '*LIBL') THEN(DO) /* *LIBL */
                RTVOBJD    OBJ(&OUTQL/&OUTQ) OBJTYPE(*OUTQ) +
                             RTNLIB(&OUTQL)
             ENDDO      /* *LIBL */
             IF         COND(&LIB *EQ '*LIBL') THEN(DO) /* *LIBL */
                RTVOBJD    OBJ(&LIB/&FILE) OBJTYPE(*FILE) RTNLIB(&LIB)
             ENDDO      /* *LIBL */
/* For single member processing, branch */
             IF         COND(&MBR *NE '*ALL') THEN(GOTO CMDLBL(ONEMBR))
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/DSPFDP) +
                          SECURE(*YES)
 READ:                  /* Read from DSPFD *MBRLIST out file */
             RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(EOF))
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
/* The old SPLF name is in pos 1-10   */
/*   of the member text description   */
             CHGVAR     VAR(&SPLFNAME) VALUE(%SST(&MLMTXT 1 10))
             IF         COND(&PRTWIDTH *EQ 0) THEN(DO) /* Same print +
                          width */
             OVRPRTF    FILE(&PRTF) TOFILE(&PRTFL/&PRTF) +
                          CTLCHAR(*FCFC) PRTTXT(*BLANK) +
                          OUTQ(&OUTQL/&OUTQ) USRDTA(CPYTOOUTQ) +
                          SPLFNAME(&SPLFNAME) SECURE(*YES)
             ENDDO      /* Same print width */
             IF         COND(&PRTWIDTH *NE 0) THEN(DO) /* Override +
                          print width */
             OVRPRTF    FILE(&PRTF) TOFILE(&PRTFL/&PRTF) PAGESIZE(*N +
                          &PRTWIDTH) CTLCHAR(*FCFC) PRTTXT(*BLANK) +
                          OUTQ(&OUTQL/&OUTQ) USRDTA(CPYTOOUTQ) +
                          SPLFNAME(&SPLFNAME) SECURE(*YES)
             ENDDO      /* Override print width */
             CPYF       FROMFILE(&LIB/&FILE) TOFILE(&PRTFL/&PRTF) +
                          FROMMBR(&MLNAME)
             GOTO       CMDLBL(READ)
 EOF:                   /* All spooled files have been read */
             EDTVAR     CHROUT(&COUNTA) NUMINP(&COUNT)
             RMVMSG     CLEAR(*ALL)
             SNDPGMMSG  MSG(&COUNTA *TCAT ' spooled files written to +
                          output queue ' *CAT &OUTQ *TCAT ' in ' +
                          *CAT &OUTQL *TCAT ' from data base file ' +
                          *CAT &FILE *TCAT ' in ' *CAT &LIB *TCAT +
                          '.') MSGTYPE(*COMP)
             RETURN     /* Normal end of program */
 ONEMBR:                /* Single member processing */
             CHKOBJ     OBJ(&LIB/&FILE) OBJTYPE(*FILE) MBR(&MBR)
             RTVMBRD    FILE(&LIB/&FILE) MBR(&MBR) TEXT(&MLMTXT)
/* The old SPLF name is in pos 1-10   */
/*   of the member text description   */
             CHGVAR     VAR(&SPLFNAME) VALUE(%SST(&MLMTXT 1 10))
             OVRPRTF    FILE(&PRTF) CTLCHAR(*FCFC) PRTTXT(*BLANK) +
                          OUTQ(&OUTQL/&OUTQ) USRDTA(CPYTOOUTQ) +
                          SPLFNAME(&SPLFNAME) SECURE(*YES)
             CPYF       FROMFILE(&LIB/&FILE) TOFILE(&PRTFL/&PRTF) +
                          FROMMBR(&MBR)
             RMVMSG     CLEAR(*ALL)
             SNDPGMMSG  MSG('Member ' *CAT &MBR *TCAT ' written to +
                          output queue ' *CAT &OUTQ *TCAT ' in ' +
                          *CAT &OUTQL *TCAT ' from data base file ' +
                          *CAT &FILE *TCAT ' in ' *CAT &LIB *TCAT +
                          '.') MSGTYPE(*COMP)
             RETURN     /* Normal end of program */
 STDERR1:               /* Standard error handling routine */
             IF         COND(&ERRORSW) THEN(SNDPGMMSG MSGID(CPF9999) +
                          MSGF(QCPFMSG) MSGTYPE(*ESCAPE))
             CHGVAR     VAR(&ERRORSW) VALUE('1') /* Set to fail on +
                          error */
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) KEYVAR(&KEYVAR)
 STDERR2:    RCVMSG     MSGTYPE(*PRV) MSGKEY(&KEYVAR) RMV(*NO) +
                          KEYVAR(&KEYVAR2) MSG(&MSG) +
                          MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          RTNTYPE(&RTNTYPE) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             IF         COND(&RTNTYPE *NE '02') THEN(GOTO +
                          CMDLBL(STDERR3))
             IF         COND(&MSGID *NE ' ') THEN(SNDPGMMSG +
                          MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG))
             IF         COND(&MSGID *EQ ' ') THEN(SNDPGMMSG +
                          MSG(&MSG) MSGTYPE(*DIAG))
             RMVMSG     MSGKEY(&KEYVAR2)
 STDERR3:    RCVMSG     MSGKEY(&KEYVAR) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          SNDMSGFLIB(&MSGFLIB)
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
