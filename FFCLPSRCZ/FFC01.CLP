/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas FF Input cycle init. file reorganisation')      */
/*********************************************************************/
/*                                                                   */
/*   Midas  -  Futures and Options Module                            */
/*                                                                   */
/*   FFC01  -  INPUT CYCLE INITIATION FILE REORGANIZATION            */
/*                                                                   */
/*       (c) Finastra International Limited 2001                     */
/*                                                                   */
/*       Last Amend No. MD046248           Date 27Oct17              */
/*       Prev Amend No. LLN022A            Date 03Jun15              */
/*                      BUG28060           Date 23Aug10              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*                      CER001             Date 25Apr05              */
/*                      LLN022             Date 24Jan05              */
/*                      228542             Date 05Aug04              */
/* Midas Release 4 --------------- Base -----------------------------*/
/* Midas DBA 3.00 Patch D -------------------------------------------*/
/* Midas DBA 3.01 ---------------------------------------------------*/
/*                      163444             Date 01Oct99              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                  113482             DATE 18FEB98                  */
/*                  CED006             DATE 28AUG97                  */
/*                  S01408             DATE 13MAY96                  */
/*                  S01456             DATE 01DEC93                  */
/*                  E59489             DATE 12FEB94                  */
/*                  E28693             DATE 19SEP91                  */
/*                  FO0126/E27376      DATE 07JUN91                  */
/*                  FO0013             DATE 18FEB91                  */
/*                  E22958             DATE 21AUG90                  */
/*                  E22177             DATE 23MAY90                  */
/*                  E21756             DATE 03MAY90                  */
/*                  E21496             DATE 19APR90                  */
/*                  S01117             DATE 26MAR90                  */
/*                  S01240             DATE 03JAN90                  */
/*                  E13205             DATE 28/02/89                 */
/*                                                                   */
/*-------------------------------------------------------------------*/
/*                                                                   */
/*       MD046248 - Finastra Rebranding                              */
/*       LLN022A - BOE Upgrade to MidasPlus - incorporate            */
/*                 hook FFC01008                                     */
/*   BUG28060 - File TRANSA not reorganize                           */
/*   CER001  -  LUX Upgrade to MidasPlus                             */
/*       LLN022 - BOE Upgrade to MidasPlus.                          */
/*                Amend hook FFC01008                                */
/*   228542  -  RGZPFM has changed at R5V3                           */
/*   163444  -  Y2K sort order and file allocation.                  */
/*   113482  -  MONMSG CPF3135 WHEN RGZPFM.                            */
/*              The program can itself lock the file.                  */
/*   CED006  -  ED Enhancements                                        */
/*   S01408  -  Core hook FFC01002 added                               */
/*              Core hook FFC01001 added                               */
/*   S01456  -  Monthly P&L Enhancements.                              */
/*   E59489  -  CLRPFM OF MEMOS, PRONO & FFACMVD in FFC1080 locks the  */
/*              EOC when one of these files are open (ie when          */
/*              enquiring on a/c movements)                            */
/*              Call pgm FFC0101 to do the RGZPFM.                     */
/*   E28693  -  RCLRSC to close down all open files.                   */
/*   FO0126  -  Include call to FF0466 to delete redundant position    */
/*           -  profit centers.                                        */
/*   FO0013  -  Fix E13205 was applied because RGZPFM prevented        */
/*              Forward Recovery working, but so does CLRPFM/CPYF.     */
/*              Correct fix is to use RGZPFM but to call the comp't    */
/*              from SDC0606 (pre DB Save) instead of SDC01 (post DB   */
/*              save). This makes fixes E13205, E22177 and E22958      */
/*              redundant. Note - fix applied to SD programs under     */
/*              Error No. LN1171.                                      */
/*           -  Fix E21756 removed - program FF0468 now updates        */
/*              TRANSD instead of updating a copy and then copying     */
/*              this file to TRANSD.                                   */
/*           -  OPNDBF/CLOF of LF's built over TRANSD was carried out  */
/*              before update and RGZPFM of TRANSD; this Access Path   */
/*              rebuild is not neccessary.                             */
/*           -  ABNOR processing inserted to handle Database errors.   */
/*   E22958  -  If QTEMP at top of LIBL (may occur if user has DRS)    */
/*              reorganised file may be copied back into version of    */
/*              file in QTEMP and data lost, causing DB errors later.  */
/*              Fix is ensure version in QTEMP has different name.     */
/*   E22177  -  CPYF for TRSETD2 had miskeyed parameter (&MKT).        */
/*   E21756  -  Prevent records to be reversed in next EOC from        */
/*              being dropped during this COB.                         */
/*   E21496  -  GOTO LOOP2 is in the wrong place, therefore any        */
/*              Market Centres after a deleted one will not be         */
/*              processed.                                             */
/*   S01117  -  MULTIBRANCHING                                         */
/*   S01240  -  FF/AME INTERFACE INCORPORATION                         */
/*   E13205  -  Replace physical file reorganisations with copies      */
/*              to and then from a duplicate in QTEMP. Note that       */
/*              access paths may have to be rebuilt.                   */
/*              - data length of &MEM should be 44                     */
/*                                                                     */
/*********************************************************************/
             PGM
/**/
/*   DECLARE VARIABLES                                              */
/**/
             DCL        &EOM          TYPE(*CHAR)  LEN(1)
             DCL        &EOY          TYPE(*CHAR)  LEN(1)
             DCL        &MKT          TYPE(*CHAR)  LEN(2)
/************DCL********&MEM          TYPE(*CHAR)  LEN(2)          */ /*E13205*/
/************DCL        &MEM          TYPE(*CHAR)  LEN(44) /*E13205*/ /*S01117*/
             DCL        &MEM          TYPE(*CHAR)  LEN(50)            /*S01117*/
             DCL        &A            TYPE(*DEC)   LEN(2 0) VALUE(1)
             DCL        &FFEOC        TYPE(*CHAR)  LEN(256)
/***********                                                          /*E21756*/
/************DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)             /*FO0013*/
/************DCL        VAR(&DMLIB)  TYPE(*CHAR) LEN(7)               /*FO0013*/
/*                                                                    /*E21756*/
             DCL        &MSG          TYPE(*CHAR)  LEN(75)            /*FO0013*/
             DCL        &MSGDBE       TYPE(*CHAR)  LEN(75)            /*FO0013*/
             DCL VAR(&S01456) TYPE(*CHAR) LEN(1) VALUE(' ')           /*S01456*/
             DCL        VAR(&LLN022) TYPE(*CHAR) LEN(1) VALUE(' ')                       /*LLN022A*/
             DCL VAR(&PRTCD) TYPE(*CHAR) LEN(7) VALUE(' ')            /*S01456*/
             DCL        VAR(&SIX) TYPE(*DEC) LEN(1 0) VALUE(0)        /*163444*/
             DCL        VAR(&SIXB) TYPE(*DEC) LEN(1 0) VALUE(0)       /*163444*/
             DCL        VAR(&CHKPOSN) TYPE(*DEC) LEN(2 0) VALUE(10)                       /*228542*/
             DCL        VAR(&LAST) TYPE(*CHAR) LEN(1)                                     /*228542*/
             DCL        VAR(&MRKTCHK) TYPE(*CHAR) LEN(10)                                 /*228542*/
