/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('Midas GL Component for enq program GL4443')           */
/*********************************************************************/
/*                                                                   */
/*       Midas - General Ledger Module                               */
/*                                                                   */
/*       GLC443 - CONTROLING CL COMPONENT FOR                        */
/*                PROJECTED LEDGER MOVEMENTS TODAY                   */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. BUG9553            Date 13Jan06              */
/*       Prev Amend No. TDA105             Date 31Mar04              */
/*                      CAP084             Date 08Jul03              */
/*                      CSF002             Date 11Aug03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC014             Date 11Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      153379             DATE 15Oct99              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPB001             DATE 17AUG99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPL002             DATE 08MAR99              */
/*                      CUT004             DATE 09OCT98              */
/*                      125333             DATE 18MAY98              */
/*                      088222             DATE 24OCT95              */
/*                      S01408             DATE 25JUL95              */
/*                      088207             DATE 20JUL95              */
/*                      S01408             DATE 12JAN95              */
/*                      059231             DATE 27OCT93              */
/*                      S01405             DATE 08DEC92              */
/*                      LN1273             DATE 22MAY91              */
/*                      LN1245             DATE 13MAY91              */
/*                      S01314             DATE 15APR91              */
/*                      E21438             DATE 22MAY90              */
/*                      S01253             DATE 17APR90              */
/*                      S01117             DATE 14/07/89             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       BUG9553 - Create dataarea EMDTA as this is required by      */
/*                 GL4443                                            */
/*       TDA105 - Enquiry falling over on a group job environment    */
/*                because previous override is not being recognised  */
/*       CAP084 - Parameter added to ZMUSER for Java wrappers        */
/*       CSF002 - Global layer.                                      */
/*                - Replace previous ZMITEM data with the new unique */
/*                  code. Remove the command which sets up SFC0600   */
/*                  as the program to be called when Attention Key   */
/*                  is pressed since SFC0600 is made redundant       */
/*                  already.                                         */
/*       CSC014 - Allow support for DBCS (Recompiled)                */
/*       153379 - The GLCJOB group session SETANTPGM is SFC0600      */
/*                (the manual instruction) rather than the session   */
/*                manager SETATNPGM SFC4460, so GLCJOB group jobs    */
/*                are not open to session manager due to limitation  */
/*                problems. (Fix 122745.)                            */
/*       CPB001 - Private Banking Module                             */
/*                Just Recompile                                     */
/*       CPL002 - Midas / Plato Interface Enhancement (Recompiled)   */
/*       CUT004 - Allow Core and Non-Core mode of multilanguage      */
/*                compiles of display files                          */
/*       125333 - Fix of 088222 incomplete. The Session Manager      */
/*                program loops because dtaara ZMITEM not found in   */
/*                the group job. Fix is to create dtaara ZMITEM in   */
/*                the new group job.                                 */
/*       088222 - If the user pressed Attention Key and selected     */
/*                SD enquiry, those pgm will try to accesss some     */
/*                dataarea and message files not setup in the group  */
/*                job and caused problem during input cycle.         */
/*                NOTE: This fix is to incorporate some logic as     */
/*                      defined in MLC0000.  If there are any further*/
/*                      changes in MLC0000.  It is necessary to amd  */
/*                      this pgm as well.                            */
/*       S01408 - Addition of core hook GLC443MP1                    */
/*                Addition of core hook GLC443MP2                    */
/*       088207 - Set up override for GLUSRMSG                       */
/*       S01408 - Addition of core hook GLC443INT                    */
/*                Addition of core hook GLC443MPS                    */
/*       059231 - If error is detected in cmd/TFRGRPJOB, produce     */
/*                program dump and end the program.                  */
/*       S01405 - AMEND USE OF GROUP JOBS TO ALLOW FOR SESSION       */
/*                MANAGER.                                           */
/*       LN1273 - IF MBIN = N, DTAARA ZMUSER MUST BE CREATED IN      */
/*                QTEMP FOR GROUP JOB                                */
/*       LN1245 - ADD IN AN OVERRIDE FOR NEW MSGF FCUSRMSG           */
/*       S01314 - CHANGED DURING PTF INCORPORATION - SD2320 RENAMED  */
/*                TO SF0410.                                         */
/*       E21438 - ADOPT USER PROFILE BY CHANGING USRPRF(*USER)       */
/*                TO USRPRF(*OWNER) AS CREATION PARAMETER.           */
/*       S01253 - CHANGED FOR MULTILANGUAGE SCREENS                  */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&RTNCDE) TYPE(*CHAR) LEN(1)   VALUE('0')
             DCL        VAR(&MBIN) TYPE(*CHAR) LEN(1)                 /*S01117*/
 
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                                     /*TDA105*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)                                   /*TDA105*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                                    /*TDA105*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                                    /*TDA105*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                                     /*TDA105*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)                           /*TDA105*/
             DCL        VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)                                 /*TDA105*/
 
