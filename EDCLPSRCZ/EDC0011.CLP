/********************************************************************/
/*OVRF*  OVRDBF FILE(EDOUTFPD) TOFILE(QAFDMBR)                      */
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas ED Bulk transfer COB initialisation')           */
/********************************************************************/
/*                                                                  */
/*       Midas - Midas Export Data Interface Module                 */
/*                                                                  */
/*       EDC0011 - Bulk Transfer Initialisation component           */
/*                                                                  */
/*       Function : This program performs initialisation needed by  */
/*                  the bulk transfer at the beginning of the COB.  */
/*                                                                  */
/*       Submitted by : COB Process                                 */
/*                                                                  */
/*       Calls :        AOMEXPR0                                    */
/*                      ED0030                                      */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/**      Prev Amend No. CCB009             Date 01Jun00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CEU031             Date 12Nov98              */
/*                      136827             DATE 02JUN98             */
/*                      CED002 *CREATE     DATE 04JUN97             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CCB009 - Journal files throughout close of business        */
/*       CEU031 - EMU Global Manager Changes                        */
/*                Initialise new extract file EDMCRLPD              */
/*       136827 - Do not attempt to remove a member if the member   */
/*                name is a blank.                                  */
/*       CED002 - Created for ED Enhancements                       */
/*                                                                  */
/********************************************************************/
             PGM
 
/* Copyright statement definition */
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
/* Other declarations */
 
             DCL        VAR(&BUEN) TYPE(*CHAR) LEN(1)
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST')
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&XLIB) TYPE(*CHAR) LEN(6)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(80)
             DCL        VAR(&AOMEXP) TYPE(*CHAR) LEN(200)
             DCL        VAR(&MSGID)   TYPE(*CHAR) LEN(7)
             DCL        VAR(&MSGDTA)  TYPE(*CHAR) LEN(100)
             DCL        VAR(&MSGF)    TYPE(*CHAR) LEN(10)
             DCL        VAR(&MSGFLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAY) TYPE(*DEC) LEN(1 0)
             DCL        VAR(&DAYA) TYPE(*CHAR) LEN(1)
             DCL        VAR(&EHAX) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MEM3) TYPE(*CHAR) LEN(3)
             DCL        VAR(&MEM4) TYPE(*CHAR) LEN(4)
             DCL        VAR(&MBNAME)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                 /*CEU031*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                 /*CEU031*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                 /*CEU031*/
             DCL        VAR(&CEU031) TYPE(*CHAR) LEN(1) VALUE(' ')    /*CEU031*/
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
 
             DCLF       FILE(EDOUTFPD)
 
/* Global error monitor */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
             CHGJOB     SWS(00000000)
 
/* Copyright statement definition - at runtime */
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             CHGVAR     VAR(&MEM) VALUE('EDC0011 - ED Bulk Transfer +
                          Initialisation')
 
             SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
/* */                                                                 /*CEU031*/
/* Check if CEU031 is existing in SCSARDPD */                         /*CEU031*/
/* */                                                                 /*CEU031*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CEU031*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                   /*CEU031*/
             CHGVAR     VAR(&SARD) VALUE('CEU031')                    /*CEU031*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD ' ')     /*CEU031*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CEU031) VALUE('Y'))                    /*CEU031*/
 
/* Retrieve Interface ICD */
 
             CHGVAR     VAR(&RTNC) VALUE('*MSG   ')
             CALL       PGM(AOMEXPR0) PARM(&RTNC &OPTN &AOMEXP)
 
             IF         COND(&RTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Prepare for transfer */
 
/* Determine the library prefix for this system */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&DPLIB) VALUE(&PREF *CAT 'DPLIB')
             CHGVAR     VAR(&JLIB) VALUE(&PREF *TCAT 'JLIB')
             CHGVAR     VAR(&XLIB) VALUE(&PREF *TCAT 'XLIB')
 
/* Reset Data Queue */
             DLTDTAQ    DTAQ(EDBULKQ)
             MONMSG     MSGID(CPF2105)
             CRTDTAQ    DTAQ(&XLIB/EDBULKQ) MAXLEN(100)
 
/* Purge Batches to Send file of old Bulk Transfer batch details */
/* Reset Sequence no. etc. */
/* Cycle Through 10 Days history  EHA0..,EHA1,EHA2, etc                     */
             RTVDTAARA  DTAARA(EDJSEQDA (24 1)) RTNVAR(&DAYA)
             CHGVAR     VAR(&DAY) VALUE(&DAYA)
             CHGVAR     VAR(&DAY) VALUE(&DAY + 1)
             MONMSG     MSGID(MCH1210)   /* IGNORE OVERFLOW - GO 9-0*/
             CHGVAR     VAR(&DAYA) VALUE(&DAY)
             CHGVAR     VAR(&EHAX) VALUE('EHA' *CAT &DAYA)
             CHGDTAARA  DTAARA(EDJSEQDA (21 30)) VALUE(%SST(&EHAX 1 +
                          4) *CAT '000001')
             CHGDTAARA  DTAARA(EDJSEQDA (1 20)) +
                          VALUE('0000000001M000000001')
/* N.B. IF EHA prefix changed, also amend crt parm for dtara EDJSEQDA        */
 
             CALL       PGM(ED0030)
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))
 