/***********                                                                  */
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Finastra International Limited +
                          2001')
/***********                                                                  */
             DCLF       FILE(MARKTD)
/**/
             MONMSG     MSGID(CPF0000 MCH0000) EXEC(GOTO ABNOR)       /*FO0013*/
/*                                                                    /*FO0013*/
             CHGVAR     VAR(&MSG) VALUE(' FF File Reorganisation +
                          Executing')                                 /*FO0013*/
             SNDMSG     TOMSGQ(MRUNQ) MSG(&MSG)                       /*FO0013*/
/*/COPY WNCPYSRC,FFC01008                                            */
/**/
/* Check if BOE processing installed */                                                  /*LLN022A*/
 
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'LLN022')                             /*LLN022A*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&LLN022) VALUE('Y'))                           /*LLN022A*/
                                                                                         /*LLN022A*/
/* Copy Futures and Options account keys */                                              /*LLN022A*/
                                                                                         /*LLN022A*/
             IF    COND(&LLN022 *EQ 'Y')  THEN(DO)                                       /*LLN022A*/
             CPYF       FROMFILE(BYFOKYPP) TOFILE(BYAKFFPP) +
                          MBROPT(*ADD)                                                   /*LLN022A*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                                   /*LLN022A*/
                                                                                         /*LLN022A*/
/* Clear Futures and Options account keys daily file */                                  /*LLN022A*/
                                                                                         /*LLN022A*/
             CLRPFM     FILE(BYFOKYPP)                                                   /*LLN022A*/
             ENDDO                                                                       /*LLN022A*/
/**/                                                                  /*E21756*/
/*   SET UP FILE IN QTEMP SO THAT MONMSG ON CPYF GETS CORRECT MSG     /*E21756*/
/**/                                                                  /*E21756*/
/************RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)         /*E21756*S01456*/
/************CHGVAR     VAR(&DMLIB) VALUE(%SST(&SDSTAT 6 2) *CAT +    /*S01456*/
/************                                      'DMLIB')    /*E21756*S01456*/
/************CRTDUPOBJ  OBJ(TRANSD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +  /*S01456*/
/************             TOLIB(QTEMP) NEWOBJ(TRANSD2) DATA(*NO) +    /*S01456*/
/************                                                  /*E21756*S01456*/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)         /*E21756*S01456*/
/************CRTDUPOBJ  OBJ(TRSETD) FROMLIB(&DMLIB) OBJTYPE(*FILE) +  /*S01456*/
/************             TOLIB(QTEMP) NEWOBJ(TRSETD2) DATA(*NO) +    /*S01456*/
/**/
/************MONMSG     MSGID(CPF0000 RPG0000 MCH0000)         /*E21756*S01456*/
/**/
/*   CALL SD2000 - END OF MONTH CHECK                               */
/**/
             CALL       PGM(SD2000) PARM(&EOM &EOY)
                                                                      /*S01456*/
             CALL (AOSARDR0) PARM(&PRTCD '*VERIFY' 'S01456')          /*S01456*/
             IF (&PRTCD *EQ ' ') (CHGVAR (&S01456) VALUE('Y'))        /*S01456*/
                                                                      /*S01456*/
/**/
/*   CALL FF0460 - DELETE CLOSE OUT SETS FOR MATURED INSTRUMENTS    */
/**/
             CALL       PGM(FF0460)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO *EXT                                                  */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)
                 GOTO       END
             ENDDO
/*   Create Y2K sort extract files                                 */ /*163444*/
/**/
                                                                      /*163444*/
 LOOPA:      ALCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIX) VALUE(&SIX + 1)                     /*163444*/
             IF         COND(&SIX *LE 6) THEN(GOTO CMDLBL(LOOPA))     /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP)                               /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC1        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNC1        )) FORMAT(FFPSNCPD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPSNCPD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
 LOOPB:      ALCOBJ     OBJ((FFPNK5PD *FILE *EXCL))                   /*163444*/
             MONMSG     MSGID(CPF0000) EXEC(DO)                       /*163444*/
             RCVMSG     WAIT(60) RMV(*NO)                             /*163444*/
             CHGVAR     VAR(&SIXB) VALUE(&SIXB + 1)                   /*163444*/
             IF         COND(&SIXB *LE 6) THEN(GOTO CMDLBL(LOOPB))    /*163444*/
             ELSE       CMD(DO)                                       /*163444*/
             SNDPGMMSG  MSG('JOB CANNOT BE RUN AT THIS TIME') +
                          TOPGMQ(*EXT) TOMSGQ(MOPERQ)                 /*163444*/
             GOTO       CMDLBL(ENDLOOP)                               /*163444*/
             ENDDO                                                    /*163444*/
             ENDDO                                                    /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNK5        )) FORMAT(FFPNK5PD) +
                          QRYSLT('YRNO *LE 72') MAPFLD((YRCC 'YRNO +
                          + 2000')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPNK5PD) +
                          MBROPT(*REPLACE)                            /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
                                                                      /*163444*/
             OPNQRYF    FILE((POSTNK5        )) FORMAT(FFPNK5PD) +
                          QRYSLT('YRNO *GT 72') MAPFLD((YRCC 'YRNO +
                          + 1900')) OPNID(Q1)                         /*163444*/
             CPYFRMQRYF FROMOPNID(Q1) TOFILE(FFPNK5PD) +
                          MBROPT(*ADD)                                /*163444*/
             CLOF       OPNID(Q1)                                     /*163444*/
/**/
/*   CALL FF0465 - DELETE POSITION DETAILS FOR MATURED INSTRUMENTS  */
/**/
             CALL       PGM(FF0465)
/*                                                                  */
             DLCOBJ     OBJ((FFPSNCPD *FILE *EXCL))                   /*163444*/
             DLCOBJ     OBJ((FFPNK5PD *FILE *EXCL))                   /*163444*/
ENDLOOP:                                                              /*163444*/
/*                                                                 */ /*163444*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO *EXT                                                  */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)
                 GOTO       END
             ENDDO
/**/                                                                  /*FO0126*/
/*   Call FF0465 - Delete redundant position profit centers             FO0126*/
/**/                                                                  /*FO0126*/
             CALL       PGM(FF0466)                                   /*FO0126*/
/*                                                                      FO0126*/
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND          FO0126*/
/* MESSAGE TO *EXT                                                      FO0126*/
/*                                                                      FO0126*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)              /*FO0126*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*FO0126*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)                             /*FO0126*/
                 GOTO       END                                       /*FO0126*/
             ENDDO                                                    /*FO0126*/
/**/
/*  CLEAR FILE EOCMGD                                               */
/**/
             CLRPFM     FILE(EOCMGD)
/**/
/*  CLEAR OTC MEMBER FOR MULTI-MEMBER FILES                         */
/**/
             CLRPFM     FILE(FOKEYD) MBR(OTC)
             CLRPFM     FILE(FOKEYA) MBR(OTC)
             INZPFM     FILE(FOKEYA) MBR(OTC) TOTRCDS(1)
             CLRPFM     FILE(MEMOSME) MBR(OTC)
             CLRPFM     FILE(PRONOME) MBR(OTC)
             CLRPFM     FILE(FFACMVD) MBR(OTC)                        /*S01240*/
/**/                                                                  /*E59489*/
/*    CALL NEW PROGRAM TO REORGANIZE MEMOS, PRONO, FFACMVD            /*E59489*/
/**/                                                                  /*E59489*/
             CALL       PGM(FFC0101)                                  /*E59489*/
/**/                                                                  /*E59489*/
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)
/**/
 LOOP:
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(NEXT))
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))
/**/
/*  CLEAR CORRECT MEMBER FOR MARKET FOR MULTI-MEMBER FILES           */
/**/
             CLRPFM     FILE(FOKEYD) MBR(&MKT)
             CLRPFM     FILE(FOKEYA) MBR(&MKT)
             INZPFM     FILE(FOKEYA) MBR(&MKT) TOTRCDS(1)
             CLRPFM     FILE(MEMOSME) MBR(&MKT)
             CLRPFM     FILE(PRONOME) MBR(&MKT)
             CLRPFM     FILE(FFACMVD) MBR(&MKT)                       /*S01240*/
