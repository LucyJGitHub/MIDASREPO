/********************************************************************/
/*                                                                  */
/*     MIDAS - I/O RECONCILE                                        */
/*                                                                  */
/*     XXC1409 - Midas xx RE-CREATE I/O DATA FOR THE FIRST OF YEAR  */
/*                                                                  */
/*     Finastra International Limited 2021                          */
/*                                                                  */
/*     Last Amend No.   EML114 *CREATE     Date 23Sep21             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*     EML114 - Inter Office Reconcile (TFJ004 Upgrade)             */
/*     TFJ004 - Inter-office Reconcile                              */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*CRT  : CRTCLPGM                                                   :*/
/*CRT  :  PGM(BISBISBISB/BISBISBISB) SRCFILE(BISBISBISB/BISBISBISB) :*/
/*CRT  : SRCMBR(*PGM) USRPRF(*USER) LOG(*JOB)                       :*/
/*CRT  : ALWRTVSRC(*YES)    AUT(*USE )                              :*/
/*CRT  : TEXT('Re-create I/O Reconcile Data For The First of Year') :*/
/*********************************************************************/
             PGM
             DCL        VAR(&MNTH) TYPE(*CHAR) LEN(3)
             DCL        VAR(&EML114) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
/**/
             CHGVAR     VAR(&SAR) VALUE('EML114')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)

             IF         COND(&RTCD *EQ '       ') THEN(DO)
                  CHGVAR     VAR(&EML114) VALUE('Y')
             ENDDO

             IF         COND(&EML114 *EQ 'Y') THEN(DO)

             RTVDTAARA  DTAARA(RUNDAT (3 3)) RTNVAR(&MNTH)
             IF         COND(&MNTH *EQ 'APR') THEN(DO)
/**/
             CALL       PGM(XX1415)
/**/
             CLRPFM     FILE(XXACNTPP)
             CALL       PGM(XX1416)
/**/
             ENDDO

             ENDDO
/**/
ENDPGM:      ENDPGM