/* Compress deleted records */
/**********  RGZPFM     FILE(EDSAVEPD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('EDSAVEPD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
 
/* Clear Sorted Batches File */
             CLRPFM     FILE(EDSAVXPD)
 
/* Clear Failed Bulk Transfer Request File */
             CLRPFM     FILE(EDFBUTPD)
 
/* Clear all members of all COB work files */
             RMVM       FILE(EDDKEYPD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(EDLKY1PD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(EDLFEEPD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(EDMKEYPD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(EDFKEYPD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
             RMVM       FILE(EDSKEYPD) MBR(*ALL)
             MONMSG     MSGID(CPF7303 CPF7301)
             CLRPFM     FILE(EDFFBPPD)
             CLRPFM     FILE(EDFFTRPD)
             CLRPFM     FILE(EDSEBHPD)
             CLRPFM     FILE(EDSEBPPD)
             CLRPFM     FILE(EDCURRPD)
             CLRPFM     FILE(EDFWDRPD)
             CLRPFM     FILE(EDCFTRPD)
             CLRPFM     FILE(EDCSBHPD)
             CLRPFM     FILE(GLCEVTPD)
             IF         COND(&CEU031 *EQ 'Y') THEN(CLRPFM +
                          FILE(EDMCRLPD))                             /*CEU031*/
 
/* Delete last night's Bulk Transfer data */
 
             DSPFD      FILE(EDBULKPD) TYPE(*MBR) OUTPUT(*OUTFILE) +
                             OUTFILE(QTEMP/EDOUTFPD)
 
LOOP:
             RCVF
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ENDLOOP))
 
             CHGVAR     VAR(&MEM3) VALUE(%SST(&MBNAME 1 3))
             CHGVAR     VAR(&MEM4) VALUE(%SST(&MBNAME 1 4))
             IF         COND(&MEM3 *NE 'EHA' *OR +
                              &MEM4 = &EHAX) THEN(DO)
                IF         COND(&MBNAME *NE '          ') THEN(DO)    /*136827*/
                        RMVM       FILE(EDBULKPD) MBR(&MBNAME)
                        MONMSG   MSGID(CPF2105 CPF7303 CPF5715 CPF7301)
                ENDDO                                                 /*136827*/
             ENDDO
             GOTO       CMDLBL(LOOP)
 
 ENDLOOP:
 
/* Clear the audit file for tonight's run; (it will be left un-    */
/* cleared until the next COB to assist in problem investigation). */
             CLRPFM     FILE(EDBUAUPD)
 
/* Set next batch number field to initial value */
             CHGDTAARA  DTAARA(EDBULK (1 60)) +
                          VALUE('000000000000000000000000000000000000+
                          000000000000000000000000')
 
/** If the Bulk Transfer process is disabled then end process now */
             CHGVAR     VAR(&BUEN) VALUE(%SUBSTRING(&AOMEXP 26 1))
 
             IF         COND(&BUEN *EQ 'N') THEN(DO)
               CHGVAR     VAR(&MEM) VALUE('EDC0010 - ED Bulk Transfer +
                            Disabled')
               SNDPGMMSG  MSG(&MEM) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
               GOTO       CMDLBL(ENDCLPGM)
             ENDDO
 
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/* Create Journal & Receiver for PF/EDSAVXPD Commitment Control */
             ENDJRNPF   FILE(*ALL) JRN(JEDC0010)
             MONMSG     MSGID(CPF7032 CPF9801)
 
             DLTJRN     JRN(JEDC0010)
             MONMSG     MSGID(CPF2105)
 
             CHGJOB     INQMSGRPY(*DFT)
             DLTJRNRCV  JRNRCV(JREDC0010)
             MONMSG     MSGID(CPF2105)
             CHGJOB     INQMSGRPY(*RQD)
 
             CRTJRNRCV  JRNRCV(&JLIB/JREDC0010)
             CRTJRN     JRN(&JLIB/JEDC0010) JRNRCV(&JLIB/JREDC0010)
             STRJRNPF   FILE(EDSAVXPD EDBUAUPD) JRN(JEDC0010) +
                          IMAGES(*BOTH)
             ENDDO                                                    /*CCB009*/
 
/* Normal termination */
 
             GOTO       CMDLBL(ENDCLPGM)
 
 
ABNOR:
 
/* Abnormal termination */
 
             RCVMSG     MSGTYPE(*EXCP) RMV(*NO) MSGDTA(&MSGDTA) +
                          MSGID(&MSGID) MSGF(&MSGF) +
                          MSGFLIB(&MSGFLIB)
             MONMSG     MSGID(CPF0000)
 
             IF         COND(&MSGID *NE '       ') THEN(DO)
                 SNDPGMMSG  MSGID(&MSGID) MSGF(&MSGFLIB/&MSGF) +
                            MSGDTA(&MSGDTA) TOMSGQ(MOPERQ MRUNQ)
                 MONMSG     MSGID(CPF0000)
             ENDDO
 
             SNDPGMMSG  MSG('EDC0011 Midas ED Bulk Transfer +
                          Preparation TERMINATED ABNORMALLY') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGJOB     SWS(XXXXXX11)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
             DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
 
ENDCLPGM:
             ENDPGM
