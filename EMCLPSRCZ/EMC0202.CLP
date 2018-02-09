/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas EM On-Line Exposure Update')                    */
/********************************************************************/
/*                                                                  */
/*        Midas     - Exposure Management Module                    */
/*                                                                  */
/*       EMC0202 - ON-LINE EXPOSURE UPDATE                          */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                  */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. CTI007             Date 31Mar14              */
/*                      CLE134             Date 01Aug12              */
/*                      CCB020             Date 06Aug12              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.04 ---------------------------------------------------*/
/*                      178060             Date 31Aug00              */
/* Midas DBA 3.02 ---------------------------------------------------*/
/*                      CSE017             Date 20Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CPK009             Date 09Aug99              */
/*                      CTI002             Date 01Sep98              */
/*                      CDL002             Date 22SEP97             */
/*                    . 106931             Date 12AUG96             */
/*                      S01408             DATE 06AUG96             */
/*                      S01408             DATE 30OCT95             */
/*                      E20287             DATE 19JUN91             */
/*                      S01332             DATE 06JUN91             */
/*                       RT0026           DATE  03MAY91             */
/*                       E23410           DATE  18SEP90             */
/*                       E21559           DATE  07AUG90             */
/*                       S01194           DATE  13DEC89             */
/*                       E15966           DATE  28/11/88            */
/*                       E13406           DATE  01/08/88            */
/*                       S01129           DATE  20/01/88            */
/*                       E12721           DATE  21/04/88            */
/*                       E12098           DATE  24/02/88            */
/*                       E11169           DATE  01/07/87            */
/*                       S01128           DATE  12/05/87            */
/*                       E81129           DATE  17/12/86            */
/*                                                                  */
/*------------------------------------------------------------------*/
/*       MD046248 - Finastra Rebranding                              */
/*       CTI007 - Trade Finance BF Midas 2.2 Exposure Management     */
/*       CLE134 - Past Due Call Loan Processing (Recompile)          */
/*       CCB020 - COB Restructure - Secondary COB Infrastructure     */
/*       178060 - Program does not give sufficient information if    */
/*                an error occurs - add additional abnormal          */
/*                termination processing.                            */
/*       CSE017 - Cum/Ex Indicator on Depot Movements (Recompiled)   */
/*       CPK009 - Packaging for DBA3 release. STRCMTCTL values set   */
/*                to CMTSCOPE(*JOB).                                 */
/*   CTI002 - Add file TIPOSTPD for TI PHASE 2                      */
/*            Add file SDACODPD for TI PHASE 2                      */
/*   CDL002 - Add file FXNETMPD for FX Netting                      */
/*       106931 - Add MONMSG(CPF0000) after evry line in ABNOR      */
/*                block to prevent program looping.                 */
/*   S01408 - ADDITION OF STANDARD CL CORE HOOKS                    */
/*            ADDITION OF CORE HOOK EMC0202002                      */
/*            ADDITION OF CORE HOOK EMC0202001                      */
/*            ADDITION OF CORE HOOK EMC0202INT                      */
/*            ADDITION OF CORE HOOK EMC0202MPS                      */
/*            ADDITION OF CORE HOOK EMC0202MPE                      */
/*            ADDITION OF CORE HOOK EMC0202ERR                      */
/*            ADDITION OF CORE HOOK EMC0202END                      */
/*       E20287 - PROGRAM LOOPS IF EMSTAT IS ALLOCATED TO ANOTHER   */
/*                JOB.                                              */
/*       S01332 - EXPOSURE MANAGEMENT RELEASE 10 ENHANCEMENTS.      */
/*       RT0026 - REMOVE ALL REFERENCE TO SYNDICATED LOANS MODULE   */
/*       E23410 - PROGRAM CHECKS FOR MODULES RT AND RE.             */
/*                AMEND TO CHECK FOR RE AND IA.                     *  *E23410*/
/*       E21559 - REMOVE CL FACILITIES FROM EXPOSURE UPDATE.        *  *E21559*/
/*       S01194 - STANDING DATA CHANGES                             */
/*       E15966 - E13406 REMOVED - ERROR CORRECTED BY E15674        *  *E15966*/
/*                AND E15492 IN EMC00.                              *  *E15966*/
/*       E13406 - ADD A MONMSG TO RCVJRNE COMMAND TO PREVENT        *  *E13406*/
/*                ABNORMAL TERMINATION IF NOT ALL THESE FILES       *  *E13406*/
/*                ARE BEING JOURNALLED IE NOT ALL MODULES PRESENT.  *  *E13406*/
/*       S01129 - AMEND RCVJRNE COMMAND TO INCLUDE FILES TRADSD,    *  *S01129*/
/*                DPTMVD AND SETLED.                                *  *S01129*/
/*       E12721 - MONMSG ADDED TO ABNORMAL PROCESSING SO THAT       *  *E12721*/
/*                PROGRAM DOES NOT LOOP IF DTAARA EMCHK IS NOT      *  *E12721*/
/*                FOUND.                                            *  *E12721*/
/*       E12098 - ERROR MESSAGE "RETRIEVAL OF JOURNALLED            *  *E12098*/
/*                INFORMATION ENDED ABNORMALLY" HAD A SPACE         *  *E12098*/
/*                BETWEEN THE M & A OF "INFORMATION"                *  *E12098*/
/*       E11169 - I/C TERMINATION CRASHES BECAUSE EM0101            *  *E11169*/
/*                LOCKS FILES.                                      *  *E11169*/
/*       S01128 - THIS PROGRAM HAS BEEN REWRITTEN FOR EMII          */
/*       S01128 - FIELD JNSQ IN EMCEXX1 CHANGED TO JOSEQN TO        */
/*                MATCH DEFINITION IN FRF                           */
/********************************************************************/
/**/
             PGM
 
/*/COPY WNCPYSRC,EMC0202INT                                        */ /*S01408*/
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/**/
             DCLF       FILE(EMCEXX1)                                 /*E81129*/
/*           DCL        VAR(&MEM) TYPE(*CHAR) LEN(44) */              /*S01194*/
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)                 /*S01194*/
             DCL        VAR(&WTIM) TYPE(*DEC) LEN(6)
             DCL        VAR(&JNSQ1) TYPE(*DEC) LEN(10)                /*E81129*/
             DCL        VAR(&JNRCN1) TYPE(*CHAR) LEN(10)              /*E81129*/
             DCL        VAR(&JOBN) TYPE(*CHAR) LEN(10)                /*E11169*/
             DCL        VAR(&USRN) TYPE(*CHAR) LEN(10)                /*E11169*/
             DCL        VAR(&JBNB) TYPE(*CHAR) LEN(6)                 /*E11169*/
             DCL        VAR(&LDA) TYPE(*CHAR) LEN(256)
             DCL        VAR(&MMOD) TYPE(*CHAR) LEN(256)
/**********  DCL        VAR(&MPHAS) TYPE(*CHAR) LEN(1)             */                     /*CCB020*/
             DCL        VAR(&EMSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&EMUSRMSG) TYPE(*CHAR) LEN(10)            /*CTI002*/
             DCL        VAR(&GROUP) TYPE(*CHAR) LEN(50)               /*CTI002*/
             DCL        VAR(&USER) TYPE(*CHAR) LEN(25)                /*CTI002*/
             DCL        VAR(&SLEVEL) TYPE(*DEC) LEN(4)                /*CTI002*/
             DCL        VAR(&TIMEO) TYPE(*DEC) LEN(5)                 /*CTI002*/
             DCL        VAR(&ERRORC) TYPE(*DEC) LEN(1) VALUE(0)       /*CTI002*/
             DCL        VAR(&MULT) TYPE(*CHAR) LEN(2)                 /*CTI002*/
                                                                                          /*CCB020*/
/* Parameter for call to CBC001001 */                                                     /*CCB020*/
             DCL        VAR(&COBST) TYPE(*CHAR) LEN(4)                                    /*CCB020*/
/**/
/**/
/*   GLOBAL MONITOR MESSAGE                                        */
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000) EXEC(GOTO ABNOR)
/**/                                                                  /*CTI002*/
/* MULTILANGAGE SUPPORT    */                                         /*CTI002*/
/**/                                                                  /*CTI002*/
             CALL       PGM(SF0410) PARM(&GROUP &USER &SLEVEL &TIMEO  +
                          &ERRORC &MULT)                              /*CTI002*/
 
             IF         COND(&MULT *EQ '  ') THEN(DO)                 /*CTI002*/
             CHGVAR     VAR(&MULT) VALUE('GB')                        /*CTI002*/
             ENDDO                                                    /*CTI002*/
             CHGVAR     VAR(&EMUSRMSG) VALUE(&MULT *CAT 'EMUSRMSG  ') /*CTI002*/
             OVRMSGF    MSGF(EMUSRMSG) TOMSGF(&EMUSRMSG)              /*CTI002*/
/**/                                                                  /*E11169*/
/* RETRIEVE JOB ATTRIBUTES */                                         /*E11169*/
/**/                                                                  /*E11169*/
             RTVJOBA    JOB(&JOBN) USER(&USRN) NBR(&JBNB)             /*E11169*/
/**/                                                                  /*E11169*/
/* AMEND EMSTAT WITH JOB DETAILS                                    *  *E11169*/
/**/                                                                  /*E11169*/
             RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)
             CHGDTAARA  DTAARA(EMSTAT (100 26)) VALUE(&JOBN *CAT +
                          &USRN *CAT &JBNB)                           /*E11169*/
/**/                                                                  /*E20287*/
             MONMSG     MSGID(CPF1063) EXEC(DO)                       /*E20287*/
             SNDPGMMSG  MSG('Exposure Management background job +
                          cannot allocate needed object (data area +
                          EMSTAT). EM job will restart at next +
                          signon into MIDAS system.') /*20287*/
             GOTO       CMDLBL(ENDP)                                  /*E20287*/
             ENDDO                                                    /*E20287*/
/**/                                                                  /*E20287*/
/**/
/*   MAIN PROCESSING                                                */
/**/
             CHGJOB SWS(00000000)
             ALCOBJ     OBJ((EMCHK *DTAARA *EXCL)) WAIT(9999)
 
/*/COPY WNCPYSRC,EMC0202MPS                                        */ /*S01408*/
 
             OVRDBF     FILE(TABLE) TOFILE(TABEM)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
/**/
             CALL       EM0090
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO DBERROR)
             IF         COND(%SWITCH(1XXXXXXX)) THEN(DO)
                        SNDPGMMSG MSG('NO EXPOSURE UPDATING WILL +
                        BE DONE - ADVISE SUPPORT') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO ENDTAG
             ENDDO
/**/
/*  FOR BYTE 10 OF DTAARA EMSTAT *NE ' ' IMPLIES NO JOURNALLING   */  /*E81129*/
             RTVDTAARA  DTAARA(EMSTAT) RTNVAR(&EMSTAT)
             IF (%SST(&EMSTAT 10 1) *NE ' ') THEN(DO)
             SNDPGMMSG  MSG('EXPOSURE FILE UPDATING NOT ACTIVE') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)                   /*E81129*/
             GOTO ENDP  /*** ===>>> ***/                              /*E81129*/
                                                    ENDDO             /*E81129*/
/**/
             RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
             CHGVAR VAR(&WTIM) VALUE(%SST(&LDA 251 6))
/************SNDPGMMSG  MSG('EXPOSURE FILE UPDATING NOW ACTIVE') +
/************           TOPGMQ(*EXT) TOMSGQ(MOPERQ)                      *178060*/
             SNDPGMMSG  MSG('Exposure file updating now active') +
                                     TOMSGQ(MOPERQ)                     /*178060*/
