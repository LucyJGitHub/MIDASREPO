/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SC Switchable features control')                */
/*********************************************************************/
/*                                                                   */
/*       Midas     - System Control Module                           */
/*                                                                   */
/*       SCC3010M - Switchable Features Control                      */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD055681           Date 31Jul20              */
/*       Prev Amend No. MD046248           Date 27Oct17              */
/*                      AR316373           Date 03Jun15              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CSC014             Date 11Apr02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CCB009             DATE 01Jun00              */
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      CPB001             DATE 17Aug00              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPL002             DATE 08Mar99              */
/*                      CUT004             DATE 09OCT98              */
/*                      S01486             DATE 20JUN94              */
/*                      S01498             DATE 20JUN94              */
/*                      S01522             DATE 25NOV94              */
/*                      061289             DATE 28SEP93              */
/*                      S01430             DATE 22SEP93              */
/*                      S01407             DATE 22JAN93              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD055681 - Deliverable Data Split for SAR                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR316373 - Recompile due to change in /COPY MLCOVRDCL and   */
/*                  MLCOVROVR.                                       */
/*       CSC014 - Allow support for DBCS (Recompiled)                */
/*       CCB009 - Journal files throughout close of business         */
/*       CPB001 - Private Banking Module                             */
/*                Just Recompile                                     */
/*       CPL002 - Midas / Plato Interface Enhancement (Recompiled)   */
/*       CUT004 - Allow Core and Non-Core mode of multilanguage      */
/*                compiles of display files                          */
/*       S01486 - PORTFOLIO MANAGEMENT                               */
/*       S01498 - PORTFOLIO LENDING - LOMBARD CREDITS                */
/*       S01522 - User Defined Correspondence                        */
/*       061289 - Add override for message file LERMSGF              */
/*       S01430 - SWITCHABILITY ENHANCEMENTS PHASE 2                 */
/*                INCLUSION OF SWITCHABLE FEATURE INITIALISATION     */
/*                PROGRAMS                                           */
/*                INCLUDE MULTILANGUAGE OVERRIDES                    */
/*       S01407 - SWITCHABILITY ENHANCEMENTS                         */
/*                THIS PROGRAM REPLACE SCC0180 (MADE REDUNDANT)      */
/*                                                                   */
/*********************************************************************/
             PGM
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCL        VAR(&RTN) TYPE(*CHAR) LEN(7)
/**/
/************DCL********VAR(&Y2MGFLA8) TYPE(*CHAR) LEN(8)      /*S01430 CUT004*/
/************DCL********VAR(&MIMGFLA8) TYPE(*CHAR) LEN(8)      /*S01430 CUT004*/
/************DCL********VAR(&CBMGFLA8) TYPE(*CHAR) LEN(8)               CUT004*/
/************DCL********VAR(&Y2MGFLA10) TYPE(*CHAR) LEN(10)    /*S01430 CUT004*/
/************DCL********VAR(&MIMGFLA10) TYPE(*CHAR) LEN(10)    /*S01430 CUT004*/
/************DCL********VAR(&CBMGFLA10) TYPE(*CHAR) LEN(10)             CUT004*/
/**/
/************DCL********VAR(&MULT) TYPE(*CHAR) LEN(2)          /*S01430 CUT004*/
/************DCL********VAR(&MITLG) TYPE(*CHAR) LEN(10)        /*S01430 CUT004*/
/************DCL********VAR(&MITZLG) TYPE(*CHAR) LEN(10)       /*S01430 CUT004*/
/************DCL********VAR(&MITCLG) TYPE(*CHAR) LEN(10)       /*S01430 CUT004*/
/**/                                                                  /*S01430*/
/************DCL********VAR(&ZZMSGF) TYPE(*CHAR) LEN(8)        /*S01430 CUT004*/
/************DCL********VAR(&SDUSRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&GLUSRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&CBUSRLG) TYPE(*CHAR) LEN(10)               CUT004*/
/************DCL********VAR(&MIDASLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&DRSMMLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&MACLG) TYPE(*CHAR) LEN(10)        /*S01430 CUT004*/
/************DCL********VAR(&MIUSRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&WNLG) TYPE(*CHAR) LEN(10)         /*S01430 CUT004*/
/************DCL********VAR(&Y1USRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&Y2USRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&Y2USRPMLG) TYPE(*CHAR) LEN(10)    /*S01430 CUT004*/
/************DCL********VAR(&HFMSGF)   TYPE(*CHAR) LEN(10)     /*S01430 CUT004*/
/************DCL********VAR(&XXUSRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&FCUSRLG) TYPE(*CHAR) LEN(10)      /*S01430 CUT004*/
/************DCL********VAR(&SEUSRMSG) TYPE(*CHAR) LEN(10)     /*S01430 CUT004*/
/************DCL********VAR(&LERMSGF) TYPE(*CHAR) LEN(10)      /*061289 CUT004*/
/************DCL********VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)     /*S01522 CUT004*/
/************DCL********VAR(&PMUSRMSG) TYPE(*CHAR) LEN(10)     /*S01486 CUT004*/
/************DCL********VAR(&LBUSRMSG) TYPE(*CHAR) LEN(10)     /*S01498 CUT004*/
/**/
             DCL        VAR(&STSMSG) TYPE(*CHAR) LEN(5)
             DCL        VAR(&RPY) TYPE(*CHAR) LEN(1)
