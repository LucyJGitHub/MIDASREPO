/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas Rep Last Sucs. Trans on Primary Mach')          */
/********************************************************************/
/*                                                                  */
/*        Midas     - Restart Recovery Module                   */
/*                                                                  */
/*       SDC1762 - Recover data areas to status at recover to point */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. E13205             Date . 23/02/             */
/*                      E00000             Date . 00/00/             */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       MD046248 - Finastra Rebranding                              */
/*       E13205 - Rewrite of SDC1723. RTVJRNE is CPU expensive and  */
/*                slow. Replaced with DSPJRN to JRNEX1 member       */
/*                DTAARA. This file is processed for updates        */
/*                                                                  */
/********************************************************************/
/**/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&TOPNT &LST_RCV)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/*   Declare Variables                                              */
/**/
             DCL        VAR(&TOPNT) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&TOPNTA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&MMOD_YES) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MNATN_YES) TYPE(*CHAR) LEN(1)
             DCL        VAR(&NACON_YES) TYPE(*CHAR) LEN(1)
             DCL        VAR(&XXSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&RTNSQN) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&RTNRCV) TYPE(*CHAR) LEN(10)
             DCL        VAR(&SEQNA) TYPE(*CHAR) LEN(10)
             DCL        VAR(&LST_RCV) TYPE(*CHAR) LEN(8)
/**/
             DCLF       FILE(*LIBL/JRNEX1)
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO CMDLBL(ABNOR))
/**/
             SNDPGMMSG  MSG('SDC1762 - Restore Data Areas') +
                          TOMSGQ(*LIBL/MRUNQ)
/**/
             CHGVAR  VAR(&TOPNTA) VALUE(&TOPNT)
/**/
/* Create JRNEX1 in QTEMP                                          */
/**/
             DLTF       FILE(QTEMP/JRNEX1)
             MONMSG     MSGID(CPF2105)
             CPYF       FROMFILE(*LIBL/JRNEX1) TOFILE(QTEMP/JRNEX1) +
                          MBROPT(*REPLACE) CRTFILE(*YES) TORCD(1)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Restore Data areas') TOPGMQ(*EXT) +
                          MSGTYPE(*STATUS)
/**/
/* Find receiver name which 'JS' is stored on by recovering a DT   */
/* entry. If no entry then error.                                  */
/**/
             IF         COND(&LST_RCV *EQ ' ') THEN(CHGVAR +
                          VAR(&LST_RCV) VALUE('*CURRENT'))
             RTVJRNE    JRN(*LIBL/ICJRN) RCVRNG(*LIBL/ICRCV001 +
                          *LIBL/&LST_RCV) FROMENT(&TOPNT) ENTTYP(JS) +
                          RTNSEQNBR(&RTNSQN) RTNRCV(&RTNRCV)
             CHGVAR     VAR(&TOPNTA) VALUE(&RTNSQN)
/**/
/* Display journal entries from recovery point to end of journal   */
/* receiver                                                        */
/**/
             CHGVAR     VAR(&SEQNA) VALUE(&RTNSQN)
             SNDPGMMSG  MSGID(CPF9898) MSGF(QSYS/QCPFMSG) +
                          MSGDTA('Extracting data area information +
                          from receiver ' *BCAT &RTNRCV *BCAT ' seq > +
                          ' *BCAT &SEQNA) TOPGMQ(*EXT) MSGTYPE(*STATUS)
             DSPJRN     JRN(*LIBL/ICJRN) RCVRNG(*LIBL/&RTNRCV +
                          *LIBL/&RTNRCV) FROMENT(&RTNSQN) JRNCDE(U) +
                          ENTTYP(DT) OUTPUT(*OUTFILE) +
                          OUTFILE(QTEMP/JRNEX1)
/**/
/* Read file until end of file and then check for some data areas  */
/**/
             OVRDBF     FILE(JRNEX1) TOFILE(QTEMP/JRNEX1)
 READ:       RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(CHECK))
/**/
/* Restore data area just read                                       */
/**/
             IF         COND((%SST(&INFO 1 8) *EQ 'MSFCTLBK') +
                       *AND (%SST(&INFO 9 10) *EQ &TOPNTA)) THEN(DO)
             CHGVAR     VAR(&XXSTAT) VALUE(%SST(&INFO 19 32) *CAT +
                          &DATAA *CAT &DATAB)
/**/
             CHGDTAARA  DTAARA(*LIBL/%SST(&INFO 1 8)) VALUE(&XXSTAT)
             SNDPGMMSG  MSG('Data area ' *BCAT %SST(&INFO 1 8) *BCAT +
                          ' retreived and updated') TOMSGQ(*LIBL/MRUNQ)
/**/
             ENDDO
             IF         COND(%SST(&INFO 7 10) *EQ &TOPNTA) THEN(DO)
             CHGVAR     VAR(&XXSTAT) VALUE(%SST(&INFO 17 34) *CAT +
                          &DATAA *CAT &DATAB)
/**/
             CHGDTAARA  DTAARA(*LIBL/%SST(&INFO 1 6)) VALUE(&XXSTAT)
             SNDPGMMSG  MSG('Data area ' *BCAT %SST(&INFO 1 6) *BCAT +
                          ' retreived and updated') TOMSGQ(*LIBL/MRUNQ)
/**/
/* Check for data areas MMOD, MNATN and NACON                        */
/**/
             IF         COND(%SST(&INFO 1 6) *EQ 'MMOD') THEN(DO)
             CHGVAR     VAR(&MMOD_YES) VALUE(Y)
             CHGVAR     VAR(&MMOD) VALUE(%SST(&INFO 17 34) *CAT +
                          &DATAA *CAT &DATAB)
             ENDDO
             IF         COND(%SST(&INFO 1 6) *EQ 'MNATN') THEN(CHGVAR +
                          VAR(&MNATN_YES) VALUE(Y))
             IF         COND(%SST(&INFO 1 6) *EQ 'NACON') THEN(CHGVAR +
                          VAR(&NACON_YES) VALUE(Y))
/**/
             ENDDO
/**/
             GOTO       CMDLBL(READ)
/**/
CHECK:
/**/
             IF         COND(&MMOD_YES *NE 'Y') THEN(DO)
             SNDPGMMSG  MSG('Data area MMOD not retreived - Error') +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MRUNQ *LIBL/MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             IF         COND(&MNATN_YES *NE 'Y') THEN(DO)
             SNDPGMMSG  MSG('Data area MNATN not retreived - Error') +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MRUNQ *LIBL/MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             IF COND(%SST(&MMOD 50 1) *EQ 'Y') THEN(DO)
             IF         COND(&NACON_YES *NE 'Y') THEN(DO)
             SNDPGMMSG  MSG('Data area NACON not retreived - Error') +
                          TOPGMQ(*EXT) TOMSGQ(*LIBL/MRUNQ *LIBL/MOPERQ)
             GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO
/**/
/* Delete JRNEX1 copy in QTEMP */
/**/
             DLTF       FILE(QTEMP/JRNEX1)
             MONMSG     MSGID(CPF2105)
/**/
             GOTO       CMDLBL(END)
/**/
/*   Error processing                                                */
/**/
 ABNOR:      SNDPGMMSG  MSG('PROGRAM SDC1762 -  Restore Data Areas to +
                          status at recover to point- ENDED +
                          ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(*LIBL/MOPERQ *LIBL/MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
END:         ENDPGM
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
