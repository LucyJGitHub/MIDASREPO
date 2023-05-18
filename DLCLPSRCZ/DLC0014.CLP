/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas DL Initialisation program for CCM003')          */
/*********************************************************************/
/*                                                                   */
/*       Midas - Dealing Data Module                                 */
/*                                                                   */
/*       DLC0014 - Set up CCM003 switchable feature                  */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. BA6016             Date 10Feb23              */
/*       Prev Amend No. MD027509           Date 10Oct22              */
/*                      CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      CCM003  *CREATE    Date 07Feb01              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BA6016 - Upgrade CMD IFSAUT to BFMidas (GSH016)             */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       CCM003 - Midas/City Dealer cashflow interface.              */
/*                                                                   */
/*********************************************************************/
             PGM        PARM(&RTCDE &PMODE)

             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&PRE)  TYPE(*CHAR) LEN(2)
             DCL        VAR(&FOLD) TYPE(*CHAR) LEN(10)
             DCL        VAR(&FLRIAS) TYPE(*CHAR) LEN(50)                                  /*CSC059*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC059*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC059*/
             DCL        VAR(&RETCOD) TYPE(*CHAR) LEN(7)                                   /*BA6016*/
             DCL        VAR(&FMT200) TYPE(*CHAR) LEN(200)                                 /*BA6016*/
             DCL        VAR(&BA6016) TYPE(*CHAR) LEN(1) VALUE('N')                        /*BA6016*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
/* Global Monitor Message */
/**/
             MONMSG     MSGID(CPF0000) EXEC(GOTO CMDLBL(ABNOR))
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
             CALL       PGM(AOSARDR0) PARM(&RETCOD '*VERIFY' +
                          'BA6016' &FMT200)                                               /*BA6016*/
             IF         COND(&RETCOD *EQ '       ') THEN(DO)                              /*BA6016*/
             CHGVAR     VAR(&BA6016) VALUE('Y')                                           /*BA6016*/
             ENDDO                                                                        /*BA6016*/
             ENDDO                                                                        /*CSC059*/
             ENDDO                                                                        /*CSC059*/

/**/
/* Mode 1 - First call */
/**/
             IF         COND(&PMODE *EQ '1') THEN(DO)

/*    Get system prefix                                              */
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
                CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)

/*    Create Folder TSMxx - If already created then continue processing */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
                IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                /*CSC059*/
/**********     CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT &FOLD)    /*CSC059*/ /*MD027509*/
                CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FOLD)      /*MD027509*/
                ENDDO                                                                     /*CSC059*/
                ELSE       CMD(DO)                                                        /*CSC059*/
                CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &FOLD)                           /*MD027509*/
                ENDDO                                                                     /*CSC059*/
                CRTDIR     DIR(&FLRIAS)                                                   /*CSC059*/
                MONMSG     MSGID(CPFA0A0)                                                 /*CSC059*/
                IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                           'Y')) THEN(DO)                                                 /*BA6016*/
                IFSAUT     PATH(&FLRIAS)                                                  /*BA6016*/
                MONMSG     MSGID(CPF0000)                                                 /*BA6016*/
                ENDDO                                                                     /*BA6016*/
                ENDDO                                                                     /*CSC059*/
                ELSE       CMD(DO)                                                        /*CSC059*/
                CRTFLR     FLR(&FOLD) TEXT('Midas/City Dealer ETVS PC +
                             File') AUT(*CHANGE)
                MONMSG     MSGID(CPF8A85 CPF8A18)
                ENDDO                                                                     /*CSC059*/

/*    Create data area LDA                                           */
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                MONMSG     MSGID(CPF1023)

/*    Start commitment control                                       */

                ENDCMTCTL
                MONMSG     MSGID(CPF0000)

                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)

                CALL       PGM(DL0014) PARM(' ')

                CALL       PGM(DL0012) PARM('TAKEON' ' ')

             ENDDO

/**/
/* Mode 2 - Second call */
/**/
             IF         COND(&PMODE *EQ '2') THEN(DO)

/*    Get system prefix                                              */
                RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PRE)
                CHGVAR     VAR(&FOLD) VALUE('TSM' *TCAT &PRE)

/*    Create Folder TSMxx - If already created then continue processing */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
                IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                /*CSC059*/
/**********     CHGVAR     VAR(&FLRIAS) VALUE(&IASP *TCAT '/' *CAT &FOLD)    /*CSC059*/ /*MD027509*/
                CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &IASP *TCAT '/' *CAT &FOLD)      /*MD027509*/
                ENDDO                                                                     /*CSC059*/
                ELSE       CMD(DO)                                                        /*CSC059*/
                CHGVAR     VAR(&FLRIAS) VALUE('/' *CAT &FOLD)                           /*MD027509*/
                ENDDO                                                                     /*CSC059*/
                CRTDIR     DIR(&FLRIAS)                                                   /*CSC059*/
                MONMSG     MSGID(CPFA0A0)                                                 /*CSC059*/
                IF         COND((&IASP_YN *EQ 'Y') *AND (&BA6016 *EQ +
                            'Y')) THEN(DO)                                                /*BA6016*/
                IFSAUT     PATH(&FLRIAS)                                                  /*BA6016*/
                MONMSG     MSGID(CPF0000)                                                 /*BA6016*/
                ENDDO                                                                     /*BA6016*/
                ENDDO                                                                     /*CSC059*/
                ELSE       CMD(DO)                                                        /*CSC059*/
                CRTFLR     FLR(&FOLD) TEXT('Midas/City Dealer ETVS PC +
                             File') AUT(*CHANGE)
                MONMSG     MSGID(CPF8A85 CPF8A18)
                ENDDO                                                                     /*CSC059*/

/*    Create data area LDA                                           */
                CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256)
                MONMSG     MSGID(CPF1023)

/*    Start commitment control                                       */

                ENDCMTCTL
                MONMSG     MSGID(CPF0000)

                STRCMTCTL  LCKLVL(*CHG) CMTSCOPE(*JOB)

                CALL       PGM(DL0014) PARM(' ')

                CALL       PGM(DL0012) PARM('TAKEON' ' ')

             ENDDO

/**/
/* Mode 3 - Deletion */
/**/
             IF         COND(&PMODE *EQ '3') THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO

             GOTO       CMDLBL(END)

/* Abnormal Processing */

 ABNOR:
             SNDPGMMSG  TOMSGQ(MOPERQ) MSG('Program DLC0014 +
                          ended abnormally')
             MONMSG     MSGID(CPF0000)

             CHGVAR     VAR(&RTCDE) VALUE('*ERROR')

 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
