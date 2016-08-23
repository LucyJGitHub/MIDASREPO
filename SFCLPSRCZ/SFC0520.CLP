/*********************************************************************/
/*STD    CLPBASE                                                     */
/*EXI    TEXT('Midas SF Drop deleted Midas user records')            */
/*********************************************************************/
/*                                                                   */
/*       Midas SECURITY PROFILE FACILITY                             */
/*                                                                   */
/*       SFC0520  - Drop Deleted Midas User records                  */
/*                                                                   */
/*       (c) Misys International Banking Systems Ltd. 2001           */
/*                                                                   */
/*       Last Amend No. CBF005             Date 04Jul11              */
/* Bank Fusion Midas 1.4 Base ---------------------------------------*/
/* Midas Plus 1.4 Base 04 -------------------------------------------*/
/* Midas Plus 1.4 Base ----------------------------------------------*/
/* Midas Plus 1.3 ---------------- Base -----------------------------*/
/*       Prev Amend No. 228542             Date 10Aug04              */
/*                      CPK017             Date 15Oct03              */
/* Midas Release 4 --------------- Base -----------------------------*/
/*                      CSC012             Date 19Oct01              */
/* Midas DBA 3.00 ---------------- Base -----------------------------*/
/*                      109996             DATE 25SEP97             */
/*                      031527             DATE 27JUL95             */
/*                      CAAA01             DATE 19APR95             */
/*                      S01408            DATE  10MAY95              */
/*                      E28090             DATE 06SEP91             */
/*                      RT0157             DATE 24JUN91             */
/*                      RT0103             DATE 17MAY91             */
/*                      RT0010             DATE 06MAY91             */
/*                      BHF982             DATE 19FEB91             */
/*                                                                  */
/********************************************************************/
/*                                                                   */
/*       CBF005 - BF Infrastructure: Single Security User Maintenance*/
/*                Profile                                            */
/*       228542 - RGZPFM has changed at R5V3                         */
/*       CPK017  -  Midas Plus packaging.                            */
/*                  Remove sending of 'ICDR' and checking of MSGQ    */
/*                  MSTATUS for any active users.                    */
/*     CSC012 - Release 4 packaging.  DTALIB logicals moved to       */
/*              DVLIB.                                               */
/*     109996  -  End RCF job because it is locking MUSER while     */
/*                dropping deleted users.                           */
/*     031527  -  Program ends abnormally if backup files already   */
/*                exist. Fix is to delete old copies of backup files*/
/*     CAAA01  -  GUI/400 Development,                              */
/*                drop all records in PF/SFUBUTPD with RECI = 'C'.  */
/*     S01408  -  Addition of core hook SFC0520MP1                  */
/*                Addition of core hook SFC0520MP2                  */
/*                Addition of core hook SFC0520MP3                  */
/*                Addition of core hook SFC0520MP4                  */
/*                Addition of core hook SFC0520MP5                  */
/*                Addition of core hook SFC0520MP6                  */
/*                Addition of core hook SFC0520MP7                  */
/*                Addition of core hook SFC0520MP8                  */
/*     E28090  -  Amend calls to SFC0700 to reflect the rewrite     */
/*                of that program.                                  */
/*     RT0157  -  Msgs should be sent via new Midas Info Screen.    */
/*     RT0103  -  PGM SHOULD ONLY BE RUN WHEN NO OTHER USERS ARE ON */
/*                THE SYSTEM.                                       */
/*     RT0010  -  COMPONENT IN MSG SHOULD BE SFC0520 NOT SDC2330    */
/*     BHF982  -  ADDLFM SHOULD BE SHARE(*YES)                      */
/********************************************************************/
             PGM
