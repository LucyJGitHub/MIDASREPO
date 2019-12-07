/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Calling Program RZB-MOS MD022057')                    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0791 - To add/delete OL repayments in PF/FACHISA       */
/*                                                                   */
/*       (c) Misys Banking Systems 2016                              */
/*                                                                   */
/*       Last Amend No. MD022057  *CREATE  Date 03Oct16              */
/*       Prev Amend No. Xxxxxxxx           Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD022057 - Calls UTLE0791 datapatch program.                */
/*                - Applied for MD051193                             */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)

             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RUNP) TYPE(*CHAR) LEN(3) VALUE('NO')
             DCL        VAR(&SLC) TYPE(*CHAR) LEN(200)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems 2016')
/**/
/* Global monitor message */
/**/

             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCLE0791 - Utility to update Facility +
                        History File - FACHISA') +
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
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
             SNDPGMMSG  MSG('UTCLE0791 - Invalid parameter passed') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter. It should either be ''U'' or +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(END)
             ENDDO
/**/
/* Get system prefix */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
/**/
/*  Check if OOFACHISA, OOFACHISH and OOFACACT already exist */
/**/
             CHKOBJ     OBJ(&DPLIB/OOFACHISA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK1))
             DLTF       FILE(OOfACHISA)

CHECK1:      CHKOBJ     OBJ(&DPLIB/OOFACHISH) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK2))
             DLTF       FILE(OOFACHISH)

CHECK2:      CHKOBJ     OBJ(&DPLIB/OOFACACT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(OOFACACT)
/**/
/* Create backup of PF/FACHISA, PF/FACHISH and PF/FACACT */
/**/

BACKUP:      IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)

             CPYF       FROMFILE(&DMLIB/FACHISA) +
                        TOFILE(&DPLIB/OOFACHISA) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(OOFACHISA)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0791 - Error occured in copying +
                          PF/FACHISA to PF/OOFACHISA. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CPYF       FROMFILE(&DMLIB/FACHISH) +
                        TOFILE(&DPLIB/OOFACHISH) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(OOFACHISH)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0791 - Error occured in copying +
                          PF/FACHISH to PF/OOFACHISH. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             CPYF       FROMFILE(&DMLIB/FACACT) +
                        TOFILE(&DPLIB/OOFACACT) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(OOFACACT)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0791 - Error occured in copying +
                          PF/FACACT to PF/OOFACACT. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO

             ENDDO

             CLRPFM     FILE(UTLE0791F1)
             CLRPFM     FILE(UTLE0791F2)
             CLRPFM     FILE(UTLE0791F3)

/**/
/* Copy selected records in HISTSHP/MHISTHP to temporary files */
/**/
             CLOF       OPNID(HISTQRY)
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&SLC) VALUE('*NOT (%SST(LTYP 1 1) *EQ +
                          %VALUES(''X'' ''Y'' ''Z'')) *AND +
                          PRAM *NE 0 *AND AMTP *EQ +
                          %VALUES(''MR'' ''RE'' ''MA'')')

             OPNQRYF    FILE((HISTSHP)) OPTION(*ALL) QRYSLT(&SLC) +
                          KEYFLD((BRCA) (CNUM) (LNRF) +
                          (VDAT) (LCD) (PRAM)) OPNID(HISTQRY)

             CPYFRMQRYF FROMOPNID(HISTQRY) TOFILE(UTLE0791F1) +
                          MBROPT(*ADD)

             CLOF       OPNID(HISTQRY)

             OPNQRYF    FILE((MHISTHP)) OPTION(*ALL) QRYSLT(&SLC) +
                          KEYFLD((BRCA) (CNUM) (LNRF) +
                          (VDAT) (LCD) (PRAM)) OPNID(HISTQRY)

             CPYFRMQRYF FROMOPNID(HISTQRY) TOFILE(UTLE0791F2) +
                          MBROPT(*ADD)

             CLOF       OPNID(HISTQRY)

             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')
/**/
/* Call program that will add/delete OL records in FACHISA */
/**/
             CALL       PGM(UTLE0791) PARM(&MODE)
/**/
/* If successful operation copy new records to FACHISA */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CPYF       FROMFILE(*LIBL/UTLE0791F3) +
                        TOFILE(&DMLIB/FACHISA) MBROPT(*ADD) +
                        FMTOPT(*NONE)
             ENDDO
/**/
/* Error occurred in the program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))

             SNDPGMMSG  MSG('UTCLE0791 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)

             CPYF       FROMFILE(&DPLIB/OOFACHISA) +
                        TOFILE(&DMLIB/FACHISA) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISA +
                          from PF/OOFACHISA. Process terminated.  +
                          Please restore manually PF/FACHISA from +
                          PF/OOFACHISA.') +
                          MSGTYPE(*INFO)
             ENDDO

             CPYF       FROMFILE(&DPLIB/OOFACHISH) +
                        TOFILE(&DMLIB/FACHISH) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISH +
                          from PF/OOFACHISH. Process terminated.  +
                          Please restore manually PF/FACHISH from +
                          PF/OOFACHISH.') +
                          MSGTYPE(*INFO)
             ENDDO

             CPYF       FROMFILE(&DPLIB/OOFACACT) +
                        TOFILE(&DMLIB/FACACT) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACACT +
                          from PF/OOFACACT. Process terminated.  +
                          Please restore manually PF/FACACT from +
                          PF/OOFACACT.') +
                          MSGTYPE(*INFO)
             ENDDO

             ENDDO
             ENDDO


 ABNOR1:     SNDPGMMSG  MSG('Error occured in UTCLE0791 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)

 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys Banking +
                          Systems 2016')
             SNDPGMMSG  MSG('End of UTCLE0791') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
