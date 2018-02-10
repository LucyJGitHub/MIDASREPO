/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas MC Delete man accs for a ctl group')            */
/*********************************************************************/
/*                                                                   */
/*   Midas - Management Accounts Module                              */
/*                                                                   */
/*   MCC0203 - Delete Management Accounts for Deleted Control Group  */
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
/*       Prev Amend No. 121615             Date 01Jun98              */
/*                      CED002             Date 20Jun97              */
/*                      S01419             DATE 14MAY93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   121615 - Do not retrieve MIDASQ dtaara or run MIDASQ pgms if    */
/*            MIDASQ is not switched on                              */
/*   CED002 - ED Enhancement for GIB                                 */
/*   S01419 - Maintain Logicals over APOSTPD/GLACPHPD                */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&CGCD)
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
                          /* Copyright statement */
             DCL        VAR(&CGCD) TYPE(*CHAR) LEN(2)
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(10)                /*S01419*/
             DCL        VAR(&PGMDTA) TYPE(*CHAR) LEN(10)              /*S01419*/
             DCL        VAR(&PGMLIB) TYPE(*CHAR) LEN(10)              /*S01419*/
             DCL        VAR(&PARM0) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM6) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM7) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM8) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM9) TYPE(*CHAR) LEN(4)                /*S01419*/
             DCL        VAR(&PARM10) TYPE(*CHAR) LEN(4)               /*S01419*/
             DCL        VAR(&BGNZST) TYPE(*CHAR) LEN(1)               /*CED002*/
             DCL        VAR(&XGRPCD) TYPE(*CHAR) LEN(10)              /*CED002*/
             DCL        VAR(&RTNCD) TYPE(*CHAR) LEN(7)                /*CED002*/
             DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                /*CED002*/
             DCL        VAR(&WRTCD) TYPE(*CHAR) LEN(1)                /*CED002*/
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200)              /*CED002*/
             DCL        VAR(&SDMMOD) TYPE(*CHAR) LEN(128)             /*121615*/
             DCL        VAR(&MIDASQ) TYPE(*CHAR) LEN(1)               /*121615*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*FIRST +
                          ')                                          /*121615*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7) VALUE(' ')      /*121615*/
 
