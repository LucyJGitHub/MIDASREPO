/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas LE Fee settlement input')                       */
/*********************************************************************/
/*                                                                   */
/*       Midas - Customer Lending Module                             */
/*                                                                   */
/*       LEC2220A - Fee Settlement Input                             */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CUP005             Date 21Sep10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. CLE038             Date 11May04              */
/*                      CRE020             Date 20Jan04              */
/*                      219608             Date 16Jul03              */
/*                      CLE034             Date 05May03              */
/* Midas Release 4.01 -----------------------------------------------*/
/*                      CAP072             Date 13Jun02              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      CLE005 *Create     Date 22May97              */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       CUP005 - Change processing of temporary files for IASP      */
/*                QTEMP is replaced by zzXPLIB.                      */
/*       CLE038 - Lending Enhancement for Nordea: Allocation by Amt  */
/*       CRE020 - Midas Plus Online Printing of Advices (GE7)        */
/*       219608 - Amendment of Settlement Allocations needs 'before' */
/*                image to ensure the right allocations are reversed.*/
/*       CLE034 - Lending Enhancements.                              */
/*       CAP072 - Conversion of LE inputs into modular structure to  */
/*                use as APIs.                                       */
/*       CLE005 - Customer Lending Enhancements - Others (T3)        */
/*                                                                   */
/********************************************************************/
             PGM        PARM(&PMODE)
/**/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&MEM) TYPE(*CHAR) LEN(50)
             DCL        VAR(&PMODE) TYPE(*CHAR) LEN(1)
             DCL        VAR(&RTCD) TYPE(*CHAR) LEN(7)                                     /*CAP072*/
             DCL        VAR(&OPTN) TYPE(*CHAR) LEN(7) +
                          VALUE('*VERIFY')                                                /*CAP072*/
             DCL        VAR(&SARD) TYPE(*CHAR) LEN(6) +
                          VALUE('CAP172')                                                 /*CAP072*/
             DCL        VAR(&TSTMP) TYPE(*CHAR) LEN(26)                                   /*CLE034*/
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
             DCL        VAR(&SARD34) TYPE(*CHAR) LEN(6) +
                          VALUE('CLE034')                                                 /*219608*/
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
             DCL        VAR(&PSARD)  TYPE(*CHAR) LEN(6)                                   /*CRE020*/
             DCL        VAR(&CRE020) TYPE(*CHAR) LEN(1) VALUE('N')                        /*CRE020*/
             DCL        VAR(&SCSARD) TYPE(*CHAR) LEN(200)                                 /*CRE020*/
             DCL        VAR(&PCMD) TYPE(*CHAR) LEN(50)                                    /*CRE020*/
/**/
/* Global monitor message */
/**/
             MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +
                          CMDLBL(ABNOR))
 
             RTVDTAARA  DTAARA(SDSTAT (6 2)) RTNVAR(&PREFIX)                              /*CUP005*/
             RTVJOBA    JOB(&JOBID) NBR(&JOBNBR)                                          /*CUP005*/
             CHGVAR     VAR(%SUBSTRING(&XPLIB 1 2)) VALUE(&PREFIX)                        /*CUP005*/
/**/                                                                                      /*219608*/
/* Determine if CLE034 installed  */                                                      /*219608*/
/**/                                                                                      /*219608*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD34)                               /*219608*/
/**/                                                                                      /*219608*/
/* Error */                                                                               /*219608*/
/**/                                                                                      /*219608*/
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*219608*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                                TOMSGQ(MOPERQ)                                            /*219608*/
             CHGJOB     JOB(XXXXXX11)                                                     /*219608*/
             ENDDO                                                                        /*219608*/
             IF         COND(&RTCD *EQ '       ') THEN(DO)                                /*219608*/
             CHGVAR     VAR(&CLE034) VALUE('Y')                                           /*219608*/
                                                                                          /*219608*/
/* Create temporary file to hold 'before' image of LESTALPD */                            /*219608*/
/**********  CPYF       FROMFILE(LEBSTLPD) TOFILE(QTEMP/LEBSTLPD) +                    */ /*CUP005*/
/**********               CRTFILE(*YES)                                     */ /*219608*/ /*CUP005*/
/**********  MONMSG     MSGID(CPF2863 CPF2817) EXEC(CLRPFM +                           */ /*CUP005*/
/**********               FILE(QTEMP/LEBSTLPD))                             */ /*219608*/ /*CUP005*/
             CPYF       FROMFILE(LEBSTLPD) TOFILE(&XPLIB/LEBSTLPD) +
                          CRTFILE(*YES)                                                   /*CUP005*/
             MONMSG     MSGID(CPF2863 CPF2817) EXEC(CLRPFM +
                          FILE(&XPLIB/LEBSTLPD))                                          /*CUP005*/
                                                                                          /*219608*/
/**Global*monitor*message**/ /*                                             */ /*219608*/ /*CUP005*/
/**********  MONMSG     MSGID(CPF0000 MCH0000 RPG0000) EXEC(GOTO +                     */ /*CUP005*/
/**********               CMDLBL(ABNOR))                                    */ /*219608*/ /*CUP005*/
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
             ENDDO                                                                        /*219608*/
