/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Monthly History processing update')          */
/********************************************************************/
/*                                                                  */
/*     Midas  CUSTOMER LENDING MODULE                           */
/*                                                                  */
/*     LEC0451  -  MONTHLY NMATLN UPDATE PROCESSING                 */
/*                                                                  */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD021155           Date 03Jul13              */
/*                      AR1089839          Date 19Feb13              */
/*                      CLE075AS           Date 06Aug12              */
/*                      CLE134             Date 01Aug12              */
/*                      CER059             Date 19Jul10              */
/*                      BUG26773           Date 18Nov09              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/*                      CAS016             Date 28Feb06              */
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      247012             Date 13Apr07              */
/*                      240409             Date 19Jun06              */
/*                      CAS009             Date 04May04              */
/*                      228542             Date 10Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      S01408             Date 26Apr96              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD021155 - COB Restructure Phase 1 remnants                 */
/*                - PDP changes still taking security copies         */
/*       AR1089839 - COBOP and 2.1 source clashes                    */
/*       CLE075AS - COB Restructure - LE COB Optimisation Phase 1    */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CER059 - German Feature Upgrade to Delhi                    */
/*       BUG26773 - FOOB in LEC10A because MATLNxx files are cleared.*/
/*                  Remove clearing of MATLNxx files.                */
/*       CAS016 - IAS18 EIR Recalculation (Fee Amortisation Over     */
/*                Whole Period)                                      */
/*       247012 - Update the cancel flag on two Collateralised       */
/*                Lending files.                                     */
/*       240409 - Fee History records are not purged. Apply 193112:  */
/*       193112 - Drop lending fee history records if associated loan*/
/*                or facility record no longer exists.               */
/*       CAS009 - Effective Interest Rate/Amortised Cost Accounting  */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       S01408 - Addition of core hook LEC0451001                   */
/*                Addition of core hook LEC0451002                   */
/*                                                                  */
/********************************************************************/
PGM PARM(&CNAM &CSEQ)
             DCL        VAR(&CNAM) TYPE(*CHAR) LEN(10)
             DCL        VAR(&CSEQ) TYPE(*DEC) LEN(5 0)
/**********  DCL        VAR(&STAT) TYPE(*CHAR) LEN(1) VALUE(' ')   */            /*S01189 CLE075AS*/
/**********  DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)          */            /*CAS009 CLE075AS*/
/**********  DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)              */            /*CAS009 CLE075AS*/
/**********  DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)              */            /*CAS009 CLE075AS*/
/**********  DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)              */            /*CAS009 CLE075AS*/
/**********  DCL        VAR(&CAS009) TYPE(*CHAR) LEN(1)            */            /*CAS009 CLE075AS*/
/**********  DCL        VAR(&SYSID) TYPE(*CHAR) LEN(2)             */            /*CAS009 CLE075AS*/
/**********  DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(7) VALUE('  DPLIB')*/        /*CAS009 CLE075AS*/
                                                                                          /*CAS009*/
