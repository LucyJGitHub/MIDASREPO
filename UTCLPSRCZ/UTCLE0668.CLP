/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Calling Program RZB-MOS AR1036835')                   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0668 - To add missing PDCL repayments in PF/FACHISA    */
/*                                                                   */
/*       (c) Finastra International Limited 2012                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR1036834 *CREATE  Date 23Oct12              */
/*                      XXXXXXXXX          Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR1036834 - Calls UTLE0668 datapatch program.               */
/*                   (Child: AR1036835)                              */
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
                          Finastra International Limited 2012')
/**/
/* Global monitor message */
/**/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR1))
/**/
/* Start of program */
/**/
             SNDPGMMSG  MSG('UTCLE0668 - Utility to update Facility +
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
             SNDPGMMSG  MSG('UTCLE0668 - Invalid parameter passed') +
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
/*  Check if SSFACHISA, SSFACHISH and SSFACACT already exist */
/**/
             CHKOBJ     OBJ(&DPLIB/SSFACHISA) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK1))
             DLTF       FILE(SSFACHISA)
 
CHECK1:      CHKOBJ     OBJ(&DPLIB/SSFACHISH) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(CHECK2))
             DLTF       FILE(SSFACHISH)
 
CHECK2:      CHKOBJ     OBJ(&DPLIB/SSFACACT) OBJTYPE(*FILE)
             MONMSG     MSGID(CPF9801) EXEC(GOTO CMDLBL(BACKUP))
             DLTF       FILE(SSFACACT)
/**/
/* Create backup of PF/FACHISA, PF/FACHISH and PF/FACACT */
/**/
 
BACKUP:      IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
 
             CPYF       FROMFILE(&DMLIB/FACHISA) +
                        TOFILE(&DPLIB/SSFACHISA) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(SSFACHISA)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0668 - Error occured in copying +
                          PF/FACHISA to PF/SSFACHISA. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/FACHISH) +
                        TOFILE(&DPLIB/SSFACHISH) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(SSFACHISH)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0668 - Error occured in copying +
                          PF/FACHISH to PF/SSFACHISH. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(&DMLIB/FACACT) +
                        TOFILE(&DPLIB/SSFACACT) MBROPT(*REPLACE) +
                        CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             CLRPFM     FILE(SSFACACT)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('UTCLE0668 - Error occured in copying +
                          PF/FACACT to PF/SSFACACT. Process +
                          terminated.') MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             ENDDO
 
             CLRPFM     FILE(UTLE0668F1)
             CLRPFM     FILE(UTLE0668F2)
             CLRPFM     FILE(UTLE0668F3)
 
/**/
/* Copy selected records in HISTSHP/MHISTHP to temporary files */
/**/
             CLOF       OPNID(HISTQRY)
             MONMSG     MSGID(CPF0000)
 
             CHGVAR     VAR(&SLC) VALUE('%SST(LTYP 1 1) *EQ +
                          %VALUES(''X'' ''Y'' ''Z'') *AND +
                          PRAM *NE 0 *AND AMTP *EQ +
                          %VALUES(''MR'' ''RE'' ''MA'')')
 
             OPNQRYF    FILE((HISTSHP)) OPTION(*ALL) QRYSLT(&SLC) +
                          OPNID(HISTQRY)
 
             CPYFRMQRYF FROMOPNID(HISTQRY) TOFILE(UTLE0668F1) +
                          MBROPT(*ADD)
 
             CLOF       OPNID(HISTQRY)
 
             OPNQRYF    FILE((MHISTHP)) OPTION(*ALL) QRYSLT(&SLC) +
                          OPNID(HISTQRY)
 
             CPYFRMQRYF FROMOPNID(HISTQRY) TOFILE(UTLE0668F2) +
                          MBROPT(*ADD)
 
             CLOF       OPNID(HISTQRY)
 
             CHGJOB     SWS(XXXXXX00)
             CHGVAR     VAR(&RUNP) VALUE('YES')
/**/
/* Call program that will add missing PDCL records in FACHISA */
/**/
             CALL       PGM(UTLE0668) PARM(&MODE)
/**/
/* If successful operation copy new records to FACHISA */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             CPYF       FROMFILE(*LIBL/UTLE0668F3) +
                        TOFILE(&DMLIB/FACHISA) MBROPT(*ADD) +
                        FMTOPT(*NONE)
             ENDDO
/**/
/* Error occurred in the program */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('UTCLE0668 completed normally.') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
             GOTO       CMDLBL(END)
/**/
/* Abnormal Termination of the program or */
/* Restore backup if an error occurred in update mode */
/**/
ABNOR:       IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             IF         COND(&RUNP *EQ 'YES') THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/SSFACHISA) +
                        TOFILE(&DMLIB/FACHISA) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISA +
                          from PF/SSFACHISA. Process terminated.  +
                          Please restore manually PF/FACHISA from +
                          PF/SSFACHISA.') +
                          MSGTYPE(*INFO)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/SSFACHISH) +
                        TOFILE(&DMLIB/FACHISH) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACHISH +
                          from PF/SSFACHISH. Process terminated.  +
                          Please restore manually PF/FACHISH from +
                          PF/SSFACHISH.') +
                          MSGTYPE(*INFO)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/SSFACACT) +
                        TOFILE(&DMLIB/FACACT) MBROPT(*REPLACE) +
                        FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/FACACT +
                          from PF/SSFACACT. Process terminated.  +
                          Please restore manually PF/FACACT from +
                          PF/SSFACACT.') +
                          MSGTYPE(*INFO)
             ENDDO
 
             ENDDO
             ENDDO
 
 
 ABNOR1:     SNDPGMMSG  MSG('Error occured in UTCLE0668 program') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International +
                          Systems 2012')
             SNDPGMMSG  MSG('End of UTCLE0668') TOMSGQ(MRUNQ MOPERQ)
             ENDPGM
