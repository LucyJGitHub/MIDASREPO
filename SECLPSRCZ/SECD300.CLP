/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SE GL Reconciliation Report')                   */
/*********************************************************************/
/*                                                                   */
/*       MIDAS/SECURITIES TRADING MODULE                             */
/*                                                                   */
/*       SECD300 - SE GL RECONCILIATION REPORT                       */
/*                                                                   */
/*       (c) Finastra International Limited 2017                     */
/*                                                                   */
/*       Last Amend No. DUG507             Date 04Feb18              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       DUG507 -  UGB FED CARS upgrde                               */
/*              -  Apply to FBM from Midas R4                        */
/*                 DUG420 - SE GL Reconciliation Report              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TYPE &RSEQ &RLEV &RENT)                 /*AUS017*/
             DCL        VAR(&TYPE) TYPE(*CHAR) LEN(2)                 /*AUS017*/
             DCL        VAR(&RSEQ) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV) TYPE(*CHAR) LEN(1) /* RCF level +
                          flag (S/C/B)             */
             DCL        VAR(&RENT) TYPE(*CHAR) LEN(3) /* RCF entity +
                          code (all/comp/bch)                 */
             DCL        VAR(&SWS) TYPE(*CHAR) LEN(8)
             DCL        VAR(&MSG1) TYPE(*CHAR) LEN(75) VALUE('JOB +
                          TERMINATED - DATABASE IN ERROR')

             SNDMSG     MSG('GL & SE RECONCILIATION REPORT') +
                          TOMSGQ(MRUNQ)

             CLRPFM     FILE(SERECNPP)
 /* GL EXTRACT */
             CALL       PGM(SED300) PARM(&TYPE &RSEQ)
 /* SE EXTRACT */
             CALL       PGM(SED301) PARM(&TYPE &RSEQ)
 /* RECONCILIATION REPORT */
             CALL       PGM(SED302) PARM(&TYPE &RSEQ)

             RTVJOBA    SWS(&SWS)
             IF         COND(%SUBSTRING(&SWS 7 2) *EQ '11') +
                          THEN(SNDMSG MSG(&MSG1) TOMSGQ(MOPERQ))

             ENDPGM
