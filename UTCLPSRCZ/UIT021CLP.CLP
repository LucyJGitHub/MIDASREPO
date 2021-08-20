/********************************************************************/
/*STD    CLPBASE                                                    */
/*EXI    TEXT('LUC139 file set up utility')                         */
/********************************************************************/
/*                                                                   */
/*       Midas SD - Standing Data Module                             */
/*                                                                   */
/*       UIT021CLP - Midas UT Italian returns utility                */
/*                                                                   */
/*       (c) Finastra International Systems Ltd. 2021                */
/*                                                                   */
/*       Last Amend No. LUC139   *Create   Date 20Jan21              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LUC139 - UCI Italian returns Upgrade to FM2.1               */
/*                                                                   */
/********************************************************************/
/**/
             PGM
             DCL        VAR(&@ERDLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&@XXLIB) TYPE(*CHAR) LEN(2)
             DCLF       FILE(CADWNDPD)
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))

/* Reset External Switches */
             CHGJOB     SWS(00000000)

/* Get the library prefix */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&@XXLIB)
             CHGVAR     VAR(&@ERDLIB) VALUE(&@XXLIB *CAT 'ERDLIB')
             CHGVAR     VAR(&@DMLIB) VALUE(&@XXLIB *CAT 'DMLIB')

 /* Copy each of the physical files */
PHYSICALS:             RCVF
                       MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(ENDLOOP))
 RETRY:      CPYF       FROMFILE(&VTFNAM) TOFILE(&@ERDLIB/&VTFNAM) +
                          CRTFILE(*YES)
                       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                                FILE(&@ERDLIB/&VTFNAM))

                       MONMSG     MSGID(CPF2952) EXEC(DO)
                       DLYJOB     DLY(100)
                       GOTO       CMDLBL(RETRY)
                       ENDDO

                       GOTO       CMDLBL(PHYSICALS)


ENDLOOP:     CRTDUPOBJ  OBJ(IRSTAT) FROMLIB(&@DMLIB) +
                          OBJTYPE(*DTAARA) TOLIB(&@ERDLIB)

             CRTDUPOBJ  OBJ(ERCTLD) FROMLIB(&@DMLIB) +
                          OBJTYPE(*DTAARA) TOLIB(&@ERDLIB)

             CRTDUPOBJ  OBJ(RUNDAT) FROMLIB(&@DMLIB) +
                          OBJTYPE(*DTAARA) TOLIB(&@ERDLIB)

             CRTDUPOBJ  OBJ(SDSTAT) FROMLIB(&@DMLIB) +
                          OBJTYPE(*DTAARA) TOLIB(&@ERDLIB)

             RETURN

 ERROR:      CHGJOB     SWS(XXXXXX11)
             DMPCLPGM
             MONMSG     MSGID(CPF0000)
             ENDPGM