/**/
/*     CALL PROGRAM TO RESET MARKET CONTROL FLAGS                   */
/**/
             CALL       PGM(FF0472) PARM('E' &MKT)
/*                                                                  */
/* FOR DATABASE ERRORS RECOVER DATA FROM LOCAL DATA AREA, SEND      */
/* MESSAGE TO *EXT                                                  */
/*                                                                  */
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)
                 GOTO       END
             ENDDO
/**/
             CHGVAR     VAR(&A) VALUE(&A + 2)
             GOTO       CMDLBL(LOOP)
/**/
/*  CLEAR OTC MEMBER FOR MULTI-MEMBER FILES                         */
/**/
 NEXT:       CLRPFM     FILE(MGEFFHH) MBR(OTC)
             CLRPFM     FILE(MGEFFPD) MBR(OTC)
             CLRPFM     FILE(MGEFFZZ) MBR(OTC)
             CLRPFM     FILE(MATIND) MBR(OTC)
             CLRPFM     FILE(EDSFKYPD) MBR(OTC)                       /*CED006*/
             MONMSG     MSGID(CPF3141)                                /*CED006*/
/**/
/*  REORGANIZE OTC MEMBER FOR MULTI-MEMBER FILES                     */
/**/
/**********  RGZPFM     FILE(CLOSTD) MBR(OTC)                         /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('CLOSTD' 'OTC')                               /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(CLOSTT) MBR(OTC)                         /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('CLOSTT' 'OTC')                               /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(POSTNCD) MBR(OTC)                        /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('POSTNCD' 'OTC')                              /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(POSTNKD) MBR(OTC)                        /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('POSTNKD' 'OTC')                              /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/
/************RGZPFM*****FILE(CLOSTD)*MBR(OTC)***********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/CLOSTD)***********************E13205*E22958*/
/************DLTF       FILE(QTEMP/CLOSTD2)                    /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                         /*E13205*FO0013*/
/************CPYF*******FROMFILE(CLOSTD)*TOFILE(QTEMP/CLOSTD)*+*********E22958*/
/*************************FROMMBR(OTC)*MBROPT(*REPLACE)*CRTFILE(*YES)*+*E22958*/
/*************************COMPRESS(*YES)*************************E13205*E22958*/
/************CPYF       FROMFILE(CLOSTD) TOFILE(QTEMP/CLOSTD2) +
/************             FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YES) +
/************             COMPRESS(*YES)                       /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************CLRPFM     FILE(CLOSTD) MBR(OTC)                  /*E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/CLOSTD)*TOFILE(CLOSTD)*+*********E22958*/
/**********************TOMBR(OTC)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/CLOSTD2) TOFILE(CLOSTD) +
/************             TOMBR(OTC) MBROPT(*REPLACE) COMPRESS(**E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************DLTF       FILE(QTEMP/CLOSTD2)                    /*E22958*FO0013*/
/************DLTF*******FILE(QTEMP/CLOSTD)***********************E13205*E22958*/
/**/                                                                  /*E22958*/
/************RGZPFM*****FILE(CLOSTT)*MBR(OTC)***********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/CLOSTT)***********************E13205*E22958*/
/************DLTF       FILE(QTEMP/CLOSTT2)                    /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                         /*E13205*FO0013*/
/************CPYF*******FROMFILE(CLOSTT)*TOFILE(QTEMP/CLOSTT)*+*********E22958*/
/*************************FROMMBR(OTC)*MBROPT(*REPLACE)*CRTFILE(*YES)*+*E22958*/
/*************************COMPRESS(*YES)*************************E13205*E22958*/
/************CPYF       FROMFILE(CLOSTT) TOFILE(QTEMP/CLOSTT2) +
/************             FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YES) +
/************             COMPRESS(*YES)                       /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************CLRPFM     FILE(CLOSTT) MBR(OTC)                  /*E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/CLOSTT)*TOFILE(CLOSTT)*+*********E22958*/
/**********************TOMBR(OTC)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/CLOSTT2) TOFILE(CLOSTT) +
/************             TOMBR(OTC) MBROPT(*REPLACE) COMPRESS(*YE22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************DLTF       FILE(QTEMP/CLOSTT2)                    /*E22958*FO0013*/
/************DLTF*******FILE(QTEMP/CLOSTT)***********************E13205*E22958*/
/**/
/************RGZPFM*****FILE(POSTNCD)*MBR(OTC)**********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/POSTNCD)**********************E13205*E22958*/
/************DLTF       FILE(QTEMP/POSTNCD2)                   /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                         /*E13205*FO0013*/
/************CPYF*******FROMFILE(POSTNCD)*TOFILE(QTEMP/POSTNCD)*+*******E22958*/
/*************************FROMMBR(OTC)*MBROPT(*REPLACE)*CRTFILE(*YES)*+*E22958*/
/*************************COMPRESS(*YES)*************************E13205*E22958*/
/************CPYF       FROMFILE(POSTNCD) TOFILE(QTEMP/POSTNCD2) +
/************             FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YES) +
/************             COMPRESS(*YES)                       /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************CLRPFM     FILE(POSTNCD) MBR(OTC)                 /*E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/POSTNCD)*TOFILE(POSTNCD)*+*******E22958*/
/**********************TOMBR(OTC)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/POSTNCD2) TOFILE(POSTNCD) +
/************             TOMBR(OTC) MBROPT(*REPLACE) COMPRESS(*YE22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************DLTF       FILE(QTEMP/POSTNCD2)                           /FO0013*/
/************DLTF*******FILE(QTEMP/POSTNCD)**********************E13205*E22958*/
/**/
/************RGZPFM*****FILE(POSTNKD)*MBR(OTC)**********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/POSTNKD)**********************E13205*E22958*/
/************DLTF       FILE(QTEMP/POSTNKD2)                   /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                         /*E13205*FO0013*/
/************CPYF*******FROMFILE(POSTNKD)*TOFILE(QTEMP/POSTNKD)*+*******E22958*/
/*************************FROMMBR(OTC)*MBROPT(*REPLACE)*CRTFILE(*YES)*+*E22958*/
/*************************COMPRESS(*YES)*************************E13205*E22958*/
/************CPYF       FROMFILE(POSTNKD) TOFILE(QTEMP/POSTNKD2) +
/************             FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YES) +
/************             COMPRESS(*YES)                       /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************CLRPFM     FILE(POSTNKD) MBR(OTC)                 /*E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/POSTNKD) TOFILE(POSTNKD) +             */
/**********************TOMBR(OTC) MBROPT(*REPLACE) COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/POSTNKD2) TOFILE(POSTNKD) +
/************             TOMBR(OTC) MBROPT(*REPLACE) COMPRESS(**E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************DLTF       FILE(QTEMP/POSTNKD2)                   /*E22958*FO0013*/
/************DLTF*******FILE(QTEMP/POSTNKD)**********************E13205*E22958*/
/**/
/*  COPY OTC MEMBER FOR MULTI-MEMBER FILES TO REMOVE DELETED RECORDS */
/**/
/*********** CPYF       FROMFILE(TRANSD) TOFILE(QTEMP/TRANSD2) +      /*E21756*/
/***********              FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YES) /*E21756*/
/***********              INCREL((*IF RECI *NE *))             /*E21756*FO0013*/
/************CPYF       FROMFILE(TRANSD) TOFILE(QTEMP/TRANSD2) +        FO0013*/
/************             FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*E21756*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) +                FO0013*/
/************             EXEC(GOTO CMDLBL(T1)) /* SKIP IF EMPTY +      FO0013*/
/************             MEMBER */                                   /*FO0013*/
/**/
/* TRSETD & TRANSD must be reorganised via FF0468 to prevent deleted  /*E21756*/
/* trades being dropped before they are reversed in the next EOC.     /*E21756*/
/*                                                                    /*E21756*/
             OVRDBF     FILE(TRANSD) MBR(OTC )                        /*FO0013*/
             OVRDBF     FILE(TRSET ) MBR(OTC )                        /*E21756*/
