/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Drop off Mvt Status Records')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading                                  */
/*                                                                   */
/*       SEC1008 - Midas SE Drop off Movement Status Records         */
/*       This component will run at End of Month                     */
/*                                                                   */
/*       (c) Finastra International Limited 2003                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/*                      CSE039  *CREATE    Date 14Feb03              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CSE039 - Automatic Settlement of Trades                     */
/*                                                                   */
/*                                                                   */
/*********************************************************************/
             PGM
 
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2003')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
             CALL       PGM(SE4325)
 
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                GOTO       CMDLBL(ABNOR)
             ENDDO
 
/* After drop off records, reorganise the file SEMVTSPD */
/**********  RGZPFM     FILE(SEMVTSPD)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('SEMVTSPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                ROLLBACK
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
 
             ENDPGM
