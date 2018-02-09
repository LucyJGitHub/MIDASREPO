/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas RE A/C'S TO MAKE INACT (LIST+OPTION)')          */
/*********************************************************************/
/*                                                                   */
/*       Midas   Retail Module                               */
/*                                                                   */
/*       REC3777 - ACCOUNTS TO BE TRANSFERRED TO INACTIVE STATUS     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CRE083AV           Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      116774             Date 18Feb98              */
/*                      S01408             DATE 11MAY95              */
/*                      069698             DATE 19APR94              */
/*                      S01413 *CREATE     DATE 13APR93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       CRE083AV - COB Restructure - RE COB Optimisation Phase 1    */
/*       116774  - No records selected by OPNQRYF because file       */
/*                 SDBANKPD in QTEMP was empty                       */
/*       S01408  - Addition of core hook REC3777MP1                  */
/*                 Addition of core hook REC3777MP2                  */
/*       069698  -  Problem with CRTDUPOBJ because file already      */
/*                  exists. Program can be called several times by   */
/*                  SPF within same job, once for each branch.       */
/*       S01413  -  Retail 3 Incorporation.                          */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CNAM &CSEQ &STAT &RSEQ &RLEV &RENT)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&STAT)    TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM)     TYPE(*CHAR) LEN(50)
             DCL        VAR(&FROMLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&TOLIB)   TYPE(*CHAR) LEN(10)
             DCL        VAR(&PRE)     TYPE(*CHAR) LEN(2)
             DCL        VAR(&LDA)     TYPE(*CHAR) LEN(256)
             DCL        VAR(&SDSTAT)  TYPE(*CHAR) LEN(256)
             DCL        VAR(&CNAM)  TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ)  TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&STATUS)  TYPE(*CHAR) LEN(1) VALUE(' ')  */                 /*CRE083AV*/
             DCL        VAR(&RSEQ)  TYPE(*CHAR) LEN(5)
             DCL        VAR(&RLEV)  TYPE(*CHAR) LEN(1)
             DCL        VAR(&RENT)  TYPE(*CHAR) LEN(3)
             DCL        VAR(&ERROR) TYPE(*CHAR) LEN(1) VALUE(' ')                       /*CRE083AV*/
/*/COPY WNCPYSRC,REC3777001                                          */
/* Journalling variables */                                                             /*CRE083AV*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CRE083AV*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(25)                                 /*CRE083AV*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CRE083AV*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CRE083AV*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CRE083AV*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CRE083AV*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CRE083AV*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CRE083AV*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AV*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CRE083AV*/
/* Start Journalling */                                                                 /*CRE083AV*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CRE083AV*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                           *CAT &CSEQA)                                                 /*CRE083AV*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CRE083AV*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) FLAG('S') +
                           TEXT(&STEXT)                                                 /*CRE083AV*/