/**/
             DCLF       FILE(SDMMODPD)                                /*109996*/
             DCL        VAR(&CPYFLD) TYPE(*CHAR) LEN(64) VALUE('(c) +
                          Misys International Banking Systems Ltd. +
                          2001')
             DCL        VAR(&SDSTAT) TYPE(*CHAR) LEN(256)
             DCL        VAR(&ID) TYPE(*CHAR) LEN(2)
/************DCL        VAR(&TOLIB) TYPE(*CHAR) LEN(10)                                */ /*CSC012*/
/************DCL        VAR(&RMV) TYPE(*LGL) LEN(1) VALUE('0')              */ /*RT0103*/ /*CPK017*/
/************DCL        VAR(&MIDAS) TYPE(*CHAR) LEN(05)                     */ /*RT0103*/ /*CPK017*/
/************DCL        VAR(&MSG) TYPE(*CHAR) LEN(132) +                               */ /*CPK017*/
/************             VALUE('SFC0520 - Job cannot be run at +                      */ /*CPK017*/
/************             this time. Other job(s) are active')              */ /*RT0103*/ /*CPK017*/
/************DCL        VAR(&MESSAGE) TYPE(*CHAR) LEN(50)                   */ /*E28090*/ /*CPK017*/
/*/COPY WNCPYSRC,SFH00240                                            */
             DCL        VAR(&TOLIB2) TYPE(*CHAR) LEN(10)              /*CAAA01*/
/************DCL        VAR(&TOLIB3) TYPE(*CHAR) LEN(10)                    */ /*CAAA01*/ /*CSC012*/
/*/COPY WNCPYSRC,SFC0520001                                          */
/********************************************************************       */ /*RT0103*/ /*CPK017*/
/**SEND*MESSAGE*'ICDR'*TO*MSGQ*MSPECIAL*TO*PREVENT*OTHER*JOBS********       */ /*RT0103*/ /*CPK017*/
/**INITIATING*WHILST*PROGRAM*IS*ACTIVE.******************************       */ /*RT0103*/ /*CPK017*/
/**CHECK*IF*OTHER*JOB(S)*ARE*CURRENTLY*ACTIVE*BY*RECEIVING*MESSAGES**       */ /*RT0103*/ /*CPK017*/
/**FROM*MSGQ*MSTATUS.************************************************       */ /*RT0103*/ /*CPK017*/
/********************************************************************       */ /*RT0103*/ /*CPK017*/
/************SNDPGMMSG  MSG('ICDR') TOMSGQ(MSPECIAL)                        */ /*RT0103*/ /*CPK017*/
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                           */ /*RT0103*/ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS) RMV(*YES)                             */ /*RT0103*/ /*CPK017*/
/************CHGVAR     VAR(&RMV) VALUE('1')                                */ /*RT0103*/ /*CPK017*/
/************RCVMSG     MSGQ(MSTATUS) RMV(*NO) MSG(&MIDAS)                  */ /*RT0103*/ /*CPK017*/
/************                                                               */ /*RT0103*/ /*CPK017*/
/************IF         COND(&MIDAS *NE '     ') THEN(DO)                   */ /*RT0103*/ /*CPK017*/
/***********    SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ) TOPGMQ(*EXT)/*RT0103RT0157*/
/************   SNDPGMMSG  MSG(&MSG) TOMSGQ(MOPERQ)                         */ /*RT0103*/ /*CPK017*/
/***************CALL       PGM(SFC0700) PARM('SFC0520' +
/***************             'CANTRUNNOW' ' ')             /*RT0157*/ /*E28090*/
/************   RTVMSG     MSGID(SFM0003) MSGF(MIDASMSG) +                             */ /*CPK017*/
/************                MSG(&MESSAGE)                                  */ /*E28090*/ /*CPK017*/
/************   CHGDTAARA  DTAARA(MIDASMSG (251 50)) VALUE(&MESSAGE)        */ /*E28090*/ /*CPK017*/
/************   RTVMSG     MSGID(SFM0005) MSGF(MIDASMSG) +                             */ /*CPK017*/
/************                MSG(&MESSAGE)                                  */ /*E28090*/ /*CPK017*/
/************   CHGDTAARA  DTAARA(MIDASMSG (351 50)) VALUE(&MESSAGE)        */ /*E28090*/ /*CPK017*/
/************   CHGDTAARA  DTAARA(MIDASMSG (1 1)) VALUE('1')                */ /*E28090*/ /*CPK017*/
/************   CALL       PGM(SFC0700) PARM('SFC0520' 'ENTER' ' ')         */ /*E28090*/ /*CPK017*/
/************ENDDO                                                          */ /*RT0103*/ /*CPK017*/
/************                                                               */ /*RT0103*/ /*CPK017*/
/************ELSE DO                                                        */ /*RT0103*/ /*CPK017*/
/**/                                                                  /*RT0103*/
             RTVDTAARA  DTAARA(SDSTAT) RTNVAR(&SDSTAT)
 