/*/COPY WNCPYSRC,FFC01004                                            */
             CALL       PGM(FF0468) PARM('  ')                        /*E21756*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)                             /*E21756*/
                 GOTO       END                                       /*E21756*/
             ENDDO                                                    /*E21756*/
             DLTOVR     FILE(TRANSD)                                  /*FO0013*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0013*/
             DLTOVR     FILE(TRSET)                                   /*E21756*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E21756*/
/**/
/**********  RGZPFM     FILE(TRANSD) MBR(OTC)                         /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('TRANSD' 'OTC')                               /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(TRSETD) MBR(OTC)                         /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('TRSETD' 'OTC')                               /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/*/COPY WNCPYSRC,FFC01005                                            */
/************CLRPFM     FILE(TRANSD) MBR(OTC)                         /*FO0013*/
 
/************OPNDBF     FILE(TRANS2) OPTION(*INP) MBR(*FIRST)         /*FO0013*/
/************   CLOF       OPNID(TRANS2)                              /*FO0013*/
/************OPNDBF     FILE(TRANS9) OPTION(*INP) MBR(*FIRST)         /*FO0013*/
/************   CLOF       OPNID(TRANS9)                              /*FO0013*/
/************OPNDBF     FILE(TRANSDM) OPTION(*INP) MBR(*FIRST)        /*FO0013*/
/************   CLOF       OPNID(TRANSDM)                             /*FO0013*/
/************OPNDBF     FILE(TRANS) OPTION(*INP) MBR(OTC)             /*FO0013*/
/************   CLOF       OPNID(TRANS)                               /*FO0013*/
/************OPNDBF     FILE(TRANS1) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS1)                              /*FO0013*/
/************OPNDBF     FILE(TRANS10) OPTION(*INP) MBR(OTC)           /*FO0013*/
/************   CLOF       OPNID(TRANS10)                             /*FO0013*/
/************OPNDBF     FILE(TRANS3) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS3)                              /*FO0013*/
/************OPNDBF     FILE(TRANS4) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS4)                              /*FO0013*/
/************OPNDBF     FILE(TRANS5) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS5)                              /*FO0013*/
/************OPNDBF     FILE(TRANS6) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS6)                              /*FO0013*/
/************OPNDBF     FILE(TRANS7) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS7)                              /*FO0013*/
/************OPNDBF     FILE(TRANS8) OPTION(*INP) MBR(OTC)            /*FO0013*/
/************   CLOF       OPNID(TRANS8)                              /*FO0013*/
/************                                                         /*FO0013*/
/************CPYF       FROMFILE(QTEMP/TRANSD2) TOFILE(TRANSD)       +/*FO0013*/
/************TOMBR(OTC) MBROPT(*REPLACE)                              /*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*FO0013*/
 
/*T1:***/ /**NEXT*FILE**/                                             /*FO0013*/
/*********** CPYF       FROMFILE(TRSETD) TOFILE(QTEMP/TRSETD2)       +/*E21756*/
/**FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YES) INCREL((*IF RECI *NE *))*E21756*/
/************CPYF       FROMFILE(TRSETD) TOFILE(QTEMP/TRSETD2) +       *FO0013*/
/************             FROMMBR(OTC) MBROPT(*REPLACE) CRTFILE(*YE21756FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +    /*FO0013*/
/************             CMDLBL(T2))  /* SKIP IF EMPTY MEMBER */     /*FO0013*/
/************CLRPFM     FILE(TRSETD) MBR(OTC)                         /*FO0013*/
/************                                                         /*FO0013*/
/************OPNDBF     FILE(TRSET1) OPTION(*INP) MBR(*FIRST)         /*FO0013*/
/************   CLOF       OPNID(TRSET1)                              /*FO0013*/
/************OPNDBF     FILE(TRSET) OPTION(*INP) MBR(OTC)             /*FO0013*/
/************   CLOF       OPNID(TRSET)                               /*FO0013*/
/************                                                         /*FO0013*/
/************CPYF       FROMFILE(QTEMP/TRSETD2) TOFILE(TRSETD)      + /*FO0013*/
/************OMBR(OTC) MBROPT(*REPLACE)                               /*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*FO0013*/
/**/                                                                  /*FO0013*/
/*T2:***/ /**NEXT*FILE**/                                             /*FO0013*/
/**/                                                                  /*FO0013*/
/**Do*not*delete*these*TEMP*files*as*MONMSG*on*the*CPYF*won't*wo*E21756*FO0013*/
/*********** DLTF       FILE(QTEMP/TRANSD2)                           /*E21756*/
/*********** DLTF       FILE(QTEMP/TRSETD2)                           /*E21756*/
/*                                                                 */
/* REMOVE RECORDS IN OTC MEMBER OF POCHG PHYSICAL FILES ONLY IF    */
/* IT IS END OF MONTH AND RECORDS HAVE BEEN FULLY PROCESSED        */
/*                                                                 */
             IF         COND(&EOM *EQ Y) THEN(DO)