/* THE FOLLOWING LINES ADDED FOR USER DEFINED MENUS               */  /*S01253*/
/************DCL********VAR(&MULT) TYPE(*CHAR) LEN(2)          /*S01253 CUT004*/
/************DCL********VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)        /*S01253 CUT004*/
/************DCL********VAR(&GROUP) TYPE(*CHAR) LEN(50)        /*S01253 CUT004*/
/************DCL********VAR(&USER) TYPE(*CHAR) LEN(25)         /*S01253 CUT004*/
/************DCL********VAR(&SLEVEL) TYPE(*DEC) LEN(4)         /*S01253 CUT004*/
/************DCL********VAR(&TIMEO) TYPE(*DEC) LEN(5)          /*S01253 CUT004*/
/************DCL********VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)/*S01253 CUT004*/
/************DCL********VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)      /*LN1245 CUT004*/
/************DCL********VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)      /*088207 CUT004*/
             DCL        VAR(&GRPJOBNAM) TYPE(*CHAR) LEN(10)           /*S01405*/
/************DCL********VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)      /*088222 CUT004*/
/************DCL********VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)      /*088222 CUT004*/
/************DCL********VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)      /*088222 CUT004*/
/************DCL********VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)    /*088222 CUT004*/
/************DCL********VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)    /*088222 CUT004*/
/************DCL********VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10)    /*088222 CUT004*/
/************DCL********VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&MIDASLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&MACLG) TYPE(*CHAR) LEN(10)        /*088222 CUT004*/
/************DCL********VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&WNLG) TYPE(*CHAR) LEN(10)         /*088222 CUT004*/
/************DCL********VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)    /*088222 CUT004*/
/************DCL********VAR(&MIDASMSG) TYPE(*CHAR) LEN(10)     /*088222 CUT004*/
/************DCL********VAR(&HFMSGF)   TYPE(*CHAR) LEN(10)     /*088222 CUT004*/
/************DCL********VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&SEUSRMSG) TYPE(*CHAR) LEN(10)     /*088222 CUT004*/
/************DCL********VAR(&LERMSGF) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&MEMSG) TYPE(*CHAR) LEN(10)        /*088222 CUT004*/
/************DCL********VAR(&FTUSRMSG) TYPE(*CHAR) LEN(10)     /*088222 CUT004*/
/************DCL********VAR(&REUSRLG) TYPE(*CHAR) LEN(10)      /*088222 CUT004*/
/************DCL********VAR(&REPTMSGF) TYPE(*CHAR) LEN(10)     /*088222 CUT004*/
             DCL        VAR(&ZMUSER) TYPE(*CHAR) LEN(10)                                  /*CAP084*/
 
/*/COPY MLCPYSRC,MLCOVRDCL                                         */ /*CUT004*/
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC443INT                                    */      /*S01408*/
/**/                                                                  /*S01408*/
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
             RTVDTAARA  DTAARA(*GDA (450 10)) RTNVAR(&GRPJOBNAM)      /*S01405*/