/**/
/**/
/**********  RTVDTAARA  DTAARA(MPHAS) RTNVAR(&MPHAS)               */                     /*CCB020*/
                                                                                          /*CCB020*/
/* Call program CBC001001 to check if program is in COB or IC */                          /*CCB020*/
/* If the return value is *YES, system is in COB */                                       /*CCB020*/
                                                                                          /*CCB020*/
             CALL       PGM(CBC001001) PARM(&COBST)                                       /*CCB020*/
                                                                                          /*CCB020*/
/**********  IF         ((%SST(&MPHAS 1 1)) *NE 'A') THEN(DO)      */                     /*CCB020*/
             IF         COND(&COBST *EQ '*YES') THEN(DO)                                  /*CCB020*/
             SNDPGMMSG  MSG('EXPOSURE FILE UPDATING NOW COMPLETE') +
                        TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                        GOTO ENDTAG
             ENDDO
/**/
/**** CHECK MODULE INDICATORS ****/
             RTVDTAARA  DTAARA(MMOD) RTNVAR(&MMOD)
             IF         ((%SST(&MMOD 10 1)) *EQ 'Y') +
                        CHGJOB SWS(XX1XXXXX) /**LE**/
             IF         ((%SST(&MMOD 2 1)) *EQ 'Y') +
                        CHGJOB SWS(X1XXXXXX) /**DL**/
/*                                                                     *E23410*/
/************IF*********((%SST(&MMOD 3 1)) *EQ 'Y') +***************** *E23410*/
/***********************CHGJOB SWS(1XXXXXXX)/ /**RT**/ /************** *E23410*/
             IF         ((%SST(&MMOD 23 1)) *EQ 'Y') +
                        CHGJOB SWS(1XXXXXXX) /**IA**/                 /*E23410*/
/*                                                                     *E23410*/
             ELSE IF    ((%SST(&MMOD 16 1)) *EQ 'Y') +
                        CHGJOB SWS(1XXXXXXX) /**RE**/
/**/
/**/
/*       BGNCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))  */ /*E81129*/ /*S01179*/
/********STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE))         /*S01179 CPK009*/
             STRCMTCTL  LCKLVL(*CHG) NFYOBJ(MNTYF (*FILE)) +
                          CMTSCOPE(*JOB)                       /*S01179 CPK009*/
             MONMSG MSGID(CPF8351)
