/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Liquidity Cashflow & Maturity Data Repts')  */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2090 - Produce LR Cashflow and Maturity Data Reports       */
/*                                                                   */
/*     (c) Misys International Banking Systems Ltd. 1999             */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*     Last Amend No. LLN012   *CREATE   Date  22APR99               */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&RUNMOD) TYPE(*CHAR) LEN(7) /* Run mode          */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
/*  If switchable feature LLN007 not on then terminate  */
             IF         COND(&LRTCD *EQ '*NRF') THEN(RETURN)
 
 
/*  Check if switchable feature 'LLN012 - LR Reporting' is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')
/*  If switchable feature LLN012 not on then terminate  */
             IF         COND(&LRTCD *EQ '*NRF') THEN(RETURN)
 
 
/*  Produce LR Cashflow and Maturity Data reports  */
             CALL       PGM(BY2090) PARM(&LRTCD)
             IF         COND(&LRTCD *NE ' ')  THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('Error occurred on call +
                          to program BY2090')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/*  End program normally  */
             RETURN
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2090 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
