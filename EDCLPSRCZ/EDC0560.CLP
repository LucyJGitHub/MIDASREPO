/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Extract forward rates')                      */
/********************************************************************/
/*                                                                  */
/*  Midas - Midas Data Export Module                                */
/*                                                                  */
/*  EDC0560 - Forward Rates for GM                                  */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*  LAST AMEND NO. CED006    *CREATE       DATE 25JUL97             */
/*                                                                  */
/*  THIS IS A 'SPECIAL PROCESSING PROGRAM' FOR THE ED MODULE.       */
/*  IT SETS UP AN EXTRACT FILE USING OPNQRYF AND THEN CALLS THE     */
/*  STANDARD BULK TRANSFER EXTRACT PROCESS TO BATCH THE EXTRACT     */
/*  FILE FOR USE BY OTHER SYSTEMS.  ALTHOUGH THERE IS A PARAMETER   */
/*  &FILENM, THIS PROGRAM IS ONLY SUITABLE FOR EDFWDRPD.            */
/*                                                                  */
/********************************************************************/
/*                                                                  */
/*       CED006 - Midas ED Enhancements                             */
/*                                                                  */
/*********************************************************************/
             PGM        PARM(&PDPLIB &FILENM &MEMBNM &EDSQCD &STREAM)
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&PDPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&FILENM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MEMBNM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&EDSQCD) TYPE(*CHAR) LEN(3)
             DCL        VAR(&STREAM) TYPE(*CHAR) LEN(1)
 
/* Global error monitor and other initial actions */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
             CHGJOB     SWS(00000000)
 
             SNDPGMMSG  MSG('EDC0560 - DL Forward rates for GM +
                          Extract') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/*  Clear extract file                                 */
 
             CLRPFM     FILE(EDFWDRPD)
 
/*  Populate temporary extract file                    */
 
             OPNQRYF    FILE((FWDRTFE) (SDBANKPD) (SDCURRPD)) +
                          OPTION(*INP) FORMAT(EDFWDRPD) +
                          QRYSLT('RECI *EQ "D"') JFLD((FWDRTFE/CCY +
                          SDCURRPD/A6CYCD)) COMMIT(*NO)
 
             CPYFRMQRYF FROMOPNID(FWDRTFE) TOFILE(EDFWDRPD) +
                          TOMBR(EDFWDRPD) MBROPT(*ADD) CRTFILE(*NO)
 
 
             CLOF       OPNID(FWDRTFE)
 
             DSPFD      FILE(&FILENM) TYPE(*MBR) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/EDOUTFPD)
 
/* Call normal batch creation program now that temporary file has    */
/* been filled.                                                      */
 
             CALL       PGM(ED0020) PARM(&PDPLIB &FILENM &MEMBNM +
                          &EDSQCD &STREAM)
 
             IF         COND(%SWITCH(XXXXXXX1)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
              GOTO       CMDLBL(ENDCLPGM)
 
 /* Error processing */
 
ABNOR:
             SNDPGMMSG  MSG('EDC0560 - DL Forward Rates for GM +
                          Extract TERMINATED ABNORMALLY') +
                          TOMSGQ(*SYSOPR) MSGTYPE(*INQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                CHGJOB     SWS(XXXXXX11)
                MONMSG     MSGID(CPF0000 MCH0000)
                DMPCLPGM
                MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
ENDCLPGM:
             ENDPGM
