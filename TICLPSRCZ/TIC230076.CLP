/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('CL program to call TI230076')                         */
/*********************************************************************/
/*                                                                   */
/*       Midas - Trade Innovation Module                             */
/*                                                                   */
/*       TIC230076 - CL program to call TI230076                     */
/*                                                                   */
/*       (c) Copyright Finastra International Limited 2005           */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. BUG6597  *CREATE   Date 10May05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       BUG6597 - Duplicate TI number and suffix for branch         */
/*                 customer.  Applied fix 230076.                    */
/*                                                                   */
/*********************************************************************/
 
             PGM        PARM(&MODE)
 
             DCL        VAR(&MODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(C) +
                          Copyright Finastra International Limited +
                          2005')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('Start of TI230076 -  To update +
                          PF/ACCNTAB') TOMSGQ(MRUNQ +
                          MOPERQ)
 
             IF         COND((&MODE *NE 'U') *AND (&MODE *NE 'u') +
                          *AND (&MODE *NE 'A') *AND (&MODE *NE +
                          'a')) THEN(DO)
             SNDPGMMSG  MSG('Invalid Parameter on Call') +
                          TOMSGQ(MOPERQ MRUNQ)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Invalid +
                          parameter passed.') +
                          MSGTYPE(*ESCAPE)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
/* Clear C23007PD */
             CLRPFM     FILE(TI23007PD)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in clearing +
                          PF/C23007PD.  Process Terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
/* Create backup in xxDMLIB if in update mode */
 
             IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
 
/* Get system Prefix */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR VAR(&DMLIB) VALUE(&PREF *TCAT 'DMLIB')
             CHGVAR VAR(&DPLIB) VALUE(&PREF *TCAT 'DPLIB')
 
/* Backing up files */
 
             CPYF       FROMFILE(&DMLIB/ACCNTAB) +
                          TOFILE(&DPLIB/ACCNTABX) CRTFILE(*YES)
 
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(DO)
             SNDUSRMSG  MSG('Error occurred in copying PF/ACCNTAB to +
                          PF/ACCNTABX.  Process Terminated.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
 
             ENDDO
 
/* Call to Program Patch Utility */
 
             CHGJOB     SWS(00000000)
             CALL       PGM(TI230076) PARM(&MODE)
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(DO)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                        GOTO CMDLBL(ABNOR)
             ENDDO
             ELSE  CMD(GOTO CMDLBL(END))
 
/* If error encountered restore files */
 
 ABNOR:      IF         COND((&MODE *EQ 'U') *OR (&MODE *EQ 'u')) +
                          THEN(DO)
             CPYF       FROMFILE(&DPLIB/ACCNTABX) +
                          TOFILE(&DMLIB/ACCNTAB) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(DO)
             GOTO       CMDLBL(ABNOR1)
             ENDDO
             MONMSG     MSGID(CPF2817 CPF3130 CPF2909) EXEC(GOTO +
                          CMDLBL(ABNOR2))
             ENDDO
 
             GOTO       CMDLBL(ABNOR1)
 
 ABNOR2:     SNDUSRMSG  MSG('Error occurred in restoring files.  +
                          Please restore the files manually:  +
                          PF/ACCNTABX to PF/ACCNTAB') MSGTYPE(*INFO)
 
 ABNOR1:     SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          TIC230076 ended abnormally - see job +
                          log') TOMSGQ(MOPERQ)
             SNDPGMMSG  MSG('LE Utility Patch TIC230076 ended +
                          abnormally') TOMSGQ(MRUNQ)
             SNDUSRMSG  MSG('Program TIC230076 ended abnormally.') +
                          MSGTYPE(*INFO)
             GOTO       CMDLBL(ENDPGM)
 /**/
 /** End program **/
 /**/
 
 END:        DLTF       FILE(&DPLIB/ACCNTABX)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 /**/
             SNDPGMMSG  MSG('LE Utility Patch TIC230076 succesfully +
                          ended') TOMSGQ(MRUNQ)
             SNDUSRMSG  MSG('Program TIC230076 succefully ended.') +
                          MSGTYPE(*INFO)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Copyright Finastra +
                          International Banking Systems 2005')
 ENDPGM:     ENDPGM
