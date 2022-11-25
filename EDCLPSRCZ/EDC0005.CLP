/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas ED Create a special case batch')                */
/*********************************************************************/
/*                                                                   */
/*       Midas - Export Data Module                                  */
/*                                                                   */
/*       EDC0005 - Create a Special Case Batch                       */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CPK030             Date 08Apr14              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      117467 *C *CREATE  Date 30Apr97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPK030 - Clean up of deliverable data library.              */
/*       117467 - New program to allow creation of special types     */
/*                of DTA batch.                                      */
/*                - Addition of HALT batch processing.               */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&BATCHTYPE &REFF &REFM &TARGETF +
                          &LOGFILE &FBUTKEY)
 
/*/COPY WNCPYSRC,EDC0005INT                                          */
 
             DCL        VAR(&BATCHTYPE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REFF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&REFM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TARGETF) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TARGETM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TARGETL) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LOGFILE) TYPE(*CHAR) LEN(10)
             DCL        VAR(&BATCHID) TYPE(*CHAR) LEN(3) VALUE('UDF')
             DCL        VAR(&FBUTKEY) TYPE(*CHAR) LEN(20)
             DCL        VAR(&SEQNBR) TYPE(*CHAR) LEN(7)
             DCL        VAR(&NEWSEQ) TYPE(*DEC) LEN(7 0)
             DCL        VAR(&MBRTEXT) TYPE(*CHAR) LEN(50) +
                          VALUE('User defined batch requested -')
             DCL        VAR(&LOG) TYPE(*CHAR) LEN(32)
             DCL        VAR(&QUOTE) TYPE(*CHAR) LEN(1) VALUE('''')                        /*CPK030*/
             DCL        VAR(&RUNSQL) TYPE(*CHAR) LEN(5000)                                /*CPK030*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGJOB     SWS(XXXXXX00)
 
/* If no reference file has been passed then default to EDHEADPD */
 
             IF         COND(&REFF *EQ '          ') THEN(CHGVAR +
                          VAR(&REFF) VALUE(EDHEADPD))
             IF         COND(&REFF *EQ 'EDHEADPD') THEN(DO)                               /*CPK030*/
                CHGVAR     VAR(&RUNSQL) VALUE('create table +
                             QTEMP/EDHEADPD (XXXXXX) as (select cast(' +
                             *TCAT &QUOTE *TCAT 'HEAD' *TCAT &QUOTE +
                             *BCAT 'as char(50)) from +
                             SYSIBM/SYSDUMMY1) with data')                                /*CPK030*/
                RUNSQL     SQL(&RUNSQL) COMMIT(*NONE)                                     /*CPK030*/
             ENDDO                                                                        /*CPK030*/
 
/*/COPY WNCPYSRC,EDC0005MPS                                          */
 
/* Build default member text for a user defined batch */
 
             CHGVAR     VAR(%SST(&MBRTEXT 32 10)) VALUE(&BATCHTYPE)
 
/* Build default data for HALT batch */
 
             IF         COND(&BATCHTYPE *EQ 'HALT      ') THEN(DO)
                CHGVAR     VAR(&BATCHID) VALUE(HLT)
                CHGVAR     VAR(&MBRTEXT) VALUE('Halt requested')
             ENDDO
 
/* Hook to allow customer specific batchtypes to be specified */
/*/COPY WNCPYSRC,EDC0005001                                          */
 
/* Obtain the next special batch sequence number and increment */
/* the stored value                                            */
 
             RTVDTAARA  DTAARA(EDSTAT (1 7)) RTNVAR(&SEQNBR)
 
             CHGVAR     VAR(&NEWSEQ) VALUE(&SEQNBR)
             IF         COND(&NEWSEQ *EQ 9999999) THEN(CHGVAR +
                          VAR(&NEWSEQ) VALUE(0000000))
             CHGVAR     VAR(&NEWSEQ) VALUE(&NEWSEQ + 1)
             CHGVAR     VAR(&SEQNBR) VALUE(&NEWSEQ)
             CHGDTAARA  DTAARA(EDSTAT (1 7)) VALUE(&SEQNBR)
 
/* Create the target batch name */
 
             CHGVAR     VAR(&TARGETM) VALUE(&BATCHID *CAT &SEQNBR)
 
/* Copy the Special Case member to the chosen batch file */
 
             CPYF       FROMFILE(&REFF) TOFILE(&TARGETF) +
                          FROMMBR(&REFM) TOMBR(&TARGETM) +
                          MBROPT(*ADD) FMTOPT(*NOCHK)
 
             CHGPFM     FILE(&TARGETF) MBR(&TARGETM) TEXT(&MBRTEXT)
 
/* Create the log entry for DTA to pick up */
 
             RTVOBJD    OBJ(&TARGETF) OBJTYPE(*FILE) RTNLIB(&TARGETL)
 
             CHGVAR     VAR(%SST(&LOG 1 10)) VALUE(&TARGETL)
             CHGVAR     VAR(%SST(&LOG 8 1)) VALUE('/')
             CHGVAR     VAR(%SST(&LOG 9 8)) VALUE(&TARGETF)
             CHGVAR     VAR(%SST(&LOG 17 1)) VALUE('.')
             CHGVAR     VAR(%SST(&LOG 18 10)) VALUE(&TARGETM)
             CHGVAR     VAR(%SST(&LOG 28 5)) VALUE('     ')
 
/* Call ED0005 to write the log entry */
 
             CALL       PGM(ED0005) PARM(&LOG &LOGFILE &FBUTKEY)
 
/*/COPY WNCPYSRC,EDC0005MPE                                          */
 
             GOTO       CMDLBL(END)
 
/* Abnormal termination */
 ABNOR:
/*/COPY WNCPYSRC,EDC0005ERR                                          */
 
             CHGJOB     SWS(XXXXXX11)
 
             SNDPGMMSG  MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                          EDC0005 ended abnormally - see job log') +
                          TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 MCH0000)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
/*/COPY WNCPYSRC,EDC0005END                                          */
 
             ENDPGM
