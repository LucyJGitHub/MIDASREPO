/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Facility activity enquiry')                  */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC0306F - Facility Activity Enquiry                        */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. MD044620           Date 10Apr17              */
/*                      AR936915           Date 07Oct14              */
/*                      AR693662           Date 06Jan11              */
/*                      CUP005             Date 21Sep10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/*                      BUG22126           Date 23Jan09              */
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/* Midas Release 4.01 -----------------------------------------------*/
/*                      189570             Date 16Oct01              */
/*                      189343             Date 07Sep01              */
/*                      194909             Date 02Feb01              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.05 ---------------------------------------------------*/
/*                      189088             Date 02Feb01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005 *Create     Date 22May97              */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       MD044620 - Temporary files of LEFCENPD & LEFATRPD are being */
/*                  created in XPLIB. Use multi-member for LEFCENPD  */
/*                  & LEFATRPD to create a member for the job.       */
/*       AR936915 - Facility activity enquiry is showing duplicate   */
/*                  events each time Enter key is pressed. Pass new  */
/*                  filename of LEFCENPD and LEFATRPD to LE0211.     */
/*                  (Child: AR936917)                                */
/*                - Applied for MD030660                             */
/*       AR693662 - Unable to access Facility Activity Enquiry       */
/*                  Screen (Child: AR693663)                         */
/*       CUP005 - Change processing of temporary files for IASP      */
/*                QTEMP is replaced by zzXPLIB.                      */
/*       BUG22126 - Override file FCLTY to include Aggregate         */
/*                  facilities in Acitivity Enquiry                  */
/*       189570 - Recompile over changed LEFCENPD.                   */
/*       189343 - Copy LEFATRPD from XXDMLIB to QTEMP, so that       */
/*                multiple users can access the enquiry for Credit   */
/*                Agreements. Make LF LEFATRL0 point to PF in QTEMP. */
/*       194909 - Delete PF/LEFCENPD after every use to resolve the  */
/*                component failure encountered in FINENDJRN.        */
/*       189088 - Copy LEFCENPD from xxDMLIB to QTEMP, so that       */
/*                multiple users can access the enquiry for Credit   */
/*                Agreements. Make LF LEFCENL0 point to PF in QTEMP. */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM
 
             DCL        VAR(&JOBTYPE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBID) TYPE(*CHAR) LEN(10)               /*189088*/
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)                                   /*CUP005*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDMLIB')                            /*189088*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDVLIB')                            /*189088*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDPLIB')                                                /*CUP005*/
             DCL        VAR(&XPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxXPLIB')                                                /*CUP005*/
             DCL        VAR(&NEWPF1) TYPE(*CHAR) LEN(10)                                  /*CUP005*/
             DCL        VAR(&NEWL01) TYPE(*CHAR) LEN(10)                                  /*CUP005*/
             DCL        VAR(&NEWPF2) TYPE(*CHAR) LEN(10)                                  /*CUP005*/
             DCL        VAR(&NEWL02) TYPE(*CHAR) LEN(10)                                  /*CUP005*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)               /*189088*/
 
/**********  CPYF       FROMFILE(LEFCENPD) TOFILE(QTEMP/LEFCENPD) +                    */ /*CUP005*/
/**********               CRTFILE(*YES)                                     */ /*189088*/ /*CUP005*/
/**********  MONMSG     MSGID(CPF2863 CPF2817) EXEC(CLRPFM +                           */ /*CUP005*/
/**********               FILE(QTEMP/LEFCENPD))                             */ /*189088*/ /*CUP005*/
 
/* Global monitor message */
 
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
/* LF LEFCENL0 needs to be based on LEFCENPD in QTEMP. This is          189088*/
/* achieved by CRTDUPOBJ of LF to QTEMP (called 'job name' to ensure    189088*/
/* uniqueness), MOVOBJ to xxDMLIB, CRTDUPOBJ back to QTEMP.             189088*/
 
/**********  RTVJOBA    JOB(&JOBID)                                         */ /*189088*/ /*CUP005*/
             RTVJOBA    JOB(&JOBID) NBR(&JOBNBR)                                          /*CUP005*/
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)          /*189088*/
             CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&PREFIX)    /*189088*/
             CHGVAR     VAR(%SUBSTRING(&DVLIB 1 2)) VALUE(&PREFIX)    /*189088*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
             CHGVAR     VAR(%SUBSTRING(&XPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
             CHGVAR     VAR(&NEWPF1) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'P1')                                                         /*AR693662*/
