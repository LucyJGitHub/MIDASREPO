/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL Program to call UTCB0857')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Close of Business                                   */
/*                                                                   */
/*       UTCCB0857 - CL program to call datapatch PGM/UTCB0857       */
/*                                                                   */
/*       (c) Finastra International Limited 2021                     */
/*                                                                   */
/*       Last Amend No. MD057673  *CREATE  Date 13Mar21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD057673 - Unauthorised transactions screen error in        */
/*                  CB001001DF                                       */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&LSTD) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&GPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)

             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)
             DCL        VAR(&SVALK1) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK2) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK3) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK4) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK5) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK6) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL6) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK7) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL7) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK8) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL8) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK9) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL9) TYPE(*CHAR) LEN(200)
             DCL        VAR(&SVALK0) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SVAL10) TYPE(*CHAR) LEN(200)

             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2021')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCCB0857 - MD-57673 Data Patch Program') +
                          TOMSGQ(MRUNQ MOPERQ)
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
/**/
             SNDPGMMSG  MSG('Invalid parameter passed to UTCCB0857') +
                             TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. Mode parameter should either be ''U'' +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO

/**/
/* Get global system prefix, if mode is for update*/
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)

/* Check system value for Bridge Midas Global Prefix */

             CHGVAR     VAR(&RTCD) VALUE(*BLANKS)
             CHGVAR     VAR(&SVAL1) VALUE(*BLANKS)

             CALL       PGM(AOSVALR0) PARM(&RTCD +
                          'BrgMidasGlobalPrefix' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK0 &SVAL10)

             IF         COND(&RTCD *NE '       ') THEN(DO)
             DMPCLPGM
             SNDUSRMSG  MSG('Database Error occurred in SDSVALPD, system value +
                             BrgMidasGlobalPrefix not found.') +
                             MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO

             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&PREF) VALUE(&SVAL1))
             CHGVAR     VAR(&GPLIB) VALUE(&PREF *TCAT 'GPLIB')
/**/

FLECHK:
/* Check if YYXXXXXXXX exists in GPLIB for backup */
/**/
             CHKOBJ     OBJ(&GPLIB/YYGPDWNLPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYGPDWNLPD)

/**/
/* Create backup */
/**/
BACKUP:
             CPYF       FROMFILE(&GPLIB/GPDWNLPD) TOFILE(&GPLIB/YYGPDWNLPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                CLRPFM     FILE(YYGPDWNLPD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in copying PF/GPDWNLPD to +
                             PF/YYGPDWNLPD. Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO
/**/
/* Call ILE/UTCB0857 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTCB0857) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCCB0857 completed normally.') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)

/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&GPLIB/YYGPDWNLPD) TOFILE(&GPLIB/GPDWNLPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/GPDWNLPD from +
                             PF/GPDWNLPD. Process terminated.  Please restore +
                             PF/GPDWNLPD manually from PF/YYGPDWNLPD.') +
                             MSGTYPE(*INFO)
             ENDDO

             ENDDO

             ENDDO

 ABNOR1:     SNDPGMMSG  MSG('Error occurred in UTCCB0857 program') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2019')
             SNDPGMMSG  MSG('End of UTCCB0857') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
