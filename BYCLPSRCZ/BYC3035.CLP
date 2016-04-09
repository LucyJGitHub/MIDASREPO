/*STD    CLPBASE                                                         */
/*EXI    TEXT('Midas BoE Missing Lending Extract Criteria Report')   */
/*********************************************************************/
/*                                                                   */
/*   MIDAS - Bank of England                                         */
/*                                                                   */
/*   BYC3035 - Missing Lending Extract Criteria Report Program       */
/*                                                                   */
/*   (c) Misys International Banking Systems Limited, 2002           */
/*                                                                   */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/*       Last Amend No. LLN022  *CREATE    Date 24Jan05              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       LLN022 - BOE upgrade to MidasPlus                           */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RSEQ &RLVL &RENT)
 
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)   /* Report sequence   */
             DCL        VAR(&RLVL) TYPE(*CHAR) LEN(1)   /* Report level      */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3)   /* Report entity     */
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                        Misys International Banking Systems Ltd. 2006')
 
/*  Global Monitor Message  */
             MONMSG     MSGID(CPF0000 RPG0000 CPD0000) EXEC(GOTO +
                          CMDLBL(ABNORM))
 
/*  Reset job switches  */
             CHGJOB     SWS(00000000)
 
/*  Run Missing Accounts Extract Criteria Report Query  */
             OVRPRTF    FILE(QPQUPRFIL) USRDTA(BY3035) +
                          SPLFNAME(BY3035P1)
             RUNQRY     QRY(BY3035) QRYFILE((SDLOANPD) (BYLEEXPP))
 
/*  Record spool file for RCF    */
             CALL       PGM(ZSFILE) PARM(&RSEQ  '  '  'BY3035P1  ' +
                          X'00001F' &ERROR)
 
/*  End program normally  */
             RETURN
 
 ABNORM:     SNDPGMMSG  MSG('BYC3035 - Missing Lending Extract +
                          Criteria Report terminated abnormally') +
                          TOMSGQ(MRUNQ MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 MCH0000)
 
 END:        CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
