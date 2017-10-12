/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Loan recalculation of principal amount & IH head')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       UTCLE0522 - CL program to call datapatch PGM/UTLE0522       */
/*                                                                   */
/*       (C) Misys Banking Systems Ltd. 2016                         */
/*                                                                   */
/*       Last Amend No. AR545781 *CREATE   Date 24Aug16              */
/*       Prev Amend No. Xnnnnnnn           Date mmdddyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       AR545781 - Missing/Multiple IH on history file.             */
/*                  Provide datapatch utility to correct principal   */
/*                  and interest values on history file.             */
/*                - Applied utility to MD-37545                      */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE)
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(8)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys Banking Systems Ltd. 2016')
/**/
             DCL VAR(&RUNCHG) TYPE(*DEC) LEN(5 0)
             DCL VAR(&RUNDAT) TYPE(*CHAR) LEN(5)
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGVAR     VAR(&RUNDAT) VALUE(&RUNCHG)
/**/
             SNDPGMMSG  MSG('UTCLE0522 - To initialise CPAM +
                          and INTR in PF/HISTSHM.') +
                          TOMSGQ(MRUNQ MOPERQ)
/**/
/* Get system prefix */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
/**/
             CHGVAR     VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
/**/
/* Check if parameter passed is 'U', 'u', 'A' or 'a' or if invalid */
/**/
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE 'a')) +
                          THEN(DO)
/**/
             SNDPGMMSG  MSG('Invalid parameter passed to UTLE0522') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter. It should either be ''U'' or +
                          ''u'' for Update and ''A'' or ''a'' for +
                          Audit.') MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/* Create backup of history files */
/**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
/**/
             DLTF       FILE(&DPLIB/BHISTSHM)
             MONMSG     MSGID(CPF0000)
 
             CPYF       FROMFILE(&DMLIB/HISTSHM) +
                          TOFILE(&DPLIB/BHISTSHM) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/HISTSHM to +
                          PF/BHISTSHM. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             DLTF       FILE(&DPLIB/BHISTSHN)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&DMLIB/HISTSHN) +
                          TOFILE(&DPLIB/BHISTSHN) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/HISTSHN to +
                          PF/BHISTSHN. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             DLTF       FILE(&DPLIB/BHISTSZX)
             MONMSG     MSGID(CPF0000)
             CPYF       FROMFILE(&DMLIB/HISTSZX) +
                          TOFILE(&DPLIB/BHISTSZX) MBROPT(*REPLACE) +
                          CRTFILE(*YES) FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/HISTSZX to +
                          PF/BHISTSZX. Process terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             ENDDO
/**/
/* Call PGM/UTLE0522 */
/**/
             CHGJOB     SWS(XXXXXX00)
             CALL       PGM(UTLE0522) PARM(&MODE)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        GOTO CMDLBL(ABNOR)
             ENDDO
             ELSE  CMD(GOTO CMDLBL(NORMAL))
 
 ABNOR:
 /**/
 /* Restore backup PF/BHISTSHM to PF/HISTSHM */
 /**/
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
 
             CPYF       FROMFILE(&DPLIB/BHISTSHM) +
                          TOFILE(&DMLIB/HISTSHM) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/HISTSHM +
                          from PF/BHISTSHM. Process terminated.   +
                          Please restore manually.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/BHISTSHN) +
                          TOFILE(&DMLIB/HISTSHN) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/HISTSHN +
                          from PF/BHISTSHN. Process terminated.   +
                          Please restore manually.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             CPYF       FROMFILE(&DPLIB/BHISTSZX) +
                          TOFILE(&DMLIB/HISTSZX) MBROPT(*REPLACE) +
                          FMTOPT(*MAP *DROP)
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in restoring PF/HISTSZX +
                          from PF/BHISTSZX. Process terminated.   +
                          Please restore manually.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(END)
             ENDDO
 
             ENDDO
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                         UTCLE0522 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
 /**/
 /* End program */
 /**/
 NORMAL:     IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                        THEN(DO)
 
             RGZPFM     FILE(HISTSHN)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
             DLTF       FILE(&DPLIB/BHISTSHM)
             MONMSG     MSGID(CPF3130 CPF3137 CPF3142) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in clearing PF/BHISTSHM.') +
                            MSGTYPE(*INFO)
             ENDDO
 
             DLTF       FILE(&DPLIB/BHISTSHN)
             MONMSG     MSGID(CPF3130 CPF3137 CPF3142) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in clearing PF/BHISTSHN.') +
                            MSGTYPE(*INFO)
             ENDDO
 
             DLTF       FILE(&DPLIB/BHISTSZX)
             MONMSG     MSGID(CPF3130 CPF3137 CPF3142) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in clearing PF/BHISTSZX.') +
                            MSGTYPE(*INFO)
             ENDDO
 
             ENDDO
 /**/
 /* End Message */
 /**/
              SNDPGMMSG  MSG('UTCLE0522 run completed  normally.') +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)
              GOTO       CMDLBL(END)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys Banking +
                          Systems Ltd. 2016')
             ENDPGM
