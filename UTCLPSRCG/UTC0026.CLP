/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas UT Compare message files')                      */
/*********************************************************************/
/*                                                                   */
/*       Midas - UT Module                                           */
/*                                                                   */
/*       UTC0026 - Compare message files                             */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPK018             Date 25Apr04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CUP002 *C *CREATE  Date 08Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK018 - MidasPlus packaging.  Moved to global layer.       */
/*       CUP002 - Message file utilities                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MSGF1LIB &MSGF2LIB &OUTPUT &OUTFILE +
                          &MBROPT)
 
             DCL        VAR(&MSGF1LIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MSGF2LIB) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CRIT1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&CRIT2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&OUTPUT) TYPE(*CHAR) LEN(8)
             DCL        VAR(&OUTFILE) TYPE(*CHAR) LEN(20)
             DCL        VAR(&MBROPT) TYPE(*CHAR) LEN(20)
             DCL        VAR(&HDRTXT) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGF1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB1) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGF2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LIB2) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBER) TYPE(*CHAR) LEN(10)
             DCL        VAR(&OPTION) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&USRSPC) TYPE(*CHAR) LEN(20) +
                          VALUE('DSPMSGF   QTEMP     ')
             DCL        VAR(&TEMPO) TYPE(*CHAR) LEN(20) +
                          VALUE('CMPMSGFO  QTEMP     ')
             DCL        VAR(&FORMAT) TYPE(*CHAR) LEN(8) +
                          VALUE('OBJL0100')
             DCL        VAR(&OBJTYPE) TYPE(*CHAR) LEN(10) +
                          VALUE('*MSGF')
             DCL        VAR(&MATCH) TYPE(*CHAR) LEN(8)
 
             DCL        VAR(&MSGID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGDTA) TYPE(*CHAR) LEN(100)
             DCL        VAR(&IN01) TYPE(*LGL)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* Separate parameters into variables */
             CHGVAR     VAR(&MSGF1) VALUE(%SST(&MSGF1LIB 1 10))
             CHGVAR     VAR(&LIB1) VALUE(%SST(&MSGF1LIB 11 10))
             CHGVAR     VAR(&MSGF2) VALUE(%SST(&MSGF2LIB 1 10))
             CHGVAR     VAR(&LIB2) VALUE(%SST(&MSGF2LIB 11 10))
             CHGVAR     VAR(&OFILE) VALUE(%SST(&OUTFILE 1 10))
             CHGVAR     VAR(&OFLIB) VALUE(%SST(&OUTFILE 11 10))
             CHGVAR     VAR(&MEMBER) VALUE(%SST(&MBROPT 3 10))
             CHGVAR     VAR(&OPTION) VALUE(%SST(&MBROPT 13 08))
             CHGVAR     VAR(&CRIT1) VALUE(&MSGF1LIB)
             CHGVAR     VAR(&CRIT2) VALUE(&MSGF2LIB)
 
/* Checking for *BASEMSGF option */
             IF         COND(&MSGF2 *EQ '*BASEMSGF') THEN(DO)
                CHGVAR     VAR(&MSGF2) VALUE(&MSGF1)
                CHGVAR     VAR(&MSGF2LIB) VALUE(&MSGF1 *CAT &LIB2)
                CHGVAR     VAR(&CRIT2) VALUE(&MSGF1 *CAT &LIB2)
             ENDDO
 
/* Checking for comparison of files with different names */
             IF         COND(&MSGF1 *NE &MSGF2) THEN(DO)
                CHGVAR     VAR(&MATCH) VALUE('SINGLE')
             ENDDO
 
/* Create temporary files if they don't already exist */
             DLTF       FILE(QTEMP/CMPMSGF1)
             MONMSG     MSGID(CPF2105)
             CPYF       FROMFILE(UTDSPMPD) TOFILE(QTEMP/CMPMSGF1) +
                          CRTFILE(*YES)
/************CHGPF      FILE(QTEMP/CMPMSGF1) MAXMBRS(*NOMAX) +
                          LVLCHK(*NO) */
 
