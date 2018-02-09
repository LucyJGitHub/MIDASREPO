/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU EMU invalid nostro shortname rept control')  */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       EUC0300 - Midas EMU Invalid Nostro Shortname Report Control */
/*                                                                   */
/*       Calls :   EU0300 - EMU Invalid Nostro Shortname Report Pgm  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CEU007  *CREATE    Date 14Dec97              */
/*                      XNNNNN             Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CEU007 - EMU Holiday Processing.                            */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLEV &RENT)
 
/*/COPY WNCPYSRC,EUC0300INT                                          */
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
             SNDPGMMSG  MSG('EUC0300 - EMU Invalid Nostro Shortname +
                          Report') TOMSGQ(MRUNQ)
 
/*/COPY WNCPYSRC,EUC0300MPS                                          */
 
             CALL       PGM(EU0300) PARM(&RSEQ)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,EUC0300MPE                                          */
 
             GOTO       CMDLBL(END)
 
 ABNOR:
/*/COPY WNCPYSRC,EUC0300ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            EUC0300 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,EUC0300END                                          */
 
             ENDPGM
