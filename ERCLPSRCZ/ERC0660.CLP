/********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI *  TEXT('MIDAS ABS European Reporting - Download of Table')    */
/********************************************************************/
/*                                                                  */
/*     MIDAS/ABS - EUROPEAN REPORTING                               */
/*                                                                  */
/*     ERC0660  - EUROPEAN REPORTING - Download of Tables           */
/*                                                                  */
/*       (c) Misys International Banking Systems Ltd. 2005           */
/*                                                                  */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Last Amend No. CER001             Date 25Apr05              */
/*       Prev Amend No. 187689             Date 19Dec00              */
/*                      CAD016 PT          Date 11Sep98              */
/*                    ULX004             DATE 18OCT94               */
/*                    ER_R10             DATE 18OCT94               */
/*                    ERL437 PT          DATE  02SEP94              */
/*                    ERL421 PT          DATE  02SEP94              */
/*                    ERL355             DATE  18JUN93              */
/*                    ERL316             DATE  17FEB93              */
/*                    ERL300 AF          DATE   19JAN93             */
/*                    ER0117             DATE  10DEC92              */
/*********************************************************************/
/*       CER001 - LUX Upgrade to MidasPlus                           */
/*     187689 - "GRD" CURRENCY IN EMU                                */
/*     CAD016 - ERLU111 IS STILL APPLICABLE                          */
/*     ULX004 - CAPITAL ADEQUACY                                     */
/*     ER_R10 - EUROPEAN REPORTING - LUXEMBOURG UPGRADE IN R10       */
/*            - SUPRESS ERTABTJ AS SDHOLPD IS NOW DEFINED IN ERDWNDPD*/
/*     ERL355 - TO CALL ERLU113 - LUMP-SUM RATES SET UP              */
/*     ERL421 - TO CALL ERLU111 - CORRECTION AMOUNTS FROM A/C UPDATE */
/*     ERL355 - ADD DOWNLOAD FOR PF/SDBRCHPD                         */
/*     ERL316 - ADD DOWNLOAD FOR PF/TABLETJ                          */
/*     ERL300 - Add new field 'Guarantor Report Name'                */
/*     ER0117 - CREDIT RECEIVED AMOUNT COMES NOW FROM ERLIMTBX5      */
/*                  ==> NO MORE USE OF ERLIMTPD                      */
/*********************************************************************/
/**/
             PGM
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(80)
 
 
/* Reset External Switches */
             CHGJOB     SWS(00000000)
 
/*  Download of Country table                                        */
 
             CLRPFM     FILE(ERCTRYPD)
             MONMSG     MSGID(CPF3142) EXEC(DO)
             CHGVAR     VAR(&MSG) VALUE('Job ERC0660 Terminated +
                          Abnormaly during the clear of PF/ERCTRYPD')
             CHGJOB     SWS(XXXXXX11)
             GOTO       ABNORMAL
             ENDDO
 
             CALL       PGM(ER0660)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +
                          ER0660) Terminated - Database Error')
             GOTO       ABNORMAL
             ENDDO
 
/*  Download of Currency table                                       */
 
/* 187689 START */
/************CLRPFM     FILE(ERCURRPD)                                */
/************MONMSG     MSGID(CPF3142) EXEC(DO)                       */
/************CHGVAR     VAR(&MSG) VALUE('Job ERC0660 Terminated +     */
/************             Abnormaly during the clear of PF/ERCURRPD') */
/************CHGJOB     SWS(XXXXXX11)                                 */
/************GOTO       ABNORMAL                                      */
/************ENDDO                                                    */
/************                                                         */
/************CALL       PGM(ER0661)                                   */
/************                                                         */
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              */
/************CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +      */
/************             ER0661) Terminated - Database Error')       */
/************GOTO       ABNORMAL                                      */
/************ENDDO                                                    */
/* 187689 END */
 
/*  Download of Lending Limit                                        */
 