/**********  DCL        VAR(&CAS016) TYPE(*CHAR) LEN(1)            */            /*CAS016 CLE075AS*/
             DCL        VAR(&CLE134) TYPE(*CHAR) LEN(1) VALUE(' ')                        /*CLE134*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                              /*AR1089839*/
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                  /*AR1089839*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7)                                  /*AR1089839*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6)                                  /*AR1089839*/
                                                                                          /*CAS016*/
             DCL        VAR(&CSEQA) TYPE(*CHAR) LEN(5)                                  /*CLE075AS*/
             DCL        VAR(&STEXT) TYPE(*CHAR) LEN(26)                                 /*CLE075AS*/
             DCL        VAR(&SEVENT) TYPE(*CHAR) LEN(15)                                /*CLE075AS*/
             DCL        VAR(&JOB) TYPE(*CHAR) LEN(10)                                   /*CLE075AS*/
             DCL        VAR(&USR) TYPE(*CHAR) LEN(10)                                   /*CLE075AS*/
             DCL        VAR(&NBR) TYPE(*CHAR) LEN(6)                                    /*CLE075AS*/
             DCL        VAR(&START) TYPE(*DEC) LEN(10 0)                                /*CLE075AS*/
             DCL        VAR(&FINISH) TYPE(*DEC) LEN(10 0)                               /*CLE075AS*/
             DCL        VAR(&SJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AS*/
             DCL        VAR(&FJRNRCVR) TYPE(*CHAR) LEN(10)                              /*CLE075AS*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
 
/*/COPY WNCPYSRC,LEC0451004                                          */
 
/*/COPY WNCPYSRC,LEC0451005                                          */
             SNDPGMMSG  MSG('MATURED LOANS FILE UPDATE') +
                        TOMSGQ(MRUNQ)
/*/COPY WNCPYSRC,LEC0451006                                          */
 
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AS*/
/* command SCWRTJREG */                                                                 /*CLE075AS*/
                                                                                        /*CLE075AS*/
             CHGVAR     VAR(&CSEQA) VALUE(&CSEQ)                                        /*CLE075AS*/
             CHGVAR     VAR(&STEXT) VALUE('Start of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AS*/
             CHGVAR     VAR(&SEVENT) VALUE(&CNAM *TCAT &CSEQA)                          /*CLE075AS*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('S') TEXT(&STEXT)                                        /*CLE075AS*/
                                                                                        /*CLE075AS*/
/**Setup*system*prefix*variable*from*SDSTAT*data*area.**/                        /*CAS009 CLE075AS*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&SYSID)        */            /*CAS009 CLE075AS*/
/**********  CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&SYSID)  */            /*CAS009 CLE075AS*/
/**/                                                                                      /*CAS009*/
/**Check*if*CAS009*is*enabled.**/                                                /*CAS009 CLE075AS*/
/**/                                                                                      /*CAS009*/
/**********CHGVAR     VAR(&RTCD) VALUE('       ')                  */            /*CAS009 CLE075AS*/
/**********CHGVAR     VAR(&SARD) VALUE('CAS009')                   */            /*CAS009 CLE075AS*/
                                                                                          /*CAS009*/
/**********CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)*/            /*CAS009 CLE075AS*/
                                                                                          /*CAS009*/
/**********CHGVAR     VAR(&CAS009) VALUE('N')                      */            /*CAS009 CLE075AS*/
/**********IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS009) VALUE('Y'))         */            /*CAS009 CLE075AS*/
/**/                                                                                      /*CAS016*/
/**Check*if*CAS016*is*enabled.**/                                                /*CAS016 CLE075AS*/
/**/                                                                                      /*CAS016*/
/**********CHGVAR     VAR(&RTCD) VALUE('       ')                  */            /*CAS016 CLE075AS*/
/**********CHGVAR     VAR(&SARD) VALUE('CAS016')                   */            /*CAS016 CLE075AS*/
                                                                                          /*CAS016*/
/**********CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)*/            /*CAS016 CLE075AS*/
                                                                                          /*CAS016*/
/**********CHGVAR     VAR(&CAS016) VALUE('N')                      */            /*CAS016 CLE075AS*/
/**********IF         COND(&RTCD *EQ '       ') +
                      THEN(CHGVAR VAR(&CAS016) VALUE('Y'))         */            /*CAS016 CLE075AS*/
/**/                                                                                      /*CLE134*/
/** Check if CLE134 is enabled. */                                                        /*CLE134*/
/**/                                                                                      /*CLE134*/
           CHGVAR     VAR(&RTCD) VALUE('       ')                                         /*CLE134*/
           CHGVAR     VAR(&SARD) VALUE('CLE134')                                          /*CLE134*/
                                                                                          /*CLE134*/
           CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &SCSARD)                       /*CLE134*/
                                                                                          /*CLE134*/
           CHGVAR     VAR(&CLE134) VALUE('N')                                             /*CLE134*/
           IF         COND(&RTCD *EQ '       ') +
                         THEN(CHGVAR VAR(&CLE134) VALUE('Y'))                             /*CLE134*/
                                                                                          /*CLE134*/
/**********  CALL       PGM(CB0160) PARM(&CNAM &CSEQ &STAT)        */                   /*CLE075AS*/
/**********  IF         COND(&STAT *EQ 'N') THEN(DO)               */                   /*CLE075AS*/
/*/COPY WNCPYSRC,LEC0451007                                          */
/**COPY*NEWLY*MATURED*LOANS*INTO*THE*NEW*FILE*READY*FOR*FILE*UPDATE*/                   /*CLE075AS*/
 
/**********  CPYF       FROMFILE(MATLNMT) TOFILE(NMTLNMT) MBROPT(*ADD)*/                /*CLE075AS*/
/**********  CPYF       FROMFILE(MATLNHH) TOFILE(NMTLNHH) +
                          MBROPT(*REPLACE)                         */                   /*CLE075AS*/
/**********  MONMSG     MSGID(CPF2817)                             */                   /*CLE075AS*/
/**********  CPYF       FROMFILE(T_MLRSVEXT) TOFILE(T_MLRSVEXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */                   /*CLE075AS*/
/**********  MONMSG     MSGID(CPF2817)                             */            /*247012 CLE075AS*/
/**********  CPYF       FROMFILE(T_CLRSVEXT) TOFILE(T_CLRSVEXX) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */                   /*CLE075AS*/
/**********  MONMSG     MSGID(CPF2817)                             */            /*247012 CLE075AS*/
/**********  IF         COND(&CAS009 *EQ 'Y') THEN(DO)             */            /*CAS009 CLE075AS*/
/**********    DLTF       FILE(XLEEIRHPD)                          */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2105)                           */            /*CAS009 CLE075AS*/
/**********    DLTF       FILE(XLECFLFPD)                          */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2105)                           */            /*CAS009 CLE075AS*/
/**********    CPYF       FROMFILE(LEFHST) TOFILE(XLEFHST)   +
                          MBROPT(*REPLACE)                         */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817)                           */            /*CAS009 CLE075AS*/
