/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Display message file(s)')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Module                                           */
/*                                                                   */
/*       DSPMSGF - Display message file information                */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CPK018  *MOVED     Date 25Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CUP002 *CREATE     Date 08Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CUP002 - Message file utilities                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGFLLIB &OUTPUT &OUTFILE &MBROPT)
 
             DCL        VAR(&MSGFLLIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBROPT) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGFL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(20) +
                          VALUE('DSPMSGF   QTEMP     ')
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('OBJL0100')
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(10) +
                          VALUE('*MSGF')
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&USLEN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&ENTSIZ) TYPE(*DEC) LEN(4 0)
             DCL        VAR(&USHEAD) TYPE(*CHAR) LEN(140)
             DCL        VAR(&USDTA) TYPE(*CHAR) LEN(20)
             DCL        VAR(&BUSSTRT) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BUSLEN) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BOFFSET) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BENTSIZ) TYPE(*CHAR) LEN(4)
             DCL        VAR(&BLANKS) TYPE(*CHAR) LEN(10)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Separate parameters into variables */
             CHGVAR     VAR(&MSGFL) VALUE(%SST(&MSGFLLIB 1 10))
             CHGVAR     VAR(&LIB) VALUE(%SST(&MSGFLLIB 11 10))
             CHGVAR     VAR(&OFILE) VALUE(%SST(&OUTFILE 1 10))
             CHGVAR     VAR(&OFLIB) VALUE(%SST(&OUTFILE 11 10))
             CHGVAR     VAR(&MEMBER) VALUE(%SST(&MBROPT 3 10))
             CHGVAR     VAR(&OPTION) VALUE(%SST(&MBROPT 13 08))
 
/* Processing for outfile option */
             IF         COND(&OUTPUT *EQ '*OUTFILE') THEN(DO)
 
/* If outfile specified then create if it doesn't already exist */
                CHKOBJ     OBJ(&OFLIB/&OFILE) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   IF         COND(&OFLIB *EQ '*LIBL') THEN(DO)
                      RTVJOBA    CURLIB(&CURLIB)
                      IF         COND(&CURLIB *EQ '*NONE') THEN(DO)
                         CHGVAR     VAR(&CURLIB) VALUE('QGPL')
                      ENDDO
                      CHGVAR     VAR(&OFLIB) VALUE(&CURLIB)
                   ENDDO
                   CPYF      FROMFILE(UTDSPMPD) TOFILE(&OFLIB/&OFILE) +
                          CRTFILE(*YES)
                   CHGPF      FILE(&OFLIB/&OFILE) MAXMBRS(*NOMAX) +
                          LVLCHK(*NO)
   /* If member not *FIRST then add named member to file */
                   IF         COND(&MEMBER *NE '*FIRST') THEN(DO)
                      RMVM       FILE(&OFLIB/&OFILE) MBR(UTDSPMPD)
                      ADDPFM     FILE(&OFLIB/&OFILE) MBR(&MEMBER) +
                          TEXT('Outfile for DSPMSGF')
                   ENDDO
                   GOTO       CMDLBL(CRTMSGF)
                ENDDO
 
/* If file already exists then check member */
                CHKOBJ  OBJ(&OFLIB/&OFILE) OBJTYPE(*FILE) MBR(&MEMBER)
                MONMSG     MSGID(CPF9815) EXEC(DO)
                   ADDPFM     FILE(&OFLIB/&OFILE) MBR(&MEMBER) +
                          TEXT('Outfile for DSPMSGF')
                   GOTO       CMDLBL(CRTMSGF)
                ENDDO
 
/* If member already exists then check if records are to be replaced */
                IF         COND(&OPTION *EQ '*REPLACE') THEN(DO)
                   CLRPFM     FILE(&OFLIB/&OFILE) MBR(&MEMBER)
                ENDDO
 
             ENDDO
 