/**********               'PD1')                                          */ /*CUP005*/ /*AR693662*/
             CHGVAR     VAR(&NEWL01) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'L1')                                                         /*AR693662*/
/**********               'L01')                                          */ /*CUP005*/ /*AR693662*/
             CHGVAR     VAR(&NEWPF2) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'P2')                                                         /*AR693662*/
/**********               'PD2')                                          */ /*CUP005*/ /*AR693662*/
             CHGVAR     VAR(&NEWL02) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'L2')                                                         /*AR693662*/
/**********               'L02')                                          */ /*CUP005*/ /*AR693662*/
 
/**********  CPYF       FROMFILE(LEFCENPD) TOFILE(&XPLIB/LEFCENPD) +                 */ /*MD044620*/
/**********               CRTFILE(*YES)                                       */ /*CUP005 MD044620*/
             CPYF       FROMFILE(LEFCENPD) TOFILE(LEFCENPD) +
                          FROMMBR(LEFCENPD) TOMBR(&NEWPF1) +
                          MBROPT(*ADD)                                                  /*MD044620*/
             MONMSG     MSGID(CPF2863 CPF2817) EXEC(CLRPFM +
                          FILE(LEFCENPD) MBR(&NEWPF1))                                  /*MD044620*/
/**********               FILE(&XPLIB/LEFCENPD))                              */ /*CUP005 MD044620*/
             ADDLFM     FILE(LEFCENL0) MBR(&NEWL01) +
                          DTAMBRS((LEFCENPD (&NEWPF1)))                                 /*MD044620*/
             MONMSG     MSGID(CPF5812 CPF7306)                                          /*MD044620*/
             OVRDBF     FILE(LEFCENPD) TOFILE(LEFCENPD) MBR(&NEWPF1)                    /*MD044620*/
             OVRDBF     FILE(LEFCENL0) TOFILE(LEFCENL0) MBR(&NEWL01)                    /*MD044620*/
 
/**********  CRTDUPOBJ  OBJ(LEFCENL0) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                 */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(&JOBID)                       */ /*189088*/ /*CUP005*/
/**********  CRTDUPOBJ  OBJ(LEFCENL0) FROMLIB(&DVLIB) OBJTYPE(*FILE) +               */ /*MD044620*/
/**********               TOLIB(&XPLIB) NEWOBJ(&JOBID)                        */ /*CUP005 MD044620*/
/**********  MONMSG     MSGID(CPF2130 CPD2104)                                */ /*189088 MD044620*/
 
/**********  MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)              */ /*189088 MD044620*/
/**********  MONMSG     MSGID(CPF2135)                                        */ /*189088 MD044620*/
 
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                   */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(LEFCENL0)                     */ /*189088*/ /*CUP005*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                 */ /*MD044620*/
/**********               TOLIB(&XPLIB) NEWOBJ(LEFCENL0)                      */ /*CUP005 MD044620*/
/**********  MONMSG     MSGID(CPF2130 CPD2104)                                */ /*189088 MD044620*/
/**********  DLTF       FILE(&DMLIB/&JOBID)                                   */ /*189088 MD044620*/
 
/**********  RNMOBJ     OBJ(&XPLIB/LEFCENPD) OBJTYPE(*FILE) +                        */ /*MD044620*/
/**********               NEWOBJ(&NEWPF1)                                     */ /*CUP005 MD044620*/
/**********  RNMOBJ     OBJ(&XPLIB/LEFCENL0) OBJTYPE(*FILE) +                        */ /*MD044620*/
/**********               NEWOBJ(&NEWL01)                                     */ /*CUP005 MD044620*/
/**********  MOVOBJ     OBJ(&XPLIB/&NEWPF1) OBJTYPE(*FILE) TOLIB(&DPLIB)      */ /*CUP005 MD044620*/
/**********  MOVOBJ     OBJ(&XPLIB/&NEWL01) OBJTYPE(*FILE) TOLIB(&DPLIB)      */ /*CUP005 MD044620*/
 
/**********  OVRDBF     FILE(LEFCENPD) TOFILE(QTEMP/LEFCENPD)               */ /*189088*/ /*CUP005*/
/**********  OVRDBF     FILE(LEFCENL0) TOFILE(QTEMP/LEFCENL0)               */ /*189088*/ /*CUP005*/
/**********  OVRDBF     FILE(LEFCENPD) TOFILE(&DPLIB/&NEWPF1)                 */ /*CUP005 MD044620*/
/**********  OVRDBF     FILE(LEFCENL0) TOFILE(&DPLIB/&NEWL01)                 */ /*CUP005 MD044620*/
 
