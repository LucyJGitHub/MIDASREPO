/********************************************************************/
/*                                                                  */
/*     MIDAS - I/O RECONCILE                                        */
/*                                                                  */
/*     XXC1408 - Midas xx SUMMARIZE & EBCDIC/ASCII CONVERSION       */
/*                FOR I/O DATA                                      */
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
/*CRT  : TEXT('Summarize & EBCDIC/ASCII Conversion for I/O Data')   :*/
/*********************************************************************/
             PGM

             DCL        VAR(&EML114) TYPE(*CHAR) LEN(1) VALUE('N')
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE('       ')
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)
/** Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000)
             CHGJOB     SWS(XXXXXX00)

             CHGVAR     VAR(&SAR) VALUE('EML114')
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)

             IF         COND(&RTCD *EQ '       ') THEN(DO)
                  CHGVAR     VAR(&EML114) VALUE('Y')
             ENDDO

             IF         COND(&EML114 *EQ 'Y') THEN(DO)
/**/
             CLRPFM     FILE(IORECNEB)
/**********  CLRPFM     FILE(IORECNCI)*****/ /*EML114*/
/**/
             CALL       PGM(XX1411)
             CALL       PGM(XX1412)

             ENDDO
/**/
ENDPGM:      ENDPGM