/* Retreive system ID from DTAARA/SDSTAT and construct data file     */
/* name in command string                                            */
/**/
/*/COPY WNCPYSRC,SFH00241                                            */
             CHGVAR     VAR(&ID) VALUE(%SST(&SDSTAT 6 2))
/************CHGVAR     VAR(&TOLIB) VALUE(&ID *TCAT 'DTALIB')                          */ /*CSC012*/
             CHGVAR     VAR(&TOLIB2) VALUE(&ID *TCAT 'DPLIB')         /*CAAA01*/
/************CHGVAR     VAR(&TOLIB3) VALUE(&ID *TCAT 'DVLIB')               */ /*CAAA01*/ /*CSC012*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC0520MP1                                          */
                                                                      /*S01408*/
/**/
/************SNDPGMMSG  MSG('SDC2330 - Drop records for deleted Midas + RT0010*/
/************             User') TOMSGQ(MOPERQ)                         RT0010*/
             SNDPGMMSG  MSG('SFC0520 - Drop records for deleted Midas +
                          User') TOMSGQ(MOPERQ)                       /*RT0010*/
             RCVF       RCDFMT(SDMMODD0)                              /*109996*/
             MONMSG     MSGID(CPF0864) EXEC(GOTO CMDLBL(LAB1))        /*109996*/
             IF         COND(&BGRCFI *EQ 'Y') THEN(DO)                /*109996*/
             CALL       PGM(QSNDDTAQ) PARM('FCDTAQ' '*LIBL' +
                          X'00001F' 'T')                              /*109996*/
             ENDDO                                                    /*109996*/
LAB1:                                                                 /*109996*/
/**/
/*     Allocate DTAARA/SDSTAT for exclusive use of 'OLD'/'NEW'    */
/**/
             ALCOBJ     OBJ((SDSTAT *DTAARA *EXCLRD))
/**/
/*  Override for fast copy  */
/**/
             OVRDBF     FILE(MUSERDD) SEQONLY(*YES 100)
/**********  OVRDBF     FILE(MACBRDD) SEQONLY(*YES 100)   */                              /*CBF005*/
             OVRDBF     FILE(MBRBSDD) SEQONLY(*YES 100)
             OVRDBF     FILE(MBROSDD) SEQONLY(*YES 100)
             OVRDBF     FILE(MCMPSDD) SEQONLY(*YES 100)
             OVRDBF     FILE(BMUSERDD) SEQONLY(*YES 100)
/**********  OVRDBF     FILE(BMACBRDD) SEQONLY(*YES 100)  */                              /*CBF005*/
             OVRDBF     FILE(BMBRBSDD) SEQONLY(*YES 100)
             OVRDBF     FILE(BMBROSDD) SEQONLY(*YES 100)
             OVRDBF     FILE(BMCMPSDD) SEQONLY(*YES 100)
/*/COPY WNCPYSRC,SFH00242                                            */
/************OVRDBF     FILE(SFUBUTPD) SEQONLY(*YES 100)                    */ /*CAAA01*/ /*CSC012*/
/************OVRDBF     FILE(BSFUBUTPD) SEQONLY(*YES 100)                   */ /*CAAA01*/ /*CSC012*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC0520MP2                                          */
                                                                      /*S01408*/
/**/
/*  If first time, ie. not restart  */
/**/
             IF         COND(%SST(&SDSTAT 8 3) *EQ 'OLD') THEN(DO)
/**/
/*  Delete old copies of backup files  */                             /*031527*/
/**/                                                                  /*031527*/
/************DLTF       FILE(&TOLIB/BMUSERDD)                               */ /*031527*/ /*CSC012*/
             DLTF       FILE(BMUSERDD)                                                    /*CSC012*/
             MONMSG     MSGID(CPF0000)                                /*031527*/
/************DLTF       FILE(&TOLIB/BMACBRDD)                               */ /*031527*/ /*CSC012*/
/**********  DLTF       FILE(BMACBRDD)   */                                    /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)   */                                    /*031527*/ /*CBF005*/
/************DLTF       FILE(&TOLIB/BMBRBSDD)                               */ /*031527*/ /*CSC012*/
             DLTF       FILE(BMBRBSDD)                                                    /*CSC012*/
             MONMSG     MSGID(CPF0000)                                /*031527*/
