/*******************************************************************/
/*STD    CLPBASE                                                   */
/*EXI *  TEXT('Midas DL Zero Effective Interest Rate Report')        */
/*******************************************************************/
/**                                                                */
/**      Midas - Dealing Module                                    */
/**                                                                */
/**      DLC0200 - Zero Effective Interest Rate Report             */
/**                                                                */
/**      Function: This program will call DL0200: Deals with       */
/**                Effective Interest Rate equal to Zero.          */
/**                                                                */
/**      (c) Misys International Banking Systems Ltd. 2005         */
/**                                                                */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/**      Last Amend No. CDL033  *CREATE    Date 23Feb05            */
/**                                                                */
/**----------------------------------------------------------------*/
/**                                                                */
/**      CDL033 - Floating Rate CDs Issued                         */
/**                                                                */
/*******************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2005')
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
/**/
/** Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             SNDPGMMSG  MSG('DLC0200 - Zero Effective Interest Rate +
                          Report') TOMSGQ(MRUNQ)
 
             CHGJOB     SWS(00000000)
/**/
/** Create data area LDA */
/**/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
             MONMSG     MSGID(CPF1023)
/**/
/** Call program CB0160 to get value of restart indicator. */
/**/
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
             CHGVAR     VAR(&STAT) VALUE('Y')
/**/
/** Call CB0150 to update restart indicator */
/**/
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
/**/
/** Call Zero Effective Interest Rate Report Program */
/**/
             CALL       PGM(DL0200)
/**/
/** If no error occured in the program */
/**/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
/**/
/** Call CB0150 to update restart indicator */
/**/
             CHGVAR     VAR(&STAT) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
/**/
/** Database error processing */
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                          TOMSGQ(MOPERQ MRUNQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
 
             GOTO       CMDLBL(END)
/**/
/** Abnormal termination - batch job */
/**/
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Zero Effective Interest Rate Report +
                          Program ended abnormally') TOMSGQ(MOPERQ +
                          MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) Misys International +
                          Banking Systems Ltd. 2005')
 
             ENDPGM
