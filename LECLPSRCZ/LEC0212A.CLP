/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Input cycle confirmations print')            */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC0212A-INPUT CYCLE CONFIRMATIONS PRINT                    */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR322731           Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CSW208             Date 15Apr08              */
/*                      248755             Date 27Jun07              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE044             DATE 09Feb06              */
/* Midas Plus 1.2 ---------------------------------------------------*/
/*                      228542             Date 10Aug04              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      205448             Date 02May02              */
/*                      CCG015             Date 09Aug01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.03 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      142225             Date 18Feb99              */
/*                      124684             DATE 06JAN98              */
/*                      S01408             DATE 12AUG96              */
/*                      S01408             DATE 14MAY96              */
/*                      102427             DATE 24APR96              */
/*                      CCG008             DATE 30OCT95              */
/*                      S01465             DATE 22MAR94              */
/*                      E41579             DATE 09MAR93              */
/*                      E40242             DATE 19JUN92              */
/*                      S01310             DATE 23JUL91              */
/*                      X00000             DATE 00XXX00              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR322731 - LEC0212A and APISERVER locks LTRIX file. Apply   */
/*                  fix 252833A (Child:AR322732)                     */
/*       252833A - Prevent LTRIX RRN 1 from being locked             */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CSW208 - SWIFT 2008 Changes                                 */
/*       248755 - Remove RCLRSC which causes problem in GOSETLOAN.   */
/*       CLE044 - Always run LE0130 regardless of S01465.            */
/*                (Upgrade to Midas Plus 1.2)                        */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       205448 - UDC module must be on for Correspondence Manager   */
/*       CCG015 - Correspondence Manager Phase 1                     */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*       142225 - Recompile due to changes in PF/SDMGMEPD            */
/*       124684 - If the confirmations job ends abnormally and does  */
/*                not change LESTAT position 6 back to 'N', no confs */
/*                are produced in subsequent runs. Fix is to use new */
/*                data area LECONF and ALCOBJ/DLCOBJ commands to     */
/*                to determine if the confirmations job is active -  */
/*                if the job fails, the data area is automatically   */
/*                de-allocated.                                      */
/*       S01408 - Core hook LEC0212A03 added                         */
/*       S01408 - Core hook LEC0212A02 added                         */
/*                COre hook LEC0212A01 added                         */
/*       102427 - If the UDC_IMMEDS job is not active, it does       */
/*                not get submitted automatically.  This fix         */
/*                causes it to get submitted if required.            */
/*       CCG008 - User Defined Correspondence - Lending              */
/*       S01465 - BLI Lending Enhancement                            */
/*       E41579 - Set up multi-language message file overrides       */
/*                also, send error messages to MOPERQ as well as     */
/*                MRUNQ, as this job is now submitted.               */
/*       E40242 - Call MEC0890 to produce audit list of messages     */
/*                generated                                          */
/*       S01310 - Re-written for SWIFT rationalisation               */
/*                                                                   */
/*********************************************************************/
/**/
             PGM
 
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
             DCL        VAR(&MSG) TYPE(*CHAR) LEN(50)
 
             DCL        VAR(&LESTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
                                                                      /*E41579*/
/*  Multiple language support variables  */                           /*E41579*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*E41579*/
             DCL        VAR(&MIUSRMSG) TYPE(*CHAR) LEN(10)            /*E41579*/
             DCL        VAR(&MIDASLG) TYPE(*CHAR) LEN(10)             /*E41579*/
             DCL        VAR(&CGUSRMSG) TYPE(*CHAR) LEN(10)            /*CCG008*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*E41579*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*E41579*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*E41579*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*E41579*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*E41579*/
                                                                      /*E41579*/
             DCL        VAR(&SDATE) TYPE(*CHAR) LEN(6)                /*E40242*/
             DCL        VAR(&STIME) TYPE(*CHAR) LEN(6)                /*E40242*/
                                                                     /*S01465*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                /*S01465*/
             DCL        VAR(&SAR) TYPE(*CHAR) LEN(6)                 /*S01465*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)            /*S01465*/
             DCL        VAR(&W0RTN) TYPE(*CHAR) LEN(7)                /*CCG008*/
             DCL        VAR(&W0CMT) TYPE(*CHAR) LEN(3) VALUE('YES')   /*CCG008*/
             DCL        VAR(&FMT)  TYPE(*CHAR) LEN(200)               /*CCG008*/
             DCL        VAR(&ACTION) TYPE(*CHAR) LEN(8)                                   /*CCG015*/
                                                                                          /*CSW208*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*CSW208*/
             DCL        VAR(&CSW208) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CSW208*/
             DCL        VAR(&CLE044) TYPE(*CHAR) LEN(1)                                   /*CLE044*/
/*/COPY WNCPYSRC,LEC0212A06                                          */
 
             DCLF       FILE(SDMGMEPD)
 
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO +
                          CMDLBL(ERROR))
 
             ALCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