/************DLTF       FILE(&TOLIB/BMBROSDD)                               */ /*031527*/ /*CSC012*/
             DLTF       FILE(BMBROSDD)                                                    /*CSC012*/
             MONMSG     MSGID(CPF0000)                                /*031527*/
/************DLTF       FILE(&TOLIB/BMCMPSDD)                               */ /*031527*/ /*CSC012*/
             DLTF       FILE(BMCMPSDD)                                                    /*CSC012*/
             MONMSG     MSGID(CPF0000)                                /*031527*/
/*/COPY WNCPYSRC,SFH00243                                            */
/**/                                                                  /*031527*/
/*  Copy Midas User data to backup files  */
/**/
/************CPYF       FROMFILE(&TOLIB/MUSERDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMUSERDD) CRTFILE(*YES)                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMUSERDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MACBRDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMACBRDD) CRTFILE(*YES)                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMACBRDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MBRBSDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMBRBSDD) CRTFILE(*YES)                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMBRBSDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MBROSDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMBROSDD) CRTFILE(*YES)                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMBROSDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/MCMPSDD) +                                     */ /*CSC012*/
/************             TOFILE(&TOLIB/BMCMPSDD) CRTFILE(*YES)                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/BMCMPSDD))                                       */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB2/SFUBUTPD) +                                   */ /*CSC012*/
/************             TOFILE(&TOLIB2/BSFUBUTPD) CRTFILE(*YES)           */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB2/BSFUBUTPD))                          */ /*CAAA01*/ /*CSC012*/
 
             CPYF       FROMFILE(MUSERDD) TOFILE(&TOLIB2/BMUSERDD) +
                          CRTFILE(*YES)                                                   /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMUSERDD))                                                 /*CSC012*/
/**********  CPYF       FROMFILE(MACBRDD) TOFILE(&TOLIB2/BMACBRDD) +
                          CRTFILE(*YES)   */                                   /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMACBRDD))   */                                 /*CSC012*/ /*CBF005*/
             CPYF       FROMFILE(MBRBSDD) TOFILE(&TOLIB2/BMBRBSDD) +
                          CRTFILE(*YES)                                                   /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMBRBSDD))                                                 /*CSC012*/
             CPYF       FROMFILE(MBROSDD) TOFILE(&TOLIB2/BMBROSDD) +
                          CRTFILE(*YES)                                                   /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMBROSDD))                                                 /*CSC012*/
/*/COPY WNCPYSRC,SFH00244                                            */
             CPYF       FROMFILE(MCMPSDD) TOFILE(&TOLIB2/BMCMPSDD) +
                          CRTFILE(*YES)                                                   /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(BMCMPSDD))                                                 /*CSC012*/
/*/COPY WNCPYSRC,SFC0520MP3                                          */
                                                                      /*S01408*/
/**/
/*  Data now in backup files  */
/**/
                CHGDTAARA  DTAARA(SDSTAT (8 3)) VALUE('NEW')
/**/
             ENDDO
/**/
/*  If first time, continue */
/*  If restart, start here  */
/**/
/*  Remove logical file members for fact copying */
/**/
 
/************RMVM       FILE(&TOLIB/MUSER) MBR(MUSER)                                  */ /*CSC012*/
             RMVM       FILE(MUSER) MBR(MUSER)                                            /*CSC012*/
             MONMSG     MSGID(CPF0000)
/************RMVM       FILE(&TOLIB/MACBR) MBR(MACBR)                                  */ /*CSC012*/
/**********  RMVM       FILE(MACBR) MBR(MACBR)   */                            /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)           */                                       /*CBF005*/
/************RMVM       FILE(&TOLIB/MBRBS) MBR(MBRBS)                                  */ /*CSC012*/
             RMVM       FILE(MBRBS) MBR(MBRBS)                                            /*CSC012*/
             MONMSG     MSGID(CPF0000)
