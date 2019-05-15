/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE Input Cycle Termination')                    */
/********************************************************************/
/*                                                                  */
/*         Midas - Securities Trading Module                        */
/*                                                                  */
/*         SEC05 - INPUT CYCLE TERMINATION                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CCB001             Date 20Apr95              */
/*                      S01401             Date 16Jun93              */
/*                      E28922             DATE 27SEP91             */
/*                      S01117             DATE 07JAN91             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*     CCB001 - Add ABNOR processing.                               */
/*     S01401 - SWIFT Msgs MT5xxs - Generate SWIFT Confirmations :  */
/*              Remove parms from SEC0304 since now mandatory.      */
/*     E28922 - REMOVE EXPECTED PARAMTERS AND HARD CODE PARAMETERS  */
/*              FOR SEC0304                                         */
/*     S01117 - MULTIBRANCHING                                      */
/*                                                                  */
/********************************************************************/
/************PGM                                                     * *S01117*/
/************PGM        PARM(&RSEQ &RLEV &RENT) */             /*S01117 E28922*/
             PGM                                                      /*E28922*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)                 /*S01117*/
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)                 /*S01117*/
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)                 /*S01117*/
/*/COPY WNCPYSRC,SEC05001                                            */
/**/                                                                  /*S01117*/
                                                                      /*CCB001*/
/* Global monitor message */                                          /*CCB001*/
                                                                      /*CCB001*/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))                              /*CCB001*/
                                                                      /*CCB001*/
             SNDPGMMSG  MSG('Input Cycle Termination') TOMSGQ(MRUNQ)
/**/
             CHGJOB     SWS(00000000)
/*/COPY WNCPYSRC,SEC05002                                            */
/**/
/************CALL       PGM(SEC0304)                                 * *S01117*/
/************CALL       PGM(SEC0304) PARM(&RSEQ &RLEV &RENT)     S01117 E28922*/
/************CALL       PGM(SEC0304) PARM('     ' 'B' 'ALL')*****E28922*S01401*/
             CALL       PGM(SEC0304)                                  /*S01401*/
/*/COPY WNCPYSRC,SEH00023                                            */
/**/
             GOTO       CMDLBL(END)                                   /*CCB001*/
                                                                      /*CCB001*/
 ABNOR:                                                               /*CCB001*/
                                                                      /*CCB001*/
             CHGJOB     SWS(XXXXXX11)                                 /*CCB001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB001*/
                                                                      /*CCB001*/
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          SEC05 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)                              /*CCB001*/
             MONMSG     MSGID(CPF0000 MCH0000)                        /*CCB001*/
                                                                      /*CCB001*/
 END:                                                                 /*CCB001*/
                                                                      /*CCB001*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                      /*CCB001*/
             ENDPGM
