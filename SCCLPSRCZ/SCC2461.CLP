/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas SC Save journal receivers to save files')       */
/********************************************************************/
/*                                                                  */
/*          MIDAS SYSTEM CONTROL MODULE                             */
/*                                                                  */
/*          SCC2461 - SAVE JOURNAL RECEIVERS TO SAVE FILES          */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                  */
/*       Last Amend No. CSC043             Date 18Jun10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*       Prev Amend No. CSC038             Date 18Aug08              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      BUG9619            Date 01Feb06              */
/*                      CSC020             Date 31Mar04              */
/*                      CSC018             Date 31May03              */
/* Midas Release 4.01.02 --------------------------------------------*/
/*                      207764             Date 23Jul02             */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      192731            Date 11Jul01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009  *CREATE   Date 01Jun00              */
/*                                                                  */
/*------------------------------------------------------------------*/
/*                                                                  */
/*       CSC043 - MidasPlus IASP Enablement                          */
/*       CSC038 - Include parameter DTACPR in save commands to reduce*/
/*                run time.                                          */
/*       BUG9619 - Close of business components run long if journal  */
/*                 cache is enabled                                  */
/*       CSC020 - Journaling changes for MidasPlus.                  */
/*       CSC018 - Journaling options for High Availability           */
/*       207764 - Change all SAV* and RST* commands to print a      */
/*                report of objects saved or restored.              */
/*       192731 - Change SAVOBJ cmd to have USEOPTBLK *NO           */
/*                instead of *YES                                   */
/*       CCB009  - New program for CCB009 - continue journaling     */
/*                 throughout close of business.  This is called    */
/*                 by SCC0405 to save extra journal receivers used  */
/*                 during the close of buseinss.                    */
/*                                                                  */
/********************************************************************/
             PGM
/**/
/* Copyright statement definition  */
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
/**/
/* File of journal receiver save file object descriptions */
/**/
             DCLF       FILE(QADSPOBJ)
/**/
             DCL        VAR(&AUTO) TYPE(*CHAR) LEN(10)
             DCL        VAR(&RSIP) TYPE(*CHAR) LEN(1)
             DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)
/*********** DCL        VAR(&COUNT) TYPE(*DEC) LEN(3) **************************************CSC020*/
/*********** DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(3) ************************************CSC020*/
             DCL        VAR(&COUNT) TYPE(*DEC) LEN(8)                                     /*CSC020*/
             DCL        VAR(&COUNTA) TYPE(*CHAR) LEN(8)                                   /*CSC020*/
             DCL        VAR(&JNSTAT) TYPE(*CHAR) LEN(200)
             DCL        VAR(&DILIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JLIB) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CURRRCV) TYPE(*CHAR) LEN(10)
/**/
/* Job name, user id and job number          */
/**/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)
/**/
/* user defined journal entry                */
/**/
             DCL        VAR(&JRNE) TYPE(*CHAR) LEN(200)
/**/
/* Seq. no of journal rec. currently attached*/
/**/
/************DCL        VAR(&LSAV) TYPE(*DEC) LEN(3) ***************************************CSC020*/
/************DCL        VAR(&LSAVA) TYPE(*CHAR) LEN(3) *************************************CSC020*/
             DCL        VAR(&LSAV) TYPE(*DEC) LEN(8)                                      /*CSC020*/
             DCL        VAR(&LSAVA) TYPE(*CHAR) LEN(8)                                    /*CSC020*/
/**/
/* Seq. no of last journal receiver to be saved */
/* by this program                              */
/**/
/************DCL        VAR(&LAST_RECV) TYPE(*DEC) LEN(3) **********************************CSC020*/
             DCL        VAR(&LAST_RECV) TYPE(*DEC) LEN(8)                                 /*CSC020*/
