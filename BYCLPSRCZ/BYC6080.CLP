/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Create Profit and Loss Download File')      */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC6080 - Create Profit & Loss Download                       */
/*                                                                   */
/*     (c) Finastra International Limited 2003                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN012             Date 23Apr99              */
/*                      LLN021 *C *CREATE  Date : 20nOV0             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     Amendment Details:                                            */
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
/*     LLN021 - Create Profit and Loss Download File                 */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas Phase  */
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG3) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&LLN021) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
 
/*  Check if switchable feature LLN021 - Bank of England PL Report */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN021' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('The Bank of England +
                          PL Report is not available')
               GOTO       CMDLBL(SNDMSG)
             ENDDO
             IF         COND((&LRTCD *NE ' ') *AND (&LRTCD *NE '*NRF')) +
                        THEN(DO)
               CHGVAR     VAR(&LMSG1) VALUE('Error occured in BYC6080 +
                          on call to program AOSARDR0')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
 
/* Retrieve midas phase */                                                                /*LLN012*/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)                                /*LLN012*/
                                                                                          /*LLN012*/
/* If close of businesss check if extrcat required   */                                   /*LLN012*/
             IF         COND(&LPHAS *EQ 'C') THEN(DO)                                     /*LLN012*/
                                                                                          /*LLN012*/
/* Retrieve three flags: 1. End of Month Indicator      */                                /*LLN012*/
/*                       2. Daily BT Extract Indicator  */                                /*LLN012*/
/*                       2. Extract On-Request Flag     */                                /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LFLAG1)                           /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (55 1)) RTNVAR(&LFLAG2)                           /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (56 1)) RTNVAR(&LFLAG3)                           /*LLN012*/
                 IF       COND(&LLN021 *NE 'Y' *AND &LFLAG1 *NE 'Y' +
                          *AND &LFLAG2 *NE 'Y' *AND &LFLAG3 *NE 'Y') +
                          THEN(RETURN)                                                    /*LLN012*/
                                                                                          /*LLN012*/
             ENDDO                                                                        /*LLN012*/
 
/* Clear PL Download file  */
                CLRPFM   FILE(BYEXPLPP)
 
/*  Call BY6080 to create extract file for download   */
               CHGVAR    VAR(&LRTCD) VALUE(' ')
               CALL      PGM(BY6080) PARM(&LRTCD)
               IF        COND(&LRTCD *NE ' ') THEN(DO)
                CHGVAR   VAR(&LMSG1) VALUE('Error occured in BYC6080 +
                         on call to program BY6080')
                GOTO     CMDLBL(ABNORM)
               ENDDO
 
 
 
/*  End program normally  */
END:         RCLRSC
             RTVDTAARA  DTAARA(MPHAS) RTNVAR(&LPHAS)
             IF         COND(&LPHAS *EQ 'A') THEN(DO)
               CHGDTAARA  DTAARA(BYSTAT (2 1)) VALUE('N')
             ENDDO
             ELSE       CMD(DO)
               CHGDTAARA  DTAARA(BYSTAT (1 1)) VALUE('N')
             ENDDO
             CHGDTAARA  DTAARA(BYSTAT (3 5)) VALUE('     ')
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC6080 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             CHGDTAARA  DTAARA(BYSTAT (7 1)) VALUE(E)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
