/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas MC Daily Primary Group Update')                 */
/*********************************************************************/
/*                                                                   */
/*       Midas - Management Accounts Module                          */
/*                                                                   */
/*       MCC0350 - Primary Management A/c Update                     */
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
/*       Prev Amend No. 130068             Date 30Apr99              */
/*                      CED002             Date 19Jun97              */
/*                      CMC001 *CREATE     Date 18MAR96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*   130068 - Dbase error in MCPOSTL4, at 05, in pgm MC0400.         */
/*            (Same cause of the problem when new period is not      */
/*            being generated.)                                      */
/*   CED002 - Midas ED Enhancements                                  */
/*   CMC001 - Created for Management Accounts                        */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&POST &CNAM &CSEQ)
/**/
/* Copyright statement defination  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/* */
/* Declare variables */
/* */
             DCL        VAR(&POST) TYPE(*CHAR) LEN(1)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
             DCL        VAR(&BUSY) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&GROUPCODE) TYPE(*CHAR) LEN(2) /*Group +
                          Code*/
             DCL        VAR(&PERIODSET) TYPE(*CHAR) LEN(1) +
                          /*Period Set*/
             DCL        VAR(&POSTINGBAS) TYPE(*CHAR) LEN(1) +
                          /*Posting Basis*/
             DCL        VAR(&STARTDATE) TYPE(*CHAR) LEN(5) /*Start +
                          Date*/
             DCL        VAR(&SECTIONS) TYPE(*CHAR) LEN(8) /*Sections*/
             DCL        VAR(&ANALYSIS) TYPE(*CHAR) LEN(10) /*Analysis*/
             DCL        VAR(&STARTTIME) TYPE(*CHAR) LEN(6) /*Start +
                          Time*/
             DCL        VAR(&RETURNCODE) TYPE(*CHAR) LEN(1) /*Return +
                          Code*/
             DCL        VAR(&I) TYPE(*DEC) LEN(3 0) VALUE(1) /* +
                          Index for key sort */
             DCL        VAR(&J) TYPE(*DEC) LEN(3 0) /* Index for key +
                          sort */
             DCL        VAR(&I2) TYPE(*DEC) LEN(3 0) /* Index for +
                          key sort */
             DCL        VAR(&J2) TYPE(*DEC) LEN(3 0) /* Index for +
                          key sort */
             DCL        VAR(&KU) TYPE(*CHAR) LEN(40) VALUE('ACODCCY +
                          BRCACNUMACSQPRFCBOKCOTTPOTSTASOC') /* Key +
                          array - not sorted */
             DCL        VAR(&KS) TYPE(*CHAR) LEN(40) /* Key array - +
                          sorted */
             DCL        VAR(&KEYFLD) TYPE(*CHAR) LEN(100) /* Key +
                          list for OPNQRYF */
             DCL        VAR(&OPNQRYF) TYPE(*CHAR) LEN(1000) +
                          /* CMD String for QCMDEXC */
             DCL        VAR(&DSFDY) TYPE(*CHAR) LEN(200) /*        +
                          Return string */
             DCL        VAR(&MCPOST) TYPE(*CHAR) LEN(10) +
                          VALUE('MCPOSTL')
/*/COPY WNCPYSRC,MCH00006                                            */
/**/
/* Global error message                                              */
/**/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
/**/
/* Create LDA if it does not already exist */
/**/
             CHKOBJ     OBJ(LDA) OBJTYPE(*DTAARA)
             MONMSG     MSGID(CPF9801) EXEC(CRTDTAARA +
                          DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('MIDAS SD AS400 LOCAL +
                          DATA AREA EQUIVALENT'))
/**/
/* Send Message to MRUNQ */
/* */
             SNDPGMMSG  MSG('MCC0350 - Primary Mgmt A/c Group +
                          Update') TOMSGQ(MRUNQ)
/* */
/* Set Job Switch */
/**/
             CHGJOB     SWS(00000000)
/**/
/* Access PCA ICD for Primary Mgmt A/c Control Group */
/**/
             CALL       PGM(AOPCACR0) PARM(&RETURNCODE '*FIRST' &DSFDY)
             CHGVAR     VAR(&GROUPCODE) VALUE(%SST(&DSFDY 15 2))
 
/* Call the Update Control Group program                             */
/* Note that only &GROUPCODE is passed in as non blank, all the      */
/* rest are filled by MC0264                                         */
/*/COPY WNCPYSRC,MCH00007                                            */
 
             CALL       PGM(MC0264) PARM(&GROUPCODE &PERIODSET +
                          &POSTINGBAS &STARTDATE &SECTIONS +
                          &ANALYSIS &STARTTIME)
 
/* Check for Database error                                        */
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))
/* */
/* Retrieve recovery flag */
/* */
             CALL       PGM(CB0160) PARM(&CNAM &CSEQ &BUSY)
/* */
/* If restart, Restore for Security Copies  */
/* */
             IF         COND(&BUSY = 'Y') THEN(DO)
 
             CPYF       FROMFILE(XGLHIBLPD) TOFILE(GLHIBLPD) +
                          FROMMBR(&GROUPCODE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GLHIBLPD) MBR(&GROUPCODE))
 
             CPYF       FROMFILE(XGLAVBLPD) TOFILE(GLAVBLPD) +
                          FROMMBR(&GROUPCODE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(GLAVBLPD) MBR(&GROUPCODE))
/*/COPY WNCPYSRC,MCH00008                                            */
 
             ENDDO
 
             ELSE       CMD(DO)
/* ELSE,  Remove members from security copy PFs and take a copy */
 
             RMVM       FILE(XGLHIBLL0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLL4) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLHIBLPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL0) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL1) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL2) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLL3) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
             RMVM       FILE(XGLAVBLPD) MBR(*ALL)
             MONMSG     MSGID(CPF7301 CPF7303)
 
