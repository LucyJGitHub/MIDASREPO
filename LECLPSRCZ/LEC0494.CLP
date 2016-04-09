/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Dropped Collateral Records')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0494 - Drop Collateral Records                           */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. 236101             Date 02Nov05              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE005 *Create     Date 22May97              */
/*                      Xnnnnn             Date ddmmmyy              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       236101 - Applied fix 235249.                                */
/*                Moved changed of component status to 'N'           */
/*                right after checking of U7/U8 to ensure that if    */
/*                component failed system will be able to restart.   */
/*                Added theory of fix 216263 when file is empty.     */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
 
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PREF) TYPE(*CHAR) LEN(2)
             DCL        VAR(&LIB) TYPE(*CHAR) LEN(7)
/*/COPY WNCPYSRC,LEH01210                                            */
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
             SNDPGMMSG  MSG('Dropped Collateral Records') TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,LEH01211                                            */
 
/* (For COB file updates add necessary code for security backups */
/* and recovery processing)                                      */
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREF)
             CHGVAR     VAR(&LIB) VALUE(&PREF *TCAT 'DPLIB')
 
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)
 
             IF         COND(&STAT = 'N') THEN(DO)
             CPYF       FROMFILE(GTEESGT) TOFILE(&LIB/XGTEESGT) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*236101*/
             CPYF       FROMFILE(GTEESZZ) TOFILE(&LIB/XGTEESZZ) +
                          CRTFILE(*YES)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                    /*236101*/
/*/COPY WNCPYSRC,LEH01212                                            */
               CHGVAR     VAR(&STAT) VALUE('Y')
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)
             ENDDO
 
             ELSE       CMD(DO)
               CPYF       FROMFILE(XGTEESGT) TOFILE(GTEESGT) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*236101*/
               CPYF       FROMFILE(XGTEESZZ) TOFILE(GTEESZZ) +
                            MBROPT(*REPLACE)
               MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                  /*236101*/
/*/COPY WNCPYSRC,LEH01213                                            */
             ENDDO
 
/* Call LE0494 */
 
             CALL       PGM(LE0494)
 
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
               CHGVAR     VAR(&STAT) VALUE('N')                                          /*236101*/
               CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)                            /*236101*/
               DLTF       FILE(XGTEESGT)
               MONMSG     MSGID(CPF2105)                                                 /*236101*/
               DLTF       FILE(XGTEESZZ)
               MONMSG     MSGID(CPF2105)                                                 /*236101*/
/**********    CHGVAR     VAR(&STAT) VALUE('N')                     */                   /*236101*/
/**********    CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)       */                   /*236101*/
             ENDDO
             ELSE       CMD(DO)
               RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
               SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:
             CHGJOB     SWS(XXXXXX11)
 
/* Abnormal termination - batch job */
 
             IF         COND(&JOBTYPE = '0') THEN(DO)
               SNDPGMMSG MSGID(CPF9898) MSGF(QCPFMSG) MSGDTA('Program +
                            LEC0494 ended abnormally - see job log') +
                            TOMSGQ(MOPERQ)
               MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
 
             ENDPGM