/* Create user space to contain list of programs */
CRTMSGF:
             DLTUSRSPC  USRSPC(QTEMP/DSPMSGF)
             MONMSG     MSGID(CPF0000)
 
             CALL       PGM(QUSCRTUS) PARM(&USRSPC 'APILIST' +
                          X'00002000' ' ' '*ALL' 'User space for +
                          list of message files')
 
/* List files specified in the DSPMSGF command */
             CALL       PGM(QUSLOBJ) PARM(&USRSPC &FORMAT &MSGFLLIB +
                          &OBJTYPE)
 
/* For output = outfile, put in override, call RPG program which will*/
/* use API to retrieve message information */
 
             IF         COND(&OUTPUT *EQ '*OUTFILE') THEN(DO)
                OVRDBF     FILE(UTDSPMPD) TOFILE(&OFLIB/&OFILE) +
                          MBR(&MEMBER)
 
                CALL       PGM(UT0025)
 
                DLTOVR     FILE(UTDSPMPD)
                GOTO       CMDLBL(END)
             ENDDO
 
/* For output = print or display, use API to get file names, and */
/* use DSPMSGD to output information */
             IF         COND(&OUTPUT *EQ '*PRINT' *OR &OUTPUT *EQ +
                          '*') THEN(DO)
                CHGVAR     VAR(%BIN(&BUSSTRT)) VALUE(1)
                CHGVAR     VAR(%BIN(&BUSLEN)) VALUE(140)
 
/* Get header information */
                CALL     PGM(QUSRTVUS) PARM(&USRSPC &BUSSTRT &BUSLEN +
                          &USHEAD)
                CHGVAR     VAR(&BOFFSET) VALUE(%SST(&USHEAD 125 4))
                CHGVAR     VAR(&BENTSIZ) VALUE(%SST(&USHEAD 137 4))
 
                CHGVAR     VAR(%BIN(&BUSSTRT)) VALUE(%BIN(&BUSSTRT) + +
                          %BIN(&BOFFSET))
                CHGVAR     VAR(&USLEN) VALUE(&ENTSIZ)
 
/* Processing for display/print option */
 LOOP:          CALL     PGM(QUSRTVUS) PARM(&USRSPC &BUSSTRT &BUSLEN +
                          &USDTA)
                CHGVAR     VAR(%BIN(&BUSSTRT)) VALUE(%BIN(&BUSSTRT) + +
                          %BIN(&BENTSIZ))
                CHGVAR     VAR(&MSGFL) VALUE(%SST(&USDTA 1 10))
                CHGVAR     VAR(&LIB) VALUE(%SST(&USDTA 11 10))
 
/* Where output exists, output to print or display */
                IF         (&MSGFL *NE &BLANKS) THEN(DO)
 
/* For output = print put in override to rename spool file */
                   IF         COND(&OUTPUT *EQ '*PRINT') THEN(DO)
                      OVRPRTF    FILE(QPMSGD) USRDTA(DSPMSGF) +
                          SPLFNAME(&MSGFL) OVRSCOPE(*JOB)
                   ENDDO
 
                   DSPMSGD    RANGE(*ALL) MSGF(&LIB/&MSGFL) +
                        DETAIL(*BASIC)  OUTPUT(&OUTPUT)
                   GOTO       CMDLBL(LOOP)
                ENDDO
             ENDDO
 
/* For output = print remove override to rename spool file */
             IF      COND(&OUTPUT *EQ '*PRINT') THEN(DO)
                DLTOVR     FILE(QPMSGD) LVL(*JOB)
             ENDDO
             GOTO       CMDLBL(END)
 ABNOR:
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm DSPMSGF') +
                          MSGTYPE(*ESCAPE)
             ENDDO
 
             CHGVAR     VAR(&IN01) VALUE('1')
ABNOR2:
 /* Receive diagnostic error message */
             RCVMSG     MSGTYPE(*DIAG) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 
             IF         COND(&MSGID *NE ' ') THEN(DO)
 /* Pass it back to calling program */
                SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*DIAG)
                GOTO       CMDLBL(ABNOR2)
             ENDDO
 /* Receive escape error message */
             RCVMSG     MSGTYPE(*EXCP) MSGDTA(&MSGDTA) MSGID(&MSGID) +
                          MSGF(&MSGF) SNDMSGFLIB(&MSGFLIB)
 /* Pass it back to calling program */
             SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                          MSGDTA(&MSGDTA) MSGTYPE(*ESCAPE)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM
