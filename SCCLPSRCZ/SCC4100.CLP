/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Performs override for branch/core files')    */
/*********************************************************************/
/*                                                                   */
/*       Midas - System Control Module                               */
/*                                                                   */
/*       SCC4100 - Overrides database files in SC3010M to read       */
/*                 either non-core or core switchable feature files. */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 05Feb18              */
/*       Prev Amend No. MD048501           Date 08Nov17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*       Prev Amend No. CSC010             Date 10Jun99              */
/*                      CSC007             Date 26Oct98              */
/*                      CSC005  *CREATE    Date 08May98              */
/*                                                                   */
/*       CALLED BY: MLC0000                                          */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD048501 - System dumps on GP270000 due to missing LDA      */
/*       CSC010 - Override SCSARSPD to SCSARZPD in non-core mode.    */
/*       CSC007 - Remove call to initialisation programs.            */
/*       CSC005 - New suite of programs and files to permit          */
/*                insertion of switchable features via passwords.    */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&PARM1 &PARM2 &PARM3 &PARM4 &PARM5)

             DCL        VAR(&OPT) TYPE(*CHAR) LEN(1)
             DCL        VAR(&FLG) TYPE(*CHAR) LEN(7)
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PARM1) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM2) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM3) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM4) TYPE(*CHAR) LEN(200)
             DCL        VAR(&PARM5) TYPE(*CHAR) LEN(200)
             DCL        VAR(&STSMSG) TYPE(*CHAR) LEN(5)                   /*CSC007*/
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)                      /*CSC007*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                 /*CSC007*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) Finastra +
                          International Limited 2001')

/* Global monitor message */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))

/* Create LDA */                                                        /*MD048501*/
                                                                        /*MD048501*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)          /*MD048501*/
             MONMSG     MSGID(CPF1023)                                  /*MD048501*/

/* Create dtaara/MIDASMSG in QTEMP */                                     /*CSC007*/
/**/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')                       /*CSC007*/
             MONMSG     MSGID(CPF0000)                                    /*CSC007*/
             CHGVAR     VAR(&OPT) VALUE(%SST(&PARM1 1 1))

/**/                                                                      /*CSC007*/

/**/                                                                      /*CSC007*/
 LOOP1:      CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                         /*CSC007*/
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STSMSG)               /*CSC007*/
/**/                                                                      /*CSC007*/
/* If &STSMSG not blank, then at least one Midas job is active */         /*CSC007*/
/**/                                                                      /*CSC007*/
             IF         COND(&STSMSG *NE '     ') THEN(DO)                /*CSC007*/
 LOOP2:      CHGVAR     VAR(&RPY) VALUE('N')                              /*CSC007*/
                                                                          /*CSC007*/
             RTVMSG     MSGID(SCM0069) MSGF(MIDASMSG) MSG(&MESSAGE)       /*CSC007*/
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)         /*CSC007*/
             RTVMSG     MSGID(SCM0070) MSGF(MIDASMSG) MSG(&MESSAGE)       /*CSC007*/
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)         /*CSC007*/
             CALL       PGM(SCC0010) PARM('SCC3010M' 'RETRY' &RPY)        /*CSC007*/
                                                                          /*CSC007*/
             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))                        /*CSC007*/
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(END))                          /*CSC007*/
             ELSE       CMD(GOTO CMDLBL(LOOP2))                           /*CSC007*/
             ENDDO                                                        /*CSC007*/

/* 'B' = Non-core processing                                         */

             IF         COND(&OPT *EQ 'B') THEN(DO)
                CALL       PGM(SC0433) PARM(&RTNCDE)                      /*CSC010*/
                OVRDBF     FILE(SCSARAJ0) TOFILE(SCSARZJ0)
                OVRDBF     FILE(SCSARSL1) TOFILE(SCSARZL1)                /*CSC010*/
                CHGVAR     VAR(&FLG) VALUE('B')
                CALL       PGM(SC3010M) PARM(&FLG)
             ENDDO

/* 'C' = Core processing                                             */

             IF         COND(&OPT *EQ 'C') THEN(DO)
                CALL       PGM(SC0433) PARM(&RTNCDE)                      /*CSC010*/
                CHGVAR     VAR(&FLG) VALUE('C')
                CALL       PGM(SC3010M) PARM(&FLG)
             ENDDO

/* 'A' = Core processing for unreleased features                     */   /*CSC010*/
                                                                          /*CSC010*/
             IF         COND(&OPT *EQ 'A') THEN(DO)                       /*CSC010*/
                OVRDBF     FILE(SCSARAJ0) TOFILE(SCSARBJ0)                /*CSC010*/
                CHGVAR     VAR(&FLG) VALUE('C')                           /*CSC010*/
                CALL       PGM(SC3010M) PARM(&FLG)                        /*CSC010*/
             ENDDO                                                        /*CSC010*/

/* 'U' = Initialisation/update                                       */
/*                                                                          CSC007*/
/************IF         COND(&OPT *EQ 'U') THEN(DO)                         CSC007*/
/************   CALL       PGM(UPRELHU0)                                    CSC007*/
/************   CALL       PGM(UP1100)                                      CSC007*/
/************ENDDO                                                          CSC007*/

/* Call SC3010M with either 'B' or 'C'                               */

             GOTO       CMDLBL(END)

 ABNOR:
             CHGVAR     VAR(&RTNCDE) VALUE('*OPT')
                                                                          /*CSC007*/
             CHGVAR     VAR(&RPY) VALUE('N')                              /*CSC007*/
             RTVMSG     MSGID(SCM0071) MSGF(MIDASMSG) MSG(&MESSAGE)       /*CSC007*/
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)         /*CSC007*/
             CALL       PGM(SCC0010) PARM('SCC3010M' 'JOBLOG' &RPY)       /*CSC007*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                    /*CSC007*/
                                                                          /*CSC007*/

 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) Finastra International Limited')

             ENDPGM