/**/                                                                                      /*219608*/
                                                                                          /*CAP072*/
/**/                                                                                      /*CAP072*/
/* Determine if CAP172 installed */                                                       /*CAP072*/
/**/                                                                                      /*CAP072*/
                                                                                          /*CAP072*/
             CALL   PGM(AOSARDR0) PARM(&RTCD &OPTN &SARD)                                 /*CAP072*/
                                                                                          /*CAP072*/
/* Error */                                                                               /*CAP072*/
 
             IF         COND(&RTCD *NE '       ' *AND &RTCD *NE +
                          '*NRF   ') THEN(DO)                                             /*CAP072*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                          TOMSGQ(MOPERQ)                                                  /*CAP072*/
             CHGJOB     JOB(XXXXXX11)                                                     /*CAP072*/
             GOTO       CMDLBL(END)                                                       /*CAP072*/
             ENDDO                                                                        /*CAP072*/
 
/* Check if CRE020 is enabled. */                                                         /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&RTCD) VALUE('       ')                                       /*CRE020*/
             CHGVAR     VAR(&OPTN) VALUE('*VERIFY')                                       /*CRE020*/
             CHGVAR     VAR(&PSARD) VALUE('CRE020')                                       /*CRE020*/
                                                                                          /*CRE020*/
             CALL       PGM(AOSARDR0) PARM(&RTCD &OPTN &PSARD &SCSARD)                    /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD *EQ '       ') THEN(CHGVAR +
                        VAR(&CRE020) VALUE('Y'))                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(&RTCD *NE '       ' *AND +
                             &RTCD *NE '*NRF   ') THEN(DO)                                /*CRE020*/
             SNDPGMMSG  MSG('AOSARDR0 - PROGRAM ERROR') +
                          TOMSGQ(MOPERQ)                                                  /*CRE020*/
             CHGJOB     JOB(XXXXXX11)                                                     /*CRE020*/
             GOTO       CMDLBL(END)                                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
/**/
/* Call Fee Settlement Program */
/**/
             CHGJOB     SWS(XXXXXX00)
                                                                                          /*CAP072*/
/* CAP172 installed */                                                                    /*CAP072*/
                                                                                          /*CAP072*/
             IF         COND(&RTCD *EQ '       ') THEN(CALL +
                          PGM(LEFESTSIN) PARM(&PMODE '' ''))                              /*CAP072*/
                                                                                          /*CAP072*/
             ELSE       CMD(DO)                                                           /*CAP072*/
                                                                                          /*CAP072*/
/* CAP172 not installed */                                                                /*CAP072*/
                                                                                          /*CAP072*/
             OVRDBF     FILE(LESTALLX) TOFILE(LESTALL2) +
                        SHARE(*NO)                                                        /*CLE034*/
             CALL       PGM(LE2220) PARM(&PMODE 'S' '' '' &TSTMP)                         /*CLE034*/
/**********  CALL       PGM(LE2220) PARM(&PMODE 'S' '' '')                                /*CLE034*/
             ENDDO                                                                        /*CAP072*/
                                                                                          /*CAP072*/
             IF         COND(%SWITCH(XXXXXX00)) THEN(DO)
                GOTO       CMDLBL(END)
             ENDDO
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
                RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)
                SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT) TOMSGQ(MOPERQ)
                GOTO       CMDLBL(END)
             ENDDO
/**/
/* Abnormal or database error processing */
/**/
 ABNOR:      SNDPGMMSG  MSG('Transaction failed.  Re-input necessary.  +
                          Enter to continue.') TOPGMQ(*EXT)
/**/
/* End of program processing */
/**/
END:         CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
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
/**********  DLTF       FILE(QTEMP/LEBSTLL3)                                */ /*219608*/ /*CUP005*/
/**********  DLTF       FILE(QTEMP/LEBSTLL4)                                */ /*219608*/ /*CUP005*/
/**********  DLTF       FILE(QTEMP/LEBSTLPD)                                */ /*219608*/ /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWL3)                                               /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWL4)                                               /*CUP005*/
             DLTF       FILE(&DPLIB/&NEWPF)                                               /*CUP005*/
                                                                                          /*219608*/
             ENDDO                                                                        /*219608*/
                                                                                          /*CRE020*/
/* Print Retail Advices if CRE020 is enabled. */                                          /*CRE020*/
                                                                                          /*CRE020*/
             IF         COND(%SWITCH(XXXXXX00) *AND +
                              &CRE020 = 'Y') THEN(DO)                                     /*CRE020*/
                                                                                          /*CRE020*/
             CHGVAR     VAR(&PCMD) VALUE('CALL PGM(REC000881) PARM(' +
                        *CAT '''LEFESTUPD'' ''LE''' *CAT ')')                             /*CRE020*/
             SBMJOB     JOB(REC000881) JOBD(MBATCH) USER(*JOBD) +
                        RTGDTA(*JOBD) RQSDTA(&PCMD) +
                        INLLIBL(*JOBD) MSGQ(MOPERQ)                                       /*CRE020*/
             ENDDO                                                                        /*CRE020*/
                                                                                          /*CRE020*/
             ENDPGM
