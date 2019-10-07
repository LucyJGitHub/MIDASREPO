/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('CL Program to call UTSD0815')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       UTCSD0815 - CL program to call datapatch PGM/UTSD0815       */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. MD051784  *CREATE  Date 20Feb19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD051784 - FBM Live COB: SDC000776 Customers Status Update  */
/*                  at Effective Date 2 FAILED                       */
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
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2019')
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCSD0815 - MD-51784 Data Patch Program') +
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
                SNDPGMMSG  MSG('Invalid parameter passed to UTCSD0815') +
                             TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. Mode parameter should either be ''U'' +
                          ''u'' for Update and ''A'' or ''a'' for +
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
             CHKOBJ     OBJ(&DPLIB/YYSDFTCSPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYSDFTCSPD)

/**/
             CHKOBJ     OBJ(&DPLIB/YYSDCUSTXC) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYSDCUSTXC)

/**/
             CHKOBJ     OBJ(&DPLIB/YYSDACTXPD) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(YYSDACTXPD)

/**/
/* Create backup */
/**/
BACKUP:
             CPYF       FROMFILE(&DMLIB/SDFTCSPD) TOFILE(&DPLIB/YYSDFTCSPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                CLRPFM     FILE(YYSDFTCSPD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in copying PF/SDFTCSPD to +
                             PF/YYSDFTCSPD. Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CPYF       FROMFILE(&DMLIB/SDCUSTXC) TOFILE(&DPLIB/YYSDCUSTXC) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                CLRPFM     FILE(YYSDCUSTXC)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in copying PF/SDCUSTXC to +
                             PF/YYSDCUSTXC. Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CPYF       FROMFILE(&DMLIB/SDACTXPD) TOFILE(&DPLIB/YYSDACTXPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
                CLRPFM     FILE(YYSDACTXPD)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in copying PF/SDACTXPD to +
                             PF/YYSDACTXPD. Process terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO
/**/
/* Call ILE/UTSD0815 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTSD0815) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCSD0815 completed normally.') TOPGMQ(*EXT) +
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

                CPYF       FROMFILE(&DPLIB/YYSDFTCSPD) TOFILE(&DMLIB/SDFTCSPD) +
                             MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in restoring PF/SDFTCSPD from +
                             PF/SDFTCSPD. Process terminated.  Please restore +
                             PF/SDFTCSPD manually from PF/YYSDFTCSPD.') +
                             MSGTYPE(*INFO)
             ENDDO

             CPYF       FROMFILE(&DPLIB/YYSDCUSTXC) TOFILE(&DMLIB/SDCUSTXC) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in restoring PF/SDACUSPD from +
                             PF/SDCUSTXC. Process terminated.  Please restore +
                             PF/SDCUSTXC manually from PF/YYSDCUSTXC.') +
                             MSGTYPE(*INFO)
             ENDDO

             CPYF       FROMFILE(&DPLIB/YYSDACTXPD) TOFILE(&DMLIB/SDACTXPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
                SNDUSRMSG  MSG('Error occurred in restoring PF/SDACTXPD from +
                             PF/SDACTXPD. Process terminated.  Please restore +
                             PF/SDACTXPD manually from PF/YYSDFCLTPA.') +
                             MSGTYPE(*INFO)
             ENDDO

             ENDDO

             ENDDO

 ABNOR1:     SNDPGMMSG  MSG('Error occurred in UTCSD0815 program') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited +
                          2019')
             SNDPGMMSG  MSG('End of UTCSD0815') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