/************DCL********VAR(&MIDASMSG) TYPE(*CHAR) LEN(10)              CUT004*/
             DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)
/*                                                                      CCB009*/
/* Declare variable CCB009 - flag for switchable feature                CCB009*/
/*                                                                      CCB009*/
             DCL        VAR(&CCB009) TYPE(*CHAR) LEN(7)               /*CCB009*/
             DCL        VAR(&AOFMT) TYPE(*CHAR) LEN(200)              /*CCB009*/
/**/
/************DCL********VAR(&GROUP) TYPE(*CHAR) LEN(50)                 CUT004*/
/************DCL********VAR(&USER) TYPE(*CHAR) LEN(25)                  CUT004*/
/************DCL********VAR(&SLEVEL) TYPE(*DEC) LEN(4)                  CUT004*/
/************DCL********VAR(&TIMEO) TYPE(*DEC) LEN(5)                   CUT004*/
/************DCL********VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)         CUT004*/
/************DCL********VAR(&MULT) TYPE(*CHAR) LEN(2)                   CUT004*/
/**/
/*/COPY MLCPYSRC,MLCOVRDCL                                         */ /*CUT004*/
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
/**/
/* Create dtaara/MIDASMSG in QTEMP */
/**/
             CRTDTAARA  DTAARA(QTEMP/MIDASMSG) TYPE(*CHAR) LEN(800) +
                          VALUE(' ') TEXT('Midas SC Midas +
                          information screen data')
             MONMSG     MSGID(CPF0000)
/**/
/* Override message file **/
/**/
/************RTVDTAARA**DTAARA(Y2MGFLA) RTNVAR(&Y2MGFLA10)     /*S01430 CUT004*/
/************RTVDTAARA**DTAARA(MIMGFLA) RTNVAR(&MIMGFLA10)     /*S01430 CUT004*/
/************RTVDTAARA**DTAARA(CBMGFLA) RTNVAR(&CBMGFLA10)              CUT004*/
/************CALL*******PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  + CUT004*/
/***********************  &ERRORC &MULT)                                CUT004*/
/**/
/************IF*********COND(&MULT *EQ '  ') THEN(DO)                   CUT004*/
/************CHGVAR*****VAR(&MULT) VALUE('GB')                          CUT004*/
/************ENDDO******                                                CUT004*/
/**/
/*****CHGVAR*****VAR(&ZZMSGF) VALUE('ZZ' *CAT &MULT *CAT 'MSGF') /*1430 CUT004*/
/*****CHGVAR*****VAR(&MITLG) VALUE(&MULT *CAT 'MITEM     ')    /*S01430 CUT004*/
/*****CHGVAR*****VAR(&MITZLG) VALUE(&MULT *CAT 'MITEMZZ   ')   /*S01430 CUT004*/
/*****CHGVAR*****VAR(&MITCLG) VALUE(&MULT *CAT 'MITMC     ')   /*S01430 CUT004*/
/*****CHGVAR*****VAR(&Y2MGFLA8) VALUE(%SST(&Y2MGFLA10 1 8))    /*S01430 CUT004*/
/*****CHGVAR*****VAR(&MIMGFLA8) VALUE(%SST(&MIMGFLA10 1 8))    /*S01430 CUT004*/
/*****CHGVAR*****VAR(&CBMGFLA8) VALUE(%SST(&CBMGFLA10 1 8))             CUT004*/
/*****CHGVAR*****VAR(&SDUSRLG) VALUE(&MULT *CAT &Y2MGFLA8)     /*S01430 CUT004*/
/*****CHGVAR*****VAR(&GLUSRLG) VALUE(&MULT *CAT &MIMGFLA8)     /*S01430 CUT004*/
/*****CHGVAR*****VAR(&CBUSRLG) VALUE(&MULT *CAT &CBMGFLA8)              CUT004*/
/*****CHGVAR*****VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*S01430 CUT004*/
/*****CHGVAR*****VAR(&DRSMMLG) VALUE(&MULT *CAT 'DRSMM     ')  /*S01430 CUT004*/
/*****CHGVAR*****VAR(&MACLG) VALUE(&MULT *CAT 'MACMSG    ')    /*S01430 CUT004*/
/*****CHGVAR*****VAR(&MIUSRLG) VALUE(&MULT *CAT 'MIUSRMSG  ')  /*S01430 CUT004*/
/*****CHGVAR*****VAR(&WNLG) VALUE(&MULT *CAT 'WNMSGF    ')     /*S01430 CUT004*/
/*****CHGVAR*****VAR(&Y1USRLG) VALUE(&MULT *CAT 'Y1USRMSG  ')  /*S01430 CUT004*/
/*****CHGVAR*****VAR(&Y2USRLG) VALUE(&MULT *CAT 'Y2USRMSG  ')  /*S01430 CUT004*/
/*****CHGVAR*****VAR(&Y2USRPMLG) VALUE(&MULT *CAT 'Y2USRPMT  ') /*01430 CUT004*/
/*****CHGVAR*****VAR(&FCUSRLG)  VALUE(&MULT *CAT 'FCUSRMSG  ') /*S01430 CUT004*/
/*****CHGVAR*****VAR(&MIDASMSG) VALUE(&MULT *CAT 'MIDASMSG  ')          CUT004*/
/*****CHGVAR*****VAR(&HFMSGF)   VALUE(&MULT *CAT 'HFMSGF    ') /*S01430 CUT004*/
/*****CHGVAR*****VAR(&XXUSRLG)  VALUE(&MULT *CAT 'XXUSRMSG  ') /*S01430 CUT004*/
/*****CHGVAR*****VAR(&SEUSRMSG) VALUE(&MULT *CAT 'SEUSRMSG  ') /*S01430 CUT004*/
/*****CHGVAR*****VAR(&LERMSGF) VALUE(&MULT *CAT 'LERMSGF   ')  /*061289 CUT004*/
/*****CHGVAR*****VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*S01522 CUT004*/
/*****CHGVAR*****VAR(&PMUSRMSG) VALUE(&MULT *CAT 'PMUSRMSG  ') /*S01486 CUT004*/
/*****CHGVAR*****VAR(&LBUSRMSG) VALUE(&MULT *CAT 'LBUSRMSG  ') /*S01498 CUT004*/
/**/                                                                  /*S01430*/
/*  APPLY MULTIPLE LANGUAGE SUPPORT OVERRIDES  */                     /*S01430*/
/**/                                                                  /*S01430*/
/************OVRDBF*****FILE(MITEM) MBR(&MITLG) SHARE(*NO)     /*S01430 CUT004*/
/************OVRDBF*****FILE(MITEMJ0) MBR(&MITLG) SHARE(*NO)   /*S01430 CUT004*/
/************OVRDBF*****FILE(MITEMJ1) MBR(&MITLG) SHARE(*NO)   /*S01430 CUT004*/
/************OVRDBF*****FILE(MITEMZZ) MBR(&MITZLG)             /*S01430 CUT004*/
/************OVRDBF*****FILE(MITMC) MBR(&MITCLG)               /*S01430 CUT004*/
/***********************                                              /*S01430*/
/************OVRMSGF****MSGF(ZZGBMSGF) TOMSGF(&ZZMSGF)         /*S01430 CUT004*/
/************OVRMSGF****MSGF(&Y2MGFLA10) TOMSGF(&SDUSRLG)      /*S01430 CUT004*/
/************OVRMSGF****MSGF(&MIMGFLA10) TOMSGF(&GLUSRLG)      /*S01430 CUT004*/
/************OVRMSGF****MSGF(&CBMGFLA10) TOMSGF(&CBUSRLG)               CUT004*/
/************OVRMSGF****MSGF(MIDAS) TOMSGF(&MIDASLG)           /*S01430 CUT004*/
/************OVRMSGF****MSGF(DRSMM) TOMSGF(&DRSMMLG)           /*S01430 CUT004*/
/************OVRMSGF****MSGF(MACMSG) TOMSGF(&MACLG)            /*S01430 CUT004*/
/************OVRMSGF****MSGF(MIUSRMSG) TOMSGF(&MIUSRLG)        /*S01430 CUT004*/
/************OVRMSGF****MSGF(WNMSGF) TOMSGF(&WNLG)             /*S01430 CUT004*/
/************OVRMSGF****MSGF(Y1USRMSG) TOMSGF(&Y1USRLG)        /*S01430 CUT004*/
/************OVRMSGF****MSGF(Y2USRMSG) TOMSGF(&Y2USRLG)        /*S01430 CUT004*/
/************OVRMSGF****MSGF(Y2USRPMT) TOMSGF(&Y2USRPMLG)      /*S01430 CUT004*/
/************OVRMSGF****MSGF(FCUSRMSG) TOMSGF(&FCUSRLG)        /*S01430 CUT004*/
/************OVRMSGF****MSGF(MIDASMSG) TOMSGF(&MIDASMSG)                CUT004*/
/************OVRMSGF****MSGF(HFMSGF)   TOMSGF(&HFMSGF)         /*S01430 CUT004*/
/************OVRMSGF****MSGF(XXUSRMSG) TOMSGF(&XXUSRLG)        /*S01430 CUT004*/
/************OVRMSGF****MSGF(SEUSRMSG) TOMSGF(&SEUSRMSG)       /*S01430 CUT004*/
/************OVRMSGF****MSGF(LERMSGF) TOMSGF(&LERMSGF)         /*061289 CUT004*/
/************OVRMSGF****MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)       /*S01522 CUT004*/
/************OVRMSGF****MSGF(PMUSRMSG) TOMSGF(&PMUSRMSG)       /*S01486 CUT004*/
/************OVRMSGF****MSGF(LBUSRMSG) TOMSGF(&LBUSRMSG)       /*S01498 CUT004*/
/**/
/*/COPY MLCPYSRC,MLCOVROVR                                         */ /*CUT004*/
/**/
/* Program not available if Midas system is active */
/**/
 LOOP1:      CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)
             RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&STSMSG)