/************RMVM       FILE(&TOLIB/MBROS) MBR(MBROS)                                  */ /*CSC012*/
             RMVM       FILE(MBROS) MBR(MBROS)                                            /*CSC012*/
             MONMSG     MSGID(CPF0000)
/************RMVM       FILE(&TOLIB/MCMPS) MBR(MCMPS)                                  */ /*CSC012*/
             RMVM       FILE(MCMPS) MBR(MCMPS)                                            /*CSC012*/
             MONMSG     MSGID(CPF0000)
/************RMVM       FILE(&TOLIB3/SFUBUTL0) MBR(SFUBUTL0)                */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                      */ /*CAAA01*/ /*CSC012*/
/************RMVM       FILE(&TOLIB3/SFUBUTL1) MBR(SFUBUTL1)                */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                      */ /*CAAA01*/ /*CSC012*/
/*/COPY WNCPYSRC,SFH00245                                            */
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC0520MP4                                          */
                                                                      /*S01408*/
/**/
/*  Copy back, including live records only  */
/**/
/************CPYF       FROMFILE(&TOLIB/BMUSERDD) +                                    */ /*CSC012*/
/************             TOFILE(&TOLIB/MUSERDD) MBROPT(*REPLACE) +                    */ /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/MUSERDD))                                        */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMACBRDD) +                                    */ /*CSC012*/
/************             TOFILE(&TOLIB/MACBRDD) MBROPT(*REPLACE) +                    */ /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/MACBRDD))                                        */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMBRBSDD) +                                    */ /*CSC012*/
/************             TOFILE(&TOLIB/MBRBSDD) MBROPT(*REPLACE) +                    */ /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/MBRBSDD))                                        */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMBROSDD) +                                    */ /*CSC012*/
/************             TOFILE(&TOLIB/MBROSDD) MBROPT(*REPLACE) +                    */ /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/MBROSDD))                                        */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB/BMCMPSDD) +                                    */ /*CSC012*/
/************             TOFILE(&TOLIB/MCMPSDD) MBROPT(*REPLACE) +                    */ /*CSC012*/
/************             INCCHAR(RECI 1 *EQ D)                                        */ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB/MCMPSDD))                                        */ /*CSC012*/
/************CPYF       FROMFILE(&TOLIB2/BSFUBUTPD) +                                  */ /*CSC012*/
/************             TOFILE(&TOLIB2/SFUBUTPD) MBROPT(*REPLACE) +                  */ /*CSC012*/
/************             INCCHAR(JZRECI 1 *EQ D)                           */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +                   */ /*CSC012*/
/************             FILE(&TOLIB2/SFUBUTPD))                           */ /*CAAA01*/ /*CSC012*/
 
             CPYF       FROMFILE(BMUSERDD) TOFILE(MUSERDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)                          /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MUSERDD))                                                  /*CSC012*/
/**********  CPYF       FROMFILE(BMACBRDD) TOFILE(MACBRDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)   */          /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MACBRDD))   */                                  /*CSC012*/ /*CBF005*/
             CPYF       FROMFILE(BMBRBSDD) TOFILE(MBRBSDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)                          /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MBRBSDD))                                                  /*CSC012*/
             CPYF       FROMFILE(BMBROSDD) TOFILE(MBROSDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)                          /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MBROSDD))                                                  /*CSC012*/
/*/COPY WNCPYSRC,SFH00246                                            */
             CPYF       FROMFILE(BMCMPSDD) TOFILE(MCMPSDD) +
                          MBROPT(*REPLACE) INCCHAR(RECI 1 *EQ D)                          /*CSC012*/
             MONMSG     MSGID(CPF2817) CMPDTA(CPF2869) EXEC(CLRPFM +
                          FILE(MCMPSDD))                                                  /*CSC012*/
/*/COPY WNCPYSRC,SFC0520MP5                                          */
                                                                      /*S01408*/
