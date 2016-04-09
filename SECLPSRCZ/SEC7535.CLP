/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE Corporate Action Default Charges Report')    */
/*********************************************************************/
/*                                                                   */
/*       Midas Securities Trading Module                             */
/*                                                                   */
/*       SEC7535 - SE Corporate Action Default Charges Maintenance   */
/*                 Report                                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CSE007  *CREATE    Date 01Dec97              */
/*       Prev Amend No.                    Date                      */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CSE007 - Corporate Actions                                  */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&MODE &RSEQ &RLEV &RENT)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MODE)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RSEQ)    TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)    TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
 
/* Global monitor message. */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(00000000)
 
/* Call RPG/SE7535: Midas SE Corporate Action Default Charges Report. */
 
             CALL       PGM(SE7535) PARM(&MODE &RSEQ)
 
/* If no error end processing. */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(GOTO +
                          CMDLBL(END))
 
/* Abnormal termination. */
 
ABNOR:
 
/* Database error processing. */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                      RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                      SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                                 TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                      MONMSG     MSGID(CPF0000)
                      GOTO       CMDLBL(END)
             ENDDO
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            SEC7535 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