/**/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STATUS)        */                 /*CRE083AV*/
 
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
/**/
             SNDPGMMSG  MSG('REC3777 - Transfer of accounts to +
                          Inactive Status') TOMSGQ(MRUNQ)
/**/
             CHGVAR     VAR(&PRE) VALUE(%SST(&SDSTAT 6 2))
             CHGVAR     VAR(&TOLIB) VALUE(&PRE *TCAT 'DPLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3777MP2                                          */
                                                                      /*S01408*/
/**/
/*  BLOCK FILES   */
/**/
             OVRDBF     FILE(ACORDAB) SEQONLY(*YES 100)
             OVRDBF     FILE(ACCNTAB) SEQONLY(*YES 100)
/**/
             IF COND(&STAT *EQ 'I') THEN(CHGJOB SWS(10000000))
             ELSE CMD(DO)
               CHGJOB SWS(00000000)
/**/
/**********  IF         COND(&STATUS *EQ 'N') THEN(DO)               */                 /*CRE083AV*/
/**/
/**********      DLTF       FILE(XACCNTAA)                           */                 /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                           */                 /*CRE083AV*/
/**********      DLTF       FILE(XACCNTAB)                           */                 /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                           */                 /*CRE083AV*/
/**********      DLTF       FILE(XACCNTAC)                           */                 /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                           */                 /*CRE083AV*/
/**/
/**********      CPYF       FROMFILE(ACCNTAA) TOFILE(&TOLIB/XACCNTAA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*/              /*CRE083AV*/
/**********      MONMSG     (CPF2817) CMPDTA(CPF2869)                */                 /*CRE083AV*/
/**/
/**********      CPYF       FROMFILE(ACCNTAC) TOFILE(&TOLIB/XACCNTAC) +
                            MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*/              /*CRE083AV*/
/**********      MONMSG     (CPF2817) CMPDTA(CPF2869)                */                 /*CRE083AV*/
/**/
/**********      CPYF       FROMFILE(ACCNTAB) TOFILE(&TOLIB/XACCNTAB) +
                            MBROPT(*REPLACE) FMTOPT(*NONE) CRTFILE(*YES)*/              /*CRE083AV*/
/**********      MONMSG     (CPF2817) CMPDTA(CPF2869)                */                 /*CRE083AV*/
/**/
/**********  CHGVAR     VAR(&STATUS) VALUE('Y')                      */                 /*CRE083AV*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)        */                 /*CRE083AV*/
/**********    ENDDO                                                 */                 /*CRE083AV*/
/**/
/**********    ELSE CMD(DO)                                          */                 /*CRE083AV*/
/**********      RMVM       FILE(ACCNT) MBR(ACCNT)                                      /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                                              /*CRE083AV*/
/**********      RMVM       FILE(ACNUM) MBR(ACNUM)                                      /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                                              /*CRE083AV*/
/**********      RMVM       FILE(SADETC) MBR(SADETC)                                    /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                                              /*CRE083AV*/
/**/
/**********      CPYF       FROMFILE(XACCNTAA) TOFILE(ACCNTAA) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)           */                 /*CRE083AV*/
/**********      MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM ACCNTAA)                     */                 /*CRE083AV*/
/**********      CPYF       FROMFILE(XACCNTAC) TOFILE(ACCNTAC) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)           */                 /*CRE083AV*/
/**********      MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM ACCNTAC)                     */                 /*CRE083AV*/
/**********      CPYF       FROMFILE(XACCNTAB) TOFILE(ACCNTAB) +
                            MBROPT(*REPLACE) FMTOPT(*NONE)           */                 /*CRE083AV*/
/**********      MONMSG     (CPF2817) CMPDTA(CPF2869) +
                            EXEC(CLRPFM ACCNTAB)                     */                 /*CRE083AV*/
/**/
/**********      ADDLFM     FILE(ACCNT) MBR(ACCNT)                   */                 /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                           */                 /*CRE083AV*/
/**********      ADDLFM     FILE(ACNUM) MBR(ACNUM)                   */                 /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                           */                 /*CRE083AV*/
/**********      ADDLFM     FILE(SADETC) MBR(SADETC)                 */                 /*CRE083AV*/
/**********      MONMSG     MSGID(CPF0000)                           */                 /*CRE083AV*/
/**********    ENDDO                                                 */                 /*CRE083AV*/
/**/
             ENDDO
/**/
             DLTOVR     FILE(ACORDAB)
             DLTOVR     FILE(ACCNTAB)
             CHGVAR     VAR(&FROMLIB) VALUE(&PRE *TCAT 'DMLIB')
                                                                      /*S01408*/
/*/COPY WNCPYSRC,REC3777MP1                                          */
                                                                      /*S01408*/
/************CRTDUPOBJ**OBJ(SDBANKPD)*FROMLIB(&FROMLIB)*+***********/ /*069698*/
/*************************OBJTYPE(*FILE)**TOLIB(QTEMP)**************/ /*069698*/
             CHKOBJ     OBJ(QTEMP/SDBANKPD) OBJTYPE(*FILE)            /*069698*/
/*********** MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(SDBANKPD) +
                          FROMLIB(&FROMLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP))                  *******069698**116774*/
             MONMSG     MSGID(CPF9801) EXEC(CRTDUPOBJ OBJ(SDBANKPD) +
                          FROMLIB(&FROMLIB) OBJTYPE(*FILE) +
                          TOLIB(QTEMP) DATA(*YES))                    /*116774*/
/**/                                                                  /*069698*/
             OVRDBF     FILE(SDBANKPD) TOFILE(QTEMP/SDBANKPD) +
                          SHARE(*YES)                                 /*069698*/
/**********  OVRDBF     FILE(SAXFI) TOFILE(ACCNTAB) SHARE(*YES)                         /*CRE083AV*/
/**********  OPNQRYF    FILE((ACCNTAB) (CLINTCB) (SDBANKPD) +
                          (SDRETLPD)) FORMAT(SAXFI AXFIAXF) +
                          QRYSLT('(ACCNTAB/RECI *EQ "D" *AND +
                          ACCNTAB/ATYP *EQ "R" *AND CALC *GT +
                          ACCNTAB/LACD *AND CALC *GT ACCNTAB/DACO ) +
                          *AND (ACCNTAB/RETB *EQ %RANGE(X"00" +
                          X"07") *OR ACCNTAB/RETB *EQ  %RANGE(X"10" +
                          X"17") *OR ACCNTAB/RETB *EQ  %RANGE(X"20" +
                          X"27") *OR ACCNTAB/RETB *EQ  %RANGE(X"30" +
                          X"37") *OR ACCNTAB/RETB *EQ  %RANGE(X"40" +
                          X"47") *OR ACCNTAB/RETB *EQ  %RANGE(X"50" +
                          X"57") *OR ACCNTAB/RETB *EQ  %RANGE(X"60" +
                          X"67") *OR ACCNTAB/RETB *EQ  %RANGE(X"70" +
                          X"77") *OR ACCNTAB/RETB *EQ  %RANGE(X"80" +
                          X"87") *OR ACCNTAB/RETB *EQ  %RANGE(X"90" +
                          X"97") *OR ACCNTAB/RETB *EQ  %RANGE(X"A0" +
                          X"A7") *OR ACCNTAB/RETB *EQ  %RANGE(X"B0" +
                          X"B7") *OR ACCNTAB/RETB *EQ  %RANGE(X"C0" +
                          X"C7") *OR ACCNTAB/RETB *EQ  %RANGE(X"D0" +
                          X"D7") *OR ACCNTAB/RETB *EQ  %RANGE(X"E0" +
                          X"E7") *OR ACCNTAB/RETB *EQ  %RANGE(X"F0" +
                          X"F7"))') KEYFLD((ACCNTAB/BRCA) +
                          (CLINTCB/ACOC) (ACCNTAB/CCY) +
                          (ACCNTAB/CNUM) (ACCNTAB/ACOD) +
                          (ACCNTAB/ACSQ)) JFLD((ACCNTAB/CNUM +
                          CLINTCB/CNUM)) MAPFLD((RECI +
                          'ACCNTAB/RECI') (BRCA 'ACCNTAB/BRCA') +
                          (ACOC 'CLINTCB/ACOC') (CNUM +
                          'ACCNTAB/CNUM') (CCY 'ACCNTAB/CCY') (ACOD +
                          'ACCNTAB/ACOD') (ACSQ 'ACCNTAB/ACSQ') +
                          (ACNO 'ACCNTAB/ACNO') (CRNM +
                          'CLINTCB/CRNM') (GRBL 'ACCNTAB/LDBL') +
                          (NETB 'ACCNTAB/CLBL') (LACD +
                          'ACCNTAB/LACD') (ZZ002 'ACCNTAB/ZZ002') +
                          (CALC 'SDBANKPD/BJRDNB - +
                          SDRETLPD/BMNDBI' *CALC)) IGNDECERR(*NO)    */                 /*CRE083AV*/
/**/
             CALL       PGM(RE377801) PARM(&ERROR)                                      /*CRE083AV*/
             IF COND(&ERROR *NE 'Y') THEN(DO)                                           /*CRE083AV*/
             CALL       PGM(RE3778) PARM(&RSEQ)
             ENDDO                                                                      /*CRE083AV*/
/**********  CLOF       OPNID(ACCNTAB)                               */                 /*CRE083AV*/
             DLTOVR     FILE(SDBANKPD)                                /*069698*/
/**/
             IF COND(%SWITCH(XXXXXX00)) THEN(DO)
/**********  CHGVAR     VAR(&STATUS) VALUE('N')                      */                 /*CRE083AV*/
/**********  CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STATUS)        */                 /*CRE083AV*/
/**/
/**********     DLTF       FILE(XACCNTAA)                            */                 /*CRE083AV*/
/**********     MONMSG     MSGID(CPF0000)                            */                 /*CRE083AV*/
/**********     DLTF       FILE(XACCNTAB)                            */                 /*CRE083AV*/
/**********     MONMSG     MSGID(CPF0000)                            */                 /*CRE083AV*/
/**********     DLTF       FILE(XACCNTAC)                            */                 /*CRE083AV*/
/**********     MONMSG     MSGID(CPF0000)                            */                 /*CRE083AV*/
                GOTO       CMDLBL(END)                                                  /*CRE083AV*/
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR     VAR(&MEM) VALUE(%SST(&LDA 134 50))
/**/
                SNDPGMMSG  MSGID(MEM0001) MSGF(REUSRMSG) MSGDTA(&MEM) +
                           TOPGMQ(*EXT) TOMSGQ(MOPERQ)
/**/
             ENDDO
/**/
             IF COND(%SWITCH(XXXXXXX1)) THEN(DO)
                SNDPGMMSG  MSG('FILE OUT OF BALANCE - RE3778') +
                           TOMSGQ(MOPERQ)
             ENDDO
 
/* Begin recovery from error */                                                         /*CRE083AV*/
/* Retrieve attributes of current job */                                                /*CRE083AV*/
                                                                                        /*CRE083AV*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CRE083AV*/
                                                                                        /*CRE083AV*/
/* Retrieve the most recent journal entry sequence number for the */                    /*CRE083AV*/
/* specific job. */                                                                     /*CRE083AV*/
                                                                                        /*CRE083AV*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                           TOENT(*FIRST) SEARCH(*DESCEND) +
                           JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                           RTNRCV(&SJRNRCVR)                                            /*CRE083AV*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CRE083AV*/
                  CHGVAR     VAR(&START) VALUE(0)                                       /*CRE083AV*/
             ENDDO                                                                      /*CRE083AV*/
                                                                                        /*CRE083AV*/
/* Determine starting journal sequence number of current job. */                        /*CRE083AV*/
/**/                                                                                    /*CRE083AV*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CRE083AV*/
                                                                                        /*CRE083AV*/
/* Remove journal changes. */                                                           /*CRE083AV*/
                                                                                        /*CRE083AV*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                           THEN(DO)                                                     /*CRE083AV*/
                  RMVJRNCHG  JRN(ICJRN) FILE((ACCNTAA) (ACCNTAB) +
                                (ACCNTAC)) +
                                FROMENT(&START) TOENT(&FINISH) +
                                RCVRNG(&SJRNRCVR &FJRNRCVR)                             /*CRE083AV*/
                  MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                     /*CRE083AV*/
             ENDDO                                                                      /*CRE083AV*/
                                                                                        /*CRE083AV*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
END:         ENDPGM
