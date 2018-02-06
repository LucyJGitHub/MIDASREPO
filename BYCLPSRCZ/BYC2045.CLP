/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Futures & Options Extract/Validation')      */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2045 - Futures & Options Extract/Validation                */
/*                                                                   */
/*     (c) Finastra International Limited 1999                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. 168557             Date 04Oct99              */
/*                      LLN012             Date 23Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     168557 - Member BYEXFFM should be cleared instead of member   */
/*              BYEXFRM prior to call of BY2045.                     */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&LMODE &LRSEQ &LRLVL &LRENT)
 
             DCL        VAR(&LMODE) TYPE(*CHAR) LEN(7)      /* Run mode */
             DCL        VAR(&LRSEQ) TYPE(*CHAR) LEN(5)      /* Report seq */
             DCL        VAR(&LRLVL) TYPE(*CHAR) LEN(1)      /* Report level */
             DCL        VAR(&LRENT) TYPE(*CHAR) LEN(3)      /* Report entity */
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LLN012) TYPE(*CHAR) LEN(1)     /* LLN012 flag */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
 
/*  Check if switchable feature LLN007 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN007' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('The Bank of England +
                          module is not available')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
             IF         COND((&LRTCD *NE ' ') *AND (&LRTCD *NE '*NRF')) +
                        THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('Error occured in BYC2045 +
                          on call to program AOSARDR0')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/*  Check if switchable feature LLN012 - BoE Liquidity is on  */                        /* LLN012 */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')                                                          /* LLN012 */
             IF         COND(&LRTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&LLN012) VALUE('Y'))                                      /* LLN012 */
 
 
/* Check for valid conditions for program to continue */
             IF         COND(&LPHAS *EQ 'C' *AND &LMODE *EQ +
                        'EXTRACT') THEN(DO)
               IF       COND(&LLN012 *NE 'Y') THEN(RETURN)
             ENDDO
 
/* Clear extract file member if EXTRACT mode */
               IF        COND(&LMODE *EQ 'EXTRACT') THEN(DO)
         /*     CLRPFM   FILE(BYEXDTPP) MBR(BYEXFRM)   */                                 /*168557*/
                CLRPFM   FILE(BYEXDTPP) MBR(BYEXFFM)                                      /*168557*/
               ENDDO
 
/*  Call Deals Extract/Validation program   */
               CHGVAR    VAR(&LRTCD) VALUE(' ')                                           /*LLN012*/
               OVRDBF    FILE(BYEXDTPP) TOFILE(BYEXDTPP) MBR(BYEXFFM)
               CALL      PGM(BY2045) PARM(&LMODE &LRSEQ &LRTCD)
               DLTOVR    FILE(BYEXDTPP)
               IF        COND(&LRTCD *NE ' ') THEN(DO)
                CHGVAR   VAR(&LMSG1) VALUE('Error occured in BYC2045 +
                         on call to program BY2045')
                GOTO     CMDLBL(ABNORM)
               ENDDO
 
/*  End program normally  */
             RCLRSC
             RETURN
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2045 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
