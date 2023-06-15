/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas IRM Copy Tmark Extract to Folder I/C')          */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Interest Risk Management                        */
/*                                                                   */
/*       RMC0210 - Copy Tmark Extract to Folder (I/C)                */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Past Amend No. BA6016             Date 10Feb23              */
/*       Prev Amend No. MD027509           Date 10Oct22              */
/*                      CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      094899             Date 20OCT95              */
/*                      CRM001  *CREATE    Date 06FEB95              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       BA6016 - Upgrade CMD IFSAUT to BFMidas (GSH016)             */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       094889 - RENAME TRADES.DAT TO CFTRADES.INT AND CHANGE       */
/*                FOLDER NAME TO REFLECT SYSTEM ID.                  */
/*       CRM001 - Midas/Tmark Interface                              */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&SYSTEM) TYPE(*CHAR) LEN(2)              /*094889*/
             DCL        VAR(&FLR) TYPE(*CHAR) LEN(12)                /*094889*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)                                   /*BA6016*/
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)                                 /*BA6016*/
             DCL        VAR(&BA6016) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA6016*/
             DCL        VAR(&FLDEXISTS) TYPE(*CHAR) LEN(1)                                /*CSC059*/
             DCL        VAR(&FLRIAS) TYPE(*CHAR) LEN(50)                                  /*CSC059*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
/**/
/**  Global Monitor Message:                                         */
/**   If an unmonitorred message occurs perform error processing     */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
                                                                                          /*CSC059*/
/* If CSC059 is on, check IASP */                                                         /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
/*                                                                                        /*CSC059*/
/*  Get the global IASP system values */                                                  /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 'IASPgroup' +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                          CSC059*/
/** Check whether system is in IASP environment.                                            CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                             /*CSC059*/
/*                                                                                          CSC059*/
/*  If IASP environment,                                                                    CSC059*/
/*                                                                                          CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
/*                                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             OVRPRTF    FILE(QSYSPRT) HOLD(*YES)                                          /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY' +
                          'BA6016' &FMT200)                                               /*BA6016*/
             IF         COND(&RETCOD *EQ '       ') THEN(DO)                              /*BA6016*/
             CHGVAR     VAR(&BA6016) VALUE('Y')                                           /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
/**/
/* Clear the final output file before copying all extract files */
/**/
             CLRPFM     FILE(RMTREXPD)
/**/
             CPYF       FROMFILE(RMFXEXPD) TOFILE(RMTREXPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPC2957)
             MONMSG     MSGID(CPF2817) EXEC(DO)
               SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CPYF       FROMFILE(RMMMEXPD) TOFILE(RMTREXPD) +
                         MBROPT(*ADD)
             MONMSG     MSGID(CPC2957)
             MONMSG     MSGID(CPF2817) EXEC(DO)
               SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CPYF       FROMFILE(RMLEEXPD) TOFILE(RMTREXPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPC2957)
             MONMSG     MSGID(CPF2817) EXEC(DO)
               SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CPYF       FROMFILE(RMFIEXPD) TOFILE(RMTREXPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPC2957)
             MONMSG     MSGID(CPF2817) EXEC(DO)
               SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CPYF       FROMFILE(RMSEEXPD) TOFILE(RMTREXPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPC2957)
             MONMSG     MSGID(CPF2817) EXEC(DO)
               SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
             CPYF       FROMFILE(RMFOEXPD) TOFILE(RMTREXPD) +
                          MBROPT(*ADD)
             MONMSG     MSGID(CPC2957)
             MONMSG     MSGID(CPF2817) EXEC(DO)
               SNDPGMMSG  MSGID(CPF2817) MSGF(QCPFMSG) +
                             TOMSGQ(MOPERQ) MSGTYPE(*NOTIFY) +
                             RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
