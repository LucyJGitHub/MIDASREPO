/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Reset Base Currency')                        */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6420 - RESET BASE CURRENCY                               */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CPM005             Date 24Jun96              */
/*                      S01124             Date 13Jun94              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CPM005 - Private Banking Phase 2                            */
/*                Focus Group Changes upgraded to DBA                */
/*       S01124 - PBFG/1 - CHANGE CUSTOMER/PORTFOLIO BASE CCY        */
/*                  VERSION RELEASE III                              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5)
/**********  DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)               * *CPM005*/
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(50)                /*CPM005*/
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(65)
             DCL        VAR(&BUSY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
/**********  DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                * *CPM005*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(10)               * *CPM005*/
/**********  DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)               * *CPM005*/
             DCL        VAR(&PMSTAT) TYPE(*CHAR) LEN(256)
 
/* RUN ONLY PROCESSING IF CHANGE OF CURRENCY OCCUR TODAY */
             RTVDTAARA  DTAARA(PMSTAT) RTNVAR(&PMSTAT)
 
             IF         COND(%SST(&PMSTAT 69 1) *NE 'Y') THEN(DO)
                 GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/**Retrieve*Job*attributes******************************************** *CPM005*/
/**********  RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)            * *CPM005*/
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/**********  CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')       * *CPM005*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')       /*CPM005*/
 
/* Send Information Program Message */
             CHGVAR     VAR(&MSG) VALUE('PMC6420 - Reset Base +
                          Currency')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/**DELETE*VESION*OF*PMPORTPP*IN*LIB/QTEMP***************************** *CPM005*/
/**********  DLTF       FILE(QTEMP/PMPORTPP)                         * *CPM005*/
/**********  MONMSG     MSGID(CPF2105)                               * *CPM005*/
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&BUSY) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &BUSY)
 
/* Save Event Control Date as Date Extract Last Run */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(XCAPRHD)   SEQONLY(*YES 100)
 
/* If Restart, Take Security Copies */
             IF         COND(&BUSY = 'Y') THEN(DO)
             CPYF       FROMFILE(&DLIB/XCAPRHD) TOFILE(CAPRHD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)    +
                          EXEC(CLRPFM FILE(CAPRHD))
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(XCAPRHD)
             MONMSG MSGID(CPF0000)
             CPYF       FROMFILE(CAPRHD) TOFILE(&DLIB/XCAPRHD) +
                  MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             ENDDO
 
             CLOF       OPNID(PMPCBCL1)
             MONMSG MSGID(CPF4520)
 
             OVRDBF     FILE(PMPCBCL1) SHARE(*YES)
             OPNQRYF    FILE((*LIBL/PMPCBCL1)) +
                          FORMAT(*LIBL/PMPCBCL1) QRYSLT('(FMCDAA +
                          *LE "' *CAT &DAECD *CAT '")') +
                          KEYFLD((FMCUST *ASCEND) (FMPTFR *ASCEND)) +
                          MAPFLD((FMCDA1 FMCDAT *ZONED 5 0) (FMCDAA +
                          FMCDA1 *CHAR 5))
 
/* Call the Program */
             CALL       PGM(PM6420)
 
             DLTOVR     FILE(PMPCBCL1)
             CLOF       OPNID(PMPCBCL1)
 
/* For Database Errors Recover Data from LDA */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         * *CPM005*/
/**********     SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG)             + *CPM005*/
/**********                MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    *CPM005*/
/**********     SNDMSG   MSG('PMC6420 ENDED ABNORMALLY FOR JOB ' *CAT +*CPM005*/
/**********                 &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' + * *CPM005*/
/**********                 *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)     * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**********     CHGVAR VAR(&MEM) VALUE('PMC6420 - FILE CONTROLS OUT +* *CPM005*/
/**********               OF BALANCE')                               * *CPM005*/
/**********     SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)* *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       CB0150 PARM(&CNAM &CSEQ &BUSY)
             CHGDTAARA  DTAARA(PMSTAT (69 2)) VALUE('NN')
 
/* Delete Security Copy */
             DLTF       FILE(XCAPRHD)
             MONMSG MSGID(CPF0000)
 
/***ENDPGM:**    ENDPGM                                              * *CPM005*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM005*/
