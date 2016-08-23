/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas BoE Create Abacus Download')                    */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2060 - Create Abacus Download                              */
/*                                                                   */
/*     (c) Misys International Banking Systems Ltd. 1998             */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*     Last Amend No. LLN016           Date: 15MAY00                 */
/*     Prev amend no. 165563           Date  08AUG99                 */
/*                    LLN012           Date  23APR99                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     Amendment Details:                                            */
/*                                                                   */
/*     LLN016 - Upgrade BoE to DBAR3.                                */
/*     165563 - If the component is called during the close of       */
/*              business the BT extarct file should be created       */
/*              ion a daily basis if LLN012 is on.                   */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
/*              This component will now run automatically on a daily */
/*              basis. The extract is only done if it is end of      */
/*              month, the BT extract is requested on daily basis    */
/*              or it has been requested on-request.                 */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LMBIN) TYPE(*CHAR) LEN(1)      /* Multi-branch */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas Phase  */
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)     /* Extract file */
             DCL        VAR(&LQSLT) TYPE(*CHAR) LEN(100)    /* Query select */
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG3) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&LLN012) TYPE(*CHAR) LEN(1)                                   /*165563*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
/*********** DCLF       FILE(SDBRCHY7)                                                    /*LLN016*/
             DCLF       FILE(BYBRCHY1)                                                    /*LLN016*/
 
 
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
               CHGVAR     VAR(&LMSG1) VALUE('Error occured in BYC2060 +
                          on call to program AOSARDR0')
               GOTO       CMDLBL(ABNORM)
             ENDDO
 
/*  Check if switchable feature LLN012 - BoE Liquidity is on  */                          /*165563*/
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')                                                            /*165563*/
             IF         COND(&LRTCD *EQ ' ') THEN(CHGVAR +
                          VAR(&LLN012) VALUE('Y'))                                        /*165563*/
 
 
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
            /* IF         COND(&LFLAG1 *NE 'Y' *AND &LFLAG2 *NE 'Y'*/                     /*165563*/
            /*            *AND &LFLAG3 *NE 'Y') THEN(RETURN) LLN012*/                     /*165563*/
                 IF       COND(&LLN012 *NE 'Y' *AND &LFLAG1 *NE 'Y' +
                          *AND &LFLAG2 *NE 'Y' *AND &LFLAG3 *NE 'Y') +
                          THEN(RETURN)                                                    /*165563*/
                                                                                          /*LLN012*/
             ENDDO                                                                        /*LLN012*/
 
/* Clear ABACUS download file  */
                CLRPFM   FILE(BYEXABPP)
 
/*  Call BY2060 to create extract file for download to ABACUS  */
               CHGVAR    VAR(&LRTCD) VALUE(' ')
               CALL      PGM(BY2060) PARM(&LRTCD)
               IF        COND(&LRTCD *NE ' ') THEN(DO)
                CHGVAR   VAR(&LMSG1) VALUE('Error occured in BYC2060 +
                         on call to program BY2060')
                GOTO     CMDLBL(ABNORM)
               ENDDO
 
 
/*  If multi-branching create separate extract file for each branch */
             OVRDBF     FILE(BYEXABPP) SHARE(*YES)
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&LMBIN)
             IF         COND(&LMBIN *EQ 'Y') THEN(DO)
 
/*EAD:******** RCVF     RCDFMT(SDBRCHD9)                                                  /*LLN016*/
 READ:         RCVF     RCDFMT(BYBRCHD0)                                                  /*LLN016*/
               MONMSG   MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
               CHGVAR   VAR(&LFILE) VALUE('BYAB' *CAT &A8BRCD *CAT 'PP ')
               CLRPFM   FILE(&LFILE)
               CHGVAR   VAR(&LQSLT) VALUE('L9BRCD *EQ' +
                        *BCAT '"' *CAT &A8BRCD *CAT '"')
               OPNQRYF  FILE((BYEXABPP)) QRYSLT(&LQSLT)
               CPYFRMQRYF FROMOPNID(BYEXABPP) TOFILE(&LFILE) +
                          MBROPT(*REPLACE)
               CLOF     OPNID(BYEXABPP)
               GOTO     CMDLBL(READ)
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
             SNDPGMMSG  MSG('BYC2060 terminated abnormally') +
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
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