/**/
/* If &STSMSG not blank, then at least one Midas job is active */
/**/
             IF         COND(&STSMSG *NE '     ') THEN(DO)
 LOOP2:      CHGVAR     VAR(&RPY) VALUE('N')

             RTVMSG     MSGID(SCM0069) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (301 50)) VALUE(&MESSAGE)
             RTVMSG     MSGID(SCM0070) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (401 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SCC3010M' 'RETRY' &RPY)

             IF         COND((&RPY *EQ 'Y') *OR (&RPY *EQ 'y')) +
                          THEN(GOTO CMDLBL(LOOP1))
             IF         COND((&RPY *EQ 'N') *OR (&RPY *EQ 'n')) +
                          THEN(GOTO CMDLBL(END))
             ELSE       CMD(GOTO CMDLBL(LOOP2))
             ENDDO
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**/
/* Journal files before calling maintenance program */
/**/
/**********  STRJRNPF   FILE(SCSARDPD) JRN(ICJRN) IMAGES(*BOTH) */                      /*MD055681*/
             STRJRNPF   FILE(SCSRDCTD) JRN(ICJRN) IMAGES(*BOTH)                         /*MD055681*/
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(SCSRDBTD) JRN(ICJRN) IMAGES(*BOTH)                         /*MD055681*/
             MONMSG     MSGID(CPF7030)                                                  /*MD055681*/
             STRJRNPF   FILE(SCSRDXTD) JRN(ICJRN) IMAGES(*BOTH)                         /*MD055681*/
             MONMSG     MSGID(CPF7030)                                                  /*MD055681*/
             STRJRNPF   FILE(SCSARCPD) JRN(ICJRN) IMAGES(*BOTH)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(SCSARIPD) JRN(ICJRN) IMAGES(*BOTH)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(SCSARMPD) JRN(ICJRN) IMAGES(*BOTH)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(SCSAROPD) JRN(ICJRN) IMAGES(*BOTH)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(SCSARRPD) JRN(ICJRN) IMAGES(*BOTH)
             MONMSG     MSGID(CPF7030)
             STRJRNPF   FILE(SCSARPPD) JRN(ICJRN) IMAGES(*BOTH)       /*S01430*/
             MONMSG     MSGID(CPF7030)                                /*S01430*/
             ENDDO                                                    /*CCB009*/
/**/
             CALL       PGM(SC3010M) PARM(&RTN)
/**/
/*                                                                      CCB009*/
/* If Feature CCB009 is NOT 'on' (close of business journaling),        CCB009*/
/*                                                                      CCB009*/
             IF         COND(&CCB009 *NE '       ') THEN(DO)          /*CCB009*/
/**********  ENDJRNPF   FILE(SCSARDPD) */                                               /*MD055681*/
             ENDJRNPF   FILE(SCSRDCTD)                                                  /*MD055681*/
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(SCSRDBTD)                                                  /*MD055681*/
             MONMSG     MSGID(CPF0000)                                                  /*MD055681*/
             ENDJRNPF   FILE(SCSRDXTD)                                                  /*MD055681*/
             MONMSG     MSGID(CPF0000)                                                  /*MD055681*/
             ENDJRNPF   FILE(SCSARCPD)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(SCSARIPD)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(SCSARMPD)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(SCSAROPD)
             MONMSG     MSGID(CPF0000)
             ENDJRNPF   FILE(SCSARRPD)
             MONMSG     MSGID(CPF0000)
                                                                      /*S01430*/
             ENDJRNPF   FILE(SCSARPPD)                                /*S01430*/
             MONMSG     MSGID(CPF0000)                                /*S01430*/
             ENDDO                                                    /*CCB009*/
                                                                      /*S01430*/
/**/
             IF         COND(&RTN *NE '       ') THEN(GOTO +
                          CMDLBL(ABNOR))
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/
             GOTO       CMDLBL(END)
/**/
 ABNOR:
             CHGVAR     VAR(&RPY) VALUE('N')
             RTVMSG     MSGID(SCM0071) MSGF(MIDASMSG) MSG(&MESSAGE)
             CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)
             CALL       PGM(SCC0010) PARM('SCC3010M' 'JOBLOG' &RPY)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/**/
 END:        ENDPGM
