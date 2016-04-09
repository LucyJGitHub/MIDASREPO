/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas Boe Consolidated Extract Report')               */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2070 - Produce Consolidated Report                         */
/*                                                                   */
/*     (c) Misys International Banking Systems Ltd. 1998             */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*     Last amend no. LLN016           Date  17MAY00                 */
/*     Prev amend no. LLN012           Date  23APR99                 */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*     Amendment Details:                                            */
/*                                                                   */
/*     LLN016 - Upgrade BoE to DBAR3.                                */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
/*              This component will now run automatically on a daily */
/*              basis. It will only run if it is end of month, the   */
/*              BT extract is requested on daily basis or it has     */
/*              been requested on-request.                           */
/*              Also query BY2070 replaced by an RPG program BY2070. */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&RUNMOD) TYPE(*CHAR) LEN(7) /* Run mode          */
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)     /* Extract file */
             DCL        VAR(&LMBIN) TYPE(*CHAR) LEN(1)      /* Multi-branch */
             DCL        VAR(&LMSG1) TYPE(*CHAR) LEN(100)    /* Message */
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LFLAG1) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG2) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LFLAG3) TYPE(*CHAR) LEN(1)     /* Flags */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas phase */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
/************DCLF*******FILE(SDBRCHY7)*****************                                   /*LLN016*/
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
 
/* Retrieve midas phase */                                                                /*LLN012*/
             RTVDTAARA  DTAARA(MPHAS (1 1)) RTNVAR(&LPHAS)                                /*LLN012*/
                                                                                          /*LLN012*/
/* If close of businesss check if extract required   */                                   /*LLN012*/
             IF         COND(&LPHAS *EQ 'C') THEN(DO)                                     /*LLN012*/
                                                                                          /*LLN012*/
/* Retrieve three flags: 1. End of Month Indicator      */                                /*LLN012*/
/*                       2. Daily BT Extract Indicator  */                                /*LLN012*/
/*                       2. Extract On-Request Flag     */                                /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (54 1)) RTNVAR(&LFLAG1)                           /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (55 1)) RTNVAR(&LFLAG2)                           /*LLN012*/
               RTVDTAARA  DTAARA(BYSTAT (56 1)) RTNVAR(&LFLAG3)                           /*LLN012*/
               IF         COND(&LFLAG1 *NE 'Y' *AND &LFLAG2 *NE 'Y' +
                          *AND &LFLAG3 *NE 'Y') THEN(RETURN)                              /*LLN012*/
                                                                                          /*LLN012*/
             ENDDO                                                                        /*LLN012*/
 
/*  Call program BY2070  */
             OVRDBF     FILE(BYEXABPP) SHARE(*YES)
             OPNQRYF    FILE((BYEXABPP)) KEYFLD((L9BRCD) (L9PCOD) +
                          (L9CYCD) (L9CUST) (L9MMOD) (L9TRAN))
             CALL       PGM(BY2070) PARM(' ')
             CLOF       OPNID(BYEXABPP)
 
 
/*********************************************************************/
/*                                                                   */
/*    Following removed for LLN012                                   */
/*                                                                   */
/*********************************************************************/
/*  Determine if multi- branching                                    */
/*           RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&LMBIN)         */
/*                                                                   */
/*  If multi-branching create separate query report for each branch **/
/*           IF         COND(&LMBIN *EQ 'Y') THEN(DO)                */
/*           IF         COND((&RENT *EQ 'ALL') *OR (&RLVL *EQ 'S')) +*/
/*                        THEN(DO)                                   */
/*EAD:         RCVF     RCDFMT(SDBRCHD9)                             */
/*             MONMSG   MSGID(CPF0864) EXEC(GOTO CMDLBL(END))        */
/*             CHGVAR   VAR(&LFILE) VALUE('BYAB' *CAT &A8BRCD *CAT 'P*/
/*             OVRPRTF  FILE(QPQUPRFIL) OUTQ(MPRINT) SPLFNAME(BY2070P*/
/*             OVRDBF   FILE(&LFILE) SHARE(*YES)                     */
/*             RUNQRY   QRY(BY2070) QRYFILE((&LFILE))                */
/*             DLTOVR   FILE(*ALL)                                   */
/*             GOTO     CMDLBL(READ)                                 */
/*            ENDDO                                                  */
/*            ELSE       CMD(DO)                                     */
/*             CHGVAR   VAR(&LFILE) VALUE('BYAB' *CAT &RENT  *CAT 'PP*/
/*             OVRPRTF  FILE(QPQUPRFIL) OUTQ(MPRINT) SPLFNAME(BY2070P*/
/*             OVRDBF   FILE(&LFILE) SHARE(*YES)                     */
/*             RUNQRY   QRY(BY2070) QRYFILE((&LFILE))                */
/*    Following removed for LLN012                                   */
/*  Determine if multi- branching                                    */
/*           RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&LMBIN)         */
/*                                                                   */
/*  If multi-branching create separate query report for each branch **/
/*           IF         COND(&LMBIN *EQ 'Y') THEN(DO)                */
/*           IF         COND((&RENT *EQ 'ALL') *OR (&RLVL *EQ 'S')) +*/
/*                        THEN(DO)                                   */
/*EAD:         RCVF     RCDFMT(SDBRCHD9)                             */
/*             MONMSG   MSGID(CPF0864) EXEC(GOTO CMDLBL(END))        */
/*             CHGVAR   VAR(&LFILE) VALUE('BYAB' *CAT &A8BRCD *CAT 'P*/
/*             OVRPRTF  FILE(QPQUPRFIL) OUTQ(MPRINT) SPLFNAME(BY2070P*/
/*             OVRDBF   FILE(&LFILE) SHARE(*YES)                     */
/*             RUNQRY   QRY(BY2070) QRYFILE((&LFILE))                */
/*             DLTOVR   FILE(*ALL)                                   */
/*             GOTO     CMDLBL(READ)                                 */
/*            ENDDO                                                  */
/*            ELSE       CMD(DO)                                     */
/*             CHGVAR   VAR(&LFILE) VALUE('BYAB' *CAT &RENT  *CAT 'PP*/
/*             OVRPRTF  FILE(QPQUPRFIL) OUTQ(MPRINT) SPLFNAME(BY2070P*/
/*             OVRDBF   FILE(&LFILE) SHARE(*YES)                     */
/*             RUNQRY   QRY(BY2070) QRYFILE((&LFILE))                */
/*             DLTOVR   FILE(*ALL)                                   */
/*            ENDDO                                                  */
/*           ENDDO                                                   */
/*                                                                   */
/*                                                                   */
/*  If single branch produce only one report  */
/*           IF         COND(&LMBIN *NE 'Y') THEN(DO)                */
/*             OVRPRTF  FILE(QPQUPRFIL) OUTQ(MPRINT) SPLFNAME(BY2070P*/
/*             OVRDBF   FILE(BYEXABPP) SHARE(*YES)                   */
/*             RUNQRY   QRY(BY2070) QRYFILE((BYEXABPP))              */
/*             DLTOVR   FILE(*ALL)                                   */
/*           ENDDO                                                   */
/*********************************************************************/
/*                                                                   */
/*    End of change for LLN012                                       */
/*                                                                   */
/*********************************************************************/
 
 
/*  End program normally  */
END:         RCLRSC
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2070 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
/*  Send any detail message  */
 SNDMSG:     IF         COND(&LMSG1 *NE ' ') THEN(DO)
               SNDPGMMSG  MSG(&LMSG1) TOMSGQ(MRUNQ MOPERQ)
               MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             ENDDO
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
