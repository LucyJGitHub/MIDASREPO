/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MQ RTEVENTS RGZ Events Reports')                */
/*********************************************************************/
/*                                                                   */
/*      Midas - Midas/Q Module                                       */
/*                                                                   */
/*      MQ545XC - Re-organise Events Reports                         */
/*                                                                   */
/*      Removes unwanted records from the files used in the Events   */
/*      interface programs.  To be run at the same time as a Midas/Q */
/*      RGZALL or RGZWRK.  Called by Command $$RGZEV                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CMQ001             Date 31Oct97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CMQ001 - MidasQ rationalisation.                            */
/*                                                                   */
/*********************************************************************/
/**/
             PGM        PARM(&DTALIB)
/**/
             DCL        VAR(&DTALIB) TYPE(*CHAR) LEN(10)
 
             DCL        VAR(&FIL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(7)
             DCL        VAR(&DTA) TYPE(*CHAR) LEN(75)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ERROR))
 
/**/
/** Allocate O#XA02, RTEVENTS to ensure access to Midas/Q **/
             ALCOBJ     OBJ((&DTALIB/O#XA02 *DTAARA *SHRUPD))
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/** Send Message - Cannot Allocate Midas/Q **/
             SNDPGMMSG  MSGID(R5E0034) MSGF(MQUSRMSG) MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPF0001) MSGF(QCPFMSG) MSGDTA($$RGZEV) +
                          MSGTYPE(*ESCAPE)
             ENDDO
             ALCOBJ     OBJ((&DTALIB/RTEVENTS *DTAARA *EXCL))
             MONMSG     MSGID(CPF1002) EXEC(DO)
/**/
/** Send Message - Cannot Allocate RTEVENTS **/
             SNDPGMMSG  MSGID(R5E0035) MSGF(MQUSRMSG) MSGTYPE(*DIAG)
             SNDPGMMSG  MSGID(CPF0001) MSGF(QCPFMSG) MSGDTA($$RGZEV) +
                          MSGTYPE(*ESCAPE)
             ENDDO
/**/
/** Override to the data library **/
             OVRDBF     FILE(MQ541XPF) TOFILE(&DTALIB/MQ541XPF) +
                          SHARE(*YES)
             OVRDBF     FILE(MQ542XPF) TOFILE(&DTALIB/MQ542XPF) +
                          SHARE(*YES)
             OVRDBF     FILE(MQ543XPF) TOFILE(&DTALIB/MQ543XPF) +
                          SHARE(*YES)
             OVRDBF     FILE(MQ544XPF) TOFILE(&DTALIB/MQ544XPF) +
                          SHARE(*YES)
/**/
/** Get a Member List of MQ541XFP **/
             DSPFD      FILE(MQ541XPF) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/QAFDMBRL)
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/QAFDMBRL) +
                          SHARE(*YES)
/**/
/** Call MQ545X to remove records used by deleted reports **/
             CALL       PGM(MQ545X)
/**/
/** RGZPFM to remove deleted records **/
/**********  RGZPFM     FILE(MQ542XPF)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MQ542XPF' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MQ543XPF)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MQ543XPF' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**********  RGZPFM     FILE(MQ544XPF)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MQ544XPF' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
                                                                                          /*228542*/
/**/
/** Delete the Member List **/
             DLTF       FILE(QTEMP/QAFDMBRL)
/**/
/** Deallocate the locks **/
             DLCOBJ     OBJ((&DTALIB/RTEVENTS *DTAARA *EXCL))
             DLCOBJ     OBJ((&DTALIB/O#XA02 *DTAARA *SHRUPD))
 
             GOTO       CMDLBL(END)
/**/
/** Global Error Processing **/
 ERROR:      RCVMSG     MSGTYPE(*EXCP) MSGDTA(&DTA) MSGID(&ID) +
                          MSGF(&FIL) SNDMSGFLIB(&FILLIB)
 
             SNDPGMMSG  MSGID(&ID) MSGF(&FILLIB/&FIL) MSGDTA(&DTA) +
                          MSGTYPE(*DIAG)
 
             SNDPGMMSG  MSGID(CPF0001) MSGF(QCPFMSG) MSGDTA($$RGZEV) +
                          MSGTYPE(*ESCAPE)
 
END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
