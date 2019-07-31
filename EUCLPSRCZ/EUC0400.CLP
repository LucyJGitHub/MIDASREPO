/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas EU EMU limit ccy conversions report control')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - EMU Module                                          */
/*                                                                   */
/*       EUC0400 - Limit Currency Conversion Control                 */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC023             Date 29Jan04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CPK014             Date 14Nov01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      139846             Date 28Aug98              */
/*                      CEU010  *CREATE    Date 23Jan98              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CSC023 - MidasPlus additional packaging.  SBMJOB change.    */
/*                OUTQ must always be *JOBD.                         */
/*       CPK014 - Submit jobs with user *JOBD                        */
/*       139846 - Rollback was issued even if EU0400 is not updating */
/*                any database file. Remove Rollback command.        */
/*       CEU010 - Limit Currency Conversion                          */
/*                                                                   */
/*********************************************************************/
             PGM
 
/* Define Paramters to EU0400   */
             DCL        VAR(&LCCY) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MODI) TYPE(*CHAR) LEN(2)
             DCL        VAR(&RFAC) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CONV) TYPE(*CHAR) LEN(1)
 
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Call Prompt Program */
 
             CALL       PGM(EU0400) PARM(&LCCY &MODI &RFAC &CONV)
 
/* If prompt program has no error and Limit Conversion is requested, */
/* Then Call Report Program */
 
             IF         COND(*NOT %SWITCH(XXXXXX11) *AND &CONV *EQ +
                          'Y') THEN(DO)
/************SBMJOB     CMD(CALL PGM(EUC0410) PARM(&LCCY &MODI +                          /*CPK014*/
/************             &RFAC)) JOBD(MBATCH)                                            /*CPK014*/
/************SBMJOB     CMD(CALL PGM(EUC0410) PARM(&LCCY &MODI +                          /*CSC023*/
/************             &RFAC)) JOBD(MBATCH) USER(*JOBD)                     /*CPK014*/ /*CSC023*/
             SBMJOB     CMD(CALL PGM(EUC0410) PARM(&LCCY &MODI +
                          &RFAC)) JOBD(MBATCH) USER(*JOBD) OUTQ(*JOBD)                    /*CSC023*/
             ENDDO
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
/***************ROLLBACK                                         */   /*139846*/
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
 
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            EUC0400 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