/*******************************************************************          */ /*CLE134 MD021155*/
/**********    IF         COND(&CLE134 *EQ 'Y') THEN(DO)                      */ /*CLE134 MD021155*/
/**********      CPYF       FROMFILE(LEPDUEPD) TOFILE(XLEPDUEPD) +                   */ /*MD021155*/
/**********                    MBROPT(*REPLACE)                               */ /*CLE134 MD021155*/
/**********      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +                         */ /*MD021155*/
/**********                    EXEC(CLRPFM FILE(XLEPDUEPD))                   */ /*CLE134 MD021155*/
/**********    ENDDO                                                          */ /*CLE134 MD021155*/
/*******************************************************************          */ /*CLE134 MD021155*/
/**********    CPYF       FROMFILE(LEEIRDPD) TOFILE(XLEEIRDPD) +
                          MBROPT(*REPLACE)                         */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XLEEIRDPD)               */            /*CAS009 CLE075AS*/
/**********    CPYF       FROMFILE(LEEIRHPD) TOFILE(&DPLIB/XLEEIRHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817)                           */            /*CAS009 CLE075AS*/
/**********    CPYF       FROMFILE(LECFLSPD) TOFILE(XLECFLSPD) +
                          MBROPT(*REPLACE)                         */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XLECFLSPD)               */            /*CAS009 CLE075AS*/
/**********    CPYF       FROMFILE(LECFLFPD) TOFILE(&DPLIB/XLECFLFPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817)                           */            /*CAS009 CLE075AS*/
/**********  ENDDO                                                 */            /*CAS009 CLE075AS*/
/**********  IF         COND(&CAS016 *EQ 'Y') THEN(DO)             */            /*CAS016 CLE075AS*/
/**********    DLTF       FILE(XLEERAPPD)                          */            /*CAS016 CLE075AS*/
/**********    MONMSG     MSGID(CPF2105)                           */            /*CAS016 CLE075AS*/
/**********    DLTF       FILE(XLEERAHPD)                          */            /*CAS016 CLE075AS*/
/**********    MONMSG     MSGID(CPF2105)                           */            /*CAS016 CLE075AS*/
/**********    CPYF       FROMFILE(LEERAPPD) TOFILE(XLEERAPPD)   +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */            /*CAS016 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817)                           */            /*CAS016 CLE075AS*/
/**********    CPYF       FROMFILE(LEERAHPD) TOFILE(&DPLIB/XLEERAHPD) +
                          MBROPT(*REPLACE) CRTFILE(*YES)           */            /*CAS016 CLE075AS*/
/**********    MONMSG     MSGID(CPF2817)                           */            /*CAS016 CLE075AS*/
                                                                                          /*CAS016*/
/**********  ENDDO                                                 */            /*CAS016 CLE075AS*/
 
/**CLEAR*MATURED*LOANS*FILE*READY*FOR*TO*BE*OUTPUT*BY*LE0451*TO*******/                 /*BUG26773*/
/**DRIVE*LE0900*******************************************************/                 /*BUG26773*/
 