/**/
/**  Copy to PC document                                             */
/**/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR  VAR(&FLRIAS) VALUE(&IASP *TCAT '/MIDAS/IRM')            /*CSC059*/ /*MD027509*/
             CHGVAR  VAR(&FLRIAS) VALUE('/' *CAT &IASP *TCAT '/MIDAS/IRM')              /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE    CMD(DO)                                                              /*CSC059*/
             CHGVAR  VAR(&FLRIAS) VALUE('/MIDAS/IRM')                                   /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             CHGVAR  VAR(&FLDEXISTS) VALUE('Y')                                           /*CSC059*/
             DSPLNK     OBJ(&FLRIAS) OUTPUT(*PRINT) OBJTYPE(*DIR)                         /*CSC059*/
             MONMSG  (CPFA0A9) EXEC(DO)                                                   /*CSC059*/
                    CHGVAR  VAR(&FLDEXISTS) VALUE('N')                                    /*CSC059*/
/**********         CHGVAR  VAR(&FLRIAS) VALUE(&IASP *TCAT '/MIDAS')         /*CSC059*/ /*MD027509*/
                    IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                            /*CSC059*/
                    CHGVAR  VAR(&FLRIAS) VALUE('/' *CAT &IASP *TCAT '/MIDAS')           /*MD027509*/
                    ENDDO                                                                 /*CSC059*/
                    ELSE    CMD(DO)                                                       /*CSC059*/
                    CHGVAR  VAR(&FLRIAS) VALUE('/MIDAS')                                /*MD027509*/
                    ENDDO                                                                 /*CSC059*/
                    CRTDIR  DIR(&FLRIAS)                                                  /*CSC059*/
                    MONMSG  MSGID(CPFA0A0)                                                /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FLRIAS)                                                     /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
/**********         CHGVAR  VAR(&FLRIAS) VALUE(&IASP *TCAT '/MIDAS/IRM')     /*CSC059*/ /*MD027509*/
                    IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                            /*CSC059*/
                    CHGVAR  VAR(&FLRIAS) VALUE('/' *CAT &IASP *TCAT '/MIDAS/IRM')       /*MD027509*/
                    ENDDO                                                                 /*CSC059*/
                    ELSE    CMD(DO)                                                       /*CSC059*/
                    CHGVAR  VAR(&FLRIAS) VALUE('/MIDAS/IRM/')                           /*MD027509*/
                    ENDDO                                                                 /*CSC059*/
                    CRTDIR  DIR(&FLRIAS)                                                  /*CSC059*/
                    MONMSG  MSGID(CPFA0A0)                                                /*CSC059*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FLRIAS)                                                     /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&FLDEXISTS *EQ 'Y') THEN(+
                        DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST))                              /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHKDLO     DLO(IRM) FLR(MIDAS) OBJTYPE(*FLR)
             MONMSG     MSGID(CPF8A77) EXEC(DO)
               CRTFLR     FLR(MIDAS)
               MONMSG     MSGID(CPF0000)
               CRTFLR     FLR(IRM) INFLR(MIDAS)
               MONMSG     MSGID(CPF0000)
             ENDDO
             ENDDO                                                                        /*CSC059*/
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSTEM)         /*094889*/
             CHGVAR     VAR(&FLR) VALUE('MIDAS/IRM/' *TCAT +
                          &SYSTEM)                                   /*094889*/
/**/                                                                 /*094889*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/**********  CHGVAR  VAR(&FLRIAS) VALUE(&IASP *TCAT '/MIDAS/IRM/' *CAT &SYSTEM)  /*CSC059 MD027509*/
             CHGVAR  VAR(&FLRIAS) VALUE('/' *CAT &IASP *TCAT '/MIDAS/IRM/' *CAT +
                       &SYSTEM)                                                         /*MD024509*/
             ENDDO                                                                        /*CSC059*/
             ELSE    CMD(DO)                                                              /*CSC059*/
             CHGVAR  VAR(&FLRIAS) VALUE('/MIDAS/IRM/' *CAT +
                       &SYSTEM)                                                         /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             CHGVAR  VAR(&FLDEXISTS) VALUE('Y')                                           /*CSC059*/
             DSPLNK  OBJ(&FLRIAS) OUTPUT(*PRINT) OBJTYPE(*DIR)                            /*CSC059*/
             MONMSG  (CPFA0A9) EXEC(DO)                                                   /*CSC059*/
                    CHGVAR  VAR(&FLDEXISTS) VALUE('N')                                    /*CSC059*/
                    CRTDIR  DIR(&FLRIAS)                                                  /*CSC059*/
                    MONMSG  MSGID(CPFA0A0)                                                /*CSC059*/