/*                                                                  */
             CPYF       FROMFILE(POCHGCC) TOFILE(QTEMP/POCHGCC2) +
                          FROMMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P1))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGCC) MBR(OTC)
             CPYF       FROMFILE(QTEMP/POCHGCC2) TOFILE(POCHGCC) +
                          TOMBR(OTC) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P1:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGRC) TOFILE(QTEMP/POCHGRC2) +
                          FROMMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P2))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGRC) MBR(OTC)
             CPYF       FROMFILE(QTEMP/POCHGRC2) TOFILE(POCHGRC) +
                          TOMBR(OTC) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P2:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGTC) TOFILE(QTEMP/POCHGTC2) +
                          FROMMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P3))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGTC) MBR(OTC)
             CPYF       FROMFILE(QTEMP/POCHGTC2) TOFILE(POCHGTC) +
                          TOMBR(OTC) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P3:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGCK) TOFILE(QTEMP/POCHGCK2) +
                          FROMMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P4))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGCK) MBR(OTC)
             CPYF       FROMFILE(QTEMP/POCHGCK2) TOFILE(POCHGCK) +
                          TOMBR(OTC) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P4:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGRK) TOFILE(QTEMP/POCHGRK2) +
                          FROMMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P5))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGRK) MBR(OTC)
             CPYF       FROMFILE(QTEMP/POCHGRK2) TOFILE(POCHGRK) +
                          TOMBR(OTC) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P5:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGTK) TOFILE(QTEMP/POCHGTK2) +
                          FROMMBR(OTC) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P6))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGTK) MBR(OTC)
             CPYF       FROMFILE(QTEMP/POCHGTK2) TOFILE(POCHGTK) +
                          TOMBR(OTC) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/**/
P6:     /* LAST FILE (OTC) */
/**/
             DLTF       FILE(QTEMP/POCHGCC2)
             DLTF       FILE(QTEMP/POCHGRC2)
             DLTF       FILE(QTEMP/POCHGTC2)
             DLTF       FILE(QTEMP/POCHGCK2)
             DLTF       FILE(QTEMP/POCHGRK2)
             DLTF       FILE(QTEMP/POCHGTK2)
             ENDDO
/*                                                                      S01408*/
/*/COPY WNCPYSRC,FFC01001                                               S01408*/
/*                                                                      S01408*/
/**/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN PF/MARKTD        */
/**/
 LOOP2:      RCVF
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(TAG1))
                                                                                          /*228542*/
/* Pad variable with blanks */                                                            /*228542*/
                                                                                          /*228542*/
             CHGVAR     VAR(&MRKTCHK) VALUE(&MRKT)                                        /*228542*/
                                                                                          /*228542*/
 BLANKCHK:                                                                                /*228542*/
             CHGVAR     VAR(&LAST) VALUE(%SST(&MRKTCHK &CHKPOSN 1))                       /*228542*/
                                                                                          /*228542*/
             IF         COND(&LAST *EQ ' ') THEN(DO)                                      /*228542*/
                CHGVAR     VAR(%SST(&MRKTCHK &CHKPOSN 1)) +
                             VALUE('*')                                                   /*228542*/
                CHGVAR     VAR(&CHKPOSN) VALUE(&CHKPOSN - 1)                              /*228542*/
                GOTO       CMDLBL(BLANKCHK)                                               /*228542*/
             ENDDO                                                                        /*228542*/
                                                                                          /*228542*/
/*                                                                  */
/* PROCESS ALL FILES IF MARKET CENTRE HAS NOT BEEN DELETED          */
/*                                                                  */
             IF         COND(&RECI *NE '*') THEN(DO)
             CHGVAR     VAR(&MKT) VALUE(&MRKT)
/**/
/*  CLEAR RELEVANT MARKET MEMBER FOR MULTI-MEMBER FILES             */
/**/
             CLRPFM     FILE(MGEFFHH) MBR(&MKT)
             CLRPFM     FILE(MGEFFPD) MBR(&MKT)
             CLRPFM     FILE(MGEFFZZ) MBR(&MKT)
             CLRPFM     FILE(MATIND) MBR(&MKT)
             CLRPFM     FILE(EDSFKYPD) MBR(&MKT)                      /*CED006*/
             MONMSG     MSGID(CPF3141)                                /*CED006*/
/**/
/*  REORGANIZE RELEVANT MARKET MEMBER FOR MULTI-MEMBER FILES        */
/**/
/**********  RGZPFM     FILE(CLOSTD) MBR(&MKT)                        /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('CLOSTD' &MRKTCHK)                            /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(CLOSTT) MBR(&MKT)                        /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('CLOSTT' &MRKTCHK)                            /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(POSTNCD) MBR(&MKT)                       /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('POSTNCD' &MRKTCHK)                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(POSTNKD) MBR(&MKT)                       /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('POSTNKD' &MRKTCHK)                           /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                                        /*BUG28060*/
             CALL       PGM(SCC000060) PARM('TRANSA' &MRKTCHK)                          /*BUG28060*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                /*BUG28060*/