/**********  STRJRNPF   FILE(QTEMP/LEFCENPD) JRN(ICJRN) +                              */ /*CUP005*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                    */ /*189088*/ /*CUP005*/
/**********  STRJRNPF   FILE(&DPLIB/&NEWPF1) JRN(ICJRN) IMAGES(*BOTH) +              */ /*MD044620*/
/**********               OMTJRNE(*OPNCLO)                                    */ /*CUP005 MD044620*/
/**********  MONMSG     MSGID(CPF7030)                                        */ /*189088 MD044620*/
/**/                                                                                      /*189343*/
/**********  CPYF       FROMFILE(LEFATRPD) TOFILE(QTEMP/LEFATRPD) +                    */ /*CUP005*/
/**********               CRTFILE(*YES)                                     */ /*189343*/ /*CUP005*/
/**********  MONMSG     MSGID(CPF2863 CPF2817) EXEC(CLRPFM +                           */ /*CUP005*/
/**********               FILE(QTEMP/LEFATRPD))                             */ /*189343*/ /*CUP005*/
/**********  CPYF       FROMFILE(LEFATRPD) TOFILE(&XPLIB/LEFATRPD) +                 */ /*MD044620*/
/**********               CRTFILE(*YES)                                       */ /*CUP005 MD044620*/
             CPYF       FROMFILE(LEFATRPD) TOFILE(LEFATRPD) +
                          FROMMBR(LEFATRPD) TOMBR(&NEWPF2) +
                          MBROPT(*ADD)                                                  /*MD044620*/
             MONMSG     MSGID(CPF2863 CPF2817) EXEC(CLRPFM +
                          FILE(LEFATRPD) MBR(&NEWPF2))                                  /*MD044620*/
/**********               FILE(&XPLIB/LEFATRPD))                              */ /*CUP005 MD044620*/
             ADDLFM     FILE(LEFATRL0) MBR(&NEWL02) +
                          DTAMBRS((LEFATRPD (&NEWPF2)))                                 /*MD044620*/
             MONMSG     MSGID(CPF5812 CPF7306)                                          /*MD044620*/
             OVRDBF     FILE(LEFATRPD) TOFILE(LEFATRPD) MBR(&NEWPF2)                    /*MD044620*/
             OVRDBF     FILE(LEFATRL0) TOFILE(LEFATRL0) MBR(&NEWL02)                    /*MD044620*/
/**/                                                                                      /*189343*/
/** LF LEFATRL0 needs to be based on LEFATRPD in QTEMP. This is      */                   /*189343*/
/** achieved by CRTDUPOBJ of LF to QTEMP (called 'job name' to       */                   /*189343*/
/** ensure uniqueness), MOVOBJ to xxDMLIB, CRTDUPOBJ back to QTEMP.  */                   /*189343*/
/**/                                                                                      /*189343*/
/**********  CRTDUPOBJ  OBJ(LEFATRL0) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                 */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(&JOBID)                       */ /*189343*/ /*CUP005*/
/**********  CRTDUPOBJ  OBJ(LEFATRL0) FROMLIB(&DVLIB) OBJTYPE(*FILE) +               */ /*MD044620*/
/**********               TOLIB(&XPLIB) NEWOBJ(&JOBID)                        */ /*CUP005 MD044620*/
/**********  MONMSG     MSGID(CPF2130 CPD2104)                                */ /*189343 MD044620*/
 /**/                                                                                     /*189343*/
/**********  MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)              */ /*189343 MD044620*/
/**********  MONMSG     MSGID(CPF2135)                                        */ /*189343 MD044620*/
 /**/                                                                                     /*189343*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                   */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(LEFATRL0)                     */ /*189343*/ /*CUP005*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                 */ /*MD044620*/
/**********               TOLIB(&XPLIB) NEWOBJ(LEFATRL0)                      */ /*CUP005 MD044620*/
/**********  MONMSG     MSGID(CPF2130 CPD2104)                                */ /*189343 MD044620*/
/**********  DLTF       FILE(&DMLIB/&JOBID)                                   */ /*189343 MD044620*/
                                                                                          /*189343*/