/** Invoke Handelsbanken command IFSAUT to correctly set user        */                   /*BA6016*/
/** authority to the IFS directory                                   */                   /*BA6016*/
                                                                                          /*BA6016*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FILE)                                                       /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&FLDEXISTS *EQ 'Y') THEN(+
                        DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST))                              /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &FLR +
                            *TCAT '/CFTRADES.INT')                           /*CSC059*/ /*MD024509*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FLR +
                            *TCAT '/CFTRADES.INT')                                      /*MD024509*/
             ENDDO                                                                        /*CSC059*/
             ELSE    CMD(DO)                                                              /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &FLR +
                            *TCAT '/CFTRADES.INT')                                      /*MD024509*/
             ENDDO                                                                        /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/RMTREXPD *FIRST) +
                          TOSTMF(&FILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*PCASCII) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED)                                                  /*CSC059*/
             MONMSG     MSGID(CPF2817) EXEC(DO)                                           /*CSC059*/
               SNDPGMMSG  MSGID(CPF2817) MSGF(QSYS/QCPFMSG) +
                          MSGDTA(RMTREXPD) TOMSGQ(MOPERQ) +
                          MSGTYPE(*NOTIFY) RPYMSGQ(*PGMQ)                                 /*CSC059*/
               GOTO       CMDLBL(ABNOR)                                                   /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*BA6016*/
/** Invoke Handelsbanken command IFSAUT to correctly set user        */                   /*BA6016*/
/** authority to the IFS directory                                   */                   /*BA6016*/
                                                                                          /*BA6016*/
             IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                        'Y')) THEN(DO)                                                    /*BA6016*/
             IFSAUT     PATH(&FILE)                                                       /*BA6016*/
             MONMSG     MSGID(CPF0000)                                                    /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHKDLO     DLO(&SYSTEM) FLR('MIDAS/IRM') OBJTYPE(*FLR)  /*094889*/
             MONMSG     MSGID(CPF8A77) EXEC(DO)                      /*094889*/
             CRTFLR     FLR(&SYSTEM) INFLR('MIDAS/IRM')              /*094889*/
             ENDDO                                                   /*094889*/
/**/                                                                 /*094889*/
/*********** CPYTOPCD   FROMFILE(RMTREXPD) TOFLR('MIDAS/IRM') +      /*094889*/
/***********              FROMMBR(*FIRST) TODOC(TRADES.DAT) +        /*094889*/
/***********              REPLACE(*YES)                              /*094889*/
             CPYTOPCD   FROMFILE(RMTREXPD) TOFLR(&FLR) +
                          FROMMBR(*FIRST) TODOC(CFTRADES.INT) +
                          REPLACE(*YES)                              /*094889*/
             MONMSG     MSGID(IWS1612) EXEC(DO)
               SNDPGMMSG  MSGID(IWS1612) MSGF(QIWS/QIWSMSG) +
                            MSGDTA(RMTREXPD) TOMSGQ(MOPERQ) +
                            MSGTYPE(*NOTIFY) RPYMSGQ(*PGMQ)
               GOTO       CMDLBL(ABNOR)
             ENDDO
             ENDDO                                                                        /*CSC059*/
/**/
             GOTO       CMDLBL(PGMEND)

/**/
/**  Error Processing:                                               */
/**  Dump the program if error occurred in this program              */
/**/
 ABNOR:      DMPCLPGM
             CHGJOB     SWS(XXXXXX11)
             SNDMSG     MSG('Job terminated - Copy Tmark Extract +
                        to Folder I/C processing ended in error') +
                        TOMSGQ(MOPERQ MRUNQ)
/**/
/**  End of Program:                                                 */
PGMEND:      CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
                                                                                          /*CSC059*/
             IF         COND(&CSC059  *EQ 'Y') THEN(DO)                                   /*CSC059*/
             DLTOVR FILE(QSYSPRT)                                                         /*CSC059*/
             MONMSG MSGID(CPF0000)                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             ENDPGM
