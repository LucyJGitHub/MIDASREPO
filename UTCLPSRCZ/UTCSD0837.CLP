/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL Program to call UTSD0837')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       UTCSD0837 - CL program to call datapatch PGM/UTSD0837       */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. MD053260  *CREATE  Date 12Jul19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD053260 - FBM COB - Component SDC000817 00001 terminated   */
/*                  abnormally. Database error in file SDCUSTPD,     */
/*                  key 000992, in , at 001                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LSTD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&MLNAME) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DELR) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2019')
 
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
 
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCSD0837 - MD053260 Data Patch +
                          Program') TOMSGQ(MRUNQ MOPERQ)
/**/
/* Create LDA if it doesn't exist */
/**/
             CHKOBJ     OBJ(QTEMP/LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             ENDDO
/**/
/* Passed parameter is invalid */
/**/
             IF         COND((&MODE *NE 'A') *AND (&MODE *NE +
                          'a') *AND (&MODE *NE 'U')  +
                          *AND (&MODE *NE 'u')) THEN(DO)
 
                SNDPGMMSG  MSG('Invalid parameter passed to +
                             UTCSD0837') TOMSGQ(MOPERQ MRUNQ)
                SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) +
                             MSGDTA('Invalid parameter passed. Mode +
                             parameter should either be ''U'' ''u'' +
                             for Update and ''A'' or ''a'' for +
                             Audit.') MSGTYPE(*ESCAPE)
                GOTO       CMDLBL(END)
             ENDDO
 
/**/
/* Get system prefix */
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)
 
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
                CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
                CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
                CHGVAR     VAR(&DTALIB) VALUE(&PREF *TCAT 'DTALIB')
/**/
 
FLECHK:
/* Check if YYXXXXXXXX exists */
/**/
                CHKOBJ     OBJ(&DPLIB/YYSDINPHPD) OBJTYPE(*FILE)
                MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
                DLTF       FILE(&DPLIB/YYSDINPHPD)
 
/**/
/* Create backup */
/**/
BACKUP:
                RTVMBRD    FILE(SDINPHPD) MBR(*FIRSTMBR) +
                             RTNMBR(&MLNAME)
CPYFLE:
                CPYF       FROMFILE(&DMLIB/SDINPHPD) +
                             TOFILE(&DPLIB/YYSDINPHPD) +
                             FROMMBR(&MLNAME) TOMBR(&MLNAME) +
                             MBROPT(*REPLACE) CRTFILE(*YES)
                MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                   CLRPFM     FILE(&DPLIB/YYSDINPHPD) MBR(&MLNAME)
                ENDDO
                MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                   SNDUSRMSG  MSG('Error occurred in copying +
                                PF/SDINPHPD to PF/YYSDINPHPD. +
                                Process terminated.') MSGTYPE(*INFO)
                   GOTO       CMDLBL(END)
                ENDDO
 
                RTVMBRD    FILE(SDINPHPD) MBR(&MLNAME *NEXT) +
                             RTNMBR(&MLNAME)
                MONMSG     MSGID(CPF3049) EXEC(GOTO +
                             CMDLBL(CALPGM))
 
                GOTO       CMDLBL(CPYFLE)
 
             ENDDO
/**/
/* Call ILE/UTSD0837 */
/**/
 CALPGM:
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')
 
             CALL       PGM(UTSD0837) PARM(&MODE)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
 RGZFLE:
/* */
/* If any records were deleted then reorganise the file */
/* */
             RTVMBRD    FILE(SDINPHPD) MBR(*FIRSTMBR) +
                          RTNMBR(&MLNAME) NBRDLTRCD(&DELR)
 NXTMBR:
             IF         COND(&DELR *NE 0) THEN(DO)
                OVRDBF     FILE(SDINPHPD) TOFILE(SDINPHPD) +
                             MBR(&MLNAME) OVRSCOPE(*JOB) SHARE(*YES)
 
                CALL       PGM(SCC000060) PARM(SDINPHPD &MLNAME)
                DLTOVR     FILE(SDINPHPD) LVL(*JOB)
 
                IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                             CMDLBL(ABNOR))
 
                RTVMBRD    FILE(SDINPHPD) MBR(&MLNAME *NEXT) +
                             RTNMBR(&MLNAME) NBRDLTRCD(&DELR)
                MONMSG     MSGID(CPF3049) EXEC(GOTO CMDLBL(END))
 
                GOTO       CMDLBL(NXTMBR)
             ENDDO
 
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('UTCSD0837 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(END)
 
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:
 
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
                IF         COND(&RUNP *EQ 'YES') THEN(DO)
                   RTVMBRD    FILE(YYSDINPHPD) MBR(*FIRSTMBR) +
                                RTNMBR(&MLNAME)
 RESTRE:
                   CPYF       FROMFILE(&DPLIB/YYSDINPHPD) +
                                TOFILE(&DMLIB/SDINPHPD) +
                                FROMMBR(&MLNAME) TOMBR(&MLNAME) +
                                MBROPT(*REPLACE) FMTOPT(*NONE)
                   MONMSG     MSGID(CPF2817 CPF3130 CPF2909) +
                                EXEC(DO)
                      SNDUSRMSG  MSG('Error occurred in restoring +
                                   PF/SDINPHPD from PF/SDINPHPD. +
                                   Process terminated.  Please +
                                   restore PF/SDINPHPD manually from +
                                   PF/YYSDINPHPD.') MSGTYPE(*INFO)
                   ENDDO
 
                   RTVMBRD    FILE(YYSDINPHPD) MBR(&MLNAME *NEXT) +
                                RTNMBR(&MLNAME)
                   MONMSG     MSGID(CPF3049) EXEC(GOTO +
                                CMDLBL(ABNOR1))
                   GOTO       CMDLBL(RESTRE)
                ENDDO
             ENDDO
 
 ABNOR1:     SNDPGMMSG  MSG('Error occurred in UTCSD0837 program') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2019')
             SNDPGMMSG  MSG('End of UTCSD0837') TOMSGQ(MRUNQ MOPERQ)
 ENDPGM:     ENDPGM