/**/
/*  Delete backup files  */
/**/
/************DLTF       FILE(&TOLIB/BMUSERDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMACBRDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMBRBSDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMBROSDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB/BMCMPSDD)                                          */ /*CSC012*/
/************DLTF       FILE(&TOLIB2/BSFUBUTPD)                       /*CAAA01*/
 
             DLTF       FILE(BMUSERDD)                                                    /*CSC012*/
/**********  DLTF       FILE(BMACBRDD)   */                                    /*CSC012*/ /*CBF005*/
             DLTF       FILE(BMBRBSDD)                                                    /*CSC012*/
             DLTF       FILE(BMBROSDD)                                                    /*CSC012*/
/*/COPY WNCPYSRC,SFH00247                                            */
             DLTF       FILE(BMCMPSDD)                                                    /*CSC012*/
/*/COPY WNCPYSRC,SFC0520MP6                                          */
                                                                      /*S01408*/
/**/
/*  Reorganise master files */
/**/
/************MONMSG     MSGID(CPF0000)                                                    /*CSC012*/
/*/COPY WNCPYSRC,SFC0520002                                          */
/************RGZPFM     FILE(&TOLIB/MUSERDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MUSERDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MUSERDD' '*FIRST')                           /*228542*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MACBRDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MACBRDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
/**********  CALL       PGM(SCC000060) PARM('MACBRDD' '*FIRST')   */           /*228542*/ /*CBF005*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MBRBSDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MBRBSDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MBRBSDD' '*FIRST')                           /*228542*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MBROSDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MBROSDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MBROSDD' '*FIRST')                           /*228542*/
                                                                                          /*228542*/
/************RGZPFM     FILE(&TOLIB/MCMPSDD)                                           */ /*CSC012*/
/**********  RGZPFM     FILE(MCMPSDD)                                          /*CSC012*/ /*228542*/
/**********  MONMSG     MSGID(CPF2981)                                                    /*228542*/
             CALL       PGM(SCC000060) PARM('MCMPSDD' '*FIRST')                           /*228542*/
                                                                                          /*228542*/
/*/COPY WNCPYSRC,SFH00248                                            */
/************RGZPFM     FILE(&TOLIB2/SFUBUTPD)                              */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF2981)                                      */ /*CAAA01*/ /*CSC012*/
                                                                      /*S01408*/
/*/COPY WNCPYSRC,SFC0520MP7                                          */
                                                                      /*S01408*/
/**/
/*  Successful completion  */
/**/
             CHGDTAARA  DTAARA(SDSTAT (8 3)) VALUE('OLD')
             SNDPGMMSG  MSG('SFC0520 - Records successfully dropped') +
                          TOMSGQ(MOPERQ)
/**/
/*  Enable access paths  */
/**/
/**ENDPGM:*****ADDLFM     FILE(&TOLIB/MUSER) MBR(MUSER)                *BHF982*/
/*ENDPGM:****ADDLFM     FILE(&TOLIB/MUSER) MBR(MUSER) SHARE(*YES)           */ /*BHF982*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CSC012*/
/**********  ADDLFM     FILE(&TOLIB/MACBR) MBR(MACBR)                  *BHF982*/
/************ADDLFM     FILE(&TOLIB/MACBR) MBR(MACBR) SHARE(*YES)           */ /*BHF982*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CSC012*/
/**********  ADDLFM     FILE(&TOLIB/MBRBS) MBR(MBRBS)                  *BHF982*/
/************ADDLFM     FILE(&TOLIB/MBRBS) MBR(MBRBS) SHARE(*YES)           */ /*BHF982*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CSC012*/
/**********  ADDLFM     FILE(&TOLIB/MBROS) MBR(MBROS)                  *BHF982*/
/************ADDLFM     FILE(&TOLIB/MBROS) MBR(MBROS) SHARE(*YES)           */ /*BHF982*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CSC012*/
/**********  ADDLFM     FILE(&TOLIB/MCMPS) MBR(MCMPS)                  *BHF982*/
/************ADDLFM     FILE(&TOLIB/MCMPS) MBR(MCMPS) SHARE(*YES)           */ /*BHF982*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                                 */ /*CSC012*/
/************ADDLFM     FILE(&TOLIB3/SFUBUTL0) MBR(SFUBUTL0) +                         */ /*CSC012*/
/************             SHARE(*YES)                                       */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                      */ /*CAAA01*/ /*CSC012*/
/************ADDLFM     FILE(&TOLIB3/SFUBUTL1) MBR(SFUBUTL0) +                         */ /*CSC012*/
/************             SHARE(*YES)                                       */ /*CAAA01*/ /*CSC012*/
/************MONMSG     MSGID(CPF0000)                                      */ /*CAAA01*/ /*CSC012*/
                                                                      /*S01408*/
 ENDPGM:                                                                                  /*CSC012*/
             ADDLFM     FILE(MUSER) MBR(MUSER) SHARE(*YES)                                /*CSC012*/