/**/
/* Name of journal receiver to be saved         */
/**/
/************DCL        VAR(&SAVF_NAME) TYPE(*CHAR) LEN(8) *********************************CSC020*/
             DCL        VAR(&SAVF_NAME) TYPE(*CHAR) LEN(10)                               /*CSC020*/
/**/
/* ASP for sav files                         */
/**/
             DCL        VAR(&ASP) TYPE(*CHAR) LEN(2)
             DCL        VAR(&CB_RTN_CDE) TYPE(*CHAR) LEN(7)
             DCL        VAR(&CB_AUTO) TYPE(*CHAR) LEN(111)
/*                                                                                        /*CSC018*/
/* Declare variables for CSC018 - Journaling options for high                             /*CSC018*/
/* availability.                                                                          /*CSC018*/
/*                                                                                        /*CSC018*/
/*/COPY SDCPYSRC,SDSVALDCL                                           */                   /*CSC018*/
             DCL        VAR(&CSC018) TYPE(*CHAR) LEN(7)                                   /*CSC018*/
             DCL        VAR(&RMTJR6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&MNGBJ6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&DDMRM6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&DDMLI6) TYPE(*CHAR) LEN(10)                                  /*CSC018*/
             DCL        VAR(&IGNTG6) TYPE(*CHAR) LEN(1)                                   /*CSC018*/
             DCL        VAR(&JLIBRMT) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&RMTCM6) TYPE(*CHAR) LEN(150)                                 /*CSC018*/
             DCL        VAR(&JLIBBKP) TYPE(*CHAR) LEN(10)                                 /*CSC018*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)                                  /*CSC018*/
             DCL        VAR(&DTACPRV) TYPE(*CHAR) LEN(10)                                 /*CSC038*/
             DCL        VAR(&IASP_YN) TYPE(*CHAR) LEN(1)                                  /*CSC043*/
             DCL        VAR(&IASP) TYPE(*CHAR) LEN(10)                                    /*CSC043*/
/*/COPY GPCPYSRCG,GPSVALDCL  */                                                           /*CSC043*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) +
                           EXEC(GOTO ABNORMAL)
/**/
/* Copyright statement defination at runtime */
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/*                                                                                        /*CSC043*/
/** Get the global IASP system values */                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
             CALL       PGM(GPAOSVALR0) PARM(&RSVALRTNC +
                          'IASPinstallation' &SVAL1 +
                          'IASPgroup' &SVAL2 &SVALK3 +
                          &SVAL3 &SVALK4 &SVAL4 &SVALK5 &SVAL5 +
                          &SVALK6 &SVAL6 &SVALK7 &SVAL7 &SVALK8 +
                          &SVAL8 &SVALK9 &SVAL9 &SVALK10 &SVAL10)                         /*CSC043*/
/*                                                                                        /*CSC043*/
/** Check whether system is in IASP environment. */                                       /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP_YN) VALUE(%SST(&SVAL1 1 1))                            /*CSC043*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
/*                                                                                        /*CSC043*/
/** Get name of IASP. */                                                                  /*CSC043*/
/*                                                                                        /*CSC043*/
              CHGVAR     VAR(&IASP) VALUE(%SST(&SVAL2 1 10))                              /*CSC043*/
                                                                                          /*CSC043*/
             ENDDO                                                                        /*CSC043*/
                                                                                          /*CSC043*/
/*                                                                                        /*CSC018*/
/** Check for Switchable feature CSC018.                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CALL       PGM(AOSARDR0) PARM(&CSC018 '*VERIFY' +
                          'CSC018' &AOFMT)                                                /*CSC018*/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' (Jounaling features for High Availability),                  /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&CSC018 *EQ '       ') THEN(DO)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Get the high availability system values */                                            /*CSC018*/
                                                                                          /*CSC018*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                          'HighAvlRmtJrnActive' &SVAL1 +
                          'HighAvlIgnTgtOnDel' &SVAL2 +
                          'HighAvlMangBackUpJrn' &SVAL3 +
                          'HighAvlDdmFileName' &SVAL4 +
                          'HighAvlDdmFileLib' &SVAL5 &SVALK6 &SVAL6 +
                          &SVALK7 &SVAL7 &SVALK8 &SVAL8 &SVALK9 +
                          &SVAL9 &SVALK10 &SVAL10)                                        /*CSC018*/
                                                                                          /*CSC018*/