/**********  CLRPFM     FILE(MATLNMT)                                */                 /*BUG26773*/
/**********  CLRPFM     FILE(MATLNZX)                                */                 /*BUG26773*/
/**********  CLRPFM     FILE(NMTLNZX)                                */                 /*BUG26773*/
/*******ENDDO                                                      */                   /*CLE075AS*/
/**********  IF         COND(&STAT *EQ 'Y') THEN(DO)               */            /*CAS009 CLE075AS*/
/*******************************************************************          */ /*CLE134 MD021155*/
/**********    IF         COND(&CLE134 *EQ 'Y') THEN(DO)                      */ /*CLE134 MD021155*/
/**********      CPYF       FROMFILE(XLEPDUEPD) TOFILE(LEPDUEPD) +                   */ /*MD021155*/
/**********                    MBROPT(*REPLACE)                               */ /*CLE134 MD021155*/
/**********      MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +                         */ /*MD021155*/
/**********                    EXEC(CLRPFM FILE(LEPDUEPD))                    */ /*CLE134 MD021155*/
/**********    ENDDO                                                          */ /*CLE134 MD021155*/
/*******************************************************************          */ /*CLE134 MD021155*/
/**********    IF         COND(&CAS009 *EQ 'Y') THEN(DO)           */            /*CAS009 CLE075AS*/
/**********       CPYF      FROMFILE(XLEFHST) TOFILE(LEFHST)   +
                            MBROPT(*REPLACE)                       */            /*CAS009 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817)                        */            /*CAS009 CLE075AS*/
/**********       CPYF      FROMFILE(XLEEIRDPD) TOFILE(LEEIRDPD) +
                            MBROPT(*REPLACE)                       */            /*CAS009 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM LEEIRDPD)                */            /*CAS009 CLE075AS*/
/**********       CPYF      FROMFILE(XLEEIRHPD) TOFILE(LEEIRHPD) +
                             MBROPT(*REPLACE)                      */            /*CAS009 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817)                        */            /*CAS009 CLE075AS*/
/**********       CPYF      FROMFILE(XLECFLSPD) TOFILE(LECFLSPD) +
                             MBROPT(*REPLACE)                      */            /*CAS009 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +
                              EXEC(CLRPFM XLECFLSPD)               */            /*CAS009 CLE075AS*/
/**********       CPYF      FROMFILE(XLECFLFPD) TOFILE(LECFLFPD) +
                             MBROPT(*REPLACE)                      */            /*CAS009 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817)                        */            /*CAS009 CLE075AS*/
/**********    ENDDO                                               */            /*CAS009 CLE075AS*/
/**********    IF         COND(&CAS016 *EQ 'Y') THEN(DO)           */            /*CAS016 CLE075AS*/
/**********       CPYF      FROMFILE(XLEERAPPD) TOFILE(LEERAPPD) +
                            MBROPT(*REPLACE)                       */            /*CAS016 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817)                        */            /*CAS009 CLE075AS*/
/**********       CPYF      FROMFILE(XLEERAHPD) TOFILE(LEERAHPD) +
                             MBROPT(*REPLACE)                      */            /*CAS009 CLE075AS*/
/**********       MONMSG     MSGID(CPF2817)                        */            /*CAS009 CLE075AS*/
/**********    ENDDO                                               */            /*CAS016 CLE075AS*/
/**********  CPYF       FROMFILE(T_MLRSVEXX) TOFILE(T_MLRSVEXT) +
                            MBROPT(*REPLACE)                       */                   /*CLE075AS*/
/**********  MONMSG     MSGID(CPF2817)                             */            /*247012 CLE075AS*/
/**********  CPYF       FROMFILE(T_CLRSVEXX) TOFILE(T_CLRSVEXT) +
                            MBROPT(*REPLACE)                       */                   /*CLE075AS*/
/**********  MONMSG     MSGID(CPF2817)                             */            /*247012 CLE075AS*/
/**********  ENDDO                                                 */            /*CAS009 CLE075AS*/
/*/COPY WNCPYSRC,LEC0451008                                          */
 
/**********           CHGVAR     VAR(&STAT) VALUE('Y')             */                   /*CLE075AS*/
/**********           CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)*/                  /*CLE075AS*/
 
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0451001                                          */
                                                                     /*S01408*/
             CALL       PGM(LE0451)
                                                                     /*S01408*/
/*/COPY WNCPYSRC,LEC0451002                                          */
                                                                     /*S01408*/
 
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
 
/**********  RGZPFM     FILE(NMTLNMT)                                                     /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('LEFHST' '*FIRST')                            /*193112*/
/**********  CALL       PGM(SCC000060) PARM('NMTLNMT' '*FIRST')    */            /*228542 CLE075AS*/
/**********    DLTF       FILE(XLEEIRHPD)                          */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2105)                           */            /*CAS009 CLE075AS*/
/**********    DLTF       FILE(XLECFLFPD)                          */            /*CAS009 CLE075AS*/
/**********    MONMSG     MSGID(CPF2105)                           */            /*CAS009 CLE075AS*/
 
