/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Rgz files to stop EOC locking')              */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC0101  -  RGZ FILES TO STOP EOC LOCKING                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      E59489             Date 29Sep93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   228542 - RGZPFM has changed at R5V3                             */
/*   E59489 - Pgm created for this error fix to stop EOC locking,    */
/*            by reorganizing MEMOSME, PRONOME & FFACMVD.            */
/*            Pgm. is called by FFC01.                               */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCLF       FILE(MKCTLD)
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&MRKTCHK) TYPE(*CHAR) LEN(10)                                 /*228542*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             CHGJOB     SWS(XXXXXX00)
/**/
/**/
/*    Read file                                                      */
/**/
LOOP:     RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO END)
                                                                                          /*228542*/
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&MRKTCHK) VALUE(&MRKT)                                        /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&MRKTCHK &CHKPOSN 1))                       /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&MRKTCHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/**/
             IF         COND(&RECI *EQ 'D') THEN(DO)
/**/
/********RGZPFM     FILE(MEMOSME) MBR(&MRKT)                                              /*228542*/
/********MONMSG     MSGID(CPF2995 CPF2981)                                                /*228542*/
             CALL       PGM(SCC000060) PARM('MEMOSME' &MRKTCHK)                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
/********RGZPFM     FILE(PRONOME) MBR(&MRKT)                                              /*228542*/
/********MONMSG     MSGID(CPF2995 CPF2981)                                                /*228542*/
             CALL       PGM(SCC000060) PARM('PRONOME' &MRKTCHK)                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                          /*228542*/
/********RGZPFM     FILE(FFACMVD) MBR(&MRKT)                                              /*228542*/
/********MONMSG     MSGID(CPF2995 CPF2981)                                                /*228542*/
             CALL       PGM(SCC000060) PARM('FFACMVD' &MRKTCHK)                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/
          ENDDO
          GOTO LOOP
/**/
 ABNOR: CHGJOB     SWS(XXXXXX1X)
/**/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:    ENDPGM