/* If there is an error finding any system value then end abnormally */                   /*CSC018*/
                                                                                          /*CSC018*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*CSC018*/
/*                                                                                        /*CSC018*/
/* Retrieve the 2-character system I.D.                                                   /*CSC018*/
/*                                                                                        /*CSC018*/
              RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)                              /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether remote journaling is being used                                     /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&RMTJR6) VALUE(%SST(&SVAL1 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If remote journaling is used, determine whether to ignore                             /*CSC018*/
/*  target receivers upon deletion.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&IGNTG6) VALUE(%SST(&SVAL2 1 1))                            /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Calculate the backup machine remote journal library.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&JLIBRMT) VALUE(&SYSID *CAT 'JLIBRMT ')                     /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  Determine whether backup journal management is being used                             /*CSC018*/
/*                                                                                        /*CSC018*/
              CHGVAR     VAR(&MNGBJ6) VALUE(%SST(&SVAL3 1 1))                             /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If backup journal management is being used, calculate the                             /*CSC018*/
/*  name of the backup journal library.                                                   /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND(&MNGBJ6 *EQ 'Y') THEN(DO)                                   /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&JLIBBKP) VALUE(&SYSID *CAT 'JLIB    ')                     /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If remote journaling OR backup journal management are being used,                     /*CSC018*/
/*  determine DDM file and library.                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
              IF         COND((&RMTJR6 *EQ 'Y') *OR (&MNGBJ6 *EQ +
                          'Y')) THEN(DO)                                                  /*CSC018*/
/*                                                                                        /*CSC018*/
               CHGVAR     VAR(&DDMRM6) VALUE(%SST(&SVAL4 1 10))                           /*CSC018*/
               CHGVAR     VAR(&DDMLI6) VALUE(%SST(&SVAL5 1 10))                           /*CSC018*/
/*                                                                                        /*CSC018*/
/*  If any of these fields are blank then remote journaling and                           /*CSC018*/
/*  backup receiver management may not be used.                                           /*CSC018*/
/*                                                                                        /*CSC018*/
               IF         COND((&DDMRM6 *EQ '          ') *OR (&DDMLI6 +
                          *EQ '          ')) THEN(DO)                                     /*CSC018*/
/*                                                                                        /*CSC018*/
                CHGVAR     VAR(&RMTJR6) VALUE('N')                                        /*CSC018*/
                CHGVAR     VAR(&MNGBJ6) VALUE('N')                                        /*CSC018*/
/*                                                                                        /*CSC018*/
               ENDDO                                                                      /*CSC018*/
/*                                                                                        /*CSC018*/
              ENDDO                                                                       /*CSC018*/
/*                                                                                        /*CSC018*/
CSC018END:                                                                                /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/**/
/* Amend position 69 on JNSTAT  to 'Y' to prevent      */
/* futher journal change processing                    */
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE(Y)
/**/
/* Update JNSTAT to correctly reflect the currently attached  */
/* receiver.  Receivers may be changed automatically by the   */
/* operating system during the close of business.             */
/**/
             RTVJRNE    JRN(ICJRN) RTNRCV(&CURRRCV)
             CHGDTAARA  DTAARA(JNSTAT (1 10)) VALUE(&CURRRCV)
/**/
/**************************************************************/
/*                                                            */
/* C H A N G E   J O U R N A L   R E C E I V E R              */
/*                                                            */
/**************************************************************/
/**/
/* Retrieve seq no. of current journal receiver attached */
/**/
             RTVDTAARA  DTAARA(JNSTAT) RTNVAR(&JNSTAT)
/*********** CHGVAR     VAR(&LSAV) VALUE(%SST(&JNSTAT 6 3)) ********************************CSC020*/
             CHGVAR     VAR(&LSAV) VALUE(%SST(&JNSTAT 3 8))                               /*CSC020*/
             CHGVAR     VAR(&LSAVA) VALUE(&LSAV)
/**/
/* Obtain the system library id from SDSTAT                          */
/**/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)
             CHGVAR     VAR(&JLIB) VALUE(&SYSID *CAT 'JLIB')
             CHGVAR     VAR(&DILIB) VALUE(&SYSID *CAT 'DILIB')
/**/
/* Format user defined 'JS' entry for the journal */
/**/
/*********** CHGVAR     VAR(%SST(&JRNE 6 8)) VALUE('ICRCV' *TCAT +
                          %SST(&JNSTAT 16 3)) **********************************************CSC020*/
             CHGVAR     VAR(%SST(&JRNE 6 10)) VALUE('IR' *TCAT +
                          %SST(&JNSTAT 13 8))                                             /*CSC020*/
/*********** CHGVAR     VAR(%SST(&JRNE 16 8)) VALUE('ICRCV' *TCAT +
                        &LSAVA) ************************************************************CSC020*/
             CHGVAR     VAR(%SST(&JRNE 16 10)) VALUE('IR' *TCAT +
                        &LSAVA)                                                           /*CSC020*/
             CHGVAR     VAR(%SST(&JRNE 26 8)) VALUE('DISK')
/**/
/* Output user defined 'JS' entry to the journal */
/**/
/**********  SNDJRNE    JRN(ICJRN) TYPE('JS') ENTDTA(&JRNE) */                           /*BUG9619*/
             SNDJRNE    JRN(ICJRN) TYPE('JS') ENTDTA(&JRNE) FORCE(*YES)                  /*BUG9619*/
/**/
/* Call SDC1717 to save data areas onto the journal */
/**/
             CALL       PGM(SDC1717)
             IF         COND(%SWITCH(XXXXXX1X)) THEN(GOTO ABNORMAL)
/**/
/**************************************************************/
/*                                                            */
/* S A V E   J O U R N A L   R E C E I V E R S                */
/*                                                            */
/**************************************************************/
/**/
/* Obtain the ASP for save files via CB0602X */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*TODAY    ')
             CALL       PGM(CB0602X) PARM(&CB_RTN_CDE &CB_AUTO)
             CHGVAR     VAR(&ASP) VALUE(%SST(&CB_AUTO 51 2))
/**/
/* Initialise sequence no. of journal receiver to be saved */
/**/
/*********** CHGVAR     VAR(&COUNTA) VALUE(%SST(&JNSTAT 16 3)) *****************************CSC020*/
             CHGVAR     VAR(&COUNTA) VALUE(%SST(&JNSTAT 13 8))                            /*CSC020*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNTA)
/**/
/* Set sequence no. of last journal receiver to be saved   */
/* to sequence no.  of journal receiver attached - 1       */
/**/
             CHGVAR     VAR(&LAST_RECV) VALUE(&LSAV)
                                                                                          /*CSC038*/
/*  Get the Value for Data Compression parameter in save commands                         /*CSC038*/
             CALL       PGM(AOSVALR0) PARM(&RSVALRTNC +
                             'SavDataCompression' &SVAL1 +
                             ' ' &SVAL2 +
                             ' ' &SVAL3 +
                             ' ' &SVAL4 +
                             ' ' &SVAL5 +
                             ' ' &SVAL6 +
                             ' ' &SVAL7 +
                             ' ' &SVAL8 +
                             ' ' &SVAL9 +
                             ' ' &SVAL10)                                                 /*CSC038*/
                                                                                          /*CSC038*/
/* If there is an error finding any system value then end abnormally */                   /*CSC038*/
                                                                                          /*CSC038*/
             IF         COND(&RSVALRTNC *NE '       ') THEN(GOTO +
                          CMDLBL(ABNORMAL))                                               /*CSC038*/
             CHGVAR     VAR(&DTACPRV) VALUE(&SVAL1)                                       /*CSC038*/
                                                                                          /*CSC038*/
/**/
 SAVE:
             CHGVAR     VAR(&COUNTA) VALUE(&COUNT)
/*********** CHGVAR     VAR(&SAVF_NAME) VALUE('ICRCV' *CAT &COUNTA) ************************CSC020*/
             CHGVAR     VAR(&SAVF_NAME) VALUE('IR' *CAT &COUNTA)                          /*CSC020*/
/*                                                                                        /*CSC043*/
/** If IASP environment */                                                                /*CSC043*/
/*                                                                                        /*CSC043*/
             IF         COND(&IASP_YN *EQ 'Y') THEN(DO)                                   /*CSC043*/
             CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('save file for +
                          Auto COB') ASP(*LIBASP)                                         /*CSC043*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC043*/
             ENDDO                                                                        /*CSC043*/
             ELSE       CMD(DO)                                                           /*CSC043*/
             CRTSAVF    FILE(&DILIB/&SAVF_NAME) TEXT('save file for +
                          Auto COB') ASP(&ASP)
             MONMSG     MSGID(CPF0000 MCH0000)
             ENDDO                                                                        /*CSC043*/
/**/
/* Do not save the currently attached reciever.                      */
/**/
             IF         COND(&LAST_RECV *NE &COUNT) THEN(DO)
/**********  SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +
/**********               OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) +
/**********               CLEAR(*ALL)                                                 /*192731*/
/**********  SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +      */    /*192731*/ /*207764*/
/**********               OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) + */    /*192731*/ /*207764*/
/**********               CLEAR(*ALL) USEOPTBLK(*NO)                 */    /*192731*/ /*207764*/
/**********  SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +                       /*CSC038*/
/**********               OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) +                  /*CSC038*/
/**********               CLEAR(*ALL) USEOPTBLK(*NO) OUTPUT(*PRINT)        /*207764*/ /*CSC038*/
             SAVOBJ     OBJ(&SAVF_NAME) LIB(&JLIB) DEV(*SAVF) +
                          OBJTYPE(*JRNRCV) SAVF(&DILIB/&SAVF_NAME) +
                          CLEAR(*ALL) USEOPTBLK(*NO) OUTPUT(*PRINT) +
                          DTACPR(&DTACPRV)                                            /*CSC038*/
             ENDDO
/**/
/* Continue saving receivers until all except current one saved      */
/**/
             IF         COND(&LAST_RECV *LE &COUNT) THEN(GOTO +
                          CMDLBL(ENDSAVE))
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             GOTO       CMDLBL(SAVE)
/**/
ENDSAVE:
/**/
/* Amend position 69 on JNSTAT  to 'N' to allow futher */
/* journal change processing                           */
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
/**/
/* Call CB0602U to update COB data fields on CBAICDPD */
/**/
             CHGVAR     VAR(%SST(&CB_AUTO 1 10)) VALUE('*SETRCV   ')
             CHGVAR     VAR(%SST(&CB_AUTO 83 5)) VALUE('*DISK')
             CHGVAR     VAR(%SST(&CB_AUTO 93 4)) VALUE(%SST(&CB_AUTO +
                          53 56))
             CALL       PGM(CB0602U) PARM(&CB_RTN_CDE &CB_AUTO)
/**/
/* Delete any receivers with higher sequence numbers   */
/* that may be present from previous days.             */
/**/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             CHGJOB     INQMSGRPY(*DFT)
 DLTRCV:
             CHGVAR     VAR(&COUNTA) VALUE(&COUNT)
/*********** CHGVAR     VAR(&SAVF_NAME) VALUE('ICRCV' *CAT &COUNTA) ************************CSC020*/
             CHGVAR     VAR(&SAVF_NAME) VALUE('IR' *CAT &COUNTA)                          /*CSC020*/
             DLTF       FILE(&DILIB/&SAVF_NAME)
             MONMSG     MSGID(CPF0000 MCH0000)
/**/
/* Continue deleting receivers until all are deleted.                */
/**/
/*                                                                                        /*CSC018*/
/* If Feature CSC018 is 'on' (journaling options for High Availability),                  /*CSC018*/
/* remote journaling is in use and if 'Ignore Target Receiver' is 'Y',                    /*CSC018*/
/* then delete receiver with option *IGNTGTRCV                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND((&CSC018 *EQ '       ') *AND (&RMTJR6 +
                          *EQ 'Y') *AND (&IGNTG6 *EQ 'Y')) THEN(DO)                       /*CSC018*/
/*                                                                                        /*CSC018*/
             DLTJRNRCV  JRNRCV(&JLIB/&SAVF_NAME) DLTOPT(*IGNTGTRCV)                       /*CSC018*/
             MONMSG     MSGID(CPF2105) EXEC(DO)                                           /*CSC018*/
/*                                                                                        /*CSC018*/
             GOTO       CMDLBL(ENDDLTRCV)                                                 /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
             ELSE       CMD(DO)                                                           /*CSC018*/
             DLTJRNRCV  JRNRCV(&JLIB/&SAVF_NAME)
             MONMSG     MSGID(CPF2105) EXEC(DO)
             GOTO       CMDLBL(ENDDLTRCV)
             ENDDO
             MONMSG     MSGID(CPF0000)
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If remote journaling is being used,                                                    /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&RMTJR6 *EQ 'Y') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete the next receiver.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                   &JLIBRMT *TCAT '/' *CAT &SAVF_NAME *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the next receiver in the remote                   /*CSC018*/
/* journaling library on the other machine.                                               /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
/* If Backup journal management is being used,                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             IF         COND(&MNGBJ6 *EQ '&') THEN(DO)                                    /*CSC018*/
/*                                                                                        /*CSC018*/
/* Calculate remote command to delete receiver ICRCV001.                                  /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE(' ')                                           /*CSC018*/
             CHGVAR     VAR(&RMTCM6) VALUE('DLTJRNRCV ' *CAT +
                          &JLIBBKP *TCAT '/' *CAT &SAVF_NAME *CAT ' +
                          DLTOPT(*IGNINQMSG)')                                            /*CSC018*/
/*                                                                                        /*CSC018*/
/* Execute the remote command to delete the receiver in the                               /*CSC018*/
/* journaling library on the backup machine.                                              /*CSC018*/
/*                                                                                        /*CSC018*/
             SBMRMTCMD  CMD(&RMTCM6) DDMFILE(&DDMLI6/&DDMRM6)                             /*CSC018*/
             MONMSG     MSGID(CPF0000 MCH0000)                                            /*CSC018*/
/*                                                                                        /*CSC018*/
             ENDDO                                                                        /*CSC018*/
/*                                                                                        /*CSC018*/
             CHGVAR     VAR(&COUNT) VALUE(&COUNT + 1)
             GOTO       CMDLBL(DLTRCV)
 ENDDLTRCV:
             CHGJOB     INQMSGRPY(*RQD)
             GOTO       CMDLBL(ENDCLPGM)
/**/
/**/
/**************************************************************/
/*                                                            */
/* A B N O R M A L   T E R M I N A T I O N                    */
/*                                                            */
/**************************************************************/
ABNORMAL:
             CHGJOB     SWS(XXXXXX1X)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CALL       PGM(SCC2450)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             SNDPGMMSG  MSG('Program SCC2461 ended abnormally') +
                          TOMSGQ(MOPERQ MRUNQ)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
             CHGDTAARA  DTAARA(JNSTAT (69 1)) VALUE('N')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 ENDCLPGM:
             ENDPGM