/* Notify MRUNQ */
             SNDPGMMSG  MSG('Input Cycle Confirmations Print') +
                        TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,LEH01026                                            */
 
/* Begin commitment control */
/**********  STRCMTCTL LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))             /*CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                              /*CPK009*/
 
/* Zero switches */
             CHGJOB     LOG(4) LOGCLPGM(*YES) SWS(10010000)
 
/* Create LDA */
             CRTDTAARA  DTAARA(QTEMP/LDA) TYPE(*CHAR) LEN(256) +
                          VALUE(' ') TEXT('Midas SD AS400 LOCAL +
                          DATA AREA EQUIVALENT')
             MONMSG     MSGID(CPF0000)
/*/COPY WNCPYSRC,LEC0212A04                                          */
/*  Multiple language support -                  */                   /*E41579*/
/*  Set up overrides for message files           */                   /*E41579*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*E41579*/
                                                                      /*E41579*/
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*E41579*/
                CHGVAR     VAR(&MULT) VALUE('GB')                     /*E41579*/
             ENDDO                                                    /*E41579*/
                                                                      /*E41579*/
/*  Build multiple language support object names  */                  /*E41579*/
             CHGVAR     VAR(&MIUSRMSG) VALUE(&MULT *CAT 'MIUSRMSG  ') /*E41579*/
             CHGVAR     VAR(&MIDASLG) VALUE(&MULT *CAT 'MIDAS     ')  /*E41579*/
             CHGVAR     VAR(&CGUSRMSG) VALUE(&MULT *CAT 'CGUSRMSG  ') /*CCG008*/
                                                                      /*E41579*/
/*  Apply multiple language support overrides  */                     /*E41579*/
             OVRMSGF    MSGF(MIUSRMSG) TOMSGF(&MIUSRMSG)              /*E41579*/
             OVRMSGF    MSGF(MIDAS) TOMSGF(&MIDASLG)                  /*E41579*/
             OVRMSGF    MSGF(CGUSRMSG) TOMSGF(&CGUSRMSG)              /*CCG008*/
                                                                      /*E41579*/
                                                                      /*E40242*/
/*  Retrieve System Date and Time - required to extract journal       /*E40242*/
/*  entries for audit report.                                         /*E40242*/
             RTVSYSVAL  SYSVAL(QTIME) RTNVAR(&STIME)                  /*E40242*/
             RTVSYSVAL  SYSVAL(QDATE) RTNVAR(&SDATE)                  /*E40242*/
/**/                                                                                      /*CSW208*/
/*  Check if SWIFT 2008 is installed. */                                                  /*CSW208*/
/**/                                                                                      /*CSW208*/
             CHGVAR     VAR(&PRTCD) VALUE('       ')                                      /*CSW208*/
             CALL       PGM(SWIF2008) PARM(&PRTCD)                                        /*CSW208*/
             IF         COND(&PRTCD *EQ 'CSW2008') THEN( +
                          CHGVAR VAR(&CSW208) VALUE('Y'))                                 /*CSW208*/
 
             RTVDTAARA  DTAARA(LESTAT) RTNVAR(&LESTAT)
 
             IF COND(%SST(&LESTAT 98 1) *EQ 'A') THEN(GOTO TAGA)
             IF COND(%SST(&LESTAT 98 1) *EQ 'B') THEN(GOTO TAGB)
             IF COND(%SST(&LESTAT 98 1) *EQ 'C') THEN(GOTO TAGC)
/**/                                                                  /*CCG008*/
/*  User Defined Correspondence processing. */                        /*CCG008*/
/**/                                                                  /*CCG008*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                   /*CCG008*/
             CHGVAR     VAR(&OPTN) VALUE('*FIRST ')                   /*CCG008*/
/**/                                                                  /*CCG008*/
/*  Access PF/SDMMODPD to determine whether UDC module is on.         /*CCG008*/
/**/                                                                  /*CCG008*/
             CALL       PGM(AOMMODR0) PARM(&RTCD &OPTN &FMT)          /*CCG008*/
/**/                                                                  /*CCG008*/
/*  Database error handling.                                          /*CCG008*/
/**/                                                                  /*CCG008*/
             IF         COND(&RTCD *NE '       ') THEN(DO)            /*CCG008*/
                CHGVAR     VAR(&MSG) VALUE('Error on access to ICD  +
                             file SDMMODPD')                          /*CCG008*/
                GOTO       CMDLBL(ERROR)                              /*CCG008*/
             ENDDO                                                    /*CCG008*/
/**/                                                                  /*CCG008*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*CCG008*/
                                                                                          /*CCG015*/
/** Call Extract File Instance Management */                                              /*CCG015*/
                CHGVAR     VAR(&ACTION) VALUE('*PREPARE')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
                                                                                          /*CCG015*/
                OVRDBF     FILE(CLOAN) SHARE(*NO)                     /*CCG008*/
                CALL       PGM(CG6000) PARM(&W0RTN &W0CMT)            /*CCG008*/
/*              RCLRSC */                                             /*CCG008*/          /*248755*/
                IF         COND(&W0RTN *NE '       ') THEN(DO)        /*CCG008*/
                   CHGVAR     VAR(&MSG) VALUE('User Defined +
                                Correspondence Extract failure')      /*CCG008*/
                   ROLLBACK                                           /*CCG008*/
                   CLRPFM     FILE(LEEXTAA)                           /*CCG008*/
                   CLRPFM     FILE(LEEXTAB)                           /*CCG008*/
                   CLRPFM     FILE(LEEXTAC)                           /*CCG008*/
                   GOTO       CMDLBL(ERROR)                           /*CCG008*/
                ENDDO                                                 /*CCG008*/
/* */                                                                                     /*CCG015*/
/* If Correspondence manager is switched on, call custom defined                          /*CCG015*/
/* extract program                                                                        /*CCG015*/
/* */                                                                                     /*CCG015*/
             CALL       PGM(CGC3604)                                                      /*CCG015*/
/* */                                                                                     /*CCG015*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)                                  /*CCG015*/
             CHGVAR     VAR(&MSG) VALUE('Correspondence Manager +
                        Custom-Defined Data Extract failed')                              /*CCG015*/
             GOTO       CMDLBL(ERROR)                                                     /*CCG015*/
             ENDDO                                                                        /*CCG015*/
                CPYF       FROMFILE(LEEXTAB) TOFILE(QTEMP/XLEEXTAB) +
                              MBROPT(*REPLACE) CRTFILE(*YES)          /*CCG008*/
             ENDDO                                                    /*CCG008*/
 
/* Produce confirmation extract LEEXT */
/*/COPY WNCPYSRC,LEC0212A07                                          */
/**/                                                                                      /*CLE044*/
/** Access SAR file to determine if switchable feature CLE044     */                      /*CLE044*/
/** is switched ON.  If ON, print LE0130 and suppress LE1150.     */                      /*CLE044*/
/**/                                                                                      /*CLE044*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CLE044*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CLE044*/
             CHGVAR     VAR(&SAR) VALUE('CLE044')                                         /*CLE044*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD)                      /*CLE044*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                          VAR(&CLE044) VALUE('Y'))                                        /*CLE044*/
/**/                                                                 /*S01465*/
/** Access SAR file to determine if switchable feature  S01465    */ /*S01465*/
/** is switched ON                                                */ /*S01465*/
/**/                                                                 /*S01465*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                  /*S01465*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                  /*S01465*/
             CHGVAR     VAR(&SAR) VALUE('S01465')                    /*S01465*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SAR &SCSARD) /*S01465*/
/*/COPY WNCPYSRC,LEC0212A08                                          */
/*********** IF         COND(&RTCD *EQ '       ') THEN(DO)           /*S01465*/           /*CLE044*/
             IF         COND((&RTCD *EQ '       ') *AND +
                        (&CLE044 *NE 'Y')) THEN(DO)                                       /*CLE044*/
/**                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0212A03                                          /*S01408*/
/**                                                                  /*S01408*/
                OVRDBF     FILE(CLOAN2) TOFILE(CLOAN) SHARE(*NO)     /*S01465*/
                CALL       PGM(LE1150) PARM('     ' 'ALL')           /*S01465*/
/*/COPY WNCPYSRC,LEC0212A05                                          */
                ENDDO                                                /*S01465*/
             ELSE       CMD(DO)                                      /*S01465*/
/**                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0212A01                                          /*S01408*/
/**                                                                  /*S01408*/
                CALL       PGM(LE0130) PARM('     ' 'ALL')
/**                                                                  /*S01408*/
/*/COPY WNCPYSRC,LEC0212A02                                          /*S01408*/
/**                                                                  /*S01408*/
             ENDDO                                                   /*S01465*/
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations print failure')
             ROLLBACK
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)       /*CCG008*/
             CPYF       FROMFILE(XLEEXTAB) TOFILE(LEEXTAB) +
                          MBROPT(*REPLACE)                            /*CCG008*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(LEEXTAB))                              /*CCG008*/
             CLRPFM     FILE(LEEXTAA)                                 /*CCG008*/
             CLRPFM     FILE(LEEXTAC)                                 /*CCG008*/
             GOTO       CMDLBL(ERROR)                                 /*CCG008*/
             ENDDO                                                    /*CCG008*/
             ELSE (DO)                                                /*CCG008*/
             CLRPFM     FILE(LEEXTAA)
             CLRPFM     FILE(LEEXTAB)
             CLRPFM     FILE(LEEXTAC)
             GOTO       CMDLBL(ERROR)
             ENDDO                                                    /*CCG008*/
             ENDDO
 
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF COND(%SST(&MMOD 28 1) *EQ 'Y') THEN(DO)
 
TAGA:        CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE('A')
 
/* Extract messages */
             OVRDBF     FILE(MGOREFL0) SHARE(*NO)
             OVRDBF     FILE(CLOAN) SHARE(*NO)
             CALL       PGM(LE4500)  /* COMIT ONLY LOANS */
 
/* If all LEEXT not processed report failure */
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmation extract failure')
             ROLLBACK
             CLRPFM     FILE(MGF320PD)
             CLRPFM     FILE(MGF330PD)
             IF         COND(&CSW208 *EQ 'Y') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
             GOTO       CMDLBL(ERROR)
             ENDDO
 
TAGB:        CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE('B')
             CLRPFM     FILE(LEEXTAA)
             CLRPFM     FILE(LEEXTAB)
             CLRPFM     FILE(LEEXTAC)
 
/* GDFs records are deleted as they are processed */
/*/COPY WNCPYSRC,LEC0212A10                                          */
 
/* Process fixed loan/deposit confirmations */
             CALL       PGM(MG0320)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*E41579*/
/************SNDPGMMSG  MSG('Loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*E41579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/* Clear MGX320PD after successful call to MG0320 */                                      /*CSW208*/
             IF         COND(&CSW208 *EQ 'Y') THEN( +
                          CLRPFM FILE(MGX320PD))                                          /*CSW208*/
                                                                                          /*CSW208*/
 
/* Process call loan/deposits */
             CALL       PGM(MG0330)
 
             IF         COND(%SWITCH(XXXXXX1X) *OR +
                          %SWITCH(XXXXXXX1)) THEN( +
             SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ MRUNQ) MSGTYPE(*INFO))        /*E41579*/
/************SNDPGMMSG  MSG('Call loan/deposit confirmation +
                          formatting failure') TOPGMQ(*EXT) +
                          TOMSGQ(MOPERQ) MSGTYPE(*INFO))           */ /*E41579*/
             IF         COND(%SWITCH(XXXXXXX1)) THEN(DO)
             ROLLBACK
             GOTO       CMDLBL(ERROR)
             ENDDO
/*/COPY WNCPYSRC,LEC0212A11                                          */
 
/**********  RGZPFM     FILE(MGF320PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             CALL       PGM(SCC000060) PARM('MGF320PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
/**********  RGZPFM     FILE(MGF330PD)                                                    /*228542*/
/**********  MONMSG     MSGID(CPF2995 CPF2981)                                            /*228542*/
             IF         COND(&CSW208 *EQ 'Y') THEN(DO)                                    /*CSW208*/
                RGZPFM     FILE(MGX320PD)                                                 /*CSW208*/
                MONMSG     MSGID(CPF2995 CPF2981)                                         /*CSW208*/
             ENDDO                                                                        /*CSW208*/
             CALL       PGM(SCC000060) PARM('MGF330PD' '*FIRST')                          /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ERROR))                                                  /*228542*/
 
