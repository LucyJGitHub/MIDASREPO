/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Reorganise DEALSD* file members 2')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0610 - (Program Name)                                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      202865             Date 15Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      197643  *CREATE    Date 25May01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       202865 - File reorganisation should not fail if the file    */
/*                is empty, MONMSG was added.                        */
/*       197643 - New program created to avoid DLC0609 having to     */
/*                process the same file twice.                       */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,DLC0610INT                                          */
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&MBRCHK) TYPE(*CHAR) LEN(10)                                  /*228542*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCLF       FILE(QAFDMBRL)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*/COPY WNCPYSRC,DLC0610MPS                                          */
 
             DSPFD      FILE(DLGXSTPD) TYPE(*MBRLIST) +
                          OUTPUT(*OUTFILE) OUTFILE(QTEMP/RGZDEALS)
 
             OVRDBF     FILE(QAFDMBRL) TOFILE(QTEMP/RGZDEALS)
 
             CHGVAR     VAR(&MLNDTR) VALUE(&MLNDTR * 9)
 
             RCVF
 
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&MBRCHK) VALUE(&MLNAME)                                       /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&MBRCHK &CHKPOSN 1))                        /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&MBRCHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/**********  IF         COND(&MLNDTR *GE &MLNRCD) THEN(RGZPFM +                           /*202865*/
/**********               FILE(&MLFILE) MBR(&MLNAME))                                     /*202865*/
             IF         COND(&MLNDTR *GE &MLNRCD) THEN(DO)                                /*202865*/
/**********  RGZPFM     FILE(&MLFILE) MBR(&MLNAME)                             /*202865*/ /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981) EXEC(GOTO CMDLBL(END))          /*202865*/ /*228542*/
             CALL       PGM(SCC000060) PARM(&MLFILE &MBRCHK)                              /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
             ENDDO                                                                        /*202865*/
 
/*/COPY WNCPYSRC,DLC0610MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,DLC0610ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          DLC0610 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,DLC0610END                                          */
 
             ENDPGM