/* Global error message                                              */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/* Access PF/SDMMODPD to determine which modules are live             /*121615*/
/**/                                                                  /*121615*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &SDMMOD)       /*121615*/
/**/                                                                  /*121615*/
/* Database error                                                     /*121615*/
/**/                                                                  /*121615*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*121615*/
               SNDPGMMSG  MSG('Error on access to ICD file +
                            AOMMODPD') TOMSGQ(MOPERQ)                 /*121615*/
               GOTO       CMDLBL(ABNOR)                               /*121615*/
             ENDDO                                                    /*121615*/
             CHGVAR     VAR(&MIDASQ) VALUE(%SST(&SDMMOD 53 1)) +
                                                                      /*121615*/
/* Build MQ/Program library                                           */
             IF         COND(&MIDASQ *EQ 'Y') THEN(DO)                /*121615*/
 
/* Build MQ/Program library                                        */ /*S01419*/
                                                                      /*S01419*/
             RTVDTAARA  DTAARA(MQLIBS (1 10)) RTNVAR(&PGMDTA)         /*S01419*/
             RTVDTAARA  DTAARA(&PGMDTA/O#XA01 (1 10)) RTNVAR(&PGMLIB) /*S01419*/
                ENDDO                                                 /*121615*/
 
/* Determine status of Export Data Module Flag                         *CED002*/
                                                                      /*CED002*/
             CALL PGM(AOMMODR0) PARM('       ' '*FIRST ' &DSFDY)      /*CED002*/
             CHGVAR     VAR(&BGNZST) VALUE(%SST(&DSFDY 99 1))         /*CED002*/
                                                                      /*CED002*/
/* If ED module flag is on then access Drip Feed Transfer File     */ /*CED002*/
                                                                      /*CED002*/
             IF         COND(&BGNZST *EQ 'Y') THEN(DO)                /*CED002*/
                                                                      /*CED002*/
               CHGVAR   VAR(&XGRPCD) VALUE(&CGCD *CAT '        ')     /*CED002*/
                                                                      /*CED002*/
               CALL     PGM(AODFTFR0) PARM('GLHIBLPD  ' &XGRPCD +
                          'MCC0203   ' &RTNCD &FMT)                   /*CED002*/
                                                                      /*CED002*/
/* If file transfer flag for GLHIBLPD is on then call ED0400       */ /*CED002*/
/* to generate a drip feed extract of deleted management accounts  */ /*CED002*/
/* and perform any necessary error processing                      */ /*CED002*/
                                                                      /*CED002*/
                 IF     COND(&RTNCD *EQ '       ') THEN(DO)           /*CED002*/
                                                                      /*CED002*/
                 OVRDBF FILE(GLHIBLPD) MBR(&CGCD)                     /*CED002*/
                                                                      /*CED002*/
                 CALL   PGM(ED0400) PARM(&XGRPCD &WRTCD)              /*CED002*/
                                                                      /*CED002*/
                 IF     COND(&WRTCD *NE ' ') THEN(DO)                 /*CED002*/
                                                                      /*CED002*/
                   CHGJOB SWS(XXXXXX11)                               /*CED002*/
                   GOTO   CMDLBL(ABNOR)                               /*CED002*/
                                                                      /*CED002*/
                 ENDDO                                                /*CED002*/
                                                                      /*CED002*/
                 DLTOVR FILE(GLHIBLPD)                                /*CED002*/
                                                                      /*CED002*/
               ENDDO                                                  /*CED002*/
                                                                      /*CED002*/
             ENDDO                                                    /*CED002*/
                                                                      /*CED002*/
/* Remove members from the Management Accounts files                 */
             RMVM       FILE(GLHIBLL0) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLHIBLL1) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLHIBLL2) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLHIBLL3) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLHIBLL4) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLHIBLPD) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
 
             RMVM       FILE(GLAVBLL0) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLAVBLL1) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLAVBLL2) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLAVBLL3) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
             RMVM       FILE(GLAVBLPD) MBR(&CGCD)
             MONMSG     MSGID(CPF7310 CPF5815)                        /*S01419*/
 
             CHGVAR     VAR(&FILE) VALUE(&CGCD *TCAT 'APOST#')        /*S01419*/
             DLTF       FILE(&FILE)                                   /*S01419*/
             MONMSG     MSGID(CPF2105)                                /*S01419*/
                                                                      /*S01419*/
             CHGVAR     VAR(&FILE) VALUE(&CGCD *TCAT 'HPOST#')        /*S01419*/
             DLTF       FILE(&FILE)                                   /*S01419*/
             MONMSG     MSGID(CPF2105)                                /*S01419*/
                                                                      /*S01419*/
                                                                      /*S01419*/
             IF         COND(&MIDASQ *EQ 'Y') THEN(DO)                /*121615*/
/* Add Logicals to MQ subset logic                                    /*S01419*/
             CALL       PGM(&PGMLIB/MQ562XC) PARM('D' &CGCD &PGMDTA +
                          &PGMLIB &PARM0 &PARM1 &PARM2 &PARM3 +
                          &PARM4 &PARM5 &PARM6 &PARM7 &PARM8 &PARM9 +
                          &PARM10)                                    /*S01419*/
                                                                      /*S01419*/
                ENDDO                                                 /*121615*/
             GOTO       CMDLBL(ENDPGM)
 
 ABNOR:      SNDPGMMSG  MSG('Management Accounts Deletion ENDED +
                          ABNORMALLY') TOMSGQ(MOPERQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
ENDPGM: ENDPGM
