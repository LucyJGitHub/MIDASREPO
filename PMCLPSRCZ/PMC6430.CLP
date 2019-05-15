/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas PM Save Start of Period Details')               */
/*********************************************************************/
/*                                                                   */
/*       Midas - Portfolio Management Module                         */
/*                                                                   */
/*       PMC6430 - SAVE START OF PERIOD DETAILS                      */
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
/*                      S01124             Date 22Jun94              */
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
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5)
/**********  DCL        VAR(&MEM) TYPE(*CHAR) LEN(52)                * *CPM005*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*CPM005*/
             DCL        VAR(&DAECD) TYPE(*CHAR) LEN(5)
             DCL        VAR(&DARUN) TYPE(*CHAR) LEN(5)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(3)
/**********  DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                * *CPM005*/
/**********  DCL        VAR(&USER) TYPE(*CHAR) LEN(10)               * *CPM005*/
/**********  DCL        VAR(&JOBNO) TYPE(*CHAR) LEN(6)               * *CPM005*/
/**********  DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)              * *CPM005*/
/**********  DCL        VAR(&DLIB) TYPE(*CHAR) LEN(10)               * *CPM005*/
             DCL        VAR(&EOM)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&EOY)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&ERR)  TYPE(*CHAR) LEN(1)                 /*CPM005*/
 
/**Retrieve*Job*attributes******************************************** *CPM005*/
/**********  RTVJOBA    JOB(&JOB) USER(&USER) NBR(&JOBNO)            * *CPM005*/
 
/* Global Monitor Message */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ENDTAG))
 
/**Get*system*ID*to*build*DLIB*name*********************************** *CPM005*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)         * *CPM005*/
/**********  CHGVAR     VAR(&DLIB) VALUE(&PREFIX *TCAT 'DLIB')       * *CPM005*/
 
/* Set OFF Switches */
             CHGJOB     SWS(00000000)
 
/* Send Program Message */
             SNDPGMMSG  MSG('PMC6430 - Save Start of Period +
                          Details') TOMSGQ(MRUNQ) MSGTYPE(*INFO)
 
/* End of month and end of year check */
/**********  CALL PGM(SD2000) PARM(&EOM &EOY)                          *CPM005*/
             CALL PGM(SD2000) PARM(&EOM &EOY &ERR)                    /*CPM005*/
 
/* If not End of month */
             IF         COND(&EOM *EQ 'N') THEN(DO)
 
/**********  CPYF  FROMFILE(&DLIB/PMPSTCPP) TOFILE(QTEMP/PMPSTCPP) + * *CPM005*/
/**********             MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE) * *CPM005*/
/**********  MONMSG     MSGID(CPF2817) EXEC(CLRPFM FILE(PMPSTCPP))   * *CPM005*/
             CLRPFM     FILE(PMPSTCPD)                                /*CPM005*/
 
/* Save Event Control Date as Date Extract Last Run */
             RTVDTAARA  DTAARA(PMSTAT (1 5)) RTNVAR(&DAECD)
             RTVDTAARA  DTAARA(PMSTAT (6 5)) RTNVAR(&DARUN)
 
/**********  DLTF       FILE(QTEMP/PMPORTPP)                         * *CPM005*/
/**********  MONMSG MSGID(CPF0000)                                   * *CPM005*/
/**********                                                          * *CPM005*/
/**********  CPYF       FROMFILE(PMPORTPP) TOFILE(QTEMP/PMPORTPP) +  * *CPM005*/
/**********              MBROPT(*REPLACE) CRTFILE(*YES) FMTOPT(*NONE)* *CPM005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)               * *CPM005*/
/**********                                                          * *CPM005*/
/**********  CPYF       FROMFILE(PMCNSDPP) TOFILE(QTEMP/PMPORTPP) +  * *CPM005*/
/**********               MBROPT(*ADD) FMTOPT(*MAP *DROP)            * *CPM005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)               * *CPM005*/
             CPYF       FROMFILE(PMPORTPD) TOFILE(PMMERGPD) +
                          MBROPT(*REPLACE) FMTOPT(*MAP *DROP)         /*CPM005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
                                                                      /*CPM005*/
             CPYF       FROMFILE(PMCNSDPD) TOFILE(PMMERGPD) +
                          MBROPT(*ADD) FMTOPT(*MAP *DROP)             /*CPM005*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*CPM005*/
 
/*  Open Query File to Select Record with Performance Start Date less */
/*  or equal than Event Control Date                                  */
/**********  OVRDBF     FILE(PMPORTPP) SHARE(*YES)                   * *CPM005*/
/**********  OPNQRYF    FILE((QTEMP/PMPORTPP)) +                     * *CPM005*/
/**********               FORMAT(QTEMP/PMPORTPP) QRYSLT('(PNPSDA +   * *CPM005*/
/**********               *LE "' *CAT &DAECD *CAT '") & (PNPSDA *GE +* *CPM005*/
/**********               "' *CAT &DARUN *CAT '") & (PNRECI *EQ +    * *CPM005*/
/**********               "D")') KEYFLD((PNCNUM *ASCEND) (PNPTFR +   * *CPM005*/
/**********               *ASCEND)) MAPFLD((PNPSD1 PNPSDT *ZONED 5 + * *CPM005*/
/**********               0) (PNPSDA PNPSD1 *CHAR 5))                * *CPM005*/
             OVRDBF     FILE(PMPORTPD) TOFILE(PMMERGPD) SHARE(*YES)   /*CPM005*/
             OVRDBF     FILE(PMPORTLL) TOFILE(PMMERGLL)               /*CPM005*/
             OPNQRYF    FILE((PMPORTPD)) QRYSLT('(PNPSDA *LE "' *CAT +
                          &DAECD *CAT '") & (PNPSDA *GE "' *CAT +
                          &DARUN *CAT '") & (PNRECI *EQ "D")') +
                          KEYFLD((PNCNUM *ASCEND) (PNPTFR *ASCEND)) +
                          MAPFLD((PNPSD1 PNPSDT *ZONED 5 0) (PNPSDA +
                          PNPSD1 *CHAR 5))                            /*CPM005*/
             CALL       PGM(PM6430)
/*********** DLTOVR     FILE(PMPORTPP)                               * *CPM005*/
/*********** CLOF       OPNID(PMPORTPP)                              * *CPM005*/
             CLOF       OPNID(PMPORTPD)                               /*CPM005*/
             DLTOVR     FILE(*ALL)                                    /*CPM005*/
 
/* For Database Errors Recover Data from LDA */
 ERROR:      IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/**********     RTVDTAARA  DTAARA(LDA (132 52)) RTNVAR(&MEM)         * *CPM005*/
/**********     SNDPGMMSG  MSGID(DBM0001) MSGF(CEUSRMSG)             + *CPM005*/
/**********                MSGDTA(&MEM) TOPGMQ(*EXT) TOMSGQ(MOPERQ)    *CPM005*/
/**********     SNDMSG   MSG('PMC6430 ENDED ABNORMALLY FOR JOB ' *CAT +*CPM005*/
/**********                 &JOBNO *TCAT '/' *TCAT &USER *TCAT '/' + * *CPM005*/
/**********                 *TCAT &JOB *TCAT '.') TOMSGQ(MOPERQ)     * *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0001) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* For File in Balance Error */
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
/**********     CHGVAR VAR(&MEM) VALUE('PMC6430 - FILE CONTROLS OUT +* *CPM005*/
/**********               OF BALANCE')                               * *CPM005*/
/**********     SNDPGMMSG MSG(&MEM) TOPGMQ(*EXT) TOMSGQ(MRUNQ MOPERQ)* *CPM005*/
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)          /*CPM005*/
                SNDPGMMSG  MSGID(PEM0002) MSGF(PMUSRMSG) MSGDTA(&MEM)  +
                          TOMSGQ(MOPERQ MRUNQ)                        /*CPM005*/
                GOTO       CMDLBL(ENDPGM)
             ENDDO
 
