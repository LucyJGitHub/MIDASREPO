/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EMU Base Currency Conversion update control')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - E.M.U. Module                                       */
/*                                                                   */
/*       EUC0510 - EMU Base Currency for Dealing Conversion          */
/*                 control program                                   */
/*                                                                   */
/*       Function: This program runs in I/C Initiation if EMU        */
/*                 switchable feature CEU009 is present in the       */
/*                 system. It runs the Base Currency for Dealing     */
/*                 conversion program if a conversion has been       */
/*                 requested for that COB                            */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last Amend No. CEU009  *CREATE    Date 13Feb98              */
/*       Prev Amend No. Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       CEU009 - EMU Base Currency for Dealing Conversion           */
/*                                                                   */
/*********************************************************************/
             PGM
 
/*/COPY WNCPYSRC,EUC0510INT                                          */
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCLF       FILE(EUDBCEPD)
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Read conversion details to see if conversion required today       */
             RCVF
 
/* If no record found then conversion details not set up so          */
/* inform user and exit immediately                                  */
             MONMSG     MSGID(CPF0864) EXEC(DO)
             SNDPGMMSG  MSGID(EUM0510) MSGF(EUMSGF) TOPGMQ(*SAME) +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
 
/* If conversion date > 0 then conversion has already been run so    */
/* inform user and exit immediately                                  */
             IF         COND(&CDAT *GT 0) THEN(DO)
             SNDPGMMSG  MSGID(EUM0502) MSGF(EUMSGF) TOPGMQ(*SAME) +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
 
/* If Run Conversion flag not 'Y', conversion has not been requested */
/* so inform user and exit immediately                               */
             IF         COND(&RCON *NE 'Y') THEN(DO)
             SNDPGMMSG  MSGID(EUM0511) MSGF(EUMSGF) TOPGMQ(*SAME) +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
 
/* Block FXDEAULL as may be large file                               */
             OVRDBF     FILE(FXDEAULL) SEQONLY(*YES)
 
/* Call Dealing Base Currency conversion                             */
/* Program is run under commitment control with commit/rollback      */
/* handled by the RPG                                                */
             CALL       PGM(EU0510)
 
/* If update completed successfully send completion message and end  */
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
             SNDPGMMSG  MSGID(EUM0512) MSGF(EUMSGF) TOPGMQ(*SAME) +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
             ELSE       CMD(DO)
 
/* Inform user of unsuccessful conversion                           */
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*SAME) TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               SNDPGMMSG  MSGID(EUM0513) MSGF(EUMSGF) TOPGMQ(*SAME) +
                          TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
               GOTO       CMDLBL(END)
             ENDDO
 
/*/COPY WNCPYSRC,EUC0510MPS                                          */
 
 ABNOR:
/*/COPY WNCPYSRC,EUC0510ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          EUC0510 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
/*/COPY WNCPYSRC,EUC0510END                                          */
 
             ENDPGM