/* ER0117 START */
/************CLRPFM     FILE(ERLIMTPD)                                   */
/************MONMSG     MSGID(CPF3142) EXEC(DO)                          */
/************CHGVAR     VAR(&MSG) VALUE('Job ERC0660 Terminated +        */
/************             Abnormaly during the clear of PF/ERLIMTPD')    */
/************CHGJOB     SWS(XXXXXX11)                                    */
/************GOTO       ABNORMAL                                         */
/************ENDDO                                                       */
 
/************CALL       PGM(ER0662)                                      */
 
/************IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                 */
/************CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +         */
/************             ER0662) Terminated - Database Error')          */
/************GOTO       ABNORMAL                                         */
/************ENDDO                                                       */
 
/*  Download of Dealing Data                                         */
 
             CPYF       FROMFILE(SDDEALPD) TOFILE(ERDEALPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERDEALPD))
 
/*  Download of Dealing Data                                         */
 
             CPYF       FROMFILE(SDBANKPD) TOFILE(ERBANKPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERBANKPD))
 
/*** ERL316 BEGIN ***/
/*  Download of Holidays Table                                       */
 
/************CPYF       FROMFILE(TABLETJ) TOFILE(ERTABTJ) +             ER_R10*/
/************             MBROPT(*REPLACE) FMTOPT(*NONE)                ER_R10*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +    ER_R10*/
/************             FILE(ERTABTJ))                                ER_R10*/
/*** ERL316 END ***/
 
/*** ERL355 BEGIN ***/
/*  Download of Holidays Table                                       */
 
             CPYF       FROMFILE(SDBRCHPD) TOFILE(ERBRCHPD) +
                          MBROPT(*REPLACE) FMTOPT(*NONE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(ERBRCHPD))
/*** ERL355 END ***/
 
/* ERL300 START */
/*  Set up of Guarantor Report Name                                  */
 
 
             CALL       PGM(ERGURNX6)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +
                          ERGURNX6) Terminated - Database Error')
             GOTO       ABNORMAL
             ENDDO
/* ERL300 END */
 
/* ERL421 START */
/* The correction amounts and provisions information are now           ULX004 */
/* maintained by ERL910 and updated by ER0960                          ULX004 */
/********                                                              ULX004 */
/***Set*up*correction*amount*from*correction*account                   ULX004 */
/********                                                              ULX004 */
/********    CALL       PGM(ERLU111)                                   ULX004 */
/********                                                              ULX004 */
/********    IF         COND(%SWITCH(XXXXXX11)) THEN(DO)               ULX004 */
/********    CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +       ULX004 */
/********                 ERLU111) Terminated - Database Error')       ULX004 */
/********    GOTO       ABNORMAL                                       ULX004 */
/********    ENDDO                                                     ULX004 */
/* ERL421 END */
/* CAD016 START */
/* The correction amounts and provisions information are still         CAD016 */
/* maintained by RE3271W6                                              CAD016 */
/*                                                                     CAD016 */
/*  Set up correction amount from correction account                   CAD016 */
/*                                                                     CAD016 */
             CALL       PGM(ERLU111)                                /* CAD016 */
/*                                                                     CAD016 */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)            /* CAD016 */
             CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +
                          ERLU111) Terminated - Database Error')    /* CAD016 */
             GOTO       ABNORMAL                                    /* CAD016 */
             ENDDO                                                  /* CAD016 */
/* CAD016 END */
/* ERL437 START */
/*  Set up of Lump-sum rates from appropriate table                  */
 
             CALL       PGM(ERLU113)
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Job ERC0660, (program +
                          ERLU113) Terminated - Database Error')
             GOTO       ABNORMAL
             ENDDO
/* ERL421 END */
/*  Normal Termination                                               */
             GOTO       FILEND
 
 ABNORMAL:   DMPCLPGM
             MONMSG     MSGID(CPF0000 MCH0000)
             SNDMSG     MSG(&MSG) +
                        TOMSGQ(MOPERQ MRUNQ)
 
FILEND:      ENDPGM