TAGC:        CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE('C')
 
/* If ISO confirmations required print messages */
             RCVF
             IF         COND(&ENFFCR = 'N') THEN(DO)
             CRTDTAQ    DTAQ(QTEMP/MEISOPRT) MAXLEN(90) +
                          TEXT('Outgoing ISO mail data queue')
             MONMSG     MSGID(CPF0000)
             CALL       PGM(ME0865)
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('ISO print failure')
             GOTO       CMDLBL(ERROR)
             ENDDO
             ENDDO
             ENDDO
 
             CHGDTAARA  DTAARA(LESTAT (98 1)) VALUE(' ')
                                                                /*102427*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO) /*102427*/
                                                                /*102427*/
/** Submit the UDC_IMMEDS JOB for immediate printing. */        /*102427*/
                CALL       PGM(CGC5217) PARM(' ')               /*102427*/
                MONMSG     MSGID(CPF0000)                       /*102427*/
             ENDDO                                              /*102427*/
             GOTO       CMDLBL(END)
ERROR:       IF         COND(&MSG = ' ') THEN(DO)
             CHGVAR     VAR(&MSG) VALUE('Confirmations generation +
                          failure')
             ENDDO
/************SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ) +
                          MSGTYPE(*INFO)                           */ /*E41579*/
             SNDPGMMSG  MSG(&MSG) TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ) +
                          MSGTYPE(*INFO)                              /*E41579*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
 
/* Send database error message to workstation & MOPERQ */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
             RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MSG)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
