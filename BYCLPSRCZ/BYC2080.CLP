/*STD    CLPBASE                                                        */
/*EXI    TEXT('Midas Boe Create Liquidity Reporting Extract File')   */
/*********************************************************************/
/*                                                                   */
/*     MIDAS - Bank of England                                       */
/*                                                                   */
/*     BYC2080 - Create Liquidity Reporting Extract File             */
/*                                                                   */
/*     (c) Finastra International Limited 1999                       */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Prev Amend No. LLN016             Date : 15mAY0             */
/*                      LLN012             Date 22Apr99              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*     LLN016 - Upgrade BoE to DBAR3.                                */
/*     LLN012 - Financial Services Authority - Liquidity Report      */
/*                                                                   */
/********************************************************************/
             PGM
 
             DCL        VAR(&LRTCD) TYPE(*CHAR) LEN(7)      /* Return code*/
             DCL        VAR(&LMBIN) TYPE(*CHAR) LEN(1)      /* Multi-branch */
             DCL        VAR(&LPHAS) TYPE(*CHAR) LEN(1)      /* Midas Phase  */
             DCL        VAR(&LFILE) TYPE(*CHAR) LEN(10)     /* Extract file */
             DCL        VAR(&LQSLT) TYPE(*CHAR) LEN(100)    /* Query select */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Finastra International Limited 2006')
/*********** DCLF       FILE(SDBRCHY7)                                                    /*LLN016*/
             DCLF       FILE(BYBRCHY1)                                                    /*LLN016*/
 
 
/*  Global Monitor Message  */
             MONMSG     MSGID(RPG0000 CPF0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
 
/*  Check if switchable feature LLN012 - Bank of England is on  */
             CALL       PGM(AOSARDR0) PARM(&LRTCD '*VERIFY' 'LLN012' +
                          ' ')
             IF         COND(&LRTCD *EQ '*NRF') THEN(RETURN)
 
/* Clear Liquidity Reporting Extract file */
             CLRPFM     FILE(BYEXLRPP)
 
/*  Call BY2080 to create extract file for Liquidity Reporting */
             CALL       PGM(BY2080) PARM(&LRTCD)
             IF         COND(&LRTCD *NE ' ') THEN(DO)
               SNDPGMMSG  MSG('Error occured in BYC2080 on call to +
                          program BY2080') TOMSGQ(MOPERQ MRUNQ)
               GOTO     CMDLBL(ABNORM)
             ENDDO
 
 
/*  If multi-branching create separate extract file for each branch */
             OVRDBF     FILE(BYEXLRPP) SHARE(*YES)
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&LMBIN)
             IF         COND(&LMBIN *EQ 'Y') THEN(DO)
 
/*EAD:******   RCVF     RCDFMT(SDBRCHD9)                                                  /*LLN016*/
 READ:         RCVF     RCDFMT(BYBRCHD0)                                                  /*LLN016*/
               MONMSG   MSGID(CPF0864) EXEC(GOTO CMDLBL(END))
               CHGVAR   VAR(&LFILE) VALUE('BYLR' *CAT &A8BRCD *CAT 'PP ')
               CLRPFM   FILE(&LFILE)
               CHGVAR   VAR(&LQSLT) VALUE('L9BRCD *EQ' +
                        *BCAT '"' *CAT &A8BRCD *CAT '"')
               OPNQRYF  FILE((BYEXLRPP)) QRYSLT(&LQSLT)
               CPYFRMQRYF FROMOPNID(BYEXLRPP) TOFILE(&LFILE) +
                          MBROPT(*REPLACE)
               CLOF     OPNID(BYEXLRPP)
               GOTO     CMDLBL(READ)
             ENDDO
 
 
/*  End program normally  */
END:         RCLRSC
             RETURN
 
 
/*  Abnormal termination  */
 ABNORM:     CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             SNDPGMMSG  MSG('BYC2080 terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
             CHGDTAARA  DTAARA(BYSTAT (7 1)) VALUE(E)
             MONMSG     MSGID(CPF0000 CPD0000 MCH0000)
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
