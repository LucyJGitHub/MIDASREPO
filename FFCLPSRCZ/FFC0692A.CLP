/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas FF Customer confs (COB) phase 1 extract')       */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  FUtures and Options Module                        */
/*                                                                   */
/*   FFC0692A -  Customer Confirmations (COB) Phase 1                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*   Prev Amend No. CCB009             Date 01Jun00                  */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  S01522             Date 15Mar95                  */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*   MD046248 - Finastra Rebranding                                  */
/*   CCB009  -  Journal files throughout close of business           */
/*   S01522  -  User Defined Correspondence                          */
/*              Split FFC0692 into three components                  */
/*                                                                   */
/*********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM
/* */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&DATA)       TYPE(*CHAR) LEN(50)
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/* */
/* Global Monitor Message */
/* */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/*                                                                      CCB009*/
/** Check for Switchable feature CCB009.                                CCB009*/
/*                                                                      CCB009*/
             CALL       PGM(AOSARDR0) PARM(&CCB009 '*VERIFY' +
                          'CCB009' &AOFMT)                            /*CCB009*/
/* */
/* Send Message to MRUNQ and standard processing parameters */
/* */
             SNDPGMMSG  MSG('FFC0692A - Customer Confirmations Phase +
                          1 Extract') TOMSGQ(MRUNQ)
             CHGJOB     SWS(XXXXX000)
/**/
/* Clear file PF/CNFRPD                                             */
/**/
             CLRPFM     FILE(CNFRPD)
/**/
/* Start Journalling of update/output files                         */
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
             STRJRNPF   FILE(TSCCYD) JRN(FFJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(POCHGCC) JRN(FFJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(POCHGRC) JRN(FFJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(POCHGTC) JRN(FFJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(POSTNCD) JRN(FFJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)
             MONMSG     MSGID(CPF7030)
             ENDDO                                                    /*CCB009*/
/**/
/*  Call start journal processing for sub-component                 */
/**/
             FFCJRN2    FILES(TSCCYD POCHGCC POCHGRC POCHGTC POSTNCD)
/*/COPY WNCPYSRC,FFC0692A01                                          */
/**/
/*  OTC Confirmations need U6 on (for FFSETL)                       */
/**/
             CHGJOB     SWS(XXXXX100)
/**/
/*  Override PF/CNFRPD                               */
/**/
             OVRDBF     FILE(CNFRPD) SEQONLY(*YES 50)
/**/
/*   Call FF0580 - Customer Confirmations Print                     */
/**/
             ALCOBJ     OBJ((ACCNT *FILE *SHRRD)) WAIT(1800)
             CALL       PGM(FF0580)
             DLCOBJ     OBJ((ACCNT *FILE *SHRRD))
/**/
/*  Delete Overrides                                                */
/**/
             DLTOVR     FILE(CNFRPD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/* */
/* Check for Database errors trapped by program */
/* */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             GOTO       CMDLBL(ABNORMAL)
             ENDDO
/**/
             GOTO       CMDLBL(ENDCLPGM)
/* */
/* Report Database errors trapped by program */
/* */
 DBERR:
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&DATA)
             SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&DATA) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)
 
/**/
/* Abnormal termination processing                       */
/**/
ABNORMAL:
             ROLLBACK
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  Call Final Journal Processing for Sub-Component                 */
/**/
             FFCJRN3    FILES(TSCCYD POCHGCC POCHGRC POCHGTC POSTNCD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program FFC0692A ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          FFC0692A ended abnormally') MSGTYPE(*ESCAPE)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/**/
 ENDCLPGM:   RCLRSC     LVL(*CALLER)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
/*  Call Final Journal Processing for Sub-Component                 */
/**/
             FFCJRN3    FILES(TSCCYD POCHGCC POCHGRC POCHGTC POSTNCD)
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* */
             ENDPGM