/* Copy files to security copy files                                 */
 
             CPYF       FROMFILE(GLHIBLPD) TOFILE(XGLHIBLPD) +
                          FROMMBR(&GROUPCODE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XGLHIBLPD) MBR(&GROUPCODE))
             CPYF       FROMFILE(GLAVBLPD) TOFILE(XGLAVBLPD) +
                          FROMMBR(&GROUPCODE) TOMBR(*FROMMBR) +
                          MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(XGLAVBLPD) MBR(&GROUPCODE))
/*/COPY WNCPYSRC,MCH00009                                            */
 
             ENDDO
 
/* Override to member for the Group Code */
 
             OVRDBF     FILE(GLHIBLPD) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL0) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL1) MBR(&GROUPCODE)                /*CED002*/
             OVRDBF     FILE(GLHIBLL3) MBR(&GROUPCODE)
             OVRDBF     FILE(GLHIBLL4) MBR(&GROUPCODE)
 
             OVRDBF     FILE(GLAVBLPD) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL0) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL1) MBR(&GROUPCODE)
             OVRDBF     FILE(GLAVBLL3) MBR(&GROUPCODE)
 
/* Sort keys into order specified in &ANALYSIS                            */
 
 LOOP1:      IF         COND(&I *GT 10) THEN(GOTO CMDLBL(EXIT1))
             IF         COND(%SST(&ANALYSIS &I 1) *NE ' ') THEN(DO)
                CHGVAR     VAR(&J) VALUE(%SST(&ANALYSIS &I 1))
                CHGVAR     VAR(&I2) VALUE(1 + ((&I - 1) * 4))
                CHGVAR     VAR(&J2) VALUE(1 + (&J * 4))
                CHGVAR     VAR(%SST(&KS &J2 4)) VALUE(%SST(&KU &I2 4))
                ENDDO
             CHGVAR     VAR(&I) VALUE(&I + 1)
             GOTO       CMDLBL(LOOP1)
 
/* Set up keylist parameter for OPNQRYF                              */
 
 EXIT1:      CHGVAR     VAR(&I) VALUE(1)
 LOOP2:      IF         COND(&I *GT 40) THEN(GOTO CMDLBL(EXIT2))
             IF         COND(%SST(&KS &I 4) *NE '    ') THEN(CHGVAR +
                          VAR(&KEYFLD) VALUE(&KEYFLD *BCAT '(' +
                          *TCAT %SST(&KS &I 4) *TCAT ')'))
             CHGVAR     VAR(&I) VALUE(&I + 4)
             GOTO       CMDLBL(LOOP2)
 
 EXIT2:      CLOF       OPNID(UPDBALPD)
             MONMSG     MSGID(CPF4520)
 
/* Set up Input File */
             IF         COND(&POST *EQ '1' *OR &POST *EQ '5') +
                          THEN(CHGVAR VAR(&MCPOST) VALUE('MCPST1PD'))
             IF         COND(&POST *EQ '2') +
                          THEN(CHGVAR VAR(&MCPOST) VALUE('MCPST2PD'))
             IF         COND(&POST *EQ '3') +
                          THEN(CHGVAR VAR(&MCPOST) VALUE('MCPST3PD'))
 
/* Set up OPNQRYF */
/* Multiply Postings by Periods affected */
 
             IF         COND(&POST *EQ '1') THEN(DO)