/************IF         COND(%SST(&GRPJOBNAM 1 5) *EQ 'S1405') +        153379*/
/************             THEN(SETATNPGM PGM(SFC4460))           S01405 153379*/
/************ELSE       CMD(SETATNPGM PGM(SFC0600))              S01405 153379*/
/**********  SETATNPGM  PGM(SFC0600)                                           /*153379*/ /*CSF002*/
                                                                                         /*BUG9553*/
             CHKOBJ     OBJ(QTEMP/EMSDS) OBJTYPE(*DTAARA)                                /*BUG9553*/
             MONMSG     MSGID(CPF9800) EXEC(DO)                                          /*BUG9553*/
             CRTDTAARA  DTAARA(QTEMP/EMSDS) TYPE(*CHAR) LEN(167)                         /*BUG9553*/
             ENDDO                                                                       /*BUG9553*/
             CHGDTAARA  DTAARA(QTEMP/EMSDS) VALUE(' ')                                   /*BUG9553*/
                                                                                         /*BUG9553*/
 
             RTVDTAARA  DTAARA(RUNDAT (13 1)) RTNVAR(&MBIN)           /*S01117*/
/* */                                                                 /*S01117*/
/*   CREATE AND SET UP USER DATA AREA    */                           /*S01117*/
/* */                                                                 /*S01117*/
             IF         COND(&MBIN *EQ 'Y') THEN(CALL PGM(SFC0400))   /*S01117*/
 
/* */                                                                 /*LN1273*/
             CHKOBJ     OBJ(QTEMP/ZMUSER) OBJTYPE(*DTAARA)            /*LN1273*/
             MONMSG     MSGID(CPF9815 CPF9801) EXEC(DO)               /*LN1273*/
/************CALL       PGM(ZMUSER) PARM(&ERRORC)                     /*LN1273*/          /*CAP084*/
             CALL       PGM(ZMUSER) PARM(&ERRORC &ZMUSER)                                 /*CAP084*/
             IF         COND(&ERRORC *NE 0) THEN(DO)                  /*LN1273*/
             SNDPGMMSG  MSG('Default Branch or Department not valid') +
                          TOPGMQ(*EXT) MSGTYPE(*INFO)                 /*LN1273*/
             SIGNOFF    LOG(*LIST)                                    /*LN1273*/
             MONMSG     MSGID(CPF0000) /* Monitor here to prevent +
                          error during re-routing of job */           /*LN1273*/
             ENDDO                                                    /*LN1273*/
             ENDDO                                                    /*LN1273*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                                                  /*TDA105*/
/* */                                                                 /*LN1273*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                                     /*TDA105*/
             CHGVAR     VAR(&MULT) VALUE('GB')                                            /*TDA105*/
             ENDDO                                                                        /*TDA105*/
/* */                                                                                     /*TDA105*/
             CHGVAR     VAR(&GLUSRLG)  VALUE(&MULT *CAT 'GLUSRMSG  ')                     /*TDA105*/
             OVRMSGF    MSGF(GLUSRMSG) TOMSGF(&GLUSRLG)                                   /*TDA105*/
/* */                                                                                     /*TDA105*/
/************CALL*******PGM(SD2320) PARM(&GROUP &USER &SLEVEL &TIMEO  +
 *************************&ERRORC &MULT)           *****/  /*S01253*/ /*S01314*/
/************CALL*******PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
/***********************  &ERRORC &MULT)                       /*S01314 CUT004*/
/***********************                                               *CUT004*/
/************IF*********COND(&MULT *EQ '  ') THEN(DO)          /*S01253 CUT004*/
/************CHGVAR*****VAR(&MULT) VALUE('GB')                 /*S01253 CUT004*/
/************ENDDO******                                       /*S01253 CUT004*/
 
/* Retrieve data areas for Multiple Language Support */               /*088222*/
                                                                      /*088222*/