/**/
/************RGZPFM*****FILE(CLOSTD)*MBR(&MKT)**********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/CLOSTD)***********************E13205*E22958*/
/************DLTF       FILE(QTEMP/CLOSTD2)                    /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                         /*E13205*FO0013*/
/************CPYF*******FROMFILE(CLOSTD)*TOFILE(QTEMP/CLOSTD)*+*********E22958*/
/*************************FROMMBR(&MKT)*MBROPT(*REPLACE)*+**************E22958*/
/*************************CRTFILE(*YES)*COMPRESS(*YES)***********E13205*E22958*/
/************CPYF       FROMFILE(CLOSTD) TOFILE(QTEMP/CLOSTD2) +
/************             FROMMBR(&MKT) MBROPT(*REPLACE) +
/************             CRTFILE(*YES) COMPRESS(*YES)         /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************CLRPFM     FILE(CLOSTD) MBR(&MKT)                 /*E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/CLOSTD)*TOFILE(CLOSTD)*+*********E22958*/
/*********************TOMBR(&MKT)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/CLOSTD2) TOFILE(CLOSTD) +
/************             TOMBR(&MKT) MBROPT(*REPLACE) COMPRESS(*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          *E13205*FO0013*/
/************DLTF       FILE(QTEMP/CLOSTD2)                     *E22958*FO0013*/
/************DLTF*******FILE(QTEMP/CLOSTD)***********************E13205*E22958*/
/**/                                                                  /*E22958*/
/************RGZPFM*****FILE(CLOSTT)*MBR(&MKT)**********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/CLOSTT)***********************E13205*E22958*/
/************DLTF       FILE(QTEMP/CLOSTT2)                    /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                         /*E13205*FO0013*/
/************CPYF*******FROMFILE(CLOSTT)*TOFILE(QTEMP/CLOSTT)*+*********E22958*/
/*************************FROMMBR(&MKT)*MBROPT(*REPLACE)*+**************E22958*/
/*************************CRTFILE(*YES)*COMPRESS(*YES)***********E13205*E22958*/
/************CPYF       FROMFILE(CLOSTT) TOFILE(QTEMP/CLOSTT2) +
/************             FROMMBR(&MKT) MBROPT(*REPLACE) +
/************             CRTFILE(*YES) COMPRESS(*YES)         /*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)         /*E13205*FO0013*/
/************CLRPFM     FILE(CLOSTT) MBR(&MKT)                 /*E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/CLOSTT2)*TOFILE(CLOSTT)*+********E22958*/
/*********************TOMBR(&MKT)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/CLOSTT2) TOFILE(CLOSTT) +
/************             TOMBR(&MKT) MBROPT(*REPLACE) COMPRESS(*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          *E13205*FO0013*/
/************DLTF       FILE(QTEMP/CLOSTT2)                     *E22958*FO0013*/
/************DLTF*******FILE(QTEMP/CLOSTT)***********************E13205*E22958*/
/**/                                                                  /*E22958*/
/************RGZPFM*****FILE(POSTNCD)*MBR(&MKT)*********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/POSTNCD)**********************E13205*E22958*/
/************DLTF       FILE(QTEMP/POSTNCD2)                    *E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                          *E13205*FO0013*/
/************CPYF*******FROMFILE(POSTNCD)*TOFILE(QTEMP/POSTNCD)*+*******E22958*/
/*************************FROMMBR(&MKT)*MBROPT(*REPLACE)*+**************E22958*/
/*************************CRTFILE(*YES)*COMPRESS(*YES)***********E13205*E22958*/
/************CPYF       FROMFILE(POSTNCD) TOFILE(QTEMP/POSTNCD2) +
/************             FROMMBR(&MKT) MBROPT(*REPLACE) +
/************             CRTFILE(*YES) COMPRESS(*YES)          *E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          *E13205*FO0013*/
/************CLRPFM     FILE(POSTNCD) MBR(&MKT)                 *E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/POSTNCD)*TOFILE(POSTNCD)*+*******E22958*/
/*********************TOMBR(&MKT)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/POSTNCD2) TOFILE(POSTNKD) +
/************             TOMBR(&MKT) MBROPT(*REPLACE) COMPRESS(*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          *E13205*FO0013*/
/************DLTF       FILE(QTEMP/POSTNCD2)                    *E22958*FO0013*/
/************DLTF*******FILE(QTEMP/POSTNCD)**********************E13205*E22958*/
/**/                                                                  /*E22958*/
/************RGZPFM*****FILE(POSTNKD)*MBR(&MKT)*********************/ /*E13205*/
/************MONMSG*****MSGID(CPF2981)******************************/ /*E13205*/
/************DLTF*******FILE(QTEMP/POSTNKD)**********************E13205*E22958*/
/************DLTF       FILE(QTEMP/POSTNKD2)                    *E22958*FO0013*/
/************MONMSG     MSGID(CPF2105)                          *E13205*FO0013*/
/************CPYF*******FROMFILE(POSTNKD)*TOFILE(QTEMP/POSTNKD)*+*******E22958*/
/*************************FROMMBR(&MKT)*MBROPT(*REPLACE)*+**************E22958*/
/*************************CRTFILE(*YES)*COMPRESS(*YES)***********E13205*E22958*/
/************CPYF       FROMFILE(POSTNKD) TOFILE(QTEMP/POSTNKD2) +
/************             FROMMBR(&MKT) MBROPT(*REPLACE) +
/************             CRTFILE(*YES) COMPRESS(*YES)          *E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          *E13205*FO0013*/
/************CLRPFM     FILE(POSTNKD) MBR(&MKT)                 *E13205*FO0013*/
/************CPYF*******FROMFILE(QTEMP/POSTNKD)*TOFILE(POSTNKD)*+*******E22958*/
/*********************TOMBR(&MKT)*MBROPT(*REPLACE)*COMPRESS(*YES)*E13205E22958*/
/************CPYF       FROMFILE(QTEMP/POSTNKD2) TOFILE(POSTNKD) +
/************             TOMBR(&MKT) MBROPT(*REPLACE) COMPRESS(*E22958*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)          *E13205*FO0013*/
/************DLTF       FILE(QTEMP/POSTNKD2)                    *E22958*FO0013*/
/************DLTF*******FILE(QTEMP/POSTNKD)**********************E13205*E22958*/
/**/
/*  COPY RELEVANT MARKET MEMBER FOR MULTI-MEMBER FILES TO REMOVE    */
/*  DELETED RECORDS                                                 */
/*********** CPYF       FROMFILE(TRANSD) TOFILE(QTEMP/TRANSD2) +      /*E21756*/
/***********              FROMMBR(&MKT) MBROPT(*REPLACE) +            /*E21756*/
/***********              CRTFILE(*YES) INCREL((*IF RECI *NE *))      /*E21756*/
/************CPYF       FROMFILE(TRANSD) TOFILE(QTEMP/TRANSD2) +
/************             FROMMBR(&MKT) MBROPT(*REPLACE) +
/************             CRTFILE(*YES)                        /*E21756*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
/************             CMDLBL(T3))  /* SKIP IF EMPTY MEMBER */     /*FO0013*/
/**/
/* TRSETD & TRANSD must be reorganised via FF0468 to prevent deleted  /*E21756*/
/* trades being dropped before they are reversed in the next EOC.     /*E21756*/
/*                                                                    /*E21756*/
             OVRDBF     FILE(TRANSD)  MBR(&MKT)                       /*FO0013*/
             OVRDBF     FILE(TRSET)  MBR(&MKT)                        /*E21756*/
/*/COPY WNCPYSRC,FFC01006                                            */
             CALL       PGM(FF0468) PARM(&MKT)                        /*E21756*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(DO)
/***********     RTVDTAARA  DTAARA(LDA (134 44)) RTNVAR(&MEM)      */ /*S01117*/
                 RTVDTAARA  DTAARA(LDA (134 50)) RTNVAR(&MEM)         /*S01117*/
                 SNDPGMMSG  MSGID(MEM0001) MSGF(MIDAS) MSGDTA(&MEM) +
                             TOPGMQ(*EXT)                             /*E21756*/
                 GOTO       END                                       /*E21756*/
             ENDDO                                                    /*E21756*/
             DLTOVR     FILE(TRANSD)                                  /*FO0013*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0013*/
             DLTOVR     FILE(TRSET)                                   /*E21756*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*E21756*/
