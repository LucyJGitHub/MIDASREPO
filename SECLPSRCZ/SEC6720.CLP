/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SE ER Gen. A/C Keys & RC Pos.Settlements')      */
/*********************************************************************/
/*                                                                   */
/*       Midas - Securities Trading Module                       */
/*                                                                   */
/*       SEC6720 - SE ER Generate A/C Keys and RC Pos. Settlements   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Last AMEND NO. 101626             DATE 18JUL96             */
/*       Prev AMEND NO. S01408             DATE 10MAY95             */
/*                      S01496             DATE 24OCT94              */
/*                      S10978             DATE 12MAY93              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       101626 - Call SE6720 with 'Type End of Day' parameter, to   */
/*                produce position settlement for a redemption (RC)  */
/*                on the same day as other securities events         */
/*                settlements generation, as per SE2100.             */
/*       S01408 - Addition of core hook SEC6720MPS                   */
/*       S01496 - Incorporation of Jyske Enhancements (S10978)       */
/*       S10978 - JYSZRH: EARLY REDEMPTIONS                          */
/*                . FOR DEPOT POSITIONS WHICH HAVE NOT CHANGED       */
/*                TODAY. + WHICH HAVE SECURITY ACTIONS DUE.          */
/*                . FOR CUSTOMER POSITIONS WHICH HAVE NOT CHANGED    */
/*                TODAY. + WHICH HAVE SECURITY ACTIONS DUE.          */
/*                                                                   */
/*********************************************************************/
/*       C R E A T I O N     P A R A M E T E R S                     */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ)
 
/* Declare PGM Variables */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM)  TYPE(*CHAR) LEN(52)
             DCL        VAR(&MSG)  TYPE(*CHAR) LEN(65)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
             DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)
             DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&ACCRX) TYPE(*CHAR) LEN(1)                /*101626*/
/*/COPY WNCPYSRC,SEC6720001                                          */
 
/* Get system ID to build DLIB name */
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)
/*********** CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')     */ /*S01496*/
             CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DPLIB')       /*S01496*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SEC6720MPS                                          */
                                                                      /*S01408*/
 
/* Send Information Program Message */
             CHGVAR     VAR(&MSG) VALUE('SEC6720 - ER GEN. A/C KEYS +
                          & RC POS. SETTL. - DEP/CUST POSITIONS')
             SNDPGMMSG  MSG(&MSG) TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* Reset Switches */
             CHGJOB     SWS(00000000)
 
/*/COPY WNCPYSRC,SEC6720002                                          */
/* Clear Output Files */
             CLRPFM     FILE(SEKEYD) MBR(REDEMP)
             CLRPFM     FILE(SEKEYA) MBR(REDEMP)
             CLRPFM     FILE(POSETD) MBR(REDEMP)
             CLRPFM     FILE(POSETA) MBR(REDEMP)
/*********** CLRPFM     FILE(POSETDX0) MBR(REDEMP)                 */ /*S01496*/
/*/COPY WNCPYSRC,SEC6720003                                          */
 
/* Retrieve the field indicating a Restart */
             CHGVAR     VAR(&STATUS) VALUE(' ')
             CALL       CB0160 PARM(&CNAM &CSEQ &STATUS)
 
/* Override Files */
             OVRDBF     FILE(SEKEYD) MBR(REDEMP)
             OVRDBF     FILE(SEKEYA) MBR(REDEMP)
             OVRDBF     FILE(POSETD) MBR(REDEMP)
             OVRDBF     FILE(POSETA) MBR(REDEMP)
/*********** OVRDBF     FILE(POSETDX0) MBR(REDEMP)                 */ /*S01496*/
/*/COPY WNCPYSRC,SEC6720004                                          */
 
/* Override to SEQONLY(*YES 100) */
             OVRDBF     FILE(XSEERRFPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEERDPPD) SEQONLY(*YES 100)
             OVRDBF     FILE(XSEERALPD) SEQONLY(*YES 100)
 
             OVRDBF     FILE(SEERRFPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SEERDPPD)  SEQONLY(*YES 100)
             OVRDBF     FILE(SEERALPD)  SEQONLY(*YES 100)
 
/* If Restart, Take Security Copy of SEERRFPD, SEERDPPD, SEERALPD  */
             IF         COND(&STATUS = 'Y') THEN(DO)
             CPYF       FROMFILE(&DLIB/XSEERRFPD) TOFILE(SEERRFPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERRFPD))
             CPYF       FROMFILE(&DLIB/XSEERDPPD) TOFILE(SEERDPPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERDPPD))
             CPYF       FROMFILE(&DLIB/XSEERALPD) TOFILE(SEERALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(SEERALPD))
             ENDDO
 
             ELSE CMD(DO)
 
/* Delete Copy Files */
             DLTF       FILE(XSEERRFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XSEERDPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(XSEERALPD)
             MONMSG MSGID(CPF0000)
 
/* Backup File */
             CPYF       FROMFILE(SEERRFPD) TOFILE(&DLIB/XSEERRFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(SEERDPPD) TOFILE(&DLIB/XSEERDPPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
             CPYF       FROMFILE(SEERALPD) TOFILE(&DLIB/XSEERALPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
 
             CHGVAR     VAR(&STATUS) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
             ENDDO
 
             DLTOVR     FILE(XSEERRFPD XSEERDPPD XSEERALPD SEERRFPD +
                          SEERDPPD SEERALPD)
 
             RTVDTAARA  DTAARA(SDSTAT (116 1)) RTNVAR(&ACCRX)         /*101626*/
/* Call the Program */
/************CALL       PGM(SE6720)                                   /*101626*/
             CALL       PGM(SE6720) PARM(&ACCRX)                      /*101626*/
 
/* Delete Override */
             DLTOVR     FILE(*ALL)
 
/* For Database Errors Recover Data from LDA */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)
/***********    SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG) MSGDTA(&MEM)   +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)           */ /*S01496*/
                SNDPGMMSG  MSGID(DBM0001) MSGF(SEUSRMSG) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)              /*S01496*/
                CHGVAR VAR(&MEM) VALUE('SEC6720 - JOB TERMINATED, +
                                        DATABASE IN ERROR')
                SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                GOTO ENDPGM
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
                   CHGVAR     VAR(&MEM) VALUE('SEC6720 - FILE CONTROLS OUT +
                                              OF BALANCE')
                   SNDPGMMSG  MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)
                   GOTO ENDPGM
             ENDDO
 
/* If the job is completed normally */
             CHGVAR     VAR(&STATUS) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)
 
/* Delete Security Copy */
             DLTF       FILE(&DLIB/XSEERRFPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSEERDPPD)
             MONMSG MSGID(CPF0000)
             DLTF       FILE(&DLIB/XSEERALPD)
             MONMSG MSGID(CPF0000)
 
             RCLRSC
 
/***ENDPGM:      ENDPGM                                            */ /*S01496*/
ENDPGM:                                                               /*S01496*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
             ENDPGM                                                   /*S01496*/