/************RTVDTAARA**DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)     /*088222 CUT004*/
/************RTVDTAARA**DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)     /*088222 CUT004*/
/************RTVDTAARA**DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10)     /*088222 CUT004*/
/***********************                                       /*088222 CUT004*/
/*****CHGVAR***VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF') /*S01253 CUT004*/
/*****CHGVAR****VAR(&FCUSRLG)  VALUE(&MULT *CAT 'FCUSRMSG  ')  /*LN1245 CUT004*/
/*****CHGVAR****VAR(&GLUSRLG)  VALUE(&MULT *CAT 'GLUSRMSG  ')  /*088207 CUT004*/
/*****CHGVAR*****VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))    /*088222 CUT004*/
/*****CHGVAR*****VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))    /*088222 CUT004*/
/*****CHGVAR*****VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8))    /*088222 CUT004*/
/*****CHGVAR*****VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)     /*088222 CUT004*/
/*****CHGVAR*****VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)     /*088222 CUT004*/
/*****CHGVAR*****VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8)     /*088222 CUT004*/
/*****CHGVAR*****VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*088222 CUT004*/
/*****CHGVAR*****VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')  /*088222 CUT004*/
/*****CHGVAR*****VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')    /*088222 CUT004*/
/*****CHGVAR*****VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')  /*088222 CUT004*/
/*****CHGVAR*****VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')     /*088222 CUT004*/
/*****CHGVAR*****VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')  /*088222 CUT004*/
/*****CHGVAR*****VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*088222 CUT004*/
/*****CHGVAR****VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ') /*088222 CUT004*/
/*****CHGVAR*****VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ') /*088222 CUT004*/
/*****CHGVAR*****VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF    ') /*088222 CUT004*/
/*****CHGVAR*****VAR(&XXUSRLG)  VALUE(&MULT *CAT 'XXUSRMSG  ') /*088222 CUT004*/
/*****CHGVAR*****VAR(&SEUSRMSG) VALUE(&MULT *CAT 'SEUSRMSG  ') /*088222 CUT004*/
/*****CHGVAR*****VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF  ')   /*088222 CUT004*/
/*****CHGVAR*****VAR(&MEMSG) VALUE(&MULT *CAT 'MEMSG     ')    /*088222 CUT004*/
/*****CHGVAR*****VAR(&FTUSRMSG) VALUE(&MULT *CAT 'FTUSRMSG  ') /*088222 CUT004*/
/*****CHGVAR*****VAR(&REUSRLG) VALUE(&MULT *CAT 'REUSRMSG  ')  /*088222 CUT004*/
/*****CHGVAR*****VAR(&REPTMSGF) VALUE(&MULT *CAT 'REPTMSGF  ') /*088222 CUT004*/
/******************************************************************** /*CUT004*/
/************OVRMSGF****MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)         /*S01253 CUT004*/
/************OVRMSGF****MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)        /*LN1245 CUT004*/
/************OVRMSGF****MSGF(GLUSRMSG) TOMSGF(&GLUSRLG)        /*088207 CUT004*/
/************OVRMSGF****MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)      /*088222 CUT004*/
/************OVRMSGF****MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)      /*088222 CUT004*/
/************OVRMSGF****MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)      /*088222 CUT004*/
/************OVRMSGF****MSGF(MIDAS) TOMSGF(&MIDASLG)           /*088222 CUT004*/
/************OVRMSGF****MSGF(DRSMM) TOMSGF(&DRSMMLG)           /*088222 CUT004*/
/************OVRMSGF****MSGF(MACMSG) TOMSGF(&MACLG)            /*088222 CUT004*/
/************OVRMSGF****MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)        /*088222 CUT004*/
/************OVRMSGF****MSGF(WNMSGF) TOMSGF(&WNLG)             /*088222 CUT004*/
/************OVRMSGF****MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)        /*088222 CUT004*/
/************OVRMSGF****MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)        /*088222 CUT004*/
/************OVRMSGF****MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)      /*088222 CUT004*/
/************OVRMSGF****MSGF(MIDASMSG) TOMSGF(&MIDASMSG)       /*088222 CUT004*/
/************OVRMSGF****MSGF(HFMSGF)   TOMSGF(&HFMSGF)         /*088222 CUT004*/
/************OVRMSGF****MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)        /*088222 CUT004*/
/************OVRMSGF****MSGF(SEUSRMSG) TOMSGF(&SEUSRMSG)       /*088222 CUT004*/
/************OVRMSGF****MSGF(LERMSGF) TOMSGF(&LERMSGF)         /*088222 CUT004*/
/************OVRMSGF****MSGF(MEMSG) TOMSGF(&MEMSG)             /*088222 CUT004*/
/************OVRMSGF****MSGF(FTUSRMSG) TOMSGF(&FTUSRMSG)       /*088222 CUT004*/
/************OVRMSGF****MSGF(REUSRMSG) TOMSGF(&REUSRLG)        /*088222 CUT004*/
/************OVRMSGF****MSGF(REPTMSGF) TOMSGF(&REPTMSGF)       /*088222 CUT004*/
                                                                      /*CUT004*/
