/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas CF Link branches to TRAM systems')              */
/*********************************************************************/
/*                                                                   */
/*       Midas     - CONFIRMATION MATCHING                       */
/*                                                                   */
/*       CFC0010 - LINK BRANCH TO TRAM SYSTEM                        */
/*       (CALLED BY CF0010)                                          */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Prev Amend No. MD027509           Date 10Oct22              */
/*       Last Amend No. CSC059             Date 10Oct22              */
/*                      MD046248           Date 27Oct17              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                                         Date 15Dec89              */
/*                                         Date DDMmmYY              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD027509 - Change folder calculation to use absolute path.  */
/*                  Applied for MD-38096                             */
/*       CSC059 - Replace QDLS processing by IFS                     */
/*       MD046248 - Finastra Rebranding                              */
/*       S01184 - CREATED FOR CONFIRMATION MATCHING                  */
/*                                                                   */
/*********************************************************************/
             PGM PARM(&SFX &VLD)
             DCL VAR(&SFX) TYPE(*CHAR) LEN(3)
             DCL VAR(&VLD) TYPE(*CHAR) LEN(1)
             DCL VAR(&FLR) TYPE(*CHAR) LEN(9)
             DCL VAR(&FILE) TYPE(*CHAR) LEN(50)                                           /*CSC059*/
             DCL VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                         /*CSC059*/
             DCL VAR(&IASP) TYPE(*CHAR) LEN(10)                                           /*CSC059*/
             DCL VAR(&ZSUBDIR) TYPE(*CHAR) LEN(200)                                       /*CSC059*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')                    /*CSC059*/
             DCL        VAR(&RTNC) TYPE(*CHAR) LEN(7) VALUE('       ')                    /*CSC059*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6) VALUE('CSC059')                      /*CSC059*/
             DCL        VAR(&SARREC) TYPE(*CHAR) LEN(200)                                 /*CSC059*/
             DCL        VAR(&CSC059) TYPE(*CHAR) LEN(1) VALUE('N' )                       /*CSC059*/
/*/COPY GPCPYSRCG,GPSVALDCL                                          */                   /*CSC059*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')

             MONMSG MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/*                                                                                        /*CSC059*/
/* Check if feature CSC059 is on */                                                       /*CSC059*/
             CALL       PGM(AOSARDR0) PARM(&RTNC &OPTN &SAR &SARREC)                      /*CSC059*/
             IF         COND(&RTNC *EQ '       ') THEN(CHGVAR +
                          VAR(&CSC059) VALUE('Y'))                                        /*CSC059*/
                                                                                          /*CSC059*/
/* If CSC059 is on, check IASP */                                                         /*CSC059*/
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
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
/*                                                                                        /*CSC059*/
/** Get the zone IFS subdirectory system value */                                         /*CSC059*/
/*                                                                                        /*CSC059*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'ZoneIFSsubdirectory' &SVAL1 &SVALK2 +
                          &SVAL2 &SVALK3 &SVAL3 &SVALK4 &SVAL4 +
                          &SVALK5 &SVAL5 &SVALK6 &SVAL6 &SVALK7 +
                          &SVAL7 &SVALK8 &SVAL8 &SVALK9 &SVAL9 +
                          &SVALK10 &SVAL10)                                               /*CSC059*/
/*                                                                                        /*CSC059*/
/** Determine IFS subdirectory. */                                                        /*CSC059*/
/*                                                                                        /*CSC059*/
             CHGVAR     VAR(&ZSUBDIR) VALUE(%SST(&SVAL1 1 200))                           /*CSC059*/
/*                                                                                        /*CSC059*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC059*/
/*                                                                                          CSC059*/
/*  Get name of IASP.                                                                       CSC059*/
/*                                                                                          CSC059*/
             CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                               /*CSC059*/
 /*          CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/CFFLR.' *CAT +          */
 /*          CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/CFFLR.' *CAT +          */
 /*                       &SFX *TCAT '/CFBUSYPD')                              */         /*CSC059*/
/**********  CHGVAR     VAR(&FILE) VALUE(&IASP *TCAT '/' *CAT &ZSUBDIR +
                          *TCAT '/CFFLR.' *CAT &SFX *TCAT '/CFBUSYPD')       /*CSC059*/ /*MD027509*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &IASP *TCAT '/' *CAT &ZSUBDIR +
                          *TCAT '/CFFLR.' *CAT &SFX *TCAT '/CFBUSYPD')                  /*MD027509*/
             ENDDO                                                                        /*CSC059*/
             ELSE       CMD(DO)                                                           /*CSC059*/
             CHGVAR     VAR(&FILE) VALUE('/' *CAT &ZSUBDIR +
                          *TCAT '/CFFLR.' *CAT &SFX *TCAT '/CFBUSYPD')                    /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             CPYTOIMPF  FROMFILE(*LIBL/CFBUSYPD *FIRST) +
                          TOSTMF(&FILE) MBROPT(*REPLACE) +
                          STMFCODPAG(*PCASCII) RCDDLM(*CRLF) +
                          DTAFMT(*FIXED)                                                  /*CSC059*/
                                                                                          /*CSC059*/
             MONMSG MSGID(CPFA085 CPFA097) EXEC(DO)                                       /*CSC059*/
                CHGVAR VAR(&VLD) VALUE('N')                                               /*CSC059*/
             ENDDO                                                                        /*CSC059*/
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE (DO)                                                                    /*CSC059*/
                                                                                          /*CSC059*/
/**  IF FOLDER 'CFFLR.&SFX' DOES NOT EXIST SET &VLD TO 'N'           */
             CHGVAR VAR(&FLR) VALUE('CFFLR.' *CAT &SFX)
             CPYTOPCD   FROMFILE(CFBUSYPD) TOFLR(&FLR) REPLACE(*YES)
             MONMSG MSGID(IWS16B6 IWS1612) EXEC(DO)
                CHGVAR VAR(&VLD) VALUE('N')
             ENDDO
                                                                                          /*CSC059*/
             ENDDO                                                                        /*CSC059*/
/**  IF FOLDER 'CFFLR.&SFX' DOES EXIST REMOVE COPY                   */
             IF         COND(&CSC059 *EQ 'Y') THEN(DO)                                    /*CSC059*/
             RMVLNK     OBJLNK(&FILE)                                                     /*CSC059*/
             MONMSG MSGID(CPF0000 IWS0000)                                                /*CSC059*/
             GOTO END                                                                     /*CSC059*/
             ENDDO                                                                        /*CSC059*/
             ELSE DO                                                                      /*CSC059*/
             DLTDLO     DLO(CFBUSYPD) FLR(&FLR)
             MONMSG MSGID(CPF0000 IWS0000)
             GOTO END
             ENDDO                                                                        /*CSC059*/

 ABNOR:      SNDPGMMSG  MSG('CFC0010 ENDED ABNORMALLY') TOPGMQ(*EXT) +
                        TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)

 END:
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')

             ENDPGM