/* Create second temporary file if it doesn't already exist */
             DLTF       FILE(QTEMP/CMPMSGF2)
             MONMSG     MSGID(CPF2105)
             CPYF       FROMFILE(UTDSPMPD) TOFILE(QTEMP/CMPMSGF2) +
                          CRTFILE(*YES)
/************CHGPF      FILE(QTEMP/CMPMSGF2) MAXMBRS(*NOMAX) +
                          LVLCHK(*NO) */
 
/* Processing for print option */
             IF         COND(&OUTPUT *EQ '*PRINT') THEN(DO)
 
/* Create temporary output file if it doesn't already exist */
                DLTF       FILE(QTEMP/CMPMSGFO)
                MONMSG     MSGID(CPF2105)
                CPYF       FROMFILE(UTCMPMPD) TOFILE(QTEMP/CMPMSGFO) +
                          CRTFILE(*YES)
/************   CHGPF      FILE(QTEMP/CMPMSGFO) MAXMBRS(*NOMAX) +
                          LVLCHK(*NO) */
             ENDDO
 
/* Processing for outfile option */
             IF         COND(&OUTPUT *EQ '*OUTFILE') THEN(DO)
 
/* If outfile specified then create if it doesn't already exist */
                CHKOBJ     OBJ(&OFLIB/&OFILE) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(DO)
                   CPYF FROMFILE(UTCMPMPD) TOFILE(&OFLIB/&OFILE) +
                       CRTFILE(*YES)
                   CHGPF FILE(&OFLIB/&OFILE) MAXMBRS(*NOMAX)
 
/* If member not *FIRST then add named member to file */
                   IF      COND(&MEMBER *NE '*FIRST') THEN(DO)
                      RMVM       FILE(&OFLIB/&OFILE) MBR(UTCMPMPD)
                      ADDPFM     FILE(&OFLIB/&OFILE) MBR(&MEMBER) +
                          TEXT('Outfile for CMPMSGF')
                   ENDDO
                   GOTO       CMDLBL(CRTCMPF)
                ENDDO
 
/* If file already exists then check member */
                CHKOBJ OBJ(&OFLIB/&OFILE) OBJTYPE(*FILE) MBR(&MEMBER)
                MONMSG     MSGID(CPF9815) EXEC(DO)
                   ADDPFM     FILE(&OFLIB/&OFILE) MBR(&MEMBER) +
                          TEXT('Outfile for CMPMSGF')
                   GOTO       CMDLBL(CRTCMPF)
                ENDDO
 
/* If member already exists then check if records are to be replaced */
                IF         COND(&OPTION *EQ '*REPLACE') THEN(DO)
                   CLRPFM     FILE(&OFLIB/&OFILE) MBR(&MEMBER)
                ENDDO
 
             ENDDO
 
CRTCMPF:
/* List messages in base files specified in the CMPMSGF command */
             DSPMSGF    MSGF(&LIB1/&MSGF1) OUTFILE(QTEMP/CMPMSGF1)
 
/* List messages in compare files specified in the CMPMSGF command */
             DSPMSGF    MSGF(&LIB2/&MSGF2) OUTFILE(QTEMP/CMPMSGF2)
 
/* Put in override and call RPG program which will use API to */
/* retrieve message information */
             IF         COND(&OUTPUT *EQ '*OUTFILE') THEN(DO)
                OVRDBF     FILE(UTCMPMPD) TOFILE(&OFLIB/&OFILE) +
                          MBR(&MEMBER)
             ENDDO
 
             IF         COND(&OUTPUT *EQ '*PRINT') THEN(DO)
                OVRDBF     FILE(UTCMPMPD) TOFILE(QTEMP/CMPMSGFO)
             ENDDO
 
             CALL       PGM(UT0026) PARM(&MATCH)
 
             IF         COND(&OUTPUT *EQ '*PRINT') THEN(DO)
                CALL       PGM(UT0027) PARM(&CRIT1 &CRIT2)
             ENDDO
 
             DLTOVR     FILE(UTCMPMPD)
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 /* Recursive error */
             IF         COND(&IN01) THEN(DO)
                SNDPGMMSG  MSGID(CPF9898) MSGF(*LIBL/QCPFMSG) +
                          MSGDTA('Recursive error in pgm CMPMSGF') +
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
                          Finastra International Limited')
             ENDPGM