/**/
/*/COPY WNCPYSRC,FFC01007                                            */
/**********  RGZPFM     FILE(TRANSD) MBR(&MKT)                        /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('TRANSD' &MRKTCHK)                            /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
/**/                                                                  /*FO0013*/
/**********  RGZPFM     FILE(TRSETD) MBR(&MKT)                        /*FO0013*/          /*228542*/
/*           MONMSG     MSGID(CPF2981)                           FO0013 113482*/
/**********  MONMSG     MSGID(CPF2981 CPF3135)                        /*113482*/          /*228542*/
             CALL       PGM(SCC000060) PARM('TRSETD' &MRKTCHK)                            /*228542*/
             IF         COND(%SWITCH(XXXXXX11)) THEN(GOTO +
                          CMDLBL(ABNOR))                                                  /*228542*/
                                                                      /*FO0013*/
/*                                                                    /*S01408*/
/*/COPY WNCPYSRC,FFC01002                                             /*S01408*/
/*                                                                    /*S01408*/
/************CLRPFM     FILE(TRANSD) MBR(&MKT)                        /*FO0013*/
 
/************OPNDBF     FILE(TRANS2) OPTION(*INP) MBR(*FIRST)         /*FO0013*/
/************   CLOF       OPNID(TRANS2)                              /*FO0013*/
/************OPNDBF     FILE(TRANS9) OPTION(*INP) MBR(*FIRST)         /*FO0013*/
/************   CLOF       OPNID(TRANS9)                              /*FO0013*/
/************OPNDBF     FILE(TRANSDM) OPTION(*INP) MBR(*FIRST)        /*FO0013*/
/************   CLOF       OPNID(TRANSDM)                             /*FO0013*/
/************OPNDBF     FILE(TRANS) OPTION(*INP) MBR(&MKT)            /*FO0013*/
/************   CLOF       OPNID(TRANS)                               /*FO0013*/
/************OPNDBF     FILE(TRANS1) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS1)                              /*FO0013*/
/************OPNDBF     FILE(TRANS10) OPTION(*INP) MBR(&MKT)          /*FO0013*/
/************   CLOF       OPNID(TRANS10)                             /*FO0013*/
/************OPNDBF     FILE(TRANS3) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS3)                              /*FO0013*/
/************OPNDBF     FILE(TRANS4) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS4)                              /*FO0013*/
/************OPNDBF     FILE(TRANS5) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS5)                              /*FO0013*/
/************OPNDBF     FILE(TRANS6) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS6)                              /*FO0013*/
/************OPNDBF     FILE(TRANS7) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS7)                              /*FO0013*/
/************OPNDBF     FILE(TRANS8) OPTION(*INP) MBR(&MKT)           /*FO0013*/
/************   CLOF       OPNID(TRANS8)                              /*FO0013*/
/************                                                         /*FO0013*/
/************CPYF       FROMFILE(QTEMP/TRANSD2) TOFILE(TRANSD)       +/*FO0013*/
/************OMBR(&MKT) MBROPT(*REPLACE)                              /*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*FO0013*/
/*T3:***/ /**NEXT*FILE**/                                             /*FO0013*/
/*********** CPYF       FROMFILE(TRSETD) TOFILE(QTEMP/TRSETD2)       +/*E21756*/
/**FROMMBR(MKT) MBROPT(*REPLACE) CRTFILE(*YES) INCREL((*IF RECI *NE *)/*E21756*/
/*********** CPYF       FROMFILE(TRSETD) TOFILE(QTEMP/TRSETD2)       +/*E22177*/
/**FROMMBR(MKT) MBROPT(*REPLACE) CRTFILE(*YES)             /*E21756*/ /*E22177*/
/************CPYF       FROMFILE(TRSETD) TOFILE(QTEMP/TRSETD2) +
/************             FROMMBR(&MKT) MBROPT(*REPLACE) +
/************             CRTFILE(*YES)                        /*E22177*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
/************             CMDLBL(T4))  /* SKIP IF EMPTY MEMBER */     /*FO0013*/
/************CLRPFM     FILE(TRSETD) MBR(&MKT)                        /*FO0013*/
/************                                                         /*FO0013*/
/************OPNDBF     FILE(TRSET1) OPTION(*INP) MBR(*FIRST)         /*FO0013*/
/************   CLOF       OPNID(TRSET1)                              /*FO0013*/
/************OPNDBF     FILE(TRSET) OPTION(*INP) MBR(&MKT)            /*FO0013*/
/************   CLOF       OPNID(TRSET)                               /*FO0013*/
/************                                                         /*FO0013*/
/************CPYF       FROMFILE(QTEMP/TRSETD2) TOFILE(TRSETD)       +/*FO0013*/
/************OMBR(&MKT) MBROPT(*REPLACE)                              /*FO0013*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)                /*FO0013*/
/**/
/*T4:***/ /**NEXT*FILE**/                                             /*FO0013*/
/**Do*not*delete*these*TEMP*files*as*MONMSG*on*the*CPYF*won't*w *E21756*FO0013*/
/*********** DLTF       FILE(QTEMP/TRANSD2)                           /*E21756*/
/*********** DLTF       FILE(QTEMP/TRSETD2)                           /*E21756*/
/*                                                                  */
/* REMOVE RECORDS IN RELEVANT MARKET MEMBER OF POCHG PHYSICAL FILES */
/* ONLY IF IT IS END OF MONTH AND RECORDS HAVE BEEN FULLY PROCESSED */
/*                                                                  */
             IF         COND(&EOM *EQ Y) THEN(DO)
/*                                                                  */
             CPYF       FROMFILE(POCHGCC) TOFILE(QTEMP/POCHGCC2) +
                          FROMMBR(&MKT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P7))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGCC) MBR(&MKT)
             CPYF       FROMFILE(QTEMP/POCHGCC2) TOFILE(POCHGCC) +
                          TOMBR(&MKT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P7:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGRC) TOFILE(QTEMP/POCHGRC2) +
                          FROMMBR(&MKT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P8))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGRC) MBR(&MKT)
             CPYF       FROMFILE(QTEMP/POCHGRC2) TOFILE(POCHGRC) +
                          TOMBR(&MKT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P8:     /* NEXT FILE */
             CPYF       FROMFILE(POCHGTC) TOFILE(QTEMP/POCHGTC2) +
                          FROMMBR(&MKT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P9))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGTC) MBR(&MKT)
             CPYF       FROMFILE(QTEMP/POCHGTC2) TOFILE(POCHGTC) +
                          TOMBR(&MKT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P9:     /* NEXT FILE */
             CPYF       FROMFILE(*LIBL/POCHGCK) +
                          TOFILE(QTEMP/POCHGCK2) FROMMBR(&MKT) +
                          MBROPT(*REPLACE) CRTFILE(*YES) +
                          INCREL((*IF AOSI *NE Y) (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P10))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGCK) MBR(&MKT)
             CPYF       FROMFILE(QTEMP/POCHGCK2) TOFILE(POCHGCK) +
                          TOMBR(&MKT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P10:    /* NEXT FILE */
             CPYF       FROMFILE(POCHGRK) TOFILE(QTEMP/POCHGRK2) +
                          FROMMBR(&MKT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P11))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGRK) MBR(&MKT)
             CPYF       FROMFILE(QTEMP/POCHGRK2) TOFILE(POCHGRK) +
                          TOMBR(&MKT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
/*                                                                  */
P11:    /* NEXT FILE */
             CPYF       FROMFILE(POCHGTK) TOFILE(QTEMP/POCHGTK2) +
                          FROMMBR(&MKT) MBROPT(*REPLACE) +
                          CRTFILE(*YES) INCREL((*IF AOSI *NE Y) +
                          (*OR ATCI *NE Y))
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(GOTO +
                          CMDLBL(P12))  /* SKIP IF EMPTY MEMBER */
             CLRPFM     FILE(POCHGTK) MBR(&MKT)
             CPYF       FROMFILE(QTEMP/POCHGTK2) TOFILE(POCHGTK) +
                          TOMBR(&MKT) MBROPT(*REPLACE)
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869)
P12:    /* LAST FILE (FOR MARKET) */
/**/
             DLTF       FILE(QTEMP/POCHGCC2)
             DLTF       FILE(QTEMP/POCHGRC2)
             DLTF       FILE(QTEMP/POCHGTC2)
             DLTF       FILE(QTEMP/POCHGCK2)
             DLTF       FILE(QTEMP/POCHGRK2)
             DLTF       FILE(QTEMP/POCHGTK2)
