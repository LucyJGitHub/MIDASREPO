/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Fees input')                                 */
/*********************************************************************/
/*                                                                   */
/*       Midas     - Customer Lending Module                         */
/*                                                                   */
/*       LEC0201B -  GENERATE ACCOUNTING ENTRIES                     */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. AR314017           Date 01Aug12              */
/*                      CLE134             Date 01Aug12              */
/*                      CUP005             Date 21Sep10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CLE038             Date 11May04              */
/*                      219608             Date 17Jul03              */
/*                      CLE034             Date 05May03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CAP064             Date 07Jun01              */
/* Midas DBA 3.03 ---------------------------------------------------*/
/*                      CLE105             DATE  22Mar00             */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005             Date  22May97             */
/*                                                                   */
/*********************************************************************/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       AR314017 - PONS/RONS warning if changed with LEACCNPD       */
/*                  records (Child:AR314018)                         */
/*       CLE134 - Past Due Call Loan Processing                      */
/*       CUP005 - Change processing of temporary files for IASP.     */
/*                QTEMP is replaced by zzXPLIB.                      */
/*       CLE038 - Lending Enhancement for Nordea: Allocation by Amt  */
/*       219608 - Amendment of Settlement Allocations needs 'before' */
/*                image to ensure the right allocations are reversed.*/
/*       CLE034 - Lending Enhancements.                              */
/*       CAP064 - Lending API enhancements - Fees Input              */
/*       CLE105 - LE Maintenance Function Switchability              */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/*********************************************************************/
             PGM
     DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                         /*CLE005*/
     DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) VALUE('*VERIFY')        /*CLE005*/
/****DCL****    VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CLE005') */  /*CLE005*/ /*CLE105*/
     DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) VALUE('CLE105')         /*CLE105*/