/**/
OPNDBF     FILE(EMCEXX1) OPTION(*INP)                                 /*E81129*/
             RCVF                                                     /*E81129*/
             MONMSG     MSGID(CPF0864) EXEC(DO)                       /*178060*/
             SNDPGMMSG  MSG('Exposure file updating terminated +
                          ABNORMALLY because file EMCEXX1 is +
                          empty.') TOMSGQ(MOPERQ)                     /*178060*/
             GOTO      CMDLBL(ABNOR)                                  /*178060*/
             ENDDO                                                    /*178060*/
/****        CHGVAR  VAR(&JNSQ1) VALUE(&JNSQ + 1)              ****/  /*S01128*/
             CHGVAR  VAR(&JNSQ1) VALUE(&JOSEQN + 1)                   /*S01128*/
/*           CHGVAR  VAR(&JNSQ) VALUE(&JNSQ + 1)                  */  /*E81129*/
CLOF       OPNID(EMCEXX1)                                             /*E81129*/
/**/                                                                  /*E81129*/
             MONMSG     MSGID(RPG0000 CPF0000 IDU0000) EXEC(DO)       /*E81129*/
/************SNDPGMMSG  MSG('EXPOSURE FILE UPDATING TERMINATED DUE +
/************           TO PROGRAM ERROR - ADVISE M.K.I.') +
/************           TOPGMQ(*EXT) TOMSGQ(MOPERQ)                    *178060*/
             SNDPGMMSG  MSG('Exposure file updating terminated +
                          ABNORMALLY due to program error') +
                          TOMSGQ(MOPERQ)                              /*178060*/
                        CALL EM0110                                   /*E81129*/
                        GOTO ERROR                                    /*E81129*/
             ENDDO                                                    /*E81129*/
/**/
RCVJ:
/*         ADDED TYPE "UB" - BEFORE IMAGE OF UPDATE 06/04/87  NG   */
/************RCVJRNE    JRN(ICJRN) EXITPGM(EM0101) FILE((DEALSDB) +
                          (DEALSDC) (DEALSDD) (DEAMSDI) (LOANSCS) +
                          (CLOANCL) (LOAMSDK) (MEMOS) (LOANSCR) +
                          (FCLTYFM) (TABTB10) (FACILFB) (REPAYRD) +
                          (ACCNTAB)) RCVRNG(&JNRCN *CURRENT) +
                          FROMENT(&JNSQ1) JRNCDE(R U) ENTTYP(PT UP +
                          UB BR UR DR XJ XE) DELAY(&WTIM) *********/  /*S01129*/
/************RCVJRNE    JRN(ICJRN) EXITPGM(EM0101) FILE((DEALSDB) +    *E21559*/
/************             (DEALSDC) (DEALSDD) (DEAMSDI) (LOANSCS) +    *E21559*/
/************             (CLOANCL) (LOAMSDK) (MEMOS) (LOANSCR) +      *E21559*/
/************             (FCLTYFM) (TABTB10) (FACILFB) (REPAYRD) +    *E21559*/
/************             (TRADSD) (DPTMVD) (SETLED) +                 *E21559*/
/************             (ACCNTAB)) RCVRNG(&JNRCN *CURRENT) +         *E21559*/
/************             FROMENT(&JNSQ1) JRNCDE(R U) ENTTYP(PT UP +   *E21559*/
/************             UB BR UR DR XJ XE) DELAY(&WTIM) ****/ /*S01129E21559*/
/*********** RCVJRNE    JRN(ICJRN) EXITPGM(EM0101) FILE((DEALSDB) +   /*RT0026*/
/***********              (DEALSDC) (DEALSDD) (DEAMSDI) (LOANSCS) +   /*RT0026*/
/***********              (CLOANCL) (LOAMSDK) (MEMOS) (LOANSCR) +     /*RT0026*/
/***********              (FCLTYFM) (TABTB10) (REPAYRD) (TRADSD) +    /*RT0026*/
/***********              (DPTMVD) (SETLED) (ACCNTAB)) RCVRNG(&JNRCN+ /*RT0026*/
/***********              *CURRENT) FROMENT(&JNSQ1) JRNCDE(R U) +     /*RT0026*/
/***********              ENTTYP(PT UP UB BR UR DR XJ XE) +           /*RT0026*/
/***********              DELAY(&WTIM)                     /*E21559*/ /*RT0026*/
/************RCVJRNE    JRN(ICJRN) EXITPGM(EM0101) FILE((DEALSDB) +   /*S01332*/
/************             (DEALSDC) (DEALSDD) (DEAMSDI) (CLOANCL) +   /*S01332*/
/************             (LOAMSDK) (MEMOS) (FCLTYFM) (TABTB10) +     /*S01332*/
/************             (TRADSD) (DPTMVD) (SETLED) (ACCNTAB)) +     /*S01332*/
/************             RCVRNG(&JNRCN *CURRENT) FROMENT(&JNSQ1) +   /*S01332*/
/************             JRNCDE(R U) ENTTYP(PT UP UB BR UR DR XJ +   /*S01332*/
/************             XE) DELAY(&WTIM)                /*RT0026*/  /*S01332*/
 
/*/COPY WNCPYSRC,EMC0202001                                        */ /*S01408*/
 
/********************                                                 /*CDL002*/
/************RCVJRNE*   JRN(ICJRN) EXITPGM(EM0101) FILE((FXDEALPP) +  /*CDL002*/
/********************     (MMDELDPP) (MMDENBPP) (MMDEAMPP) +          /*CDL002*/
/********************     (CLOANCL) (LOAMSDK) (MEMOS) (FCLTYFM) +     /*CDL002*/
/********************     (TABTB10) (TRADSD) (DPTMVD) (SETLED) +      /*CDL002*/
/********************     (ACCNTAB) (DEALSDG) (POSTNCD OTC)) +        /*CDL002*/
/********************     RCVRNG(&JNRCN *CURRENT) FROMENT(&JNSQ1) +   /*CDL002*/
/********************     JRNCDE(R U) ENTTYP(PT UP UB BR UR DR XJ +   /*CDL002*/
/********************     XE) DELAY(&WTIM)                 /*S01332*/ /*CDL002*/
                                                                      /*CDL002*/
/************RCVJRNE*   JRN(ICJRN) EXITPGM(EM0101) FILE((FXDEALPP) +  /*CTI002*/
/********************     (MMDELDPP) (MMDENBPP) (MMDEAMPP) +          /*CTI002*/
/********************                                                 /*CTI002*/
/********************     (CLOANCL) (LOAMSDK) (MEMOS) (FCLTYFM) +     /*CTI002*/
/********************     (TABTB10) (TRADSD) (DPTMVD) (SETLED) +      /*CTI002*/
/********************     (ACCNTAB) (DEALSDG) (POSTNCD OTC) +         /*CTI002*/
/********************     (FXNETMPD)) RCVRNG(&JNRCN *CURRENT) +       /*CTI002*/
/********************     FROMENT(&JNSQ1) JRNCDE((R) (U)) ENTTYP(PT + /*CTI002*/
/********************     UP UB BR UR DR XJ XE) DELAY(&WTIM) *CDL002* /*CTI002*/
/********************                                                 /*CTI002*/
                                                                      /*CTI002*/
/**********  RCVJRNE    JRN(ICJRN) EXITPGM(EM0101) FILE((FXDEALPP) +
                          (MMDELDPP) (MMDENBPP) (MMDEAMPP) +
                          (SDACODPD) (TIPOSTPD) +
                          (CLOANCL) (LOAMSDK) (MEMOS) (FCLTYFM) +
                          (TABTB10) (TRADSD) (DPTMVD) (SETLED) +
                          (ACCNTAB) (DEALSDG) (POSTNCD OTC) +
                          (FXNETMPD)) RCVRNG(&JNRCN *CURRENT) +
                          FROMENT(&JNSQ1) JRNCDE((R) (U)) ENTTYP(PT +
                          UP UB BR UR DR XJ XE DL) +
                                                DELAY(&WTIM)   **/                 /*CTI002 CTI007*/
                                                                                          /*CTI007*/
             RCVJRNE    JRN(ICJRN) EXITPGM(EM0101) FILE((FXDEALPP) +
                          (MMDELDPP) (MMDENBPP) (MMDEAMPP) +
                          (SDACODPD) (TIPOSTPD) (CLOANCL) (LOAMSDK) +
                          (MEMOS) (FCLTYFM) (TABTB10) (TRADSD) +
                          (DPTMVD) (SETLED) (ACCNTAB) (DEALSDG) +
                          (POSTNCD OTC) (FXNETMPD) (GLATMIPD)) +
                          RCVRNG(&JNRCN *CURRENT) JRNCDE((R) (U)) +
                          ENTTYP(PT UP UB BR UR DR XJ XE DL PX) +
                          DELAY(&WTIM) FROMENT(&JNSQ1)                                    /*CTI007*/
/*                                                                 */ /*S01408*/
/*/COPY WNCPYSRC,EMC0202002                                        */ /*S01408*/
/*                                                                 */ /*S01408*/
/**/                                                                  /*E13406*/
/************MONMSG     MSGID(CPF7060)                         /*E13406*E15966*/
/**/                                                                  /*E81129*/
             MONMSG     MSGID(CPF9803) EXEC(DO)                       /*E81129*/
                DLYJOB     DLY(30)                                    /*E81129*/
                GOTO RCVJ                                             /*E81129*/
             ENDDO                                                    /*E81129*/
 
/*/COPY WNCPYSRC,EMC0202MPE                                        */ /*S01408*/
/**/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO ERROR)
/**/
             IF         COND(%SWITCH(XXXXX1XX)) THEN(DO)
                CALL       EMCHDRD PARM(&JNSQ1 &JNRCN1)
                CHGVAR  VAR(&JNSQ1) VALUE(&JNSQ1 + 1)                 /*E81129*/
                CHGVAR  VAR(&JNRCN) VALUE(&JNRCN1)                    /*E81129*/
                CHGJOB  SWS(XXXXX0XX)                                 /*E81129*/
                GOTO RCVJ                                             /*E81129*/
             ENDDO                                                    /*E81129*/
/**/
             IF         COND(%SWITCH(XXXXX0XX)) THEN(GOTO ENDTAG)
/**/
/*NOR:       SNDPGMMSG  MSG('PROGRAM - Retrieval of Journalled Inform +
                        ation ENDED ABNORMALLY') TOMSGQ(MOPERQ MRUNQ) /*E12098*/
ABNOR:       SNDPGMMSG  MSG('PROGRAM - Retrieval of Journalled +
                        Information ENDED ABNORMALLY') +
                        TOMSGQ(MOPERQ MRUNQ)                          /*E12098*/
             MONMSG     MSGID(CPF0000)                                /*106931*/
 
             CHGJOB     LOG(4 0 *SECLVL) LOGCLPGM(*YES)               /*178060*/
             MONMSG     MSGID(CPF0000)                                /*178060*/
 
             DSPJOBLOG  OUTPUT(*PRINT)                                /*178060*/
             MONMSG     MSGID(CPF0000)                                /*178060*/
 
             DMPCLPGM                                                 /*178060*/
             MONMSG     MSGID(CPF0000)                                /*178060*/
 
/*/COPY WNCPYSRC,EMC0202ERR                                        */ /*S01408*/
 
             GOTO ENDTAG
/**/
ERROR:       ROLLBACK
             MONMSG     MSGID(CPF0000)                                /*106931*/
             ENDCMTCTL
             MONMSG     MSGID(CPF0000)                                /*106931*/
/**/
/* FOR DATABASE ERRORS RECOVER DATA FROM LDA                        */
/**/
    DBERROR:
              IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                  RTVDTAARA  DTAARA(LDA) RTNVAR(&LDA)
                  MONMSG     MSGID(CPF0000)                           /*106931*/
/*             CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 44))           */ /*S01194*/
               CHGVAR VAR(&MEM) VALUE(%SST(&LDA 134 50))              /*S01194*/
               MONMSG     MSGID(CPF0000)                              /*106931*/
                  SNDPGMMSG MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                            TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                  MONMSG     MSGID(CPF0000)                           /*106931*/
                         CALL EM0110
                         MONMSG     MSGID(CPF0000)                    /*106931*/
              ENDDO
/**/
   ENDTAG:
              DLTOVR     FILE(TABLE)
             MONMSG     MSGID(CPF9841)                                /*E20287*/
             MONMSG     MSGID(CPF0000)                                /*106931*/
/**/                                                                  /*E12721*/
/* The following MONMSG commands are included to ensure that if an  *  *E12721*/
/* error occurs here it will be processed here and not by the global*  *E12721*/
/* MONMSG command.                                                  *  *E12721*/
/**/                                                                  /*E12721*/
             DLCOBJ     OBJ((EMCHK *DTAARA *EXCL))
             MONMSG     MSGID(CPF0000)                                /*E12721*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
       MONMSG     MSGID(CPF0000)                                      /*106931*/
 
/*/COPY WNCPYSRC,EMC0202END                                        */ /*S01408*/
 
 ENDP:     ENDPGM