/*/COPY MLCPYSRC,MLCOVROVR                                         */ /*CUT004*/
                                                                      /*088222*/
/* Create the Midas Information Screen data area */                   /*088222*/
 
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')                   /*088222*/
             MONMSG     MSGID(CPF1023)                                /*088222*/
                                                                      /*088222*/
/* Create local data area */                                          /*088222*/
                                                                      /*088222*/
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          TEXT('Midas SD Local data area')            /*088222*/
             MONMSG     MSGID(CPF1023)                                /*088222*/
                                                                      /*088222*/
/**/                                                                  /*S01408*/
/* Create the data area ZMITEM in QTEMP                            */ /*125333*/
 
/**********  CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(9) + */
/**********               VALUE('D        ') TEXT('Midas SF +     */
/**********               Menu group/item code')                  */                      /*CSF002*/
             CRTDTAARA  DTAARA(QTEMP/ZMITEM) TYPE(*CHAR) LEN(10) +
                          VALUE('          ') TEXT('Midas SF +
                          Unique Menu Item Code')                                         /*CSF002*/
             MONMSG     MSGID(CPF1023)                                /*125333*/
/**/                                                                  /*125333*/
/*/COPY WNCPYSRC,GLC443MPS                                    */      /*S01408*/
/**/                                                                  /*S01408*/
/**/
/**  At this point control is transfered to the enquiry        */
/**  program and will not return to this CL program unless     */
/**                                                            */
/**   (i)    User pressed CMD 1 during this enquiry program    */
/**   (ii)   A database error occured within the enquiry       */
/**   (iii)  A program crash occured within the enquiry        */
/**/
 
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC443MP1                                    */      /*S01408*/
/**/                                                                  /*S01408*/
             CALL       PGM(GL4443)
/**/                                                                  /*S01408*/
/*/COPY WNCPYSRC,GLC443MP2                                    */      /*S01408*/
/**/                                                                  /*S01408*/
 
 
/**/
/**  If a data base error occured within the enquiry program   */
/**  then the error will be handled by the group job program   */
/**  GLC440.  An error may also of occured in a program called */
/**  from within the enquiry, if so switch '1' will be set ON. */
/**/
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(CHGVAR +
                          VAR(&RTNCDE) VALUE('1'))
             ELSE
               IF         COND(%SWITCH(1XXXXXXX)) THEN(CHGVAR +
                            VAR(&RTNCDE) VALUE('3'))
 
             GOTO       CMDLBL(RETRN)
 
 
/**/
/**  If an error other than a data base error occurs then      */
/**  again GLC440 will handle it by producing a job log        */
/**/
 
 ABNOR:      CHGVAR     VAR(&RTNCDE) VALUE('2')
 
/**/
/**  Before returning to the controling program ensure that    */
/**  *GDA contains the contents of *LDA and the end status     */
/**  of this program.                                          */
/**/
 
 
 RETRN:      CALL       PGM(GLC440A) PARM('O')
/*********** CHGDTAARA  DTAARA(*GDA (1 1)) VALUE(&RTNCDE)             /*S01405*/
/*********** TFRGRPJOB  GRPJOB(GLCJOB0)                               /*S01405*/
             CHGDTAARA  DTAARA(*GDA (460 1)) VALUE(&RTNCDE) /*S01405*/
             TFRGRPJOB  GRPJOB(&GRPJOBNAM)                            /*S01405*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*059231*/
                  SNDPGMMSG  MSG('Error occured in program GLC443 +
                                  - See Program dump listing') +
                                  TOPGMQ(*EXT) TOMSGQ(MOPERQ)         /*059231*/
                  DMPCLPGM                                            /*059231*/
                  GOTO       CMDLBL(ENDCL)                            /*059231*/
             ENDDO                                                    /*059231*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/************ENDPGM                                                */ /*059231*/
 ENDCL:      ENDPGM                                                   /*059231*/
