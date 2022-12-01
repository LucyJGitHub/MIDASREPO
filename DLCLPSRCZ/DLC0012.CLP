/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Citydealer cash flow extract in EVTS fmt')   */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Module                                      */
/*                                                                   */
/*       DLC0012 - Midas Customer Lending Download of Transactions   */
/*                 to City Dealer in ETVS Format                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD027509           Date 10Oct22              */
/*       Prev Amend No. CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003 *CREATE     Date 02Feb01              */
/*                                         Date                      */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CCM003 - Midas/City Dealer Lending interface.               */
/*                                                                   */
/*********************************************************************/
             PGM
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&NUMREC) TYPE(*DEC) LEN(10 0)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&FOLD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FILEXISTS)  TYPE(*CHAR) LEN(1)                               /*CSC059*/
             DCL        VAR(&FILE) TYPE(*CHAR) LEN(50)                                    /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

/*    Global monitor message.                                        */

             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
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
             ENDDO                                                                        /*CSC059*/
             OVRPRTF    FILE(QSYSPRT) HOLD(*YES)                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
/*                                                                                        /*CSC059*/

/*    Obtain system prefix.                                          */

             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
             CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)


/*    If file DLETLEPD is not empty then copy to PC document         */
/*    LEETVS.CSV in shared folder TSMxx, where xx is the Midas       */
/*    system prefix.                                                 */

             OVRDBF     FILE(DLETLEPD) SHARE(*NO)
             RTVMBRD    FILE(DLETLEPD) NBRCURRCD(&NUMREC)

             IF         COND(&NUMREC *NE 0) THEN(DO)

             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILEXISTS) VALUE('Y')                                        /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &FOLD +
                            *TCAT '/LEETVS.CSV')                             /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FOLD +
                            *TCAT '/LEETVS.CSV')                                        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &FOLD +
                            *TCAT '/LEETVS.CSV')                                        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             DSPLNK     OBJ(&FILE) OUTPUT(*PRINT)                                         /*CSC059*/
             MONMSG     (CPFA0A9) EXEC(CHGVAR VAR(&FILEXISTS) VALUE('N'))                 /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&FILEXISTS *EQ 'Y') THEN(DO)                                 /*CSC059*/
                        DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST)                               /*CSC059*/
                        GOTO TAG1                                                         /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/DLETLEPD *FIRST) +
                          TOSTMF(&FILE) STMFCODPAG(*PCASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)                                    /*CSC059*/
             MONMSG     (CPF2817) EXEC(GOTO TAG1)                                         /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CPYTOPCD   FROMFILE(DLETLEPD) TOFLR(&FOLD) +
                          TODOC(LEETVS.CSV) TRNFMT(*TEXT)
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG1)
             ENDDO                                                                        /*CSC059*/
             CPYF       FROMFILE(DLETLEPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)
             CLRPFM     FILE(DLETLEPD)
 TAG1:       ENDDO

/*    If file DLETCLPD is not empty then copy to PC document            CCM003*/
/*    CLETVS.CSV in shared folder TSMxx, where xx is the Midas          CCM003*/
/*    system prefix.                                                    CCM003*/

             OVRDBF     FILE(DLETCLPD) SHARE(*NO)                     /*CCM003*/
             RTVMBRD    FILE(DLETCLPD) NBRCURRCD(&NUMREC)             /*CCM003*/

             IF         COND(&NUMREC *NE 0) THEN(DO)                  /*CCM003*/

             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILEXISTS) VALUE('Y')                                        /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &FOLD +
                            *TCAT '/CLETVS.CSV')                             /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FOLD +
                            *TCAT '/CLETVS.CSV')                                        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &FOLD +
                            *TCAT '/CLETVS.CSV')                                        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             DSPLNK     OBJ(&FILE) OUTPUT(*PRINT)                                         /*CSC059*/
             MONMSG     (CPFA0A9) EXEC(CHGVAR VAR(&FILEXISTS) VALUE('N'))                 /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&FILEXISTS *EQ 'Y') THEN(DO)                                 /*CSC059*/
                        DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST)                               /*CSC059*/
                        GOTO TAG2                                                         /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/DLETCLPD *FIRST) +
                          TOSTMF(&FILE) STMFCODPAG(*PCASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)                                    /*CSC059*/
             MONMSG     (CPF2817) EXEC(GOTO TAG2)                                         /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CPYTOPCD   FROMFILE(DLETCLPD) TOFLR(&FOLD) +
                          TODOC(CLETVS.CSV) TRNFMT(*TEXT)             /*CCM003*/
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG2)        /*CCM003*/
             ENDDO                                                                        /*CSC059*/
             CPYF       FROMFILE(DLETCLPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)                                /*CCM003*/
             CLRPFM     FILE(DLETCLPD)                                /*CCM003*/
 TAG2:       ENDDO

/*    If file DLETCPPD is not empty then copy to PC document            CCM003*/
/*    CPETVS.CSV in shared folder TSMxx, where xx is the Midas          CCM003*/
/*    system prefix.                                                    CCM003*/

             OVRDBF     FILE(DLETCPPD) SHARE(*NO)                     /*CCM003*/
             RTVMBRD    FILE(DLETCPPD) NBRCURRCD(&NUMREC)             /*CCM003*/

             IF         COND(&NUMREC *NE 0) THEN(DO)                  /*CCM003*/

             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
             CHGVAR     VAR(&FILEXISTS) VALUE('Y')                                        /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &FOLD +
                            *TCAT '/CPETVS.CSV')                             /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FOLD +
                            *TCAT '/CPETVS.CSV')                                        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &FOLD +
                            *TCAT '/CPETVS.CSV')                                        /*MD027509*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             DSPLNK     OBJ(&FILE) OUTPUT(*PRINT)                                         /*CSC059*/
             MONMSG     (CPFA0A9) EXEC(CHGVAR VAR(&FILEXISTS) VALUE('N'))                 /*CSC059*/
                                                                                          /*CSC059*/
             IF         COND(&FILEXISTS *EQ 'Y') THEN(DO)                                 /*CSC059*/
                        DLTSPLF FILE(QSYSPRT) SPLNBR(*LAST)                               /*CSC059*/
                        GOTO TAG3                                                         /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/DLETCPPD *FIRST) +
                          TOSTMF(&FILE) STMFCODPAG(*PCASCII) +
                          RCDDLM(*CRLF) DTAFMT(*FIXED)                                    /*CSC059*/
             MONMSG     (CPF2817) EXEC(GOTO TAG3)                                         /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CPYTOPCD   FROMFILE(DLETCPPD) TOFLR(&FOLD) +
                          TODOC(CPETVS.CSV) TRNFMT(*TEXT)             /*CCM003*/
             MONMSG     MSGID(IWS16B4 IWS1612) EXEC(GOTO TAG3)        /*CCM003*/
             ENDDO                                                                        /*CSC059*/
             CPYF       FROMFILE(DLETCPPD) TOFILE(DLETVTPD) +
                          MBROPT(*ADD)                                /*CCM003*/
             CLRPFM     FILE(DLETCPPD)                                /*CCM003*/
 TAG3:       ENDDO

/*    Database error processing.                                     */

             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                ROLLBACK
                RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                           TOMSGQ(MOPERQ MRUNQ)
             ENDDO

             GOTO       CMDLBL(END)

 /*   Abnormal termination - batch job                               */

 ABNOR:
             CHGJOB     SWS(XXXXXX11)
             SNDPGMMSG  MSG('Copy to Citydealer document LEETVS +
                          ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