/************SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)              */ /*E41579*/
             SNDPGMMSG  MSGID(MEM0011) MSGF(MIDAS) MSGDTA(&MSG) +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ MRUNQ)           /*E41579*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
             CHGJOB     SWS(XXXXXX11)
/* UDC module must be on in order to call a Correspondence Manager program                /*205448*/
             IF         COND(%SST(&FMT 101 1) *EQ 'Y') THEN(DO)                           /*205448*/
                CHGVAR     VAR(&ACTION) VALUE('*CLEAR  ')                                 /*CCG015*/
                CALL       PGM(CGC3605) PARM(&ACTION)                                     /*CCG015*/
             ENDDO                                                                        /*205448*/
 
END:         ENDCMTCTL
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
                                                                      /*E40242*/
/* Call Message Generation Audit Report with parameters of Module  */ /*E40242*/
/* ID, Type of run, Current Journal and Date and Time of job       */ /*E40242*/
             CALL       PGM(MEC0890) PARM('LE' 'C' 'ICJRN     ' +
                          &SDATE &STIME)                              /*E40242*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E40242*/
 
/* Ensure stop confirmations indicator set off */
/*/COPY WNCPYSRC,LEH01264                                            */
/**********  CALL       PGM(LE0106) */                                                   /*252833A*/
/**********  MONMSG     MSGID(CPF0000 RPG0000 MCH0000) */                                /*252833A*/
/*/COPY WNCPYSRC,LEH01265                                            */
 
/* Reset busy flag in LESTAT */
/*/COPY WNCPYSRC,LEC0212A09                                          */
/************ALCOBJ     OBJ((LESTAT *DTAARA *EXCLRD)) WAIT(32000)     /*124684*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*124684*/
/************CHGDTAARA  DTAARA(LESTAT (6 1)) VALUE('N')               /*124684*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*124684*/
/************DLCOBJ     OBJ((LESTAT *DTAARA *EXCLRD))                 /*124684*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*124684*/
 
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLCOBJ     OBJ((LECONF *DTAARA *EXCL))                   /*124684*/
             MONMSG     MSGID(CPF0000)                                /*124684*/
             ENDPGM