/**********  ADDLFM     FILE(MACBR) MBR(MACBR) SHARE(*YES)   */                /*CSC012*/ /*CBF005*/
/**********  MONMSG     MSGID(CPF0000)   */                                    /*CSC012*/ /*CBF005*/
             ADDLFM     FILE(MBRBS) MBR(MBRBS) SHARE(*YES)                                /*CSC012*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC012*/
             ADDLFM     FILE(MBROS) MBR(MBROS) SHARE(*YES)                                /*CSC012*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC012*/
             ADDLFM     FILE(MCMPS) MBR(MCMPS) SHARE(*YES)                                /*CSC012*/
             MONMSG     MSGID(CPF0000)                                                    /*CSC012*/
/*/COPY WNCPYSRC,SFC0520MP8                                          */
                                                                      /*S01408*/
/**/
/*   Deallocate DTAARA/SDSTAT */
/**/
             DLCOBJ     OBJ((SDSTAT *DTAARA *EXCLRD))
             CHGVAR     VAR(&CPYFLD) VALUE('(c) +
                          Misys International Banking Systems Ltd.')
/**/
/************ENDDO                                                          */ /*RT0103*/ /*CPK017*/
/************                                                               */ /*RT0103*/ /*CPK017*/
/********************************************************************       */ /*RT0103*/ /*CPK017*/
/**SEND*'MIDAS'*MESSAGE*TO*MSGQ*MSTATUS*THAT*WAS*REMOVED*AT*TOP*OF***       */ /*RT0103*/ /*CPK017*/
/**THIS*PROGRAM.*REMOVE*MESSAGE*'ICDR'*FROM*MSGQ*MSPECIAL*AND*RESET**       */ /*RT0103*/ /*CPK017*/
/**MSGQ*MSTATUS.*****************************************************       */ /*RT0103*/ /*CPK017*/
/********************************************************************       */ /*RT0103*/ /*CPK017*/
/************IF         COND(&RMV) THEN(                            +       */ /*RT0103*/ /*CPK017*/
/************   SNDPGMMSG  MSG('MIDAS') TOMSGQ(MSTATUS))                    */ /*RT0103*/ /*CPK017*/
/************                                                               */ /*RT0103*/ /*CPK017*/
/************CHGMSGQ    MSGQ(MSPECIAL) RESET(*YES)                          */ /*RT0103*/ /*CPK017*/
/************MONMSG     MSGID(CPF0000)                                      */ /*RT0103*/ /*CPK017*/
/**REMOVE*'ICDR'*MSG*SENT*TO*MSPECIAL*AT*TOP*OF*PROGRAM**************       */ /*RT0103*/ /*CPK017*/
/************RCVMSG     MSGQ(MSPECIAL) RMV(*YES)                            */ /*RT0103*/ /*CPK017*/
/************MONMSG     MSGID(CPF0000)                                      */ /*RT0103*/ /*CPK017*/
/************CHGMSGQ    MSGQ(MSTATUS) RESET(*YES)                           */ /*RT0103*/ /*CPK017*/
/************MONMSG     MSGID(CPF0000)                                      */ /*RT0103*/ /*CPK017*/
                                                                      /*RT0103*/
/*/COPY WNCPYSRC,SFC0520003                                          */
             ENDPGM
/*/COPY WNCPYSRC,SFC0520004                                          */