/*/COPY WNCPYSRC,LEC0451003                                          */
/**********           CHGVAR     VAR(&STAT) VALUE('N')             */                   /*CLE075AS*/
/**********           CALL       PGM(CB0150) PARM(&CNAM &CSEQ &STAT)*/                  /*CLE075AS*/
/*/COPY WNCPYSRC,LEC0451009                                          */
   ENDDO
             ELSE (DO)                                                                  /*CLE075AS*/
                                                                                        /*CLE075AS*/
/* If abnormal, retrieve attributes of current job */                                   /*CLE075AS*/
                                                                                        /*CLE075AS*/
             RTVJOBA    JOB(&JOB) USER(&USR) NBR(&NBR)                                  /*CLE075AS*/
                                                                                        /*CLE075AS*/
/* Retrieve the most recent journal entry sequence number */                            /*CLE075AS*/
/* for the specific job */                                                              /*CLE075AS*/
                                                                                        /*CLE075AS*/
             RTVJRNE    JRN(ICJRN) RCVRNG(*CURCHAIN) FROMENT(*LAST) +
                          TOENT(*FIRST) SEARCH(*DESCEND) +
                          JOB(&NBR/&USR/&JOB) RTNSEQNBR(&START) +
                          RTNRCV(&SJRNRCVR)                                             /*CLE075AS*/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(DO)                                 /*CLE075AS*/
             CHGVAR     VAR(&START) VALUE(0)                                            /*CLE075AS*/
             ENDDO                                                                      /*CLE075AS*/
                                                                                        /*CLE075AS*/
/* Determine starting journal sequence number of current job */                         /*CLE075AS*/
                                                                                        /*CLE075AS*/
             SCRTVJEVT  EVENT(&SEVENT) FLAG('S') RECEIVER(&FJRNRCVR) +
                           SEQ(&FINISH)                                                 /*CLE075AS*/
                                                                                        /*CLE075AS*/
/* Remove journal changes */                                                            /*CLE075AS*/
                                                                                        /*CLE075AS*/
             IF         COND((&START *NE 0) *AND (&FINISH *NE 0)) +
                          THEN(DO)                                                      /*CLE075AS*/
             RMVJRNCHG  JRN(ICJRN) FILE((MATLNMT) (MATLNHH) +
                          (T_MLRSVEXT) (T_CLRSVEXT) (LEFHST) +
                          (LEEIRDPD) (LEEIRHPD) (LECFLSPD) +
                          (LECFLFPD) (LEERAPPD) (LEERAHPD)) +
                          RCVRNG(&SJRNRCVR &FJRNRCVR) +
                          FROMENT(&START) TOENT(&FINISH)                                /*CLE075AS*/
             MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                          /*CLE075AS*/
             IF         COND(&CLE134 *EQ 'Y') THEN(DO)                                  /*MD021155*/
                RMVJRNCHG  JRN(ICJRN) FILE((LEPDUEPD)) RCVRNG(&SJRNRCVR +
                             &FJRNRCVR) FROMENT(&START) TOENT(&FINISH)                  /*MD021155*/
                MONMSG     MSGID(CPF7049 CPF7042 CPF9801 CPF7041)                       /*MD021155*/
             ENDDO                                                                      /*MD021155*/
             ENDDO                                                                      /*CLE075AS*/
                                                                                        /*CLE075AS*/
             ENDDO                                                                      /*CLE075AS*/
                                                                                        /*CLE075AS*/
             CALL       PGM(LE9001)                                                       /*247012*/
 
/* Write current journal sequence number to file SCJSEQPD, using */                     /*CLE075AS*/
/* command SCWRTJREG */                                                                 /*CLE075AS*/
                                                                                        /*CLE075AS*/
             CHGVAR     VAR(&STEXT) VALUE(' ')                                          /*CLE075AS*/
             CHGVAR     VAR(&STEXT) VALUE('End of ' *CAT &CNAM +
                          *CAT &CSEQA)                                                  /*CLE075AS*/
             SCWRTJREG  EVENT(&SEVENT) COMP(&CNAM) CMPSEQ(&CSEQ) +
                          FLAG('E') TEXT(&STEXT)                                        /*CLE075AS*/
                                                                                        /*CLE075AS*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
ENDPGM