/* Copy extracted data from workfile to master file */
/**********  CPYF       FROMFILE(PMPSTCPP) TOFILE(PMPSTMPP) +        * *CPM005*/
/**********               MBROPT(*ADD) FMTOPT(*MAP *DROP)            * *CPM005*/
             OPNQRYF    FILE((PMPSTCPD)) FORMAT(PMPSTMQ0) +
                          MAPFLD((QFCNUM GFCNUM) (QFPTFR GFPTFR) +
                          (QFINNR GFINNR) (QFVALG GFVALG) (QFCCY1 +
                          GFCCY1) (QFCDP1 GFCDP1) (QFCNTR GFCNTR) +
                          (QFLIND GFLIND) (QFTDSS GFTDSS) (QFAMT1 +
                          GFAMT1) (QFACIS GFACIS) (QFPLFX GFPLFX) +
                          (QFMFXR GFMFXR) (QFMFMD GFMFMD) (QFMPRC +
                          GFMPRC) (QFTRNB GFTRNB) (QFMODI GFMODI) +
                          (QFBYSF GFBYSF) (QFFOIS GFFOIS) (QFTXT2 +
                          GFTXT2) (QFSTMN GFSTMN) (QFPPRC GFPPRC) +
                          (QFMFXD GFMFXD) (QFNMDP GFNMDP) (QFSPBS +
                          GFSPBS) (QFTKDM GFTKDM) (QFMNPF GFMNPF) +
                          (QFTKVL GFTKVL) (QFFPSI GFRESH) (QFVDAT +
                          GFVDAT) (QFMVPC GFMVPC))                    /*CPM005*/
             CPYFRMQRYF FROMOPNID(PMPSTCPD) TOFILE(PMPSTMQ0) +
                          MBROPT(*ADD)  FMTOPT(*NOCHK)                /*CPM005*/
             CLOF       OPNID(PMPSTCPD)                               /*CPM005*/
                                                                      /*CPM005*/
             CLRPFM     FILE(PMMERGPD)                                /*CPM005*/
             ENDDO
 
             GOTO       CMDLBL(ENDPGM)
 
ENDTAG:      DMPCLPGM
/***ENDPGM:**    ENDPGM                                              * *CPM005*/
ENDPGM:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM                                                   /*CPM005*/