/****DCL****    VAR(&CLE005) TYPE(*CHAR) LEN(1) VALUE('N') */ /*CLE005*/ /*CLE105*/
     DCL        VAR(&CLE105) TYPE(*CHAR) LEN(1) VALUE('N')            /*CLE105*/
     DCL        VAR(&FMT) TYPE(*CHAR) LEN(200)                        /*CLE005*/
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
             DCL        VAR(&SARD34) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE034')                                                 /*CLE034*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
             DCL        VAR(&JOBID) TYPE(*CHAR) LEN(10)                                   /*219608*/
             DCL        VAR(&JOBNBR) TYPE(*CHAR) LEN(6)                                   /*CUP005*/
             DCL        VAR(&DMLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDMLIB')                                                /*219608*/
             DCL        VAR(&DVLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDVLIB')                                                /*219608*/
             DCL        VAR(&DPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxDPLIB')                                                /*CUP005*/
             DCL        VAR(&XPLIB) TYPE(*CHAR) LEN(10) +
                          VALUE('xxXPLIB')                                                /*CUP005*/
             DCL        VAR(&NEWPF) TYPE(*CHAR) LEN(10)                                   /*CUP005*/
             DCL        VAR(&NEWL3) TYPE(*CHAR) LEN(10)                                   /*CUP005*/
             DCL        VAR(&NEWL4) TYPE(*CHAR) LEN(10)                                   /*CUP005*/
             DCL        VAR(&PREFIX) TYPE(*CHAR) LEN(2)                                   /*219608*/
             DCL        VAR(&CLE034) TYPE(*CHAR) LEN(1) VALUE('N')                        /*219608*/
             DCL        VAR(&PRTCD) TYPE(*CHAR) LEN(7)                                    /*219608*/
             DCL        VAR(&POPTN) TYPE(*CHAR) LEN(7) VALUE('*FREE')                     /*219608*/
             DCL        VAR(&PTYPE) TYPE(*CHAR) LEN(4)                                    /*219608*/
             DCL        VAR(&PLNRF) TYPE(*CHAR) LEN(6)                                    /*219608*/
             DCL        VAR(&PVDAT) TYPE(*CHAR) LEN(5)                                    /*219608*/
             DCL        VAR(&PLASN) TYPE(*CHAR) LEN(3)                                    /*219608*/
             DCL        VAR(&PCNUM) TYPE(*CHAR) LEN(6)                                    /*219608*/
             DCL        VAR(&PFACL) TYPE(*CHAR) LEN(5)                                    /*219608*/
             DCL        VAR(&PFSEQ) TYPE(*CHAR) LEN(2)                                    /*219608*/
             DCL        VAR(&PPYRC) TYPE(*CHAR) LEN(1)                                    /*219608*/
/**********  DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(765)             */            /*219608 CLE038*/
             DCL        VAR(&DSSDY) TYPE(*CHAR) LEN(800)                                  /*CLE038*/
/**/                                                                  /*CLE005*/
             CHGJOB     SWS(00000000)                                 /*CLE005*/
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CUP005*/
             RTVJOBA    JOB(&JOBID) NBR(&JOBNBR)                                          /*CUP005*/
             CHGVAR     VAR(%SUBSTRING(&XPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
/**/                                                                                      /*CLE034*/
/* Determine if CLE034 installed  */                                                      /*CLE034*/
/**/                                                                                      /*CLE034*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD34)                               /*CLE034*/
/**/                                                                                      /*CLE034*/
/* Error */                                                                               /*CLE034*/
/**/                                                                                      /*CLE034*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CLE034*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                                            /*CLE034*/
             CHGJOB (XXXXXX11)                                                            /*CLE034*/
             ENDDO                                                                        /*CLE034*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*CLE034*/
             OVRDBF     FILE(LESTALLX) TOFILE(LESTALL2) +
                        SHARE(*NO)                                                        /*CLE034*/
                                                                                          /*219608*/
             CHGVAR     VAR(&CLE034) VALUE('Y')                                           /*219608*/
/* Create temporary file to hold 'before' image of LESTALPD */                            /*219608*/
/**********  CPYF       FROMFILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD) +                    */ /*CUP005*/
/**********               CRTFILE(*YES)                                     */ /*219608*/ /*CUP005*/
             CPYF       FROMFILE(LEBSTLPD) TOFILE(&XPLIB/LEBSTLPD) +
                          CRTFILE(*YES)                                                   /*CUP005*/
             MONMSG     MSGID(CPF2863 CPF2817) EXEC(DO)                                   /*219608*/
/**********             CLRPFM FILE(QTEMP/LEBSTLPD)                         */ /*219608*/ /*CUP005*/
                        CLRPFM FILE(&XPLIB/LEBSTLPD)                                      /*CUP005*/
             GOTO       CMDLBL(FILEND)         /* File already exists                     /*219608*/
                        ENDDO                                                             /*219608*/
                                                                                          /*219608*/
/* Logical files LEBSTLL3 & LEBSTLL4 need to be based over the copy                       /*219608*/
/* of LEBSTLPD which was just created in QTEMP. This is achieved                          /*219608*/
/* by CRTDUPOBJ of LF to QTEMP (called 'job name' to ensure                               /*219608*/
/* uniqueness), MOVOBJ to xxDMLIB, CRTDUPOBJ back to QTEMP.                               /*219608*/
                                                                                          /*219608*/
/**********  RTVJOBA    JOB(&JOBID)                                         */ /*219608*/ /*CUP005*/
/**********  RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                */ /*219608*/ /*CUP005*/
             CHGVAR     VAR(%SUBSTRING(&DMLIB 1 2)) VALUE(&PREFIX)                        /*219608*/
             CHGVAR     VAR(%SUBSTRING(&DVLIB 1 2)) VALUE(&PREFIX)                        /*219608*/
             CHGVAR     VAR(%SUBSTRING(&DPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
             CHGVAR     VAR(&NEWPF) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'PD')                                                           /*CUP005*/
             CHGVAR     VAR(&NEWL3) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'L3')                                                           /*CUP005*/
             CHGVAR     VAR(&NEWL4) VALUE('LE' *TCAT &JOBNBR *TCAT +
                          'L4')                                                           /*CUP005*/
                                                                                          /*219608*/
/* Create Logical file LEBSTLL3:                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(LEBSTLL3) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                 */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(&JOBID)                       */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(LEBSTLL3) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(&JOBID)                                    /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)                          /*219608*/
             MONMSG     MSGID(CPF2135)                                                    /*219608*/
                                                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                   */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(LEBSTLL3)                     */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(LEBSTLL3)                                  /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             DLTF       FILE(&DMLIB/&JOBID)                                               /*219608*/
/*                                                                                        /*219608*/
/* Create Logical file LEBSTLL4:                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(LEBSTLL4) FROMLIB(&DVLIB) OBJTYPE(*FILE) +                 */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(&JOBID)                       */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(LEBSTLL4) FROMLIB(&DVLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(&JOBID)                                    /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
                                                                                          /*219608*/
             MOVOBJ     OBJ(&JOBID) OBJTYPE(*FILE) TOLIB(&DMLIB)                          /*219608*/
             MONMSG     MSGID(CPF2135)                                                    /*219608*/
                                                                                          /*219608*/
/**********  CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +                   */ /*CUP005*/
/**********               TOLIB(QTEMP) NEWOBJ(LEBSTLL4)                     */ /*219608*/ /*CUP005*/
             CRTDUPOBJ  OBJ(&JOBID) FROMLIB(&DMLIB) OBJTYPE(*FILE) +
                          TOLIB(&XPLIB) NEWOBJ(LEBSTLL4)                                  /*CUP005*/
             MONMSG     MSGID(CPF2130 CPD2104)                                            /*219608*/
             DLTF       FILE(&DMLIB/&JOBID)                                               /*219608*/
                                                                                          /*219608*/
             RNMOBJ     OBJ(&XPLIB/LEBSTLPD) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWPF)                                                  /*CUP005*/
             RNMOBJ     OBJ(&XPLIB/LEBSTLL3) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWL3)                                                  /*CUP005*/
             RNMOBJ     OBJ(&XPLIB/LEBSTLL4) OBJTYPE(*FILE) +
                          NEWOBJ(&NEWL4)                                                  /*CUP005*/
             MOVOBJ     OBJ(&XPLIB/&NEWPF) OBJTYPE(*FILE) TOLIB(&DPLIB)                   /*CUP005*/
             MOVOBJ     OBJ(&XPLIB/&NEWL3) OBJTYPE(*FILE) TOLIB(&DPLIB)                   /*CUP005*/
             MOVOBJ     OBJ(&XPLIB/&NEWL4) OBJTYPE(*FILE) TOLIB(&DPLIB)                   /*CUP005*/
 
FILEND:                                                                                   /*219608*/
/**********  OVRDBF     FILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD)               */ /*219608*/ /*CUP005*/
/**********  OVRDBF     FILE(LEBSTLL3) TOFILE(QTEMP/LEBSTLL3)               */ /*219608*/ /*CUP005*/
/**********  OVRDBF     FILE(LEBSTLL4) TOFILE(QTEMP/LEBSTLL4)               */ /*219608*/ /*CUP005*/
             OVRDBF     FILE(LEBSTLPD) TOFILE(&DPLIB/&NEWPF)                              /*CUP005*/
             OVRDBF     FILE(LEBSTLL3) TOFILE(&DPLIB/&NEWL3)                              /*CUP005*/
             OVRDBF     FILE(LEBSTLL4) TOFILE(&DPLIB/&NEWL4)                              /*CUP005*/
                                                                                          /*219608*/
/**********  STRJRNPF   FILE(QTEMP/LEBSTLPD) JRN(ICJRN) +                              */ /*CUP005*/
/**********               IMAGES(*BOTH) OMTJRNE(*OPNCLO)                    */ /*219608*/ /*CUP005*/
             STRJRNPF   FILE(&DPLIB/&NEWPF) JRN(ICJRN) IMAGES(*BOTH) +
                          OMTJRNE(*OPNCLO)                                                /*CUP005*/
             MONMSG     MSGID(CPF7030)                                                    /*219608*/
/**/                                                                                      /*219608*/
             ENDDO                                           /*CLE034*/
/**Check*if*CLE005*is*installed**/                         /*CLE005*/ /*CLE105*/
/**/                                                                  /*CLE005*/
/* Check if CLE105 is installed */                                    /*CLE005*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD &FMT)    /*CLE005*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)            /*CLE005*/
/***********     CHGVAR     VAR(&CLE005) VALUE('Y')  */    /*CLE005*/ /*CLE105*/
                 CHGVAR     VAR(&CLE105) VALUE('Y')                   /*CLE105*/
             ENDDO                                                    /*CLE005*/
/*/COPY WNCPYSRC,LEC0201B01                                          */
/**/                                                                  /*CLE005*/
/*********** IF         COND(&CLE005 = 'Y') THEN(DO) */   /*CLE005*/  /*CLE105*/
             IF         COND(&CLE105 = 'Y') THEN(DO)                  /*CLE105*/
             OVRDBF     FILE(LEIFEELX) TOFILE(LEIFEEL2) SHARE(*NO)                        /*CAP064*/
             OVRDBF     FILE(CLOANA1)  TOFILE(CLOANL4)  SHARE(*NO)                        /*CLE134*/
             OVRDBF     FILE(FCLTYA1)  TOFILE(FCLTY)    SHARE(*NO)                        /*CLE134*/
             OVRDBF     FILE(LEFEEDA1) TOFILE(LEFEED)   SHARE(*NO)                        /*CLE134*/
             OVRDBF     FILE(LEACCNBB) TOFILE(LEACCNLB) SHARE(*NO)                      /*AR314017*/
                                                                                        /*AR314017*/
             CALL       PGM(LE2210) PARM('I' ' ' ' ' &TSTMP)                              /*CLE034*/
/**********  CALL       PGM(LE2210) PARM('I' ' ' ' ') */                          /*CLE005  CLE034*/
             DLTOVR     FILE(LEIFEELX)                                                    /*CAP064*/
                                                                                          /*219608*/
             IF         COND(&CLE034 = 'Y') THEN(DO)                                      /*219608*/
                                                                                          /*219608*/
/* Close file LEBSTLPD on access object AOBSTLR0 using Option '*FREE':                    /*219608*/
             CALL       PGM(AOBSTLR0) PARM(&PRTCD &POPTN &PTYPE +
                          &PLNRF &PVDAT &PLASN &PCNUM &PFACL +
                          &PFSEQ &PPYRC &DSSDY)                                           /*219608*/
                                                                                          /*219608*/
/**********  ENDJRNPF   FILE(QTEMP/LEBSTLPD) +                                         */ /*CUP005*/
/**********               JRN(ICJRN)                                        */ /*219608*/ /*CUP005*/
             ENDJRNPF   FILE(&DPLIB/&NEWPF) JRN(ICJRN)                                    /*CUP005*/
             DLTOVR     FILE(LEBSTLPD)                                                    /*219608*/
             DLTOVR     FILE(LEBSTLL3)                                                    /*219608*/
             DLTOVR     FILE(LEBSTLL4)                                                    /*219608*/
                                                                                          /*219608*/
             DLTF       FILE(&DPLIB/&NEWL3)                                               /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWL4)                                               /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWPF)                                               /*CUP005*/
 
             ENDDO                                                                        /*219608*/
             ENDDO                                                    /*CLE005*/
     ELSE  CMD(DO)                                                    /*CLE005*/
             CALL       PGM(LER110)
             ENDDO                                                    /*CLE005*/
/**/                                                                  /*CLE005*/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
             ENDPGM