/*********** CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPERDPD) + *130068*/
/***********              (' *TCAT &MCPOST *TCAT ')) +                 *130068*/
/***********              FORMAT(UPDBALPD) QRYSLT(''PAMT *NE 0 *AND +  *130068*/
/***********              DTPSTC *EQ PSET *AND DTCLSD *LT 1 +          *130068*/
/***********              *AND PDTM *GT DTTM'')')                      *130068*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPERDPD) +
                          (' *TCAT &MCPOST *TCAT ')) FORMAT(UPDBALPD) +
                          QRYSLT(''DTPSTC *EQ PSET *AND DTCLSD *LT 1 +
                          *AND PDTM *GT DTTM'')')                     /*130068*/
             ENDDO
             ELSE       CMD(DO)
/*********** CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPERDPD) +  130068*/
/***********              (' *TCAT &MCPOST *TCAT ')) +                  130068*/
/***********              FORMAT(UPDBALPD) QRYSLT(''PAMT *NE 0 *AND +   130068*/
/***********              DTPSTC *EQ PSET *AND DTCLSD *LT 1 +           130068*/
/***********              *AND PDTM *GE DTTM'')')                       130068*/
             CHGVAR     VAR(&OPNQRYF) VALUE('OPNQRYF FILE((GLPERDPD) +
                          (' *TCAT &MCPOST *TCAT ')) +
                          FORMAT(UPDBALPD) +
                          QRYSLT(''DTPSTC *EQ PSET *AND DTCLSD *LT 1 +
                          *AND PDTM *GE DTTM'')')                     /*130068*/
             ENDDO
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT 'KEYFLD(' +
                          *TCAT &KEYFLD *TCAT '(CPNB) (EVDT))')
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          'JFLD((DTEPDD EVDT *GE) (SPDD EVDT *LE)) +
                          JDFTVAL(*NO) MAPFLD(')
 
             IF         COND(%SST(&ANALYSIS 3 1) *EQ ' ') +
                          THEN(CHGVAR VAR(&OPNQRYF) VALUE(&OPNQRYF +
                          *BCAT '(BRCA ''''''   '''''')'))
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT '(DTTM +
                          ''' *TCAT &STARTDATE *TCAT &STARTTIME +
                          *TCAT ''' *ZONED 11 0)')
 
             CHGVAR     VAR(&OPNQRYF) VALUE(&OPNQRYF *BCAT +
                          '(CPNB ''DTPDCT *CAT DTPDYR *CAT +
                          DTPDNY'') (PSET ''''''' *CAT &PERIODSET +
                          *CAT ''''''' *CHAR 1) (SPDD ''DTSPDD * +
                          %MIN(%MAX(DTRPDN 0) 1)'' *DEC 5 0)) +
                          ALWCPYDTA(*OPTIMIZE) OPNID(UPDBALPD)')
 
             CALL       PGM(QCMDEXC) PARM(&OPNQRYF 1000)
 
/* Set busy flag */
             CHGVAR     VAR(&BUSY) VALUE('Y')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/* Call Update Management Accounts to Current End of Period program  */
             CALL       PGM(MC0230) PARM(&GROUPCODE &RETURNCODE)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Call Update Management Accounts with Movements program            */
 
             OVRDBF     FILE(UPDBALPD) TOFILE(GLPERDPD) SHARE(*YES)
             CALL       PGM(MC0235) PARM(&GROUPCODE &RETURNCODE)
             DLTOVR     FILE(UPDBALPD)
             MONMSG     MSGID(CPF9841)
 
/* Check for database error                                          */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                   RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                   SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                              TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                   GOTO       CMDLBL(ERROR)
             ENDDO
 
/* Reset busy flag as run successful */
             CHGVAR     VAR(&BUSY) VALUE('N')
             CALL       PGM(CB0150) PARM(&CNAM &CSEQ &BUSY)
 
/* Clear input files                 */
             CLRPFM     FILE(MCFREXPD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(MCPCACPD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(MCPCBLPD)
             MONMSG     MSGID(CPF0000)
             CLRPFM     FILE(MCMOVEPD)
             MONMSG     MSGID(CPF0000)
 
/* Delete all file overrides                                         */
             DLTOVR     FILE(*ALL)
 
             GOTO       CMDLBL(END)
 
 ERROR:      CHGJOB     SWS(XXXXXX11)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             SNDPGMMSG  MSG('Daily Primary Mgmt A/c Group Update - +
                          ENDED ABNORMALLY') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DMPCLPGM
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