/**/
             ENDDO
/**/
/************GOTO       LOOP2                                         /*E21496*/
             ENDDO
/**/                                                                  /*E21496*/
             GOTO       LOOP2                                         /*E21496*/
/**/                                                                  /*E21496*/
/*/COPY WNCPYSRC,FFC01011                                            */
             RGZPFM     FILE(FFCOCHPD)                                                    /*CER001*/
             MONMSG     MSGID(CPF2981 CPF3135)                                            /*CER001*/
/**/
/* CALL PROGRAM TO RESET MONTHLY STATISTICS IF IT IS END OF MONTH   */
/**/
 TAG1:
/*/COPY WNCPYSRC,FFC01003                                            */
/*           IF         COND(&EOM *EQ Y) THEN(DO)                  */ /*S01456*/
             IF    COND((&EOM *EQ Y) *AND (&S01456 *NE 'Y')) THEN(DO) /*S01456*/
             OVRDBF     FILE(POSTNKD) MBR(*ALL)
             OVRDBF     FILE(POSTNCD) MBR(*ALL)
             OVRDBF     FILE(PRICSD) MBR(*ALL)
/**/
/************CALL       PGM(FF0540)                                */ /*S01456*/
             CALL       PGM(FF0540) PARM('  ')                        /*S01456*/
/**/
             DLTOVR     FILE(POSTNKD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(POSTNCD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             DLTOVR     FILE(PRICSD)
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)
             ENDDO
/**/                                                                  /*S01456*/
/* CALL PROGRAM TO RESET MONTHLY STATISTICS IF IT IS END OF MONTH  */ /*S01456*/
/* AND IF THE SWITCHABLE FEATURE S01456 IS ON.                     */ /*S01456*/
/**/                                                                  /*S01456*/
             IF     COND((&S01456 *EQ Y) *AND (&EOM *EQ Y)) THEN(DO)  /*S01456*/
             OVRDBF     FILE(POSTNCD) MBR(OTC)                        /*S01456*/
             OVRDBF     FILE(POSTNKD) MBR(OTC)                        /*S01456*/
             OVRDBF     FILE(PRICSD) MBR(OTC)                         /*S01456*/
/**/                                                                  /*S01456*/
             CALL       PGM(FF0540) PARM('  ')                        /*S01456*/
/**/                                                                  /*S01456*/
             DLTOVR     FILE(POSTNKD)                                 /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
             DLTOVR     FILE(POSTNCD)                                 /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
             DLTOVR     FILE(PRICSD)                                  /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
/**/                                                                  /*S01456*/
/* LOOP TO PROCESS ALL MARKET CENTRES CONTAINED IN DTAARA/FFEOC     */
/**/                                                                  /*S01456*/
             RTVDTAARA  DTAARA(FFEOC) RTNVAR(&FFEOC)                  /*S01456*/
/**/                                                                  /*S01456*/
             CHGVAR     VAR(&A) VALUE(1)                              /*S01456*/
 LOOP3:      CHGJOB     SWS(XXXXXX00)                                 /*S01456*/
             IF         COND((%SST(&FFEOC &A 2) *EQ '  ') *OR (&A *GT +
                          61)) THEN(GOTO CMDLBL(END1))                /*S01456*/
             CHGVAR     VAR(&MKT) VALUE(%SST(&FFEOC &A 2))            /*S01456*/
/**/                                                                  /*S01456*/
/*  OVERRIDE MULTI-MEMBER FILES TO CORRECT MEMBER FOR MARKET        */
/**/                                                                  /*S01456*/
/**/                                                                  /*S01456*/
             OVRDBF     FILE(POSTNCD) MBR(&MKT)                       /*S01456*/
             OVRDBF     FILE(POSTNKD) MBR(&MKT)                       /*S01456*/
             OVRDBF     FILE(PRICSD) MBR(&MKT)                        /*S01456*/
/**/                                                                  /*S01456*/
             CALL       PGM(FF0540) PARM(&MKT)                        /*S01456*/
/**/                                                                  /*S01456*/
             DLTOVR     FILE(POSTNKD)                                 /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
             DLTOVR     FILE(POSTNCD)                                 /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
             DLTOVR     FILE(PRICSD)                                  /*S01456*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*S01456*/
/**/                                                                  /*S01456*/
             CHGVAR     VAR(&A) VALUE(&A + 2)                         /*S01456*/
             GOTO       CMDLBL(LOOP3)                                 /*S01456*/
END1:        ENDDO                                                    /*S01456*/
/**/                                                                  /*S01456*/
/**Delete*these*files*here*rather*than*above*so*that*empty*membe*E21756*FO0013*/
/**are*skipped.***                                             /*E21756*FO0013*/
/************DLTF       FILE(QTEMP/TRANSD2)                    /*E21756*FO0013*/
/************DLTF       FILE(QTEMP/TRSETD2)                    /*E21756*FO0013*/
/**/
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Finastra International Limited')
/**/                                                                  /*E28693*/
             RCLRSC                                                   /*E28693*/
/**/                                                                  /*E28693*/
/**/
             GOTO       CMDLBL(END)                                   /*FO0013*/
/**/                                                                  /*FO0013*/
 ABNOR:      CHGVAR     &MSGDBE VALUE(' JOB TERMINATED - DATABASE IN ERROR')
             SNDPGMMSG  TOPGMQ(*EXT) MSG(&MSGDBE)                     /*FO0013*/
             CHGJOB     SWS(XXXXXX11)                                 /*FO0013*/
             DLTOVR     FILE(*ALL)                                    /*FO0013*/
             MONMSG     MSGID(CPF0000 RPG0000 MCH0000)                /*FO0013*/
/**/
/*/COPY WNCPYSRC,FFC01009                                            */
 END:        ENDPGM
/*/COPY WNCPYSRC,FFC01010                                            */
