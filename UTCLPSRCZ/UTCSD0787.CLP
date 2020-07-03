/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas  SD MD-53116 Utility program for T_GZCUSTEX')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Standing Data Module                                */
/*                                                                   */
/*       UTCSD0787 - Midas  SD MD-53116 Utility pgm                  */
/*                   (CL program to call ILE/UTSD0787)               */
/*                                                                   */
/*       (c) Finastra International Limited 2019                     */
/*                                                                   */
/*       Last Amend No. MD053116  *CREATE  Date 08Oct19              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD053116 - Customer Deactivated but not displayed as        */
/*                  inactive.                                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
/**/
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&GMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&GLOBID) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited 2016')
/**/
/*/COPY SDCPYSRC,SDSVALDCL                                                                        */
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCSD0787 - MD-53116 Utility Program+
                          for T_GZCUSTEX') TOMSGQ(MRUNQ MOPERQ)
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
             SNDPGMMSG  MSG('Invalid parameter passed to UTCSD0787') +
                             TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed. It should either be ''U'' +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u'))  +
                        THEN(DO)
/**/
/*  Determine global system ID.                                                                   */
/**/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC 'GlobalSystemPrefix' +
                          &SVAL1 &SVALK2 &SVAL2 &SVALK3 &SVAL3 +
                          &SVALK4 &SVAL4 &SVALK5 &SVAL5 &SVALK6 +
                          &SVAL6 &SVALK7 &SVAL7 &SVALK8 &SVAL8 +
                          &SVALK9 &SVAL9 &SVALK10 &SVAL10)
/**/
/* If there is an error finding system values, then end abnormally.                               */
/**/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                             CMDLBL(ABNOR1))
/**/
/*  Define names of global libraries.                                                             */
/**/
             CHGVAR     VAR(&GLOBID) VALUE(&SVAL1)
             CHGVAR     VAR(&GPLIB) VALUE(&GLOBID *TCAT 'GPLIB')
             CHGVAR     VAR(&GMLIB) VALUE(&GLOBID *TCAT 'GMLIB')
/**/
/* Check if Y_GZCUSTEX exists */
/**/
             CHKOBJ     OBJ(&GPLIB/Y_GZCUSTEX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(FLECHK))
             DLTF       FILE(Y_GZCUSTEX)
/**/
FLECHK:      CHKOBJ     OBJ(&GPLIB/Y_GZCUSTEX) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(Y_GZCUSTEX)
/**/
/* Create backup of PF/T_GZCUSTEX  */
/**/
BACKUP:      CPYF       FROMFILE(&GMLIB/T_GZCUSTEX) +
                          TOFILE(&GPLIB/Y_GZCUSTEX) MBROPT(*REPLACE) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(Y_GZCUSTEX)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/T_GZCUSTEX +
                          tO PF/Y_GZCUSTEX. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO
/**/
/* Call ILE/UTSD0787 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')

             CALL       PGM(UTSD0787) PARM(&MODE)
/**/
/* Error occurred in audit program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCSD0787 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)

/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&GPLIB/Y_GZCUSTEX) +
                        TOFILE(&GMLIB/T_GZCUSTEX) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/T_GZCUSTEX+
                           from PF/Y_GZCUSTEX. Process terminated.  +
                          Please restore PF/T_GZCUSTEX manually from +
                          PF/Y_GZCUSTEX.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO
             ENDDO

ABNOR1:      SNDPGMMSG  MSG('Error occurred in UTCSD0787 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Limited 2016')
             SNDPGMMSG  MSG('End of UTCSD0787') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