/**********  RNMOBJ     OBJ(&XPLIB/LEFATRPD) OBJTYPE(*FILE) +                           /*MD044620*/
/**********               NEWOBJ(&NEWPF2)                                     */ /*CUP005 MD044620*/
/**********  RNMOBJ     OBJ(&XPLIB/LEFATRL0) OBJTYPE(*FILE) +                           /*MD044620*/
/**********               NEWOBJ(&NEWL02)                                     */ /*CUP005 MD044620*/
/**********  MOVOBJ     OBJ(&XPLIB/&NEWPF2) OBJTYPE(*FILE) TOLIB(&DPLIB)      */ /*CUP005 MD044620*/
/**********  MOVOBJ     OBJ(&XPLIB/&NEWL02) OBJTYPE(*FILE) TOLIB(&DPLIB)      */ /*CUP005 MD044620*/
 
/**********  OVRDBF     FILE(LEFATRPD) TOFILE(QTEMP/LEFATRPD)               */ /*189343*/ /*CUP005*/
/**********  OVRDBF     FILE(LEFATRL0) TOFILE(QTEMP/LEFATRL0)               */ /*189343*/ /*CUP005*/
/**********  OVRDBF     FILE(LEFATRPD) TOFILE(&DPLIB/&NEWPF2)                 */ /*CUP005 MD044620*/
/**********  OVRDBF     FILE(LEFATRL0) TOFILE(&DPLIB/&NEWL02)                 */ /*CUP005 MD044620*/
                                                                                          /*189343*/
/**********  STRJRNPF   FILE(QTEMP/LEFATRPD) JRN(ICJRN) +                   */ /*189343*/ /*CUP005*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                    */ /*189343*/ /*CUP005*/
/**********  STRJRNPF   FILE(&DPLIB/&NEWPF2) JRN(ICJRN) IMAGES(*BOTH) +              */ /*MD044620*/
/**********               OMTJRNE(*OPNCLO)                                    */ /*CUP005 MD044620*/
/**********  MONMSG     MSGID(CPF7030)                                        */ /*189343 MD044620*/
 
             RTVJOBA    TYPE(&JOBTYPE)
             CHGDTAARA  DTAARA(LDA) VALUE(' ')
             CHGJOB     SWS(XXXXXX00)
 
/* Call Facility Activity Enquiry */
 
             OVRDBF     FILE(FCLTY) TOFILE(FCLTY4)  SHARE(*YES)                         /*BUG22126*/
/**********  CALL       PGM(LE0211)                                         */          /*AR936915*/
             CALL       PGM(LE0211) PARM(&NEWPF1 &NEWPF2)                               /*AR936915*/
             DLTOVR     FILE(FCLTY)                                                     /*BUG22126*/
 
/**********  ENDJRNPF   FILE(QTEMP/LEFCENPD QTEMP/LEFATRPD) +               */ /*189343*/ /*CUP005*/
/**********               JRN(ICJRN)                                        */ /*189343*/ /*CUP005*/
/**********  ENDJRNPF   FILE(&DPLIB/&NEWPF1 &DPLIB/&NEWPF2) JRN(ICJRN)        */ /*CUP005 MD044620*/
             DLTOVR     FILE(LEFCENPD)                                /*189088*/
             DLTOVR     FILE(LEFCENL0)                                /*189088*/
             DLTOVR     FILE(LEFATRPD)                                                    /*189343*/
             DLTOVR     FILE(LEFATRL0)                                                    /*189343*/
 
/**********  DLTF       FILE(QTEMP/LEFCENL0)                                */ /*194909*/ /*CUP005*/
/**********  DLTF       FILE(QTEMP/LEFCENPD)                                */ /*194909*/ /*CUP005*/
/**********  DLTF       FILE(&DPLIB/&NEWL01)                                  */ /*CUP005 MD044620*/
/**********  DLTF       FILE(&DPLIB/&NEWL02)                                  */ /*CUP005 MD044620*/
/**********  DLTF       FILE(&DPLIB/&NEWPF1)                                  */ /*CUP005 MD044620*/
/**********  DLTF       FILE(&DPLIB/&NEWPF2)                                  */ /*CUP005 MD044620*/
                                                                                          /*194909*/
             RMVM       FILE(LEFCENL0) MBR(&NEWL01)                                     /*MD044620*/
             RMVM       FILE(LEFCENPD) MBR(&NEWPF1)                                     /*MD044620*/
             RMVM       FILE(LEFATRL0) MBR(&NEWL02)                                     /*MD044620*/
             RMVM       FILE(LEFATRPD) MBR(&NEWPF2)                                     /*MD044620*/
                                                                                        /*MD044620*/
/* Database error processing */
 
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
             ENDDO
 
             GOTO       CMDLBL(END)
 
 ABNOR:      CHGJOB     SWS(XXXXXX11)
 
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
 
             ENDPGM
